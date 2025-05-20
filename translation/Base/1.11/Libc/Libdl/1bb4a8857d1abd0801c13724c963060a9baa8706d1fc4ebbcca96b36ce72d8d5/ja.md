```
LazyLibraryPath
```

`LazyLibrary`で使用するための遅延構築されたライブラリパスのヘルパータイプ。引数は`joinpath()`に渡されます。引数は`string()`を呼び出すことができる必要があります。

```
libfoo = LazyLibrary(LazyLibraryPath(prefix, "lib/libfoo.so.1.2.3"))
```
