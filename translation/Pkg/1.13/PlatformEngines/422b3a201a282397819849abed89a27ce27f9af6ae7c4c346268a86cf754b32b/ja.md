```julia
package(src_dir::AbstractString, tarball_path::AbstractString)
```

`src_dir` を、`tarball_path` に配置される tarball に圧縮します。ファイル拡張子に応じて、gzip と zstd の両方の圧縮方式に対応しています。
