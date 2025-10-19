```julia
<:(T1, T2)::Bool
```

サブタイピング関係は、2つの型の間で定義されます。Juliaにおいて、型 `S` は型 `T` の *サブタイプ* であると言われるのは、`S <: T` が成り立つ場合のみです。

任意の型 `L` と任意の型 `R` に対して、`L <: R` は、型 `L` の任意の値 `v` が型 `R` の値でもあることを意味します。すなわち、`(L <: R) && (v isa L)` は `v isa R` を意味します。

サブタイピング関係は *部分順序* です。すなわち、`<:` は以下の性質を持ちます：

  * *反射的*：任意の型 `T` に対して、`T <: T` が成り立ちます
  * *反対称的*：任意の型 `A` と任意の型 `B` に対して、`(A <: B) && (B <: A)` は `A == B` を意味します
  * *推移的*：任意の型 `A`、任意の型 `B`、および任意の型 `C` に対して、`(A <: B) && (B <: C)` は `A <: C` を意味します

詳細は [Types](@ref man-types)、[`Union{}`](@ref)、[`Any`](@ref)、[`isa`](@ref) の情報を参照してください。

# 例

```jldoctest
julia> Float64 <: AbstractFloat
true

julia> Vector{Int} <: AbstractArray
true

julia> Matrix{Float64} <: Matrix{AbstractFloat}  # `Matrix` は不変
false

julia> Tuple{Float64} <: Tuple{AbstractFloat}    # `Tuple` は共変
true

julia> Union{} <: Int  # 最下位型 `Union{}` は各型のサブタイプです。
true

julia> Union{} <: Float32 <: AbstractFloat <: Real <: Number <: Any  # 演算子のチェーン
true
```

`<:` キーワードは、同じサブタイピング関係を表すいくつかの構文上の使い方も持っていますが、演算子を実行したり Bool を返したりはしません：

  * [`UnionAll`](@ref) 型のパラメータの下限と上限を [`where`](@ref) 文で指定するため。
  * メソッドの (静的) パラメータの下限と上限を指定するため、[Parametric Methods](@ref) を参照してください。
  * 新しい型を宣言する際にサブタイピング関係を定義するため、[`struct`](@ref) と [`abstract type`](@ref) を参照してください。
