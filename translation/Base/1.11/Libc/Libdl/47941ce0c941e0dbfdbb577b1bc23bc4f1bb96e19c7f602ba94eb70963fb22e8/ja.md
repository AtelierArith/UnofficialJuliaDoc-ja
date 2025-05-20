```
BundledLazyLibraryPath
```

バンドルされたJuliaディストリビューション内に保存されている遅延構築されたライブラリパスのヘルパータイプで、主にBaseモジュールによって使用されます。

```
libfoo = LazyLibrary(BundledLazyLibraryPath("lib/libfoo.so.1.2.3"))
```
