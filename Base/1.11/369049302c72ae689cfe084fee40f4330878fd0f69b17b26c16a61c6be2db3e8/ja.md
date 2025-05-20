```
redirect_stdio(;stdin=stdin, stderr=stderr, stdout=stdout)
```

`stdin`、`stderr`、`stdout` のサブセットのストリームをリダイレクトします。各引数は `IOStream`、`TTY`、[`Pipe`](@ref)、ソケット、または `devnull` でなければなりません。

!!! compat "Julia 1.7"
    `redirect_stdio` は Julia 1.7 以降が必要です。

