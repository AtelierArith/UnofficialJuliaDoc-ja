```
rotate!(x, y, c, s)
```

`x`を`c*x + s*y`で上書きし、`y`を`-conj(s)*x + c*y`で上書きします。`x`と`y`を返します。

!!! compat "Julia 1.5"
    `rotate!`は少なくともJulia 1.5を必要とします。

