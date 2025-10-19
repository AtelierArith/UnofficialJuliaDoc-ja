```julia
applicable(f, args...) -> Bool
```

与えられた汎用関数が与えられた引数に適用可能なメソッドを持っているかどうかを判断します。

関連情報として[`hasmethod`](@ref)を参照してください。

# 例

```jldoctest
julia> function f(x, y)
           x + y
       end;

julia> applicable(f, 1)
false

julia> applicable(f, 1, 2)
true
```
