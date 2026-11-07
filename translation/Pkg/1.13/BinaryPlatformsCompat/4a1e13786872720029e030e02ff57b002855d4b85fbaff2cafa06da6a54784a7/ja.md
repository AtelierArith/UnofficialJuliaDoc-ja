```julia
valid_dl_path(path::AbstractString, platform::Platform)
```

指定された`path`が有効な動的ライブラリのファイル名で終わる場合は、`true`を返します。たとえば、`"usr/lib/libfoo.so.3.5"`のようなパスの場合は`true`を返しますが、`"libbar.so.f.a"`のようなパスの場合は`false`を返します。

このメソッドは非推奨であり、Julia 2.0で削除される予定です。
