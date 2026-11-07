```julia
touch(path::AbstractString)
touch(fd::File)
```

ファイルの最終更新日時を現在の時刻に更新します。

ファイルが存在しない場合は、新しいファイルが作成されます。

`path` を返します。

# Examples

```jldoctest; setup = :(curdir = pwd(); testdir = mktempdir(); cd(testdir)), teardown = :(cd(curdir); rm(testdir, recursive=true)), filter = r"[\d\.]+e[\+\-]?\d+"
julia> write("my_little_file", 2);

julia> mtime("my_little_file")
1.5273815391135583e9

julia> touch("my_little_file");

julia> mtime("my_little_file")
1.527381559163435e9
```

[`mtime`](@ref) は `touch` によって変更されたことが確認できます。
