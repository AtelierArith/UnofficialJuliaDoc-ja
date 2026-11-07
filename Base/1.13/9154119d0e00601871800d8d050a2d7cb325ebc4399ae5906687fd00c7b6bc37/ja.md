```julia
prompt(message; default="")::Union{String, Nothing}
```

`message`を表示し、ユーザーの入力を待ちます。入力は、改行（\n）が入力されるか、空行でEOF（^D）文字が入力されると終了します。`default`が指定されている場合は、改行だけを入力して`default`を選択できます。

パスワードを安全に入力する方法については、`Base.winprompt`（Windowsの場合）および`Base.getpass`も参照してください。

# Examples

```julia-repl
julia> your_name = Base.prompt("Enter your name");
Enter your name: Logan

julia> your_name
"Logan"
```
