```
LibGit2.GitDescribeResult(repo::GitRepo; kwarg...)
```

Produce a `GitDescribeResult` of the repository `repo`'s working directory. The `GitDescribeResult` contains detailed information about the workdir based on the keyword argument:

  * `options::DescribeOptions=DescribeOptions()`

In this case, the description is run on HEAD, producing the most recent tag which is an ancestor of HEAD. Afterwards, a status check on the [`workdir`](@ref) is performed and if the `workdir` is dirty (see [`isdirty`](@ref)) the description is also considered dirty.

Equivalent to `git describe`. See [`DescribeOptions`](@ref) for more information.
