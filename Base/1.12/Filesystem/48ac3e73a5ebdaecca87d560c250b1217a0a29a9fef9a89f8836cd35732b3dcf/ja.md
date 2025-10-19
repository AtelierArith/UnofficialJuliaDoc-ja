```julia
normpath(path::AbstractString, paths::AbstractString...) -> String
```

一連のパスを結合して正規化されたパスに変換し、「.」および「..」のエントリを削除します。`normpath(joinpath(path, paths...))`と同等です。
