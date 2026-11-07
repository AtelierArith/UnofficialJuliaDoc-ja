```julia
TextDisplay(io::IO)
```

`TextDisplay <: AbstractDisplay`を返します。これは、任意のオブジェクトを（デフォルトで）text/plain MIMEタイプとして表示し、そのテキスト表現を指定されたI/Oストリームに書き込みます。（Julia REPLでオブジェクトを表示する方法です。）
