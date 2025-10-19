```julia
skip(stream::TranscodingStream, offset)
```

`stream` から `offset` バイトが読み取られるか、`eof(stream)` に達するまでバイトを読み取ります。

読み取ったバイトを破棄して `stream` を返します。

この関数は、`offset` バイトを読み取る前に `eof(stream)` に達した場合、`EOFError` をスローしません。
