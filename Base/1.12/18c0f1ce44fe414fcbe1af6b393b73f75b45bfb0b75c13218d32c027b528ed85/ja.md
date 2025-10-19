```julia
LinRange{T,L}
```

`start` と `stop` の間に `len` 個の線形に間隔を空けた要素を持つ範囲。間隔のサイズは `len` によって制御され、`Integer` でなければなりません。

# 例

```jldoctest
julia> LinRange(1.5, 5.5, 9)
9-element LinRange{Float64, Int64}:
 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5
```

[`range`](@ref) を使用するのと比較して、`LinRange` を直接構築する方がオーバーヘッドが少なくなりますが、浮動小数点エラーを修正しようとはしません：

```jldoctest
julia> collect(range(-0.1, 0.3, length=5))
5-element Vector{Float64}:
 -0.1
  0.0
  0.1
  0.2
  0.3

julia> collect(LinRange(-0.1, 0.3, 5))
5-element Vector{Float64}:
 -0.1
 -1.3877787807814457e-17
  0.09999999999999999
  0.19999999999999998
  0.3
```

対数間隔の点については [`Logrange`](@ref Base.LogRange) も参照してください。
