```
connect(path::AbstractString) -> PipeEndpoint
```

指定されたパスにある名前付きパイプ / UNIX ドメインソケットに接続します。

!!! note
    Unix ではパスの長さは92バイトから108バイトの間に制限されています（cf. `man unix`）。

