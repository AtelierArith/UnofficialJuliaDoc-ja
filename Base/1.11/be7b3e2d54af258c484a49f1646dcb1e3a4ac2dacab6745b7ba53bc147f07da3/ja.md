```
isassigned(ref::RefValue) -> Bool
```

与えられた [`Ref`](@ref) が値に関連付けられているかどうかをテストします。これは、ビットタイプオブジェクトの [`Ref`](@ref) に対して常に真です。参照が未定義の場合は `false` を返します。

# 例

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
