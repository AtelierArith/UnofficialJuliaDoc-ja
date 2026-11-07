```julia
struct NewSSAValue
```

`NewSSAValue`はIncrementalCompactのコンテキストで使われます。その意味は、どこに現れるかによって異なります。

1. コンパクション済みのノードでは、   i. 正の`id`を持つ`NewSSAValue`は、通常のSSAValueと同じ意味です。   ii. 負の`id`を持つ`NewSSAValue`は、コンパクション後の`new_node`ノードを参照します。
2. コンパクションされていないノードでは、   i. 正の`id`を持つ`NewSSAValue`は、すでにコンパクションされた命令のインデックスを参照します。   ii. 負の`id`を持つ`NewSSAValue`は、コンパクション済みのノードの場合と同じ意味です。
