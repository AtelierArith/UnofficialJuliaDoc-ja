```julia
rank(S::SVD{<:Any, T}; atol::Real=0, rtol::Real=min(n,m)*ϵ) where {T}
```

SVD オブジェクト `S` の数値ランクを、特異値のうち `max(atol, rtol*σ₁)` より大きいものの個数として計算します。ここで、`σ₁` は計算された特異値の最大値です。これはデフォルトの [`rank(::AbstractMatrix)`](@ref) メソッドと同等ですが、既存の SVD 分解を再利用します。`atol` と `rtol` は、それぞれ絶対許容誤差と相対許容誤差です。デフォルトの相対許容誤差は `n*ϵ` です。ここで、`n` は UΣV' の最小次元のサイズ、`ϵ` は `S` の要素型の [`eps`](@ref) です。

!!! compat "Julia 1.12"
    `rank(::SVD)` メソッドの使用には、Julia 1.12 以降が必要です。

