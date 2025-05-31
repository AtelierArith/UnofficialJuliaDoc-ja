```
mapreduce(f, op, A::AbstractArray...; dims=:, [init])
```

Evaluates to the same as `reduce(op, map(f, A...); dims=dims, init=init)`, but is generally faster because the intermediate array is avoided.

!!! compat "Julia 1.2"
    `mapreduce` with multiple iterators requires Julia 1.2 or later.


# Examples

```jldoctest
julia> a = reshape(Vector(1:16), (4,4))
4×4 Matrix{Int64}:
 1  5   9  13
 2  6  10  14
 3  7  11  15
 4  8  12  16

julia> mapreduce(isodd, *, a, dims=1)
1×4 Matrix{Bool}:
 0  0  0  0

julia> mapreduce(isodd, |, a, dims=1)
1×4 Matrix{Bool}:
 1  1  1  1
```
