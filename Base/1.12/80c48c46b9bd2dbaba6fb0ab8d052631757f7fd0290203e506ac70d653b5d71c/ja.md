```julia
findmax!(rval, rind, A) -> (maxval, index)
```

`A`の最大値と対応する線形インデックスを`rval`と`rind`の単一次元に沿って見つけ、結果を`rval`と`rind`に格納します。`NaN`は`missing`を除くすべての値よりも大きいと見なされます。

!!! warning
    変更された引数が他の引数とメモリを共有している場合、動作が予期しないものになることがあります。

