```julia
shell_escape(args::Union{Cmd,AbstractString...}; special::AbstractString="")
```

非エクスポートの`shell_escape`関数は、非エクスポートの[`Base.shell_split()`](@ref)関数の逆関数です。文字列またはコマンドオブジェクトを受け取り、特殊文字をエスケープします。これにより、その結果に[`Base.shell_split()`](@ref)を適用すると、元のコマンドに含まれる単語の配列が得られます。`special`キーワード引数では、空白、バックスラッシュ、引用符、ドル記号に加えて、どの文字を特殊文字として扱うかを指定します（デフォルト：なし）。

# Examples

```jldoctest
julia> Base.shell_escape("cat", "/foo/bar baz", "&&", "echo", "done")
"cat '/foo/bar baz' && echo done"

julia> Base.shell_escape("echo", "this", "&&", "that")
"echo this && that"
```
