```julia
applicable(f, args...)::Bool
```

指定されたジェネリック関数に、指定された引数に適用できるメソッドがあるかどうかを判定します。

[`hasmethod`](@ref)も参照してください。

# Examples

```jldoctest
julia> function f(x, y)
           x + y
       end;

julia> applicable(f, 1)
false

julia> applicable(f, 1, 2)
true
```
