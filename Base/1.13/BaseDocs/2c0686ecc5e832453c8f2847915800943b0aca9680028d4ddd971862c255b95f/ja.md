```julia
getproperty(value, name::Symbol)
getproperty(value, name::Symbol, order::Symbol)
```

構文 `a.b` は `getproperty(a, :b)` を呼び出します。構文 `@atomic order a.b` は `getproperty(a, :b, :order)` を呼び出し、構文 `@atomic a.b` は `getproperty(a, :b, :sequentially_consistent)` を呼び出します。

# Examples

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

`getproperty` のオーバーロードは、必要な場合に限るべきです。構文 `obj.f` の動作が通常と異なると、混乱を招く可能性があるためです。また、メソッドを使うほうが望ましい場合も多いことに注意してください。詳しくは、スタイルガイドのドキュメント [Prefer exported methods over direct field access](@ref) も参照してください。

[`getfield`](@ref Core.getfield)、[`propertynames`](@ref Base.propertynames)、[`setproperty!`](@ref Base.setproperty!) も参照してください。
