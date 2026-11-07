```julia
partialsort!(v, k; by=identity, lt=isless, rev=false, order::Base.Order.Ordering=Base.Order.Forward)
```

ベクトル `v` を変更し、インデックス `k` の値（`k` が範囲の場合は、隣接する値の範囲）が、配列全体をソートした場合に現れる位置に来るようにします。`k` が単一のインデックスの場合はその値を返し、`k` が範囲の場合は、それらのインデックスにある値の配列を返します。`partialsort!` は入力配列を完全にはソートしない場合があることに注意してください。

キーワード引数については、[`sort!`](@ref) のドキュメントを参照してください。

# Examples

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
