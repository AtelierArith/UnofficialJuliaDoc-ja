```julia
@isdefined(s)::Bool
```

変数 `s` が現在のスコープで定義されているかどうかを判定します。

フィールドのプロパティについては [`isdefined`](@ref)、配列のインデックスについては [`isassigned`](@ref)、その他のマッピングについては [`haskey`](@ref) も参照してください。

# Examples

```jldoctest
julia> @isdefined newvar
false

julia> newvar = 1
1

julia> @isdefined newvar
true

julia> function f()
           println(@isdefined x)
           x = 3
           println(@isdefined x)
       end
f (generic function with 1 method)

julia> f()
false
true
```
