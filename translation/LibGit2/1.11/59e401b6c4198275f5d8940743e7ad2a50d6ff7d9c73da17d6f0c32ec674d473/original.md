```julia
LibGit2.FetchHead
```

Contains the information about HEAD during a fetch, including the name and URL of the branch fetched from, the oid of the HEAD, and whether the fetched HEAD has been merged locally.

The fields represent:

  * `name`: The name in the local reference database of the fetch head, for example,  `"refs/heads/master"`.
  * `url`: The URL of the fetch head.
  * `oid`: The [`GitHash`](@ref) of the tip of the fetch head.
  * `ismerge`: Boolean flag indicating whether the changes at the  remote have been merged into the local copy yet or not. If `true`, the local  copy is up to date with the remote fetch head.
