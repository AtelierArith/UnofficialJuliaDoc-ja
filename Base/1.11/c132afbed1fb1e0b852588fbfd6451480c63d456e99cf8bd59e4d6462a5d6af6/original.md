```
count!([f=identity,] r, A)
```

Count the number of elements in `A` for which `f` returns `true` over the singleton dimensions of `r`, writing the result into `r` in-place.

!!! warning
    Behavior can be unexpected when any mutated argument shares memory with any other argument.


!!! compat "Julia 1.5"
    inplace `count!` was added in Julia 1.5.


# Examples

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> count!(<=(2), [1 1], A)
1×2 Matrix{Int64}:
 1  1

julia> count!(<=(2), [1; 1], A)
2-element Vector{Int64}:
 2
 0
```
