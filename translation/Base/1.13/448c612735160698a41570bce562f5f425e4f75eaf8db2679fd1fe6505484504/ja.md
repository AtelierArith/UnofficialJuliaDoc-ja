```julia
isopen(object)::Bool
```

IOやタイマーなどのオブジェクトがまだ開いており、したがってアクティブな状態かどうかを判定します。

関連項目: [`close`](@ref)

# Examples

```jldoctest
julia> io = open("my_file.txt", "w+");

julia> isopen(io)
true

julia> close(io)

julia> isopen(io)
false
```
