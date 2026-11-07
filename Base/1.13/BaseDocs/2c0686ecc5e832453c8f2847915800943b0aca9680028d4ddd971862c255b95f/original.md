```julia
getproperty(value, name::Symbol)
getproperty(value, name::Symbol, order::Symbol)
```

The syntax `a.b` calls `getproperty(a, :b)`. The syntax `@atomic order a.b` calls `getproperty(a, :b, :order)` and the syntax `@atomic a.b` calls `getproperty(a, :b, :sequentially_consistent)`.

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

One should overload `getproperty` only when necessary, as it can be confusing if the behavior of the syntax `obj.f` is unusual. Also note that using methods is often preferable. See also this style guide documentation for more information: [Prefer exported methods over direct field access](@ref).

See also [`getfield`](@ref Core.getfield), [`propertynames`](@ref Base.propertynames) and [`setproperty!`](@ref Base.setproperty!).
