```julia
issuccess(F::Factorization)
```

行列の因数分解が成功したかどうかをテストします。

!!! compat "Julia 1.6"
    `issuccess(::CholeskyPivoted)` はJulia 1.6以降が必要です。


# 例

```jldoctest
julia> F = cholesky([1 0; 0 1]);

julia> issuccess(F)
true
```
