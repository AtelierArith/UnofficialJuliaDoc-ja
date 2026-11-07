```julia
isassigned(ref::RefValue)::Bool
```

指定された[`Ref`](@ref)に値が関連付けられているかどうかを判定します。ビット型オブジェクトの[`Ref`](@ref)では、常にtrueです。参照が未定義の場合は、`false`を返します。

# Examples

```jldoctest
julia> ref = Ref{Function}()
Base.RefValue{Function}(#undef)

julia> isassigned(ref)
false

julia> ref[] = (foobar(x) = x)
foobar (generic function with 1 method)

julia> isassigned(ref)
true

julia> isassigned(Ref{Int}())
true
```
