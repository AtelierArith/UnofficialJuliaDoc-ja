```
Union{Types...}
```

`Union`型は、その引数型のいずれかのインスタンスをすべて含む抽象型です。これは、`T <: Union{T,S}` および `S <: Union{T,S}` を意味します。

他の抽象型と同様に、すべての引数が非抽象であっても、インスタンス化することはできません。

# 例

```jldoctest
julia> IntOrString = Union{Int,AbstractString}
Union{Int64, AbstractString}

julia> 1 isa IntOrString # Intのインスタンスはユニオンに含まれています
true

julia> "Hello!" isa IntOrString # Stringも含まれています
true

julia> 1.0 isa IntOrString # Float64はIntでもAbstractStringでもないため含まれていません
false
```

# 拡張ヘルプ

ほとんどの他のパラメトリック型とは異なり、ユニオンはそのパラメータに対して共変です。たとえば、`Union{Real, String}`は`Union{Number, AbstractString}`のサブタイプです。

空のユニオン [`Union{}`](@ref) は、Juliaのボトム型です。
