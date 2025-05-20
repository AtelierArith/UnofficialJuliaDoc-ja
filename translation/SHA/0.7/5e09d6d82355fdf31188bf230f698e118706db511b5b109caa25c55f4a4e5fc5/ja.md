```
update!(context, data[, datalen])
```

データ内のバイトでSHAコンテキストを更新します。ハッシュを最終化するための[`digest!`](@ref)も参照してください。

# 例

```julia-repl
julia> ctx = SHA1_CTX()
SHA1ハッシュ状態

julia> update!(ctx, b"ハッシュされるデータ")
```
