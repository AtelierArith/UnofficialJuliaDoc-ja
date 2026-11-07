```julia
fdio([name::AbstractString, ]fd::Integer[, own::Bool=false])::IOStream
```

整数のファイルディスクリプタから [`IOStream`](@ref) オブジェクトを作成します。`own` が `true` の場合、このオブジェクトを閉じると、基になるディスクリプタも閉じられます。デフォルトでは、`IOStream` はガベージコレクション時に閉じられます。`name` を使うと、ディスクリプタを名前付きファイルに関連付けられます。
