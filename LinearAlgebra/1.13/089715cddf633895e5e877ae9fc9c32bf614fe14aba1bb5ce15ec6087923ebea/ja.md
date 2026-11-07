```julia
issuccess(F::Factorization)
```

行列の因子分解が成功したことを確認します。

!!! compat "Julia 1.6"
    `issuccess(::CholeskyPivoted)` は Julia 1.6 以降が必要です。


# Examples

```jldoctest
julia> F = cholesky([1 0; 0 1]);

julia> issuccess(F)
true
```
