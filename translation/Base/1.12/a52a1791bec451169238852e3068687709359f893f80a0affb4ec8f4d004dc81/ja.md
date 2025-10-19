```julia
fullname(m::Module)
```

モジュールの完全修飾名をシンボルのタプルとして取得します。例えば、

# 例

```jldoctest
julia> fullname(Base.Iterators)
(:Base, :Iterators)

julia> fullname(Main)
(:Main,)
```
