```julia
partialsort!(v, k; by=identity, lt=isless, rev=false, order::Base.Order.Ordering=Base.Order.Forward)
```

ベクトル `v` を変更し、インデックス `k`（または、`k` が範囲の場合は隣接する値の範囲）にある値が、配列全体をソートした場合に現れる位置へ移動するようにします。`k` が単一のインデックスなら、その値を返します。`k` が範囲なら、それらのインデックスにある値を配列として返します。`partialsort!` は、入力配列全体をソートするとは限らないことに注意してください。

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
