```julia
listen(path::AbstractString) -> PipeServer
```

名前付きパイプ / UNIX ドメインソケットを作成して、接続を待ち受けます。

!!! note
    Unix ではパスの長さが 92〜108 バイト程度に制限されています（`man unix` を参照）。

