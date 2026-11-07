```julia
Generator(f, iter)
```

Given a function `f` and an iterator `iter`, construct an iterator that yields the values of `f` applied to the elements of `iter`. The syntax `f(x) for x in iter` is syntax for constructing an instance of this type.

```jldoctest
julia> g = (abs2(x) for x in 1:5);

julia> for x in g
           println(x)
       end
1
4
9
16
25

julia> collect(g)
5-element Vector{Int64}:
  1
  4
  9
 16
 25
```
