```julia
bunchkaufman!(A, rook::Bool=false; check = true) -> BunchKaufman
```

`bunchkaufman!`は[`bunchkaufman`](@ref)と同じですが、コピーを作成するのではなく、入力`A`を上書きすることでスペースを節約します。
