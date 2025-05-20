```
cycle(iter[, n::Int])
```

An iterator that cycles through `iter` forever. If `n` is specified, then it cycles through `iter` that many times. When `iter` is empty, so are `cycle(iter)` and `cycle(iter, n)`.

`Iterators.cycle(iter, n)` is the lazy equivalent of [`Base.repeat`](@ref)`(vector, n)`, while [`Iterators.repeated`](@ref)`(iter, n)` is the lazy [`Base.fill`](@ref)`(item, n)`.

!!! compat "Julia 1.11"
    The method `cycle(iter, n)` was added in Julia 1.11.


# Examples

```jldoctest
julia> for (i, v) in enumerate(Iterators.cycle("hello"))
           print(v)
           i > 10 && break
       end
hellohelloh

julia> foreach(print, Iterators.cycle(['j', 'u', 'l', 'i', 'a'], 3))
juliajuliajulia

julia> repeat([1,2,3], 4) == collect(Iterators.cycle([1,2,3], 4))
true

julia> fill([1,2,3], 4) == collect(Iterators.repeated([1,2,3], 4))
true
```
