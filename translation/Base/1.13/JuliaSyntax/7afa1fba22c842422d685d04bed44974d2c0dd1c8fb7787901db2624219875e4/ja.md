```julia
ParseState(stream::ParseStream)
```

ParseStateは、構文解析木を再帰的にたどる際にパーサーのコンテキストを保持する、`ParseStream`をラップした内部データ構造です。たとえば、通常は`x -y`は`(x) - (y)`を意味しますが、行列リテラルを解析しているときは`space_sensitive`モードになり、`[x -y]`は[(x) (-y)]を意味します。
