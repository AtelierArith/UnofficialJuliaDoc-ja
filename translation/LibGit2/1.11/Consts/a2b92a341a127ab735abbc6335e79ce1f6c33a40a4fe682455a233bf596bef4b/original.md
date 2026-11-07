Option flags for `GitRepo`.

  * `REPOSITORY_OPEN_NO_SEARCH` - Only open the repository if it can be immediately found in the `path`.  Do not walk up from the `path` looking at parent directories.
  * `REPOSITORY_OPEN_CROSS_FS` - Unless this flag is set, open will not continue searching across filesystem boundaries. (E.g. Searching in a user's home directory `/home/user/source/` will not return `/.git/` as the found repo if `/` is a different filesystem than `/home`.)
  * `REPOSITORY_OPEN_BARE` - Open repository as a bare repo regardless of core.bare config, and defer loading config file for faster setup.
