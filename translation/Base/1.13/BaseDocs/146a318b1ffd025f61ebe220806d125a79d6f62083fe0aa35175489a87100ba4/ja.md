```julia
global
```

`global x`を使うと、現在のスコープとその内側のスコープで、`x`がその名前のグローバル変数を参照するようになります。詳しくは[manual section on variable scoping](@ref scope-of-variables)を参照してください。

# Examples

```jldoctest
julia> z = 3
3

julia> function foo()
           global z = 6 # use the z variable defined outside foo
       end
foo (generic function with 1 method)

julia> foo()
6

julia> z
6
```
