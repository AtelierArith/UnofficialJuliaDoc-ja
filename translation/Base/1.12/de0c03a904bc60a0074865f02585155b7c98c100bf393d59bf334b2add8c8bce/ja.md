```julia
shell_escape(args::Union{Cmd,AbstractString...}; special::AbstractString="")
```

未エクスポートの `shell_escape` 関数は、未エクスポートの [`Base.shell_split()`](@ref) 関数の逆です：文字列またはコマンドオブジェクトを受け取り、特別な文字をエスケープして、[`Base.shell_split()`](@ref) を呼び出すと元のコマンドの単語の配列が返されるようにします。`special` キーワード引数は、空白、バックスラッシュ、引用符、ドル記号に加えて特別と見なされる文字を制御します（デフォルト：なし）。

# 例

```jldoctest
julia> Base.shell_escape("cat", "/foo/bar baz", "&&", "echo", "done")
"cat '/foo/bar baz' && echo done"

julia> Base.shell_escape("echo", "this", "&&", "that")
"echo this && that"
```
