```julia
listen(path::AbstractString) -> PipeServer
```

名前付きパイプ / UNIX ドメインソケットを作成してリッスンします。

!!! note
    Unix ではパスの長さは92バイトから108バイトの間に制限されています（cf. `man unix`）。

