```julia
FILE(::Ptr)
FILE(::IO)
```

libcの`FILE*`で、開かれたファイルを表します。

これは[`ccall`](@ref)への`Ptr{FILE}`引数として渡すことができ、また[`seek`](@ref)、[`position`](@ref)、および[`close`](@ref)もサポートしています。

`FILE`は、通常の`IO`オブジェクトから構築できますが、それは開かれたファイルである必要があります。その後、閉じる必要があります。

# 例

```jldoctest
julia> using Base.Libc

julia> mktemp() do _, io
           # libcの`puts(char*, FILE*)`を使用して一時ファイルに書き込む
           file = FILE(io)
           ccall(:fputs, Cint, (Cstring, Ptr{FILE}), "hello world", file)
           close(file)
           # 再度ファイルを読み込む
           seek(io, 0)
           read(io, String)
       end
"hello world"
```
