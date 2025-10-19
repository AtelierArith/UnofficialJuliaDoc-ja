```julia
flatten(btdata::Vector, lidict::LineInfoDict) -> (newdata::Vector{UInt64}, newdict::LineInfoFlatDict)
```

"フラット化された" バックトレースデータを生成します。個々の命令ポインタは、インライン化のためにマルチフレームバックトレースに対応することがあります。そのような場合、この関数はインライン呼び出しのために偽の命令ポインタを挿入し、命令ポインタと単一の StackFrame との 1 対 1 のマッピングを持つ辞書を返します。
