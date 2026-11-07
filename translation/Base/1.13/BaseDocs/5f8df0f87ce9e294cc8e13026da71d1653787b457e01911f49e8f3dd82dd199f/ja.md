```julia
Union{Types...}
```

`Union`型は抽象型であり、その引数型のいずれかに属するすべてのインスタンスを含みます。つまり、`T <: Union{T,S}`と`S <: Union{T,S}`です。

ほかの抽象型と同様、すべての引数が具象型であっても、インスタンス化することはできません。

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

ほとんどのパラメトリック型とは異なり、Union型はパラメーターに関して共変です。たとえば、`Union{Real, String}`は`Union{Number, AbstractString}`のサブタイプです。

空のUnion型である[`Union{}`](@ref)は、Juliaのボトム型です。
