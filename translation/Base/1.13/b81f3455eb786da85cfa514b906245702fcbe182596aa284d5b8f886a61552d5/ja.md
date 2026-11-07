```julia
fdio([name::AbstractString, ]fd::Integer[, own::Bool=false])::IOStream
```

整数のファイル記述子から [`IOStream`](@ref) オブジェクトを作成します。`own` が `true` の場合、このオブジェクトを閉じると、基になるファイル記述子も閉じられます。デフォルトでは、`IOStream` はガベージコレクション時に閉じられます。`name` を使うと、ファイル記述子を名前付きファイルに関連付けられます。
