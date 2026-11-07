```julia
redirect_stderr([stream]) -> stream
```

[`redirect_stdout`](@ref)と同様ですが、[`stderr`](@ref)向けです。

!!! note
    `stream`は、`IOStream`、`TTY`、[`Pipe`](@ref)、ソケット、`devnull`など、互換性のあるオブジェクトである必要があります。


[`redirect_stdio`](@ref)も参照してください。
