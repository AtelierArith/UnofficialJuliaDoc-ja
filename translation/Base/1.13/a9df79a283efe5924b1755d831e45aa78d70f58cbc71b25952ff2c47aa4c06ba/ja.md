```julia
@cmd str
```

`str` 文字列から、実行するシェルコマンドを表す `Cmd` を生成します。これは ``` `str` ``` と同様です。[`Cmd`](@ref) オブジェクトはプロセスとして実行でき、起動元の julia プロセスが終了した後も存続できます（詳細は `Cmd` を参照）。

# Examples

```jldoctest
julia> cm = @cmd " echo 1 "
`echo 1`

julia> run(cm)
1
Process(`echo 1`, ProcessExited(0))
```
