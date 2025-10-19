```julia
BundledLazyLibraryPath
```

バンドルされたJuliaディストリビューション内に保存されている遅延構築されたライブラリパスのためのヘルパータイプで、主にBaseモジュールによって使用されます。

```julia
libfoo = LazyLibrary(BundledLazyLibraryPath("lib/libfoo.so.1.2.3"))
```
