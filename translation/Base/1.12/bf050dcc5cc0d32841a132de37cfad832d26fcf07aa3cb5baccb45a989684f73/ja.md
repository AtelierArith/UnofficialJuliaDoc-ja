```julia
fdio([name::AbstractString, ]fd::Integer[, own::Bool=false]) -> IOStream
```

整数ファイルディスクリプタから[`IOStream`](@ref)オブジェクトを作成します。`own`が`true`の場合、このオブジェクトを閉じると基になるディスクリプタも閉じられます。デフォルトでは、`IOStream`はガーベジコレクションされると閉じられます。`name`を使用すると、ディスクリプタを名前付きファイルに関連付けることができます。
