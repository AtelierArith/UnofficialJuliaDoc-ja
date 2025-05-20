```
nzrange(A::AbstractSparseMatrixCSC, col::Integer)
```

スパース行列の列の構造的非ゼロ値のインデックスの範囲を返します。[`nonzeros`](@ref)および[`rowvals`](@ref)と組み合わせることで、スパース行列を便利に反復処理できます：

```
A = sparse(I,J,V)
rows = rowvals(A)
vals = nonzeros(A)
m, n = size(A)
for j = 1:n
   for i in nzrange(A, j)
      row = rows[i]
      val = vals[i]
      # スパースの魔法を実行...
   end
end
```

!!! warning
    行列に非ゼロ要素を追加または削除すると、`nzrange`が無効になる可能性があるため、反復処理中に行列を変更しないでください。

