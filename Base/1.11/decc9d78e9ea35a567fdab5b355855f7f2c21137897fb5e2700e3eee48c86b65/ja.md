```
redirect_stderr([stream]) -> stream
```

[`stderr`](@ref) のための [`redirect_stdout`](@ref) と同様です。

!!! note
    `stream` は、`IOStream`、`TTY`、[`Pipe`](@ref)、ソケット、または `devnull` のような互換性のあるオブジェクトでなければなりません。


他に [`redirect_stdio`](@ref) を参照してください。
