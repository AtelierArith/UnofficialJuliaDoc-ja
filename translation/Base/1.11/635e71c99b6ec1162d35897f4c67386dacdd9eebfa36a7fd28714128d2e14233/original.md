```
fullname(m::Module)
```

Get the fully-qualified name of a module as a tuple of symbols. For example,

# Examples

```jldoctest
julia> fullname(Base.Iterators)
(:Base, :Iterators)

julia> fullname(Main)
(:Main,)
```
