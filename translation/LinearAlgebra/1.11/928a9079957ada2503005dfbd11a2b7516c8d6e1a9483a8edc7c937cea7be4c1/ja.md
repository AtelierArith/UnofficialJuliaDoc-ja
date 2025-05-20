```
reflect!(x, y, c, s)
```

`x`を`c*x + s*y`で上書きし、`y`を`conj(s)*x - c*y`で上書きします。`x`と`y`を返します。

!!! compat "Julia 1.5"
    `reflect!`は少なくともJulia 1.5が必要です。

