```julia
reflect!(x, y, c, s)
```

`x` を `c*x + s*y` で、`y` を `conj(s)*x - c*y` で上書きします。`x` と `y` を返します。

!!! compat "Julia 1.5"
    `reflect!` には Julia 1.5 以降が必要です。

