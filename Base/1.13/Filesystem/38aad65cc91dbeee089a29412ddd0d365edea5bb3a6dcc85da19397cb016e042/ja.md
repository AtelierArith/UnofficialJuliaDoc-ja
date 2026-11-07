```julia
abspath(path::AbstractString, paths::AbstractString...)::String
```

複数のパスを結合し、必要に応じてカレントディレクトリを追加して、絶対パスに変換します。`abspath(joinpath(path, paths...))` と同等です。
