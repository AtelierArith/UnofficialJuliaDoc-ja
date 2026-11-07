```julia
rstrip_shell(s::AbstractString)
```

末尾にバックスラッシュとスペース（「\ 」）が続く場合はそれを考慮しつつ、シェルコマンド文字列の末尾の空白を削除します。

```jldoctest
julia> Base.rstrip_shell("echo 'Hello World' \\ ")
"echo 'Hello World' \\ "

julia> Base.rstrip_shell("echo 'Hello World'    ")
"echo 'Hello World'"
```
