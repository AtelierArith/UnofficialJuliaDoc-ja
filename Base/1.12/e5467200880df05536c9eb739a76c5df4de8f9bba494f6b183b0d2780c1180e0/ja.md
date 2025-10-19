```julia
shell_escape_posixly(args::Union{Cmd,AbstractString...})
```

エクスポートされていない `shell_escape_posixly` 関数は、文字列またはコマンドオブジェクトを受け取り、特別な文字をエスケープして、posix シェルに引数として渡すのに安全な形式にします。

参照: [`Base.shell_escape()`](@ref)

# 例

```jldoctest
julia> Base.shell_escape_posixly("cat", "/foo/bar baz", "&&", "echo", "done")
"cat '/foo/bar baz' '&&' echo done"

julia> Base.shell_escape_posixly("echo", "this", "&&", "that")
"echo this '&&' that"
```
