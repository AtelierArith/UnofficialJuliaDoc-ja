```julia
LibGit2.StatusEntry
```

Providing the differences between the file as it exists in HEAD and the index, and providing the differences between the index and the working directory. Matches the `git_status_entry` struct.

The fields represent:

  * `status`: contains the status flags for the file, indicating if it is current, or has been changed in some way in the index or work tree.
  * `head_to_index`: a pointer to a [`DiffDelta`](@ref) which encapsulates the difference(s) between the file as it exists in HEAD and in the index.
  * `index_to_workdir`: a pointer to a `DiffDelta` which encapsulates the difference(s) between the file as it exists in the index and in the [`workdir`](@ref).
