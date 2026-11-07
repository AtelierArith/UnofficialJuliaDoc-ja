```julia
mul!(C, A, B, α, β) -> C
```

行列と行列、または行列とベクトルの積和演算をインプレースで行います ``A B α + C β``。結果は `C` に上書きして格納されます。`C` は `A` または `B` とエイリアスになっていてはならない点に注意してください。

!!! compat "Julia 1.3"
    5 引数の `mul!` を使用するには、Julia 1.3 以降が必要です。


# Examples

```jldoctest
julia> A = [1.0 2.0; 3.0 4.0]; B = [1.0 1.0; 1.0 1.0]; C = [1.0 2.0; 3.0 4.0];

julia> α, β = 100.0, 10.0;

julia> mul!(C, A, B, α, β) === C
true

julia> C
2×2 Matrix{Float64}:
 310.0  320.0
 730.0  740.0

julia> C_original = [1.0 2.0; 3.0 4.0]; # A copy of the original value of C

julia> C == A * B * α + C_original * β
true
```
