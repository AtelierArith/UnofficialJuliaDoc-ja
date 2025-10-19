```julia
chmod(path::AbstractString, mode::Integer; recursive::Bool=false)
```

`path`の権限モードを`mode`に変更します。現在サポートされているのは整数の`mode`（例：`0o777`）のみです。`recursive=true`で、かつ`path`がディレクトリの場合、そのディレクトリ内のすべての権限が再帰的に変更されます。`path`を返します。

!!! note
    Julia 1.6以前は、Windows上でファイルシステムACLを正しく操作できなかったため、ファイルの読み取り専用ビットのみを設定していました。現在はACLを操作できるようになりました。

