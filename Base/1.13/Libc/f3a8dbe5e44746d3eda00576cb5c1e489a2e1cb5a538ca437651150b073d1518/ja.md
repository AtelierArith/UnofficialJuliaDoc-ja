```julia
FILE(::Ptr)
FILE(::IO)
```

開かれたファイルを表す libc `FILE*`。

[`ccall`](@ref) の引数として `Ptr{FILE}` を渡すことができ、[`seek`](@ref)、[`position`](@ref)、[`close`](@ref) もサポートします。

通常の `IO` オブジェクトが開かれたファイルであれば、そこから `FILE` を作成できます。作成後は必ず閉じてください。

# Examples

```jldoctest
julia> using Base.Libc

julia> mktemp() do _, io
           # write to the temporary file using `puts(char*, FILE*)` from libc
           file = FILE(io)
           ccall(:fputs, Cint, (Cstring, Ptr{FILE}), "hello world", file)
           close(file)
           # read the file again
           seek(io, 0)
           read(io, String)
       end
"hello world"
```
