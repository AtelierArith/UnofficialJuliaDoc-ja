```julia
source_location(x)
source_location(source::SourceFile, byte_index::Integer)

source_location(LineNumberNode, x)
source_location(LineNumberNode, source, byte_index)
```

ソース内でオブジェクト `x` が最初に現れるバイト位置の `(line,column)` を取得します。2つ目の形式では、ソースファイルを指定することで、`byte_index` をより正確に特定できます。

最初の引数に `LineNumberNode` を指定すると、行番号ノードオブジェクト内に行番号とファイル名が返されます。
