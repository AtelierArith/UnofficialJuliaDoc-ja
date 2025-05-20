```
content(blob::GitBlob) -> String
```

[`GitBlob`](@ref) `blob`の内容を取得します。`blob`がバイナリデータを含む場合（[`isbinary`](@ref)を使用して判断できます）、エラーをスローします。それ以外の場合は、`blob`の内容を含む`String`を返します。
