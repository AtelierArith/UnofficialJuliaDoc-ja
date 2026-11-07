```julia
BundledLazyLibraryPath(subpath)
```

Julia ディストリビューション内のライブラリパスを遅延構築するためのヘルパー型です。Julia の非公開共有ライブラリディレクトリを基準にパスを構築します。

主に Julia の標準ライブラリで使用されます。たとえば、次のように使います。

```julia
const libgmp = LazyLibrary(BundledLazyLibraryPath("libgmp.so.10"))
```

!!! compat "Julia 1.11"
    `BundledLazyLibraryPath` は Julia 1.11 で追加されました。


関連項目: [`LazyLibrary`](@ref)、[`LazyLibraryPath`](@ref)。
