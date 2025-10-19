```julia
continue
```

現在のループの反復をスキップします。

# 例

```jldoctest
julia> for i = 1:6
           iseven(i) && continue
           println(i)
       end
1
3
5
```
