```julia
break
```

Break out of a loop immediately.

# Examples

```jldoctest
julia> i = 0
0

julia> while true
           global i += 1
           i > 5 && break
           println(i)
       end
1
2
3
4
5
```
