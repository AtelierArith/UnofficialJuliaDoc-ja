```julia
parent(A)
```

ビューの基になる親オブジェクトを返します。`SubArray`、`SubString`、`ReshapedArray`、`LinearAlgebra.Transpose`型のオブジェクトでは、この親オブジェクトは、オブジェクトの作成時に引数として`view`、`reshape`、`transpose`などに渡されたものです。入力がラップされたオブジェクトでない場合は、入力自体を返します。入力が複数回ラップされている場合、取り除かれるのは最外層のラッパーだけです。

# Examples

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
