```julia
findmax!(rval, rind, A) -> (maxval, index)
```

`rval`と`rind`の単一要素次元に沿って、`A`の最大値と対応する線形インデックスを求め、その結果を`rval`と`rind`に格納します。`NaN`は、`missing`を除くすべての値より大きいものとして扱われます。

!!! warning
    変更される引数がほかの引数とメモリを共有している場合、予期しない動作が起こることがあります。

