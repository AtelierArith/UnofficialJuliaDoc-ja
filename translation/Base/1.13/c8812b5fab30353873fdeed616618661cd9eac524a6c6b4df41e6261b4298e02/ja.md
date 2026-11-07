```julia
WeakRef(x)
```

`w = WeakRef(x)` は、Julia の値 `x` への [weak reference](https://en.wikipedia.org/wiki/Weak_reference) を構築します。`w` は `x` への参照を保持しますが、`x` がガベージコレクションで回収されることを妨げません。`w.value` は、`x` がまだガベージコレクションで回収されていなければ `x`、`x` がすでに回収されていれば `nothing` になります。

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
