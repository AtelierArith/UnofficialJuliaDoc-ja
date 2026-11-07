```julia
LibGit2.DescribeFormatOptions
```

Matches the [`git_describe_format_options`](https://libgit2.org/libgit2/#HEAD/type/git_describe_format_options) struct.

The fields represent:

  * `version`: version of the struct in use, in case this changes later. For now, always `1`.
  * `abbreviated_size`: lower bound on the size of the abbreviated `GitHash` to use, defaulting to `7`.
  * `always_use_long_format`: set to `1` to use the long format for strings even if a short format can be used.
  * `dirty_suffix`: if set, this will be appended to the end of the description string if the [`workdir`](@ref) is dirty.
