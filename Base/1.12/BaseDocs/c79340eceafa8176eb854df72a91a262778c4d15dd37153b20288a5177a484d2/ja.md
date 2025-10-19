```julia
while
```

`while` ループは条件式を繰り返し評価し、式が真である限りループの本体を評価し続けます。最初に `while` ループに到達したときに条件式が偽であれば、本体は決して評価されません。

# 例

```jldoctest
julia> i = 1
1

julia> while i < 5
           println(i)
           global i += 1
       end
1
2
3
4
```
