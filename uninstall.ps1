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
$installed_task = Get-ScheduledTask "$app_name`_StartAtLogon_$env:USERNAME" -ErrorAction SilentlyContinue

if ($installed_task) {
    # remove scheduled task
    _newline
    _info "Found scheduled task '$($installed_task.TaskName)'."
    _info "  executable path : $($installed_task.Actions.Execute)"

    _newline
    if (_request_consent "Do you want to uninstall this application?") {
        _info "Uninstalling..."
        Unregister-ScheduledTask -TaskName $installed_task.TaskName -Confirm:$false

        # remove application shortcut
        Remove-Item (Join-Path $env:USERPROFILE "Start Menu\Programs\$app_name`.lnk") -Force

        # remove registry entry
        Get-Item $uninstall_key | Remove-Item -Force

        _newline
        _confirm_status "Uninstall complete"
    }
}
else {
    _newline
    _warning "No installations found for current user, exiting."
}

_newline
