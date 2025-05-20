```
LibGit2.GitDescribeResult(committish::GitObject; kwarg...)
```

Produce a `GitDescribeResult` of the `committish` `GitObject`, which contains detailed information about it based on the keyword argument:

  * `options::DescribeOptions=DescribeOptions()`

A git description of a `committish` object looks for the tag (by default, annotated, although a search of all tags can be performed) which can be reached from `committish` which is most recent. If the tag is pointing to `committish`, then only the tag is included in the description. Otherwise, a suffix is included which contains the number of commits between `committish` and the most recent tag. If there is no such tag, the default behavior is for the description to fail, although this can be changed through `options`.

Equivalent to `git describe <committish>`. See [`DescribeOptions`](@ref) for more information.
