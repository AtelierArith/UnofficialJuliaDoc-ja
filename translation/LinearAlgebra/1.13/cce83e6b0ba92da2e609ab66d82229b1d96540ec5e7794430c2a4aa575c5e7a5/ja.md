```julia
rotate!(x, y, c, s)
```

`x`を`s*y + c*x`で上書きし、`y`を`c*y - conj(s)*x`で上書きします。`x`と`y`を返します。

!!! compat "Julia 1.5"
    `rotate!`にはJulia 1.5以降が必要です。

