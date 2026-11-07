```julia
read(filename::AbstractString)
```

ファイルの内容全体を`Vector{UInt8}`として読み込みます。

```julia
read(filename::AbstractString, String)
```

ファイルの内容全体を文字列として読み込みます。

```julia
read(filename::AbstractString, args...)
```

ファイルを開いて、その内容を読み込みます。`args`は`read`に渡されます。これは`open(io->read(io, args...), filename)`と同等です。
