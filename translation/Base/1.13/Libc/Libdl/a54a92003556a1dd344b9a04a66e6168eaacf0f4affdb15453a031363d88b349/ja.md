```julia
LazyLibraryPath(path_pieces...)
```

[`LazyLibrary`](@ref)で使用する、ライブラリのパスを遅延構築するためのヘルパー型です。パスの各要素は評価されずに保持され、ライブラリへの初回アクセス時に`joinpath()`で結合されます。引数には`string()`を呼び出せる必要があります。

# Example

```julia
const mylib = LazyLibrary(LazyLibraryPath(artifact_dir, "lib", "libmylib.so.1.2.3"))
```

!!! compat "Julia 1.11"
    `LazyLibraryPath`はJulia 1.11で追加されました。


関連項目：[`LazyLibrary`](@ref)、[`BundledLazyLibraryPath`](@ref)。
