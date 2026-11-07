```julia
redirect_stdio(;stdin=stdin, stderr=stderr, stdout=stdout)
```

ストリーム `stdin`、`stderr`、`stdout` の一部をリダイレクトします。各引数には、`IOStream`、`TTY`、[`Pipe`](@ref)、ソケット、または `devnull` を指定する必要があります。

!!! compat "Julia 1.7"
    `redirect_stdio` は Julia 1.7 以降で必要です。

