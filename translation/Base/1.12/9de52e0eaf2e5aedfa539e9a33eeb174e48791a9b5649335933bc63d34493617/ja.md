```julia
isbitstype(T)
```

型 `T` が「プレーンデータ」型である場合、つまり不変であり、他の値への参照を含まず、`primitive` 型と他の `isbitstype` 型のみを含む場合は `true` を返します。典型的な例としては、[`UInt8`](@ref)、[`Float64`](@ref)、および [`Complex{Float64}`](@ref) のような数値型があります。このカテゴリの型は重要であり、型パラメータとして有効であり、[`isdefined`](@ref) / [`isassigned`](@ref) ステータスを追跡しない可能性があり、C と互換性のある定義されたレイアウトを持っています。`T` が型でない場合は、`false` を返します。

他にも [`isbits`](@ref)、[`isprimitivetype`](@ref)、[`ismutable`](@ref) を参照してください。

# 例

```jldoctest
julia> isbitstype(Complex{Float64})
true

julia> isbitstype(Complex)
false
```
