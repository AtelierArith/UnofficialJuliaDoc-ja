```julia
WeakRef(x)
```

`w = WeakRef(x)` は、Julia の値 `x` に対する [weak reference](https://en.wikipedia.org/wiki/Weak_reference) を構築します。`w` は `x` への参照を保持しますが、`x` がガベージコレクションによって回収されることを妨げません。`w.value` は、`x` がまだガベージコレクションによって回収されていなければ `x` となり、`x` がすでに回収されていれば `nothing` となります。

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
