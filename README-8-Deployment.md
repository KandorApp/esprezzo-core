# Deployment Tooling

We have included some tooling to aid in the setup and maintenance of full nodes. 

### Usage:
```
  edeliver <build-command|deploy-command|node-command|local-command> command-info [Options]
  edeliver --help|--version
  edeliver help <command>

  Build Commands:
  edeliver build release [--revision=<git-revision>|--tag=<git-tag>] [--branch=<git-branch>] [Options]
  edeliver build upgrade --from=<git-tag-or-revision>|--with=<release-version-from-store>
                        [--to=<git-tag-or-revision>] [--branch=<git-branch>] [Options]

  Deploy Commands:
  edeliver deploy release|upgrade [[to] staging|production] [--version=<release-version>] [Options]
  edeliver upgrade [staging|production] [--to=<git-tag-or-revision>] [--branch=<git-branch>] [Options]
  edeliver update  [staging|production] [--to=<git-tag-or-revision>] [--branch=<git-branch>] [Options]

  Node Commands:
  edeliver start|stop|restart|ping|version [staging|production] [Options]
  edeliver migrate [staging|production] [up|down] [--version=<migration-version>]
  edeliver [show] migrations [on] [staging|production]

  Local Commands:
  edeliver check release|config [--version=<release-version>]
  edeliver show releases|appups
  edeliver show relup <xyz.upgrade.tar.gz>
  edeliver edit relup|appups [--version=<release-version>]
  edeliver upload|download [release|upgrade <release-version>]|<src-file-name> [<dest-file-name>]
  edeliver increase [major|minor] versions [--from=<git-tag-or-revision>] [--to=<git-tag-or-revision>]
  edeliver unpack|pack release|upgrade [--version=<release-version>]


Options:
  -C, --compact         Displays every task as it's run, silences all output. (default mode)
  -V, --verbose         Same as above, does not silence output.
  -P, --plain           Displays every task as it's run, silences all output. No colouring. (CI)
  -D, --debug           Runs in shell debug mode, displays everything.
  -S, --skip-existing   Skip copying release archives if they exist already on the deploy hosts.
  -F, --force           Do not ask, just do, overwrite, delete or destroy everything
      --clean-deploy    Delete the release, lib and erts-* directories before deploying the release
      --skip-git-clean  Don't build from a clean state for faster builds. See  env
      --skip-mix-clean  Skip the 'mix clean step' for faster builds. Use in addition to --skip-git-clean
      --skip-relup-mod  Skip modification of relup file. Custom relup instructions are not added
      --relup-mod=<module-name> The name of the module to modify the relup
      --auto-version=revision|commit-count|branch|date Automatically append metadata to release version.
      --increment-version=major|minor|patch Increment the version for the current build.
      --set-version=<release-version> Set the release version for the current build.
      --start-deploy    Starts the deployed release. If release is running, it is restarted!
      --host=[u@]vwx.yz Run command only on that host, even if different hosts are configured
      --mix-env=<env>   Build with custom mix env $MIX_ENV. Default is 'prod'

Miscellaneous:
  Sometimes you will be asked, if you omit a required argument (e.g --from for the build upgrade task)
  You can overwrite any config at runtime:

  BUILD_HOST=build-2.acme.com edeliver build release
  GIT_CLEAN_PATHS='_build rel priv/generated' edeliver build release

  ```