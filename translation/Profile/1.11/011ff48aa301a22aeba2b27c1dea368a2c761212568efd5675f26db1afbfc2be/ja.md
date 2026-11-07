```julia
flatten(btdata::Vector, lidict::LineInfoDict) -> (newdata::Vector{UInt64}, newdict::LineInfoFlatDict)
```

「フラット化」されたバックトレースデータを生成します。インライン化によって、個々の命令ポインタが複数フレームからなるバックトレースに対応する場合があります。その場合、この関数はインライン化された呼び出しに対する偽の命令ポインタを挿入し、各命令ポインタが単一のStackFrameに対応する辞書を返します。
