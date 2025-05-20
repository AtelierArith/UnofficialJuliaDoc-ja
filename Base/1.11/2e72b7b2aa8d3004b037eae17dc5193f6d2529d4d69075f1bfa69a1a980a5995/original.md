```
all(itr) -> Bool
```

Test whether all elements of a boolean collection are `true`, returning `false` as soon as the first `false` value in `itr` is encountered (short-circuiting). To short-circuit on `true`, use [`any`](@ref).

If the input contains [`missing`](@ref) values, return `missing` if all non-missing values are `true` (or equivalently, if the input contains no `false` value), following [three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic).

See also: [`all!`](@ref), [`any`](@ref), [`count`](@ref), [`&`](@ref), , [`&&`](@ref), [`allunique`](@ref).

# Examples

```jldoctest
julia> a = [true,false,false,true]
4-element Vector{Bool}:
 1
 0
 0
 1

julia> all(a)
false

julia> all((println(i); v) for (i, v) in enumerate(a))
1
2
false

julia> all([missing, false])
false

julia> all([true, missing])
missing
```
