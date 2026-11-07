```julia
nzrange(A, col::Integer)
```

疎配列 `A` の列 `col` における、構造的に非ゼロの値のインデックス範囲を返します。[`nonzeros`](@ref) および [`rowvals`](@ref) と組み合わせることで、疎行列を簡単に反復処理できます。

```julia
A = sparse(I,J,V)
rows = rowvals(A)
vals = nonzeros(A)
m, n = size(A)
for j = 1:n
   for i in nzrange(A, j)
      row = rows[i]
      val = vals[i]
      # perform sparse wizardry...
   end
end
```

!!! warning
    行列への非ゼロ要素の追加や削除によって `nzrange` が無効になることがあります。反復処理中に行列を変更しないでください。

