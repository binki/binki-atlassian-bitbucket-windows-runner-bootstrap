IF NOT DEFINED BITBUCKET_RUNNER_START (
  ECHO BITBUCKET_RUNNER_START variable must be defined.
  EXIT /B 1
)

: # Do this in the profile directory.
CD %USERPROFILE%

: # Disable powershell security. See https://support.atlassian.com/bitbucket-cloud/docs/set-up-runners-for-windows/#Allow-unsigned-scripts-to-run-in-PowerShell 
ECHO Set-ExecutionPolicy Bypass | powershell -noprofile -

: # Work around a performance issue specific to Hyper-V guests on systems using “Killer” WiFi
ECHO Get-NetAdapterAdvancedProperty ^^^| Where-Object RegistryKeyword -like '*Lso*IPv*' ^^^| Select-Object -Property Name,RegistryKeyword,@{name='RegistryValue';expression={'0'}} ^^^| Set-NetAdapterAdvancedProperty | powershell -noprofile -

: # Disable the Windows pagefile and swapfile (recommended by Bitbucket). See https://stackoverflow.com/a/37813686
ECHO $c = Get-CimInstance Win32_ComputerSystem; $c.AutomaticManagedPagefile = $False; Set-CimInstance $c; foreach ($p in Get-CimInstance Win32_PageFile) { Remove-CimInstance $p } | powershell -noprofile -

: # See https://docs.chocolatey.org/en-us/choco/setup/#install-with-cmdexe
ECHO iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) | powershell -noprofile -
SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

choco install -y git temurin11 git-lfs.install

: # The PATH will be updated to include Java. The bootstrap scripts require us to preload that path. Use the chocolatey-provided script.
RefreshEnv

curl -Lo atlassian-bitbucket-pipelines-runner.zip https://product-downloads.atlassian.com/software/bitbucket/pipelines/atlassian-bitbucket-pipelines-runner-3.23.0.zip
MD atlassian-bitbucket-pipelines-runner
CD atlassian-bitbucket-pipelines-runner
: # yay libarchive
tar -xf ..\atlassian-bitbucket-pipelines-runner.zip

SET STARTUP_SCRIPT_PATH=%USERPROFILE%\bitbucket-runner.cmd
ECHO CD "%USERPROFILE%\atlassian-bitbucket-pipelines-runner\bin" > "%STARTUP_SCRIPT_PATH%"
ECHO powershell -noprofile %BITBUCKET_RUNNER_START% >> "%STARTUP_SCRIPT_PATH%"

schtasks /create /sc ONLOGON /tn bitbucket-pipelines-runner /tr "%STARTUP_SCRIPT_PATH%" /rl HIGHEST

shutdown /r /t 0
