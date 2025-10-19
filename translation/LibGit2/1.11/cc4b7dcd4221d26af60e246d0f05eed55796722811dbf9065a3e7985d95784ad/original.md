```julia
LibGit2.DescribeOptions
```

Matches the [`git_describe_options`](https://libgit2.org/libgit2/#HEAD/type/git_describe_options) struct.

The fields represent:

  * `version`: version of the struct in use, in case this changes later. For now, always `1`.
  * `max_candidates_tags`: consider this many most recent tags in `refs/tags` to describe a commit.  Defaults to 10 (so that the 10 most recent tags would be examined to see if they describe a commit).
  * `describe_strategy`: whether to consider all entries in `refs/tags` (equivalent to `git-describe --tags`)  or all entries in `refs/` (equivalent to `git-describe --all`). The default is to only show annotated tags.  If `Consts.DESCRIBE_TAGS` is passed, all tags, annotated or not, will be considered.  If `Consts.DESCRIBE_ALL` is passed, any ref in `refs/` will be considered.
  * `pattern`: only consider tags which match `pattern`. Supports glob expansion.
  * `only_follow_first_parent`: when finding the distance from a matching reference to the described  object, only consider the distance from the first parent.
  * `show_commit_oid_as_fallback`: if no matching reference can be found which describes a commit, show the  commit's [`GitHash`](@ref) instead of throwing an error (the default behavior).
