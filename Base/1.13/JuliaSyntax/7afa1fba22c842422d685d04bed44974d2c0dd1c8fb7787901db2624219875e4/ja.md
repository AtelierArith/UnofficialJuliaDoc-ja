```julia
ParseState(stream::ParseStream)
```

ParseState は、構文解析ツリーを再帰的にたどる際にパーサーのコンテキストを保持する、`ParseStream` をラップした内部データ構造です。たとえば、通常は `x -y` は `(x) - (y)` を意味しますが、行列リテラルを解析するときは `space_sensitive` モードになり、`[x -y]` は [(x) (-y)] を意味します。
