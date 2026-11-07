```julia
flatten(btdata::Vector, lidict::LineInfoDict) -> (newdata::Vector{UInt64}, newdict::LineInfoFlatDict)
```

「フラット化」されたバックトレースデータを生成します。インライン化によって、単一の命令ポインタが複数フレームのバックトレースに対応することがあります。その場合、この関数はインライン化された呼び出しに対する偽の命令ポインタを挿入し、各命令ポインタと単一のStackFrameを1対1で対応付ける辞書を返します。
