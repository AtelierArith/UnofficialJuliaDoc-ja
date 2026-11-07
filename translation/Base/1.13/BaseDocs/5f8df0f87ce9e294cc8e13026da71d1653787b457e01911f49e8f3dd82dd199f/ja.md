```julia
Union{Types...}
```

`Union`型は抽象型であり、その引数型のいずれかのインスタンスをすべて含みます。つまり、`T <: Union{T,S}`と`S <: Union{T,S}`が含まれます。

ほかの抽象型と同様、引数がすべて具象型であっても、インスタンス化することはできません。

# Examples

```jldoctest
julia> IntOrString = Union{Int,AbstractString}
Union{Int64, AbstractString}

julia> 1 isa IntOrString # instance of Int is included in the union
true

julia> "Hello!" isa IntOrString # String is also included
true

julia> 1.0 isa IntOrString # Float64 is not included because it is neither Int nor AbstractString
false
```

# Extended Help

ほとんどのパラメトリック型とは異なり、ユニオンはパラメーターに関して共変です。たとえば、`Union{Real, String}`は`Union{Number, AbstractString}`のサブタイプです。

空のユニオン[`Union{}`](@ref)は、Juliaのボトム型です。
