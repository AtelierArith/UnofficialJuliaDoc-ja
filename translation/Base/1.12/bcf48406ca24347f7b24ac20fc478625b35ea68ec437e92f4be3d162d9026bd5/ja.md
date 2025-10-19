```julia
WeakRef(x)
```

`w = WeakRef(x)` は、Juliaの値 `x` への [弱参照](https://en.wikipedia.org/wiki/Weak_reference) を構築します：`w` は `x` への参照を含んでいますが、`x` がガーベジコレクトされるのを防ぎません。`w.value` は、`x` がまだガーベジコレクトされていない場合は `x` であり、`x` がガーベジコレクトされている場合は `nothing` です。

```jldoctest
julia> x = "a string"
"a string"

julia> w = WeakRef(x)
WeakRef("a string")

julia> GC.gc()

julia> w           # a reference is maintained via `x`
WeakRef("a string")

julia> x = nothing # clear reference

julia> GC.gc()

julia> w
WeakRef(nothing)
```
