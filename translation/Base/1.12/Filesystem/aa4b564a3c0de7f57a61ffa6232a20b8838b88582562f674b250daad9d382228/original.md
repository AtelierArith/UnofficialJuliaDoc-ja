```julia
ispath(path) -> Bool
ispath(path_elements...) -> Bool
```

Return `true` if a valid filesystem entity exists at `path`, otherwise returns `false`.

This is the generalization of [`isfile`](@ref), [`isdir`](@ref) etc.
