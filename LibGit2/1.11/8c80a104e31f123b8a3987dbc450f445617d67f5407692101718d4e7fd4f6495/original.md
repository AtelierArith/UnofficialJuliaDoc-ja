```
LibGit2.CherrypickOptions
```

Matches the [`git_cherrypick_options`](https://libgit2.org/libgit2/#HEAD/type/git_cherrypick_options) struct.

The fields represent:

  * `version`: version of the struct in use, in case this changes later. For now, always `1`.
  * `mainline`: if cherrypicking a merge commit, specifies the parent number (starting at `1`) which will allow cherrypick to apply the changes relative to that parent. Only relevant if cherrypicking a merge commit. Default is `0`.
  * `merge_opts`: options for merging the changes in. See [`MergeOptions`](@ref) for more information.
  * `checkout_opts`: options for the checkout of the commit being cherrypicked. See [`CheckoutOptions`](@ref)  for more information.
