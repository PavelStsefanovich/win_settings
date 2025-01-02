param(
    [switch] $package
)

$ErrorActionPreference = 'Stop'
$app_name = 'WinSettingsShortcuts'

try {
    # init
    $current_location = $PWD.Path
    Set-Location $PSScriptRoot

    if (!(Get-Command python -ErrorAction SilentlyContinue)) { throw "Python is not installed" }
    Write-Host "Python version: $(python --version)" -ForegroundColor Gray

    # virtual environment
    Write-Host "`n:: Creating virtual environment..." -ForegroundColor Gray
    & python -m venv .venv
    & .venv\Scripts\Activate.ps1

    # dependencies
    Write-Host "`n:: Installing dependencies..." -ForegroundColor Gray
    if (!(Get-Command pip -ErrorAction SilentlyContinue)) { & python get-pip.py }
    & pip install -r requirements.txt

    # build
    Write-Host "`n:: Building..." -ForegroundColor Gray
    Get-Item dist, *.zip, "$app_name`.exe" -ErrorAction SilentlyContinue | Remove-Item -Force -recurse

    $pyinstaller_cmd = "pyinstaller"
    $pyinstaller_cmd += " -F -i assets\favicon-blue.ico"
    $pyinstaller_cmd += " -n $app_name"
    $pyinstaller_cmd += " --windowed"
    $pyinstaller_cmd += " --clean"
    $pyinstaller_cmd += " main.py"

    # <#
    # debug options:
    #   --debug=imports (must not be used together with "--windowed")
    # #>

    Write-Host "[EXECUTING] '$pyinstaller_cmd'" -ForegroundColor Gray
    Invoke-Expression $pyinstaller_cmd

    & deactivate

    # package
    if ( $package ) {
        Write-Host "`n:: Packaging..." -ForegroundColor Gray
        mkdir ".\dist\$app_name" | Out-Null
        foreach ($item in @("dist\$app_name`.exe", 'assets', 'README.md', 'build.ps1', 'install.ps1', 'uninstall.ps1')) {
            (Get-Item $item).FullName | ForEach-Object { Copy-Item $_ ".\dist\$($app_name)" -Force -Recurse }
        }
        Add-Type -AssemblyName "system.io.compression.filesystem"
        $source_dir = Join-Path $PSScriptRoot "dist\$app_name"
        $output_zip = Join-Path $PSScriptRoot "$app_name`.zip"
        [io.compression.zipfile]::CreateFromDirectory($source_dir, $output_zip, "Optimal", $false)
    }

    Move-Item "dist\$app_name`.exe" $PSScriptRoot -Force
    Write-Host "BUILD FINISHED" -ForegroundColor Green
}
catch {
    if ( $_.Exception.Message.Trim() -eq 'Operation did not complete successfully because the file contains a virus or potentially unwanted software.' ) {
        Write-Warning "Windows Defender may be blocking this build. Try adding the build directory to the exclusion list."
    }
    Write-Host "[ERROR] BUILD FAILED" -ForegroundColor Red
    throw $_
}
finally {
    Set-Location $current_location
}
