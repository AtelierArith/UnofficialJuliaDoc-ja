```
mul!(C, A, B, α, β) -> C
```

行列-行列または行列-ベクトルの組み合わせのインプレース乗算加算 $A B α + C β$。結果は `C` に上書きされて保存されます。 `C` は `A` または `B` とエイリアスされてはいけません。

!!! compat "Julia 1.3"
    五引数の `mul!` は少なくとも Julia 1.3 が必要です。


# 例

```jldoctest
julia> A = [1.0 2.0; 3.0 4.0]; B = [1.0 1.0; 1.0 1.0]; C = [1.0 2.0; 3.0 4.0];

julia> α, β = 100.0, 10.0;

julia> mul!(C, A, B, α, β) === C
true

julia> C
2×2 Matrix{Float64}:
 310.0  320.0
 730.0  740.0

julia> C_original = [1.0 2.0; 3.0 4.0]; # C の元の値のコピー

julia> C == A * B * α + C_original * β
true
```
