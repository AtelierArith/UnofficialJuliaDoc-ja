```julia
count([f=identity,] itr; init=0) -> Integer
```

Count the number of elements in `itr` for which the function `f` returns `true`. If `f` is omitted, count the number of `true` elements in `itr` (which should be a collection of boolean values). `init` optionally specifies the value to start counting from and therefore also determines the output type.

!!! compat "Julia 1.6"
    `init` keyword was added in Julia 1.6.


See also: [`any`](@ref), [`sum`](@ref).

# Examples

```jldoctest
julia> count(i->(4<=i<=6), [2,3,4,5,6])
3

julia> count([true, false, true, true])
3

julia> count(>(3), 1:7, init=0x03)
0x07
```
