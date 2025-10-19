```julia
partialsort!(v, k; by=identity, lt=isless, rev=false)
```

ベクトル `v` をインプレースで部分的にソートし、インデックス `k` の値（または `k` が範囲の場合は隣接する値の範囲）が配列が完全にソートされた場合に出現する位置に配置されるようにします。`k` が単一のインデックスの場合、その値が返されます。`k` が範囲の場合、そのインデックスにある値の配列が返されます。`partialsort!` は入力配列を完全にソートしない場合があることに注意してください。

キーワード引数については、[`sort!`](@ref) のドキュメントを参照してください。

# 例

```jldoctest
julia> a = [1, 2, 4, 3, 4]
5-element Vector{Int64}:
 1
 2
 4
 3
 4

julia> partialsort!(a, 4)
4

julia> a
5-element Vector{Int64}:
 1
 2
 3
 4
 4

julia> a = [1, 2, 4, 3, 4]
5-element Vector{Int64}:
 1
 2
 4
 3
 4

julia> partialsort!(a, 4, rev=true)
2

julia> a
5-element Vector{Int64}:
 4
 4
 3
 2
 1
```
