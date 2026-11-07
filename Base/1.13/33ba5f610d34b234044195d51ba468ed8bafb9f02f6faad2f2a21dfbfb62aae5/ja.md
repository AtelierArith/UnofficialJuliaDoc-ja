```julia
redirect_stdout([stream]) -> stream
```

C および Julia レベルのすべての [`stdout`](@ref) 出力をリダイレクトするパイプを作成します。パイプの両端を表すストリームを返します。[`stdout`](@ref) に書き込まれたデータは、パイプの `rd` 側から読み取れるようになります。

!!! note
    `stream` は、`IOStream`、`TTY`、[`Pipe`](@ref)、ソケット、`devnull` など、互換性のあるオブジェクトでなければなりません。


[`redirect_stdio`](@ref) も参照してください。
