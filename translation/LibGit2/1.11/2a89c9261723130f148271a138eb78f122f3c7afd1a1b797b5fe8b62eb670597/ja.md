```julia
rawcontent(blob::GitBlob)::Vector{UInt8}
```

[`GitBlob`](@ref) `blob`の*生の*内容を取得します。これは、blobの内容を格納した`Array`です。内容はバイナリの場合もあれば、Unicodeの場合もあります。この`Array`に書き込んでも、ディスク上のblobは更新されません。`rawcontent`を使うと、未加工のバイナリデータを出力`Array`に読み込めますが、有効なUnicodeかどうかは検証されません。そのため、有効なUnicodeデータを想定する関数に結果を渡すと、エラーが発生することがあります。

[`content`](@ref)も参照してください。こちらは、`blob`の内容がバイナリで、有効なUnicodeではない場合にエラーをスローします。
