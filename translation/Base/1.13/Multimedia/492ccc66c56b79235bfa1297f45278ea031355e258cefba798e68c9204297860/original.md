```julia
showable(mime, x)
```

Return a boolean value indicating whether or not the object `x` can be written as the given `mime` type.

(By default, this is determined automatically by the existence of the corresponding [`show`](@ref) method for `typeof(x)`.  Some types provide custom `showable` methods; for example, if the available MIME formats depend on the *value* of `x`.)

# Examples

```jldoctest
julia> showable(MIME("text/plain"), rand(5))
true

julia> showable("image/png", rand(5))
false
```
