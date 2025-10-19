```julia
LibGit2.reftype(ref::GitReference) -> Cint
```

Return a `Cint` corresponding to the type of `ref`:

  * `0` if the reference is invalid
  * `1` if the reference is an object id
  * `2` if the reference is symbolic
