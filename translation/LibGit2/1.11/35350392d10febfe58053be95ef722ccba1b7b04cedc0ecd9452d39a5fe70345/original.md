```
LibGit2.CheckoutOptions
```

Matches the [`git_checkout_options`](https://libgit2.org/libgit2/#HEAD/type/git_checkout_options) struct.

The fields represent:

  * `version`: version of the struct in use, in case this changes later. For now, always `1`.
  * `checkout_strategy`: determine how to handle conflicts and whether to force the  checkout/recreate missing files.
  * `disable_filters`: if nonzero, do not apply filters like CLRF (to convert file newlines between UNIX and DOS).
  * `dir_mode`: read/write/access mode for any directories involved in the checkout. Default is `0755`.
  * `file_mode`: read/write/access mode for any files involved in the checkout.  Default is `0755` or `0644`, depending on the blob.
  * `file_open_flags`: bitflags used to open any files during the checkout.
  * `notify_flags`: Flags for what sort of conflicts the user should be notified about.
  * `notify_cb`: An optional callback function to notify the user if a checkout conflict occurs.  If this function returns a non-zero value, the checkout will be cancelled.
  * `notify_payload`: Payload for the notify callback function.
  * `progress_cb`: An optional callback function to display checkout progress.
  * `progress_payload`: Payload for the progress callback.
  * `paths`: If not empty, describes which paths to search during the checkout.  If empty, the checkout will occur over all files in the repository.
  * `baseline`: Expected content of the [`workdir`](@ref), captured in a (pointer to a)  [`GitTree`](@ref). Defaults to the state of the tree at HEAD.
  * `baseline_index`: Expected content of the [`workdir`](@ref), captured in a (pointer to a)  `GitIndex`. Defaults to the state of the index at HEAD.
  * `target_directory`: If not empty, checkout to this directory instead of the `workdir`.
  * `ancestor_label`: In case of conflicts, the name of the common ancestor side.
  * `our_label`: In case of conflicts, the name of "our" side.
  * `their_label`: In case of conflicts, the name of "their" side.
  * `perfdata_cb`: An optional callback function to display performance data.
  * `perfdata_payload`: Payload for the performance callback.
