```julia
countfrom(start=1, step=1)
```

An iterator that counts forever, starting at `start` and incrementing by `step`.

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
