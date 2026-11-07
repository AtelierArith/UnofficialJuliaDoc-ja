```julia
emit(stream, mark, kind, flags = EMPTY_FLAGS; error=nothing)
```

直近で`bump()`されたトークンの末尾までを対象に、`mark`から始まるソースバイト範囲をカバーする、新しい非終端ノードを出力に追加します。開始位置の`mark`には、以前の`position()`の戻り値を指定します。出力されるノードの`node_span`には、`mark`以降に出力されたノードの数が設定されます。
