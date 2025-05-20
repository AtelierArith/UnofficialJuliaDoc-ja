```
continue
```

Skip the rest of the current loop iteration.

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
