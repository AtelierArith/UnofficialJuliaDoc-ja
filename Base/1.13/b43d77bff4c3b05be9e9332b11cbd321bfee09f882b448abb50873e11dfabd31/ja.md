```julia
LogicalIndex(mask)
```

`LogicalIndex`型は、`mask[I]`がtrueとなるすべてのインデックスIを格納する特殊なベクトルです。この特殊な型は、直接インデックス指定できません。直接指定を可能にすると、検索にO(n)の時間がかかるためです。`AbstractArray{Bool}`は、[`to_indices`](@ref)の呼び出し時に`LogicalIndex`でラップされます。
