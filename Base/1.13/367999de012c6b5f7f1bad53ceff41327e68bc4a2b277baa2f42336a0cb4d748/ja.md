```julia
fullname(m::Module)
```

モジュールの完全修飾名をシンボルのタプルとして取得します。たとえば、

# Examples

```jldoctest
julia> fullname(Base.Iterators)
(:Base, :Iterators)

julia> fullname(Main)
(:Main,)
```
