```julia
redirect_stdin([stream]) -> stream
```

[`redirect_stdout`](@ref)と似ていますが、[`stdin`](@ref)の場合に使います。ストリームの方向が逆になる点に注意してください。

!!! note
    `stream`は、`IOStream`、`TTY`、[`Pipe`](@ref)、ソケット、`devnull`など、互換性のあるオブジェクトでなければなりません。


[`redirect_stdio`](@ref)も参照してください。
