```julia
countfrom(start=1, step=1)
```

`start`から始まり、`step`ずつ増加しながら無限に数え続けるイテレータ。

# Examples

```jldoctest
julia> for v in Iterators.countfrom(5, 2)
           v > 10 && break
           println(v)
       end
5
7
9
```
