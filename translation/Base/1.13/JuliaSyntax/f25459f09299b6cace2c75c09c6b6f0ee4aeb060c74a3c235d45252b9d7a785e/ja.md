```julia
unsafe_textbuf(stream)
```

解析中の`Vector{UInt8}`テキストバッファを返します。このバッファは`ParseStream`です。

!!! warning
    textbufを使用する間、呼び出し元は`stream`への参照を保持していなければなりません。

