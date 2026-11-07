```julia
while
```

`while` ループでは条件式を繰り返し評価し、条件式が真である限り、while ループの本体を実行し続けます。while ループに初めて到達した時点で条件式が偽の場合、本体は一度も実行されません。

# Examples

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
