This attempts to perform the [steps to setup a self-hosted Windows runner](https://support.atlassian.com/bitbucket-cloud/docs/set-up-runners-for-windows/) documented by Atlassian for you. The purpose of automating these steps is to reduce the number of manual steps required to set up a runner.

When setting up Windows, you must create an autologin account. Do this by ensuring there is no network connection during an install, pressing shift+F10, running the command `oobe\bypassnro` (which will reboot the system), and then proceeding by creating a local account with no password. This way, the user can automatically login and the scheduled task can be triggered on login, avoiding many issues with running things on headless Windows.

In order to bootstrap a runner, you must first visit the “Add runner” page in Bitbucket and copy the `.\start.ps1` command. Then open an Administrator CMD and type `SET BITBUCKET_RUNNER_START=` and then paste and press enter. Finally, copy and paste the following and press enter:

```
SET BITBUCKET_RUNNER_START=.\start.ps1 -accountUuid '{scrubbed}' -repositoryUuid '{scrubbed}' -runnerUuid '{scrubbed}' -OAuthClientId scrubbed -OAuthClientSecret scrubbed -workingDirectory '..\temp'
curl -L https://github.com/binki/binki-atlassian-bitbucket-windows-runner-bootstrap/blob/master/bootstrap.cmd?raw=1 | CMD
```
