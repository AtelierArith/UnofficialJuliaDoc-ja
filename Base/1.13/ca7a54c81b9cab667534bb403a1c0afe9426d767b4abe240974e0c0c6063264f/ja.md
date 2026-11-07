```julia
shell_escape_posixly(args::Union{Cmd,AbstractString...})
```

非エクスポートの`shell_escape_posixly`関数は、文字列またはコマンドオブジェクトを受け取り、POSIXシェルに引数として安全に渡せるよう、特殊文字をエスケープします。

関連項目: [`Base.shell_escape()`](@ref)

# Examples

```jldoctest
julia> Base.shell_escape_posixly("cat", "/foo/bar baz", "&&", "echo", "done")
"cat '/foo/bar baz' '&&' echo done"

julia> Base.shell_escape_posixly("echo", "this", "&&", "that")
"echo this '&&' that"
```
