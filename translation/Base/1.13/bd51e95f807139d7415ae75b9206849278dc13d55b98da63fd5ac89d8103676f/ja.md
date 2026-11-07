```julia
promote_type(type1, type2, ...)
```

昇格とは、型の異なる値を、共通の単一の型に変換することです。`promote_type` は、演算子（通常は数学演算子）に型の異なる引数が渡されたときの、Julia における既定の昇格動作を表します。`promote_type` は通常、型を過度に広げることなく、どちらかの入力型の値の大部分を少なくとも近似できる型を返そうとします。多少の精度損失は許容されます。たとえば、厳密にはすべての [`Int64`](@ref) の値を `Float64` の値として正確に表現できないにもかかわらず、`promote_type(Int64, Float64)` は [`Float64`](@ref) を返します。

関連項目: [`promote`](@ref)、[`promote_typejoin`](@ref)、[`promote_rule`](@ref)。

# Examples

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

!!! warning "これを直接オーバーロードしないでください"
    独自の型の昇格動作をオーバーロードするには、[`promote_rule`](@ref) をオーバーロードしてください。`promote_type` は、型を判定するために内部で `promote_rule` を呼び出します。`promote_type` を直接オーバーロードすると、曖昧さによるエラーが発生することがあります。

