```julia
promote_type(type1, type2, ...)
```

プロモーションは、異なる型の値を単一の共通型に変換することを指します。`promote_type`は、演算子（通常は数学的なもの）が異なる型の引数を受け取ったときのJuliaにおけるデフォルトのプロモーション動作を表します。`promote_type`は、一般的に、過度に広がることなく、いずれかの入力型のほとんどの値を少なくとも近似できる型を返そうとします。いくらかの損失は許容されます。たとえば、`promote_type(Int64, Float64)`は[`Float64`](@ref)を返しますが、厳密にはすべての[`Int64`](@ref)の値が正確に`Float64`の値として表現できるわけではありません。

関連情報: [`promote`](@ref), [`promote_typejoin`](@ref), [`promote_rule`](@ref).

# 例

```jldoctest
julia> promote_type(Int64, Float64)
Float64

julia> promote_type(Int32, Int64)
Int64

julia> promote_type(Float32, BigInt)
BigFloat

julia> promote_type(Int16, Float16)
Float16

julia> promote_type(Int64, Float16)
Float16

julia> promote_type(Int8, UInt16)
UInt16
```

!!! warning "この関数を直接オーバーロードしないでください"
    自分の型のためにプロモーションをオーバーロードするには、[`promote_rule`](@ref)をオーバーロードする必要があります。`promote_type`は、型を決定するために内部的に`promote_rule`を呼び出します。`promote_type`を直接オーバーロードすると、曖昧さのエラーが発生する可能性があります。

