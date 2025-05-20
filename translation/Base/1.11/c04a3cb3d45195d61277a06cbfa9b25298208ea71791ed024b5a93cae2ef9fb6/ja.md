```
redirect_stdin([stream]) -> stream
```

[`stdout`](@ref)と同様ですが、[`stdin`](@ref)用です。ストリームの方向が逆になっていることに注意してください。

!!! note
    `stream`は、`IOStream`、`TTY`、[`Pipe`](@ref)、ソケット、または`devnull`などの互換性のあるオブジェクトでなければなりません。


他にも[`redirect_stdio`](@ref)を参照してください。
