```julia
dropdims(A; dims)
```

`A`と同じデータを持つ配列を返します。ただし、`dims`で指定された次元は削除されます。`dims`内のすべての`d`について、`size(A,d)`は1でなければならず、`1:ndims(A)`の範囲外にある次元や数値の重複は禁止されています。

結果は`A`と同じ基底データを共有します。そのため、`A`が変更可能である場合に限り結果も変更可能であり、一方の要素を設定すると、もう一方の値も変わります。

関連項目: [`reshape`](@ref)、[`vec`](@ref)。

# Examples

```jldoctest
julia> a = reshape(Vector(1:4),(2,2,1,1))
2×2×1×1 Array{Int64, 4}:
[:, :, 1, 1] =
 1  3
 2  4

julia> b = dropdims(a; dims=3)
2×2×1 Array{Int64, 3}:
[:, :, 1] =
 1  3
 2  4

julia> b[1,1,1] = 5; a
2×2×1×1 Array{Int64, 4}:
[:, :, 1, 1] =
 5  3
 2  4
```
