```
ismutable(v) -> Bool
```

Return `true` if and only if value `v` is mutable.  See [Mutable Composite Types](@ref) for a discussion of immutability. Note that this function works on values, so if you give it a `DataType`, it will tell you that a value of the type is mutable.

!!! note
    For technical reasons, `ismutable` returns `true` for values of certain special types (for example `String` and `Symbol`) even though they cannot be mutated in a permissible way.


See also [`isbits`](@ref), [`isstructtype`](@ref).

# Examples

```jldoctest
julia> ismutable(1)
false

julia> ismutable([1,2])
true
```

!!! compat "Julia 1.5"
    This function requires at least Julia 1.5.

