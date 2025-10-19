```julia
mapreduce(f, op, A::AbstractArray...; dims=:, [init])
```

`reduce(op, map(f, A...); dims=dims, init=init)` と同じ結果になりますが、中間配列を避けるため、一般的に高速です。

!!! compat "Julia 1.2"
    複数のイテレータを持つ `mapreduce` は、Julia 1.2 以降が必要です。


# 例

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
