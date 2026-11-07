```julia
redirect_stdio(;stdin=stdin, stderr=stderr, stdout=stdout)
```

ストリームの一部をリダイレクトします：`stdin`、`stderr`、`stdout`。各引数には、`IOStream`、`TTY`、[`Pipe`](@ref)、ソケット、または`devnull`を指定する必要があります。

!!! compat "Julia 1.7"
    `redirect_stdio`にはJulia 1.7以降が必要です。

