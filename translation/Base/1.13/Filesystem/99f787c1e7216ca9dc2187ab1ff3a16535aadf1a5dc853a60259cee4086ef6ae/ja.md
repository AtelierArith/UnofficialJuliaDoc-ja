```julia
normpath(path::AbstractString, paths::AbstractString...)::String
```

複数のパスを結合し、「.」および「..」の要素を取り除いて、正規化されたパスに変換します。`normpath(joinpath(path, paths...))` と同等です。
