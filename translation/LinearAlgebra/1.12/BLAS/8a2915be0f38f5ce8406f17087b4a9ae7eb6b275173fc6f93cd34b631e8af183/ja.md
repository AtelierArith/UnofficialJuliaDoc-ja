```julia
geru!(alpha, x, y, A)
```

ベクトル `x` と `y` を用いて行列 `A` のランク-1 更新を行います。更新は `alpha*x*transpose(y) + A` です。
