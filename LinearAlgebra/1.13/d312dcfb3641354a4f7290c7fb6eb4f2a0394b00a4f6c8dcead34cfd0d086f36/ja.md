```julia
issuccess(F::LU; allowsingular = false)
```

行列の LU 分解が成功したかどうかをテストします。デフォルトでは、有効ではあるものの階数落ちした U 因子を生成する分解は失敗とみなされます。これは `allowsingular = true` を渡すことで変更できます。

!!! compat "Julia 1.11"
    `allowsingular` キーワード引数は Julia 1.11 で追加されました。


# Examples

```jldoctest
julia> F = lu([1 2; 1 2], check = false);

julia> issuccess(F)
false

julia> issuccess(F, allowsingular = true)
true
```
