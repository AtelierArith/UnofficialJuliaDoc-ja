```
global
```

`global x` は、現在のスコープおよびその内部スコープで `x` が同名のグローバル変数を参照するようにします。詳細については、[変数のスコープに関するマニュアルセクション](@ref scope-of-variables)を参照してください。

# 例

```jldoctest
julia> z = 3
3

julia> function foo()
           global z = 6 # fooの外で定義されたz変数を使用
       end
foo (generic function with 1 method)

julia> foo()
6

julia> z
6
```
