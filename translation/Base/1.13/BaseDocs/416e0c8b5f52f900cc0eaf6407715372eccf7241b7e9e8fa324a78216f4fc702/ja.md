```julia
continue
```

現在のループ反復の残りをスキップします。

# Examples

```jldoctest
julia> for i = 1:6
           iseven(i) && continue
           println(i)
       end
1
3
5
```
