```julia
gecon!(normtype, A, anorm)
```

行列 `A` の逆条件数を求めます。`normtype = I` の場合、条件数は無限大ノルムで求められます。`normtype = O` または `1` の場合、条件数は1ノルムで求められます。`A` は `getrf!` の結果でなければならず、`anorm` は関連するノルムにおける `A` のノルムです。
