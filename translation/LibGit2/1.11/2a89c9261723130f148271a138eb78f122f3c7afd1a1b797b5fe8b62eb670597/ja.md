```julia
rawcontent(blob::GitBlob)::Vector{UInt8}
```

[`GitBlob`](@ref) `blob`の*生の*内容を取得します。これは、blobの内容を格納した`Array`であり、バイナリの場合もUnicodeの場合もあります。この`Array`に書き込んでも、ディスク上のblobは更新されません。`rawcontent`を使うと、ユーザーは生のバイナリデータを出力`Array`に読み込めます。また、有効なUnicodeかどうかの検証は行われないため、結果を有効なUnicodeデータを想定する関数に渡すとエラーが発生する場合があります。

[`content`](@ref)も参照してください。こちらは、`blob`の内容がバイナリで、有効なUnicodeではない場合にエラーをスローします。
