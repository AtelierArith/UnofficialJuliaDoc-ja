```julia
parent(A)
```

ビューの基になる親オブジェクトを返します。`SubArray`、`SubString`、`ReshapedArray`、または`LinearAlgebra.Transpose`のタイプのオブジェクトの親は、オブジェクト作成時に`view`、`reshape`、`transpose`などに引数として渡されたものです。入力がラップされたオブジェクトでない場合は、入力自体を返します。入力が複数回ラップされている場合は、最外層のラッパーのみが削除されます。

# 例

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> V = view(A, 1:2, :)
2×2 view(::Matrix{Int64}, 1:2, :) with eltype Int64:
 1  2
 3  4

julia> parent(V)
2×2 Matrix{Int64}:
 1  2
 3  4
```
