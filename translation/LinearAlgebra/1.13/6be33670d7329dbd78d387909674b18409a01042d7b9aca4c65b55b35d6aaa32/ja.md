```julia
reflectorApply!(x, τ, A)
```

左からハウスホルダー反射を適用し、`A`をインプレースで乗算します。これは`A .= (I - [1; x[2:end]] * conj(τ) * [1; x[2:end]]') * A`と等価です。
