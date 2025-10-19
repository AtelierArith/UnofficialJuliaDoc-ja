```julia
which(f, types)
```

与えられた `types` の引数に対して呼び出される `f` のメソッド（`Method` オブジェクト）を返します。

`types` が抽象型である場合、`invoke` によって呼び出されるメソッドが返されます。

関連情報: [`parentmodule`](@ref), [`@which`](@ref Main.InteractiveUtils.@which), および [`@edit`](@ref Main.InteractiveUtils.@edit).
