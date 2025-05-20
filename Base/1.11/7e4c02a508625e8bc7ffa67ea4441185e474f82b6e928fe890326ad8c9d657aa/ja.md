```
bytesavailable(io)
```

このストリームまたはバッファからの読み取りがブロックされる前に、読み取りのために利用可能なバイト数を返します。

# 例

```jldoctest
julia> io = IOBuffer("JuliaLang is a GitHub organization");

julia> bytesavailable(io)
34
```
