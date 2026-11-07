```julia
entrytype(te::GitTreeEntry)
```

`te`が参照するオブジェクトの型を返します。結果は、[`objtype`](@ref)が返す型のいずれかです。たとえば、`GitTree`や`GitBlob`です。
