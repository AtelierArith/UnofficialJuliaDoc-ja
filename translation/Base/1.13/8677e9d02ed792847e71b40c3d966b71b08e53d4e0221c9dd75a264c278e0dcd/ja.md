```julia
write(io::IO, x)
```

値の正規バイナリ表現を、指定された I/O ストリームまたはファイルに書き込みます。ストリームに書き込まれたバイト数を返します。テキスト表現を書き込むには [`print`](@ref) も参照してください（エンコーディングは `io` によって異なる場合があります）。

書き込まれる値のエンディアンは、ホストシステムのエンディアンに依存します。プラットフォーム間で一貫した結果を得るには、書き込み時または読み込み時に、[`htol`](@ref) や [`ltoh`](@ref) などを使って固定エンディアンに変換してください。

同じ `write` 呼び出しで複数の値を書き込めます。つまり、次の例は同等です。

```julia
write(io, x, y...)
write(io, x) + write(io, y...)
```

# Examples

一貫性のあるシリアライズ：

```jldoctest
julia> fname = tempname(); # random temporary filename

julia> open(fname,"w") do f
           # Make sure we write 64bit integer in little-endian byte order
           write(f,htol(Int64(42)))
       end
8

julia> open(fname,"r") do f
           # Convert back to host byte order and host integer type
           Int(ltoh(read(f,Int64)))
       end
42
```

write 呼び出しの統合：

```jldoctest
julia> io = IOBuffer();

julia> write(io, "JuliaLang is a GitHub organization.", " It has many members.")
56

julia> takestring!(io)
"JuliaLang is a GitHub organization. It has many members."

julia> write(io, "Sometimes those members") + write(io, " write documentation.")
44

julia> takestring!(io)
"Sometimes those members write documentation."
```

`write` メソッドを持たないユーザー定義のプレーンデータ型は、`Ref` でラップすると書き込めます。

```jldoctest
julia> struct MyStruct; x::Float64; end

julia> io = IOBuffer()
IOBuffer(data=UInt8[...], readable=true, writable=true, seekable=true, append=false, size=0, maxsize=Inf, ptr=1, mark=-1)

julia> write(io, Ref(MyStruct(42.0)))
8

julia> seekstart(io); read!(io, Ref(MyStruct(NaN)))
Base.RefValue{MyStruct}(MyStruct(42.0))
```
