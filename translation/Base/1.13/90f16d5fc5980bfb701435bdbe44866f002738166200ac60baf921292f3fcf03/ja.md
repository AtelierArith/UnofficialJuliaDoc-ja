```julia
isbitstype(T)
```

`true`を返します。ただし、`T`が「プレーンデータ」型、つまり不変で、他の値への参照を含まず、`primitive`型とその他の`isbitstype`型のみを含む場合に限ります。代表的な例として、[`UInt8`](@ref)、[`Float64`](@ref)、[`Complex{Float64}`](@ref)などの数値型があります。この型のカテゴリが重要なのは、型パラメーターとして有効であり、[`isdefined`](@ref) / [`isassigned`](@ref)の状態を追跡しない場合があり、Cと互換性のあるレイアウトが定義されているためです。`T`が型でない場合は、`false`を返します。

関連項目: [`isbits`](@ref)、[`isprimitivetype`](@ref)、[`ismutable`](@ref)。

# Examples

```jldoctest
julia> isbitstype(Complex{Float64})
true

julia> isbitstype(Complex)
false
```
