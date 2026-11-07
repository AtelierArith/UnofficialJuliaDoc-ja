```julia
struct NewSSAValue
```

`NewSSAValue`はIncrementalCompactのコンテキストで使われます。その意味は、どこに現れるかによって異なります。

1. すでにコンパクト化されたノードでは、   i. 正の`id`を持つ`NewSSAValue`は、通常のSSAValueと同じ意味です。   ii. 負の`id`を持つ`NewSSAValue`は、コンパクト化後の`new_node`ノードを指します。
2. コンパクト化されていないノードでは、   i. 正の`id`を持つ`NewSSAValue`は、すでにコンパクト化された命令のインデックスを指します。   ii. 負の`id`を持つ`NewSSAValue`は、コンパクト化されたノードの場合と同じ意味です。
