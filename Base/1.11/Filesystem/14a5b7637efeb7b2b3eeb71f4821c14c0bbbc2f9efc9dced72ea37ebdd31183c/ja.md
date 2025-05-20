```
touch(path::AbstractString)
touch(fd::File)
```

ファイルの最終更新タイムスタンプを現在の時間に更新します。

ファイルが存在しない場合は、新しいファイルが作成されます。

`path`を返します。

# 例

```julia-repl
julia> write("my_little_file", 2);

julia> mtime("my_little_file")
1.5273815391135583e9

julia> touch("my_little_file");

julia> mtime("my_little_file")
1.527381559163435e9
```

[`mtime`](@ref)が`touch`によって変更されたことがわかります。
