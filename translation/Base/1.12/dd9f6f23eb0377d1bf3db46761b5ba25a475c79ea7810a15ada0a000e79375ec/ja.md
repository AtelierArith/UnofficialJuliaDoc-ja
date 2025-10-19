```julia
@isdefined s -> Bool
```

変数 `s` が現在のスコープで定義されているかどうかをテストします。

フィールドプロパティについては [`isdefined`](@ref) を、配列インデックスについては [`isassigned`](@ref) を、その他のマッピングについては [`haskey`](@ref) を参照してください。

# 例

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
