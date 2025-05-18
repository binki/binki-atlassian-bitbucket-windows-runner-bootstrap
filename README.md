This attempts to perform the [steps to setup a self-hosted Windows runner](https://support.atlassian.com/bitbucket-cloud/docs/set-up-runners-for-windows/) documented by Atlassian for you. The purpose of automating these steps is to reduce the number of manual steps required to set up a runner.

When setting up Windows, you must create an autologin account. Do this by ensuring there is no network connection during an install, pressing shift+F10, running the command `oobe\bypassnro` (which will reboot the system), and then proceeding by creating a local account with no password. This way, the user can automatically login and the scheduled task can be triggered on login, avoiding many issues with running things on headless Windows.

Usage instructions:

1. Open an Administrator Command Prompt on your VM.
2. Copy in the following:

    ```
    SET BITBUCKET_RUNNER_START=
    ```

3. Visit the “Add runner” page in Bitbucket.
4. Copy and past the `.\start.ps1` command into the administrator command prompt.
5. Press enter in the administrator command prompt. You will have set the `BITBUCKET_RUNNER_START` variable to the command starting with `.\start.ps1`.
6. Copy and paste the below and press enter:

```
curl -L https://github.com/binki/binki-atlassian-bitbucket-windows-runner-bootstrap/blob/master/bootstrap.cmd?raw=1 | CMD
```
