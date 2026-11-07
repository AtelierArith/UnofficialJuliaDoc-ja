```julia
LazyLibraryPath(path_pieces...)
```

[`LazyLibrary`](@ref)で使用する、ライブラリのパスを遅延構築するためのヘルパー型です。パスの各要素は未評価のまま保持され、ライブラリに初めてアクセスしたときに`joinpath()`で結合されます。引数には`string()`を呼び出せる必要があります。

# Example

```julia
const mylib = LazyLibrary(LazyLibraryPath(artifact_dir, "lib", "libmylib.so.1.2.3"))
```

!!! compat "Julia 1.11"
    `LazyLibraryPath`はJulia 1.11で追加されました。


[`LazyLibrary`](@ref)、[`BundledLazyLibraryPath`](@ref)も参照してください。
