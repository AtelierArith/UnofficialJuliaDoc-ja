```julia
rank(A::AbstractMatrix; atol::Real=0, rtol::Real=atol>0 ? 0 : n*ϵ)
rank(A::AbstractMatrix, rtol::Real)
```

行列の数値的ランクを計算するには、`svdvals(A)` の出力のうち、`max(atol, rtol*σ₁)` より大きいものがいくつあるかを数えます。ここで、`σ₁` は `A` の計算された最大特異値です。`atol` と `rtol` はそれぞれ絶対許容誤差と相対許容誤差です。デフォルトの相対許容誤差は `n*ϵ` であり、ここで `n` は `A` の最小次元のサイズ、`ϵ` は `A` の要素型の [`eps`](@ref) です。

!!! note
    数値的ランクは、特異値が閾値許容誤差 `max(atol, rtol*σ₁)` に近い条件の悪い行列の敏感で不正確な特性を示すことがあります。このような場合、特異値計算や行列へのわずかな摂動が、1つまたは複数の特異値を閾値を越えさせることによって `rank` の結果を変える可能性があります。これらの変動は、異なるJuliaのバージョン、アーキテクチャ、コンパイラ、またはオペレーティングシステム間の浮動小数点誤差の変化によっても発生することがあります。


!!! compat "Julia 1.1"
    `atol` と `rtol` のキーワード引数は、少なくともJulia 1.1が必要です。Julia 1.0では `rtol` は位置引数として利用可能ですが、これはJulia 2.0で非推奨になります。


# 例

```jldoctest
julia> rank(Matrix(I, 3, 3))
3

julia> rank(diagm(0 => [1, 0, 2]))
2

julia> rank(diagm(0 => [1, 0.001, 2]), rtol=0.1)
2

julia> rank(diagm(0 => [1, 0.001, 2]), rtol=0.00001)
3

julia> rank(diagm(0 => [1, 0.001, 2]), atol=1.5)
1
```
