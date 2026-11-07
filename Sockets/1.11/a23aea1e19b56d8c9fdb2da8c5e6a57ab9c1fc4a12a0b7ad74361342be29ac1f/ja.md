```julia
listen(path::AbstractString) -> PipeServer
```

名前付きパイプ／UNIXドメインソケットを作成して、接続を待ち受けます。

!!! note
    Unixでは、パスの長さは92～108バイト程度に制限されています（`man unix`）。

