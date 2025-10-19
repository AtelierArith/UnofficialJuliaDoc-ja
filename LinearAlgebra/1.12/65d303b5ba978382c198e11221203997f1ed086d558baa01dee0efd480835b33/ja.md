```julia
issuccess(F::LU; allowsingular = false)
```

LU因子分解が成功したかどうかをテストします。デフォルトでは、有効だがランクが不足しているU因子を生成する因子分解は失敗と見なされます。これは`allowsingular = true`を渡すことで変更できます。

!!! compat "Julia 1.11"
    `allowsingular`キーワード引数はJulia 1.11で追加されました。


# 例

```jldoctest
julia> F = lu([1 2; 1 2], check = false);

julia> issuccess(F)
false

julia> issuccess(F, allowsingular = true)
true
```
