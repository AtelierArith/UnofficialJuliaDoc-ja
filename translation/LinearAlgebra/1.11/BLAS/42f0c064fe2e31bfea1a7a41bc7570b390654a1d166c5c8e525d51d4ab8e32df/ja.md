```
rot!(n, X, incx, Y, incy, c, s)
```

`X`を`c*X + s*Y`で上書きし、`Y`を`-conj(s)*X + c*Y`で上書きします。これは、ストライド`incx`を持つ配列`X`の最初の`n`要素と、ストライド`incy`を持つ配列`Y`の最初の`n`要素に対して行われます。`X`と`Y`を返します。

!!! compat "Julia 1.5"
    `rot!`は少なくともJulia 1.5が必要です。

