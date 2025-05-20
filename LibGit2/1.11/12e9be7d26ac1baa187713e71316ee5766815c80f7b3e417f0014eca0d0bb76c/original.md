```
isbare(repo::GitRepo) -> Bool
```

Determine if `repo` is bare. Suppose the top level directory of `repo` is `DIR`. A non-bare repository is one in which the git directory (see [`gitdir`](@ref)) is `DIR/.git`, and the working tree can be checked out. A bare repository is one in which all of git's administrative files are simply in `DIR`, rather than "hidden" in the `.git` subdirectory. This means that there is nowhere to check out the working tree, and no tracking information for remote branches or configurations is present.
