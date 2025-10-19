```julia
redirect_stdio(;stdin=stdin, stderr=stderr, stdout=stdout)
```

`stdin`、`stderr`、`stdout`のサブセットをリダイレクトします。各引数は`IOStream`、`TTY`、[`Pipe`](@ref)、ソケット、または`devnull`でなければなりません。

!!! compat "Julia 1.7"
    `redirect_stdio`はJulia 1.7以降が必要です。

