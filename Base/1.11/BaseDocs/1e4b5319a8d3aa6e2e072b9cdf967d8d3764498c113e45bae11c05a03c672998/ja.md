```
Union{}
```

`Union{}`、型の空の [`Union`](@ref) は、値を持たない型です。つまり、任意の `x` に対して `isa(x, Union{}) == false` という定義的な性質を持っています。`Base.Bottom` はそのエイリアスとして定義されており、`Union{}` の型は `Core.TypeofBottom` です。

# 例

```jldoctest
julia> isa(nothing, Union{})
false
```
