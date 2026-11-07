```julia
read!(stream::IO, array::AbstractArray)
read!(filename::AbstractString, array::AbstractArray)
```

I/Oストリームまたはファイルからバイナリデータを読み込み、`array`を埋めます。
