```
allequal(itr) -> Bool
allequal(f, itr) -> Bool
```

Return `true` if all values from `itr` are equal when compared with [`isequal`](@ref). Or if all of `[f(x) for x in itr]` are equal, for the second method.

Note that `allequal(f, itr)` may call `f` fewer than `length(itr)` times. The precise number of calls is regarded as an implementation detail.

See also: [`unique`](@ref), [`allunique`](@ref).

!!! compat "Julia 1.8"
    The `allequal` function requires at least Julia 1.8.


!!! compat "Julia 1.11"
    The method `allequal(f, itr)` requires at least Julia 1.11.


# Examples

```jldoctest
julia> allequal([])
true

julia> allequal([1])
true

julia> allequal([1, 1])
true

julia> allequal([1, 2])
false

julia> allequal(Dict(:a => 1, :b => 1))
false

julia> allequal(abs2, [1, -1])
true
```
