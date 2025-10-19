```julia
@locals()
```

呼び出し元の時点で定義されているすべてのローカル変数の名前（シンボルとして）と値の辞書を構築します。

!!! compat "Julia 1.1"
    このマクロは少なくともJulia 1.1が必要です。


# 例

```jldoctest
julia> let x = 1, y = 2
           Base.@locals
       end
Dict{Symbol, Any} with 2 entries:
  :y => 2
  :x => 1

julia> function f(x)
           local y
           show(Base.@locals); println()
           for i = 1:1
               show(Base.@locals); println()
           end
           y = 2
           show(Base.@locals); println()
           nothing
       end;

julia> f(42)
Dict{Symbol, Any}(:x => 42)
Dict{Symbol, Any}(:i => 1, :x => 42)
Dict{Symbol, Any}(:y => 2, :x => 42)
```
