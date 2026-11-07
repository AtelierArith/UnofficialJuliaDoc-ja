```julia
unsafe_textbuf(stream)
```

解析中の `Vector{UInt8}` テキストバッファを返します。このバッファは `ParseStream` によって解析されています。

!!! warning
    textbuf の使用中は、呼び出し元が `stream` への参照を保持している必要があります。

