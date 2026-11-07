```julia
map!(function, array)
```

[`map`](@ref)と同様ですが、結果は同じ配列に格納されます。

!!! compat "Julia 1.12"
    このメソッドを使用するには、Julia 1.12以降が必要です。それ以前のバージョンもサポートするには、同等の`map!(function, array, array)`を使用してください。


# Examples

```jldoctest
julia> a = [1 2 3; 4 5 6];

julia> map!(x -> x^3, a);

julia> a
2×3 Matrix{Int64}:
  1    8   27
 64  125  216
```
