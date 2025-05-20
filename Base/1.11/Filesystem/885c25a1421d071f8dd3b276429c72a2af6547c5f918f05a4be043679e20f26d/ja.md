```
normpath(path::AbstractString, paths::AbstractString...) -> String
```

一連のパスを結合し、"."および".."エントリを削除することによって正規化されたパスに変換します。`normpath(joinpath(path, paths...))`と同等です。
