```julia
geru!(alpha, x, y, A)
```

行列 `A` をベクトル `x` および `y` によって `alpha*x*transpose(y) + A` としてランク1更新します。
