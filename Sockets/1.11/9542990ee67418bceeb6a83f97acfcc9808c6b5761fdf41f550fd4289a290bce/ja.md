```julia
connect(path::AbstractString) -> PipeEndpoint
```

名前付きパイプ / UNIX ドメインソケット `path` に接続します。

!!! note
    Unix では、パスの長さは 92〜108 バイト程度に制限されています（`man unix` を参照）。

