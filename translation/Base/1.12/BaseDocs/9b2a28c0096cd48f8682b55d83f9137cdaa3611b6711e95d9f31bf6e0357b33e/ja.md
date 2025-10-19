```julia
getproperty(value, name::Symbol)
getproperty(value, name::Symbol, order::Symbol)
```

構文 `a.b` は `getproperty(a, :b)` を呼び出します。構文 `@atomic order a.b` は `getproperty(a, :b, :order)` を呼び出し、構文 `@atomic a.b` は `getproperty(a, :b, :sequentially_consistent)` を呼び出します。

# 例

```jldoctest
julia> struct MyType{T <: Number}
           x::T
       end

julia> function Base.getproperty(obj::MyType, sym::Symbol)
           if sym === :special
               return obj.x + 1
           else # fallback to getfield
               return getfield(obj, sym)
           end
       end

julia> obj = MyType(1);

julia> obj.special
2

julia> obj.x
1
```

`getproperty` は必要な場合にのみオーバーロードすべきです。なぜなら、構文 `obj.f` の動作が異常であると混乱を招く可能性があるからです。また、メソッドを使用することがしばしば好ましいことにも注意してください。詳細については、このスタイルガイドのドキュメントを参照してください: [Prefer exported methods over direct field access](@ref)。

また、[`getfield`](@ref Core.getfield)、[`propertynames`](@ref Base.propertynames) および [`setproperty!`](@ref Base.setproperty!) も参照してください。
