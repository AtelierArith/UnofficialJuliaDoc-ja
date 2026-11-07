```julia
PipeBuffer(data::AbstractVector{UInt8}=UInt8[]; maxsize::Integer = typemax(Int))
```

読み取りが可能で、書き込みは追記によって行う[`IOBuffer`](@ref)です。シークと切り詰めには対応していません。利用可能なコンストラクターについては[`IOBuffer`](@ref)を参照してください。`data`が指定されている場合、データベクトルを操作するための`PipeBuffer`を作成します。必要に応じて、基になる`Array`の拡張上限サイズも指定できます。
