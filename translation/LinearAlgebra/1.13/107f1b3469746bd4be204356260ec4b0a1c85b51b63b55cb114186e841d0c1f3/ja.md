```julia
rank(A::AbstractMatrix; atol::Real=0, rtol::Real=atol>0 ? 0 : n*ϵ)
rank(A::AbstractMatrix, rtol::Real)
```

`svdvals(A)`の出力のうち、`max(atol, rtol*σ₁)`を超えるものの個数を数えることで、行列の数値ランクを計算します。ここで、`σ₁`は、`A`で計算された最大の特異値です。`atol`と`rtol`は、それぞれ絶対許容誤差と相対許容誤差です。相対許容誤差のデフォルト値は`n*ϵ`です。ここで、`n`は`A`の最小次元のサイズ、`ϵ`は`A`の要素型の[`eps`](@ref)です。

!!! note
    数値ランクは、特異値が許容誤差のしきい値`max(atol, rtol*σ₁)`に近い、悪条件の行列を評価する際に、結果が不安定で精度に欠けることがあります。このような場合、特異値の計算や行列にわずかな摂動が加わるだけで、1つ以上の特異値がしきい値をまたぎ、`rank`の結果が変わることがあります。こうした差異は、Juliaのバージョン、アーキテクチャ、コンパイラ、オペレーティングシステムの違いによる浮動小数点誤差の変化によっても生じることがあります。


!!! compat "Julia 1.1"
    `atol`および`rtol`キーワード引数を使用するには、Julia 1.1以降が必要です。Julia 1.0では`rtol`を位置引数として指定できますが、これはJulia 2.0で非推奨になります。


# Examples

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
