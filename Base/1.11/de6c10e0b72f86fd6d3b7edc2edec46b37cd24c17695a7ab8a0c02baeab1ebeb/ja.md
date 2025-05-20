```
write(io::IO, x)
```

指定されたI/Oストリームまたはファイルに値の標準的なバイナリ表現を書き込みます。ストリームに書き込まれたバイト数を返します。テキスト表現を書き込むには、[`print`](@ref)を参照してください（エンコーディングは`io`に依存する場合があります）。

書き込まれる値のエンディアンはホストシステムのエンディアンに依存します。プラットフォーム間で一貫した結果を得るために、書き込み/読み込み時に固定エンディアンに変換してください（例：[`htol`](@ref)および[`ltoh`](@ref)を使用）。

同じ`write`呼び出しで複数の値を書くことができます。すなわち、以下は同等です：

```
write(io, x, y...)
write(io, x) + write(io, y...)
```

# 例

一貫したシリアル化：

```jldoctest
julia> fname = tempname(); # ランダムな一時ファイル名

julia> open(fname,"w") do f
           # 64ビット整数をリトルエンディアンバイト順で書き込むことを確認
           write(f,htol(Int64(42)))
       end
8

julia> open(fname,"r") do f
           # ホストバイト順とホスト整数型に戻す
           Int(ltoh(read(f,Int64)))
       end
42
```

書き込み呼び出しのマージ：

```jldoctest
julia> io = IOBuffer();

julia> write(io, "JuliaLang is a GitHub organization.", " It has many members.")
56

julia> String(take!(io))
"JuliaLang is a GitHub organization. It has many members."

julia> write(io, "Sometimes those members") + write(io, " write documentation.")
44

julia> String(take!(io))
"Sometimes those members write documentation."
```

`write`メソッドを持たないユーザー定義のプレーンデータ型は、`Ref`でラップすることで書き込むことができます：

```jldoctest
julia> struct MyStruct; x::Float64; end

julia> io = IOBuffer()
IOBuffer(data=UInt8[...], readable=true, writable=true, seekable=true, append=false, size=0, maxsize=Inf, ptr=1, mark=-1)

julia> write(io, Ref(MyStruct(42.0)))
8

julia> seekstart(io); read!(io, Ref(MyStruct(NaN)))
Base.RefValue{MyStruct}(MyStruct(42.0))
```
