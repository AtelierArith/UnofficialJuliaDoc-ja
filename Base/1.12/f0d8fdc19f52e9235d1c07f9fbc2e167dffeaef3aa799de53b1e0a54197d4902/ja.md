```julia
map!(function, array)
```

[`map`](@ref)と同様ですが、結果を同じ配列に格納します。

!!! compat "Julia 1.12"
    このメソッドはJulia 1.12以降が必要です。以前のバージョンもサポートするには、同等の`map!(function, array, array)`を使用してください。


# 例

```jldoctest
julia> a = [1 2 3; 4 5 6];

julia> map!(x -> x^3, a);

julia> a
2×3 Matrix{Int64}:
  1    8   27
 64  125  216
```
