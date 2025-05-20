```
TextDisplay(io::IO)
```

`TextDisplay <: AbstractDisplay` を返し、任意のオブジェクトをテキスト/プレーン MIME タイプとして表示し（デフォルト）、テキスト表現を指定された I/O ストリームに書き込みます。（これが Julia REPL でオブジェクトが印刷される方法です。）
