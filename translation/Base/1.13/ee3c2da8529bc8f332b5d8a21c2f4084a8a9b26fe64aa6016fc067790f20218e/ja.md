```julia
<:(T1, T2)::Bool
```

2つの型の間に定義される部分型関係。Juliaでは、型 `S` が型 `T` の *部分型* であるとは、`S <: T` が成り立つことをいいます。

任意の型 `L` と任意の型 `R` について、`L <: R` ならば、型 `L` の任意の値 `v` は、型 `R` でもあります。つまり、`(L <: R) && (v isa L)` ならば、`v isa R` です。

部分型関係は *半順序* です。つまり、`<:` は次の性質を持ちます。

  * *反射的*: 任意の型 `T` について、`T <: T` が成り立つ
  * *反対称的*: 任意の型 `A` と任意の型 `B` について、`(A <: B) && (B <: A)` ならば `A == B` が成り立つ
  * *推移的*: 任意の型 `A`、任意の型 `B`、任意の型 `C` について、`(A <: B) && (B <: C)` ならば `A <: C` が成り立つ

[Types](@ref man-types)、[`Union{}`](@ref)、[`Any`](@ref)、[`isa`](@ref) も参照してください。

# Examples

```jldoctest
julia> Float64 <: AbstractFloat
true

julia> Vector{Int} <: AbstractArray
true

julia> Matrix{Float64} <: Matrix{AbstractFloat}  # `Matrix` is invariant
false

julia> Tuple{Float64} <: Tuple{AbstractFloat}    # `Tuple` is covariant
true

julia> Union{} <: Int  # The bottom type, `Union{}`, subtypes each type.
true

julia> Union{} <: Float32 <: AbstractFloat <: Real <: Number <: Any  # Operator chaining
true
```

キーワード `<:` には、同じ部分型関係を表す構文上の用法がほかにもいくつかあります。ただし、これらの用法では演算子は実行されず、Bool も返されません。

  * [`where`](@ref) 文で、[`UnionAll`](@ref) 型のパラメーターの下限と上限を指定する。
  * メソッドの（静的）パラメーターの下限と上限を指定する。[Parametric Methods](@ref) を参照。
  * 新しい型の宣言時に部分型関係を定義する。[`struct`](@ref) と [`abstract type`](@ref) を参照。
