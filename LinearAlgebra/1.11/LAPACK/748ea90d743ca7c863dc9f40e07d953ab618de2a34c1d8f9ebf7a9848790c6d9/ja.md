```
trexc!(compq, ifst, ilst, T, Q) -> (T, Q)
trexc!(ifst, ilst, T, Q) -> (T, Q)
```

行列のシュア分解 `T` を再配置し、行インデックス `ifst` の `T` の対角ブロックを行インデックス `ilst` に移動します。`compq = V` の場合、シュアベクトル `Q` が再配置されます。`compq = N` の場合は変更されません。4引数のメソッドは、`compq = V` で5引数のメソッドを呼び出します。
