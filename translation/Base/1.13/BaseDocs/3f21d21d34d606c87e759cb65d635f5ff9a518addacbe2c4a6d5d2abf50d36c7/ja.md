```julia
Function
```

すべての関数の抽象型。

# Examples

```jldoctest
julia> isa(+, Function)
true

julia> typeof(sin)
typeof(sin) (singleton type of function sin, subtype of Function)

julia> ans <: Function
true
```
