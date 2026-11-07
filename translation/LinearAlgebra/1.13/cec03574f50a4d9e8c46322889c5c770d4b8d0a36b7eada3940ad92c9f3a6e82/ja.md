```julia
bunchkaufman!(A, rook::Bool=false; check = true) -> BunchKaufman
```

`bunchkaufman!` は [`bunchkaufman`](@ref) と同じですが、コピーを作成せずに入力 `A` を上書きするため、メモリを節約できます。
