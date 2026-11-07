```julia
reflect!(x, y, c, s)
```

`x`を`c*x + s*y`で上書きし、`y`を`conj(s)*x - c*y`で上書きします。`x`と`y`を返します。

!!! compat "Julia 1.5"
    `reflect!`にはJulia 1.5以降が必要です。

