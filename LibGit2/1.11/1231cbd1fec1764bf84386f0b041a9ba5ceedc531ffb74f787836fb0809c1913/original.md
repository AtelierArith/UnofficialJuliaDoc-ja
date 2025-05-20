```
LibGit2.cherrypick(repo::GitRepo, commit::GitCommit; options::CherrypickOptions = CherrypickOptions())
```

Cherrypick the commit `commit` and apply the changes in it to the current state of `repo`. The keyword argument `options` sets checkout and merge options for the cherrypick.

!!! note
    `cherrypick` will *apply* the changes in `commit` but not *commit* them, so `repo` will be left in a dirty state. If you want to also commit the changes in `commit` you must call [`commit`](@ref) yourself.

