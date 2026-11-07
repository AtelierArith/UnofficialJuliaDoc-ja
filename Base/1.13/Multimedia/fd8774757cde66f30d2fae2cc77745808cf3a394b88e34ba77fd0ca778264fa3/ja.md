```julia
TextDisplay(io::IO)
```

`TextDisplay <: AbstractDisplay`を返します。これは、任意のオブジェクトを（デフォルトで）text/plain MIME タイプとして表示し、そのテキスト表現を指定された I/O ストリームに書き込みます。（Julia REPL でオブジェクトを表示する方法です。）
