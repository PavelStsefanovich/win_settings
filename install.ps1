$message_padding = "  "

function _error {

    param(
        [string]$message
    )

    Write-Host ($message_padding + "ERROR: $message`n") -ForegroundColor Red
}

function _info {

    param(
        [string]$message,
        [switch]$no_newline
    )

    Write-Host ($message_padding + $message) -ForegroundColor Gray -NoNewline:$no_newline
}

function _newline {

    param(
        [int]$count = 1
    )

    Write-Host ("$message_padding`n" * $count).TrimEnd()
}

function _warning {

    param(
        [string]$message,
        [switch]$no_newline,
        [switch]$no_prefix
    )

    if ($no_prefix) {
        Write-Host ($message_padding + $message) -ForegroundColor Yellow -NoNewline:$no_newline
    }
    else {
        Write-Host ($message_padding + "WARNING: $message") -ForegroundColor Yellow -NoNewline:$no_newline
    }
}

function _confirm_status {

    param(
        [string]$message,
        [switch]$no_newline
    )

    Write-Host ($message_padding + $message) -ForegroundColor Green -NoNewline:$no_newline
}

function _request_consent {

    param(
        [string]$question
    )

    do {
        _warning (" (?) $question ( Y: yes / N: no): ") -no_prefix
        $reply = [string]$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
        if ($reply.tolower() -notin 'y', 'n') {
            _error "It's a yes/no question."
        }
    }
    while ($reply.tolower() -notin 'y', 'n')

    switch ($reply) {
        'y' { _info "<yes>"; return $true }
        'n' { _info "<no>"; return $false }
    }
}



##########################################################################

$ErrorActionPreference = 'Stop'
$app_name = 'WinSettingsShortcuts'
$uninstall_key = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$app_name"

_newline
_info "Installation directory : $PSScriptRoot"
if (!(_request_consent "Proceed?")) {
    _warning "Installation cancelled by user."
    _newline
    exit
}

_newline
_info "Installing..."

try {
    $executable_path = (gi "$PSScriptRoot\$app_name`.exe").FullName
}
catch {
    _newline
    _error "Could not find $app_name`.exe"
    throw $_
}

$task_name = "$app_name`_StartAtLogon_$env:USERNAME"
$action = New-ScheduledTaskAction -Execute $executable_path -WorkingDirectory $PSScriptRoot
$settings = New-ScheduledTaskSettingsSet -Compatibility Win8 `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -DisallowDemandStart `
    -RestartCount 1 `
    -RestartInterval (New-TimeSpan -Minutes 1) `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 5) `
    -StartWhenAvailable

$current_user = $env:USERDOMAIN, $env:USERNAME -join ('\')
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $current_user
$principal = New-ScheduledTaskPrincipal -UserId $current_user -LogonType Interactive

# check if scheduled task exists already
$task = Get-ScheduledTask $task_name -ErrorAction SilentlyContinue

if ($task) {
    _warning "Scheduled task '$task_name' already exists."
    _info "  executable path : $($task.Actions.Execute)"
    _info "You can cancel current installation process,"
    _info "or proceed (this will replace the existing task)."
    if (!(_request_consent "Proceed?")) {
        _warning "Installation cancelled by user."
        _newline
        exit
    }
    Unregister-ScheduledTask -TaskName $task.TaskName -Confirm:$false
}

$task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -Settings $settings
Register-ScheduledTask $task_name -InputObject $task | Out-Null

# create application shortcut
$objShell = New-Object -ComObject ("WScript.Shell")
$objShortCut = $objShell.CreateShortcut((Join-Path $env:USERPROFILE "Start Menu\Programs\$app_name`.lnk"))
$objShortCut.TargetPath = $executable_path
$objShortCut.WorkingDirectory = $PSScriptRoot
$objShortCut.Save()

# create registry entry for uninstallation
$favicon_path = Join-Path $PSScriptRoot 'assets\favicon-blue.ico'
$uninstall_script_path = Join-Path (Split-Path $executable_path) 'uninstall.ps1'
$uninstall_string = "powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File `"$uninstall_script_path`""
New-Item $uninstall_key -Force | Out-Null
New-ItemProperty $uninstall_key -Name DisplayName -PropertyType String -Value $app_name -Force | Out-Null
New-ItemProperty $uninstall_key -Name DisplayIcon -PropertyType String -Value $favicon_path -Force | Out-Null
New-ItemProperty $uninstall_key -Name UninstallString -PropertyType String -Value $uninstall_string -Force | Out-Null

# status message
_newline
_confirm_status "Installation complete"
_info "$app_name is set to start automatically at logon."

_newline
if (_request_consent "Would you like to launch $app_name now?") {
    _info "starting application"
    & $executable_path
}

_newline
