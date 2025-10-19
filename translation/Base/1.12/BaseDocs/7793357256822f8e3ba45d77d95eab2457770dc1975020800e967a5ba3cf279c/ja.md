```julia
local
```

`local` は新しいローカル変数を導入します。詳細については、[manual section on variable scoping](@ref scope-of-variables)を参照してください。

# 例

```jldoctest
julia> function foo(n)
           x = 0
           for i = 1:n
               local x # ループローカルの x を導入
               x = i
           end
           x
       end
foo (generic function with 1 method)

julia> foo(10)
0
```
