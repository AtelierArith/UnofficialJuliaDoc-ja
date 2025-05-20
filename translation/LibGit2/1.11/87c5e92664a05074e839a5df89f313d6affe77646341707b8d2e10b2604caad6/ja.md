```
rawcontent(blob::GitBlob) -> Vector{UInt8}
```

[`GitBlob`](@ref) `blob`の*生*コンテンツを取得します。これは、blobの内容を含む`Array`であり、バイナリまたはUnicodeのいずれかである可能性があります。この`Array`に書き込んでも、ディスク上のblobは更新されません。`rawcontent`は、ユーザーが生のバイナリデータを出力`Array`にロードできるようにし、正しいUnicodeであることを確認しないため、結果が有効なUnicodeデータを期待する関数に渡されるとエラーが発生する可能性があります。

また、[`content`](@ref)も参照してください。これは、`blob`の内容がバイナリであり、有効なUnicodeでない場合にエラーをスローします。
