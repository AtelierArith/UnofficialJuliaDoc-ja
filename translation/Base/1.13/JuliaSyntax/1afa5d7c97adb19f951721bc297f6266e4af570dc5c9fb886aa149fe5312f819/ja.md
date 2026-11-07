```julia
source_line(x)
source_line(source::SourceFile, byte_index::Integer)
```

オブジェクト `x` が最初に現れる行の行番号を取得します。2つ目の形式では、`source` 内の指定された `byte_index` における行番号を取得します。
