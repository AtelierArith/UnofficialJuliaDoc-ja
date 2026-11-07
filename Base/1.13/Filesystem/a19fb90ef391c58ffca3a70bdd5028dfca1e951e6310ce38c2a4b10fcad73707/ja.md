```julia
chmod(path::AbstractString, mode::Integer; recursive::Bool=false)
```

`path` のパーミッションモードを `mode` に変更します。現在サポートされているのは整数の `mode`（例: `0o777`）のみです。`recursive=true` が指定され、パスがディレクトリの場合、そのディレクトリ内のすべてのパーミッションが再帰的に変更されます。`path` を返します。

!!! note
    Julia 1.6 より前のバージョンでは、Windows のファイルシステム ACL を正しく操作できず、ファイルの読み取り専用ビットを設定するだけでした。現在は ACL を操作できます。

