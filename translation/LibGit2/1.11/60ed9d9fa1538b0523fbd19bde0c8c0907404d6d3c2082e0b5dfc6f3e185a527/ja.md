```julia
content(blob::GitBlob)::String
```

[`GitBlob`](@ref) `blob` の内容を取得します。`blob` にバイナリデータが含まれている場合（[`isbinary`](@ref) を使って判定できます）は、エラーをスローします。それ以外の場合は、`blob` の内容を含む `String` を返します。
