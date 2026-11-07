```julia
mul!(Y, A, B) -> Y
```

行列と行列、または行列とベクトルの積 ``A B`` を計算し、その結果を `Y` に格納します。既存の `Y` の値は上書きされます。`Y` は、`A` または `B` とエイリアスになっていてはならない点に注意してください。

# Examples

```jldoctest
julia> A = [1.0 2.0; 3.0 4.0]; B = [1.0 1.0; 1.0 1.0]; Y = similar(B);

julia> mul!(Y, A, B) === Y
true

julia> Y
2×2 Matrix{Float64}:
 3.0  3.0
 7.0  7.0

julia> Y == A * B
true
```

# Implementation

独自の行列型やベクトル型では、可能であれば3引数の `mul!` を直接実装するのではなく、5引数の `mul!` を実装することを推奨します。
