```julia
which(f, types)
```

指定された`types`の引数に対して呼び出される、`f`（`Method`オブジェクト）のメソッドを返します。

`types`が抽象型の場合は、`invoke`によって呼び出されるメソッドを返します。

関連項目：[`parentmodule`](@ref)、[`@which`](@ref Main.InteractiveUtils.@which)、[`@edit`](@ref Main.InteractiveUtils.@edit)。
