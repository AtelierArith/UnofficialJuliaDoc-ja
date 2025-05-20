```
abspath(path::AbstractString, paths::AbstractString...) -> String
```

一連のパスを結合し、必要に応じて現在のディレクトリを追加することで、絶対パスに変換します。`abspath(joinpath(path, paths...))`と同等です。
