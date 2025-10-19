Priority level of a config file.

These priority levels correspond to the natural escalation logic (from higher to lower) when searching for config entries in git.

  * `CONFIG_LEVEL_DEFAULT` - Open the global, XDG and system configuration files if any available.
  * `CONFIG_LEVEL_PROGRAMDATA` - System-wide on Windows, for compatibility with portable git
  * `CONFIG_LEVEL_SYSTEM` - System-wide configuration file; `/etc/gitconfig` on Linux systems
  * `CONFIG_LEVEL_XDG` - XDG compatible configuration file; typically `~/.config/git/config`
  * `CONFIG_LEVEL_GLOBAL` - User-specific configuration file (also called Global configuration file); typically `~/.gitconfig`
  * `CONFIG_LEVEL_LOCAL` - Repository specific configuration file; `$WORK_DIR/.git/config` on non-bare repos
  * `CONFIG_LEVEL_WORKTREE` - Worktree specific configuration file; `$GIT_DIR/config.worktree`
  * `CONFIG_LEVEL_APP` - Application specific configuration file; freely defined by applications
  * `CONFIG_HIGHEST_LEVEL` - Represents the highest level available config file (i.e. the most specific config file available that actually is loaded)
