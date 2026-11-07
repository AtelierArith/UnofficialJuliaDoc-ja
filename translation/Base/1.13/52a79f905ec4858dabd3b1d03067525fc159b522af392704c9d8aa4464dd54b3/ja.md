```julia
mapreduce(f, op, A::AbstractArray...; dims=:, [init])
```

`reduce(op, map(f, A...); dims=dims, init=init)` と同じ結果になりますが、中間配列を作成しないため、一般にこちらのほうが高速です。

!!! compat "Julia 1.2"
    複数のイテレータを使う `mapreduce` は、Julia 1.2 以降が必要です。


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
