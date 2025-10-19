```julia
@ntuple N expr
```

`N`-タプルを生成します。`@ntuple 2 i`は`(i_1, i_2)`を生成し、`@ntuple 2 k->k+1`は`(2,3)`を生成します。
