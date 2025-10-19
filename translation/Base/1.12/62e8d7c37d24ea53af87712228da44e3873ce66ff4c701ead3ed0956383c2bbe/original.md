```julia
any(p, itr) -> Bool
```

Determine whether predicate `p` returns `true` for any elements of `itr`, returning `true` as soon as the first item in `itr` for which `p` returns `true` is encountered (short-circuiting). To short-circuit on `false`, use [`all`](@ref).

If the input contains [`missing`](@ref) values, return `missing` if all non-missing values are `false` (or equivalently, if the input contains no `true` value), following [three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic).

# Examples

```jldoctest
julia> any(i->(4<=i<=6), [3,5,7])
true

julia> any(i -> (println(i); i > 3), 1:10)
1
2
3
4
true

julia> any(i -> i > 0, [1, missing])
true

julia> any(i -> i > 0, [-1, missing])
missing

julia> any(i -> i > 0, [-1, 0])
false
```
