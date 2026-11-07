```julia
trexc!(compq, ifst, ilst, T, Q) -> (T, Q)
trexc!(ifst, ilst, T, Q) -> (T, Q)
```

行列のシュール分解 `T` を並べ替え、`T` の行インデックス `ifst` にある対角ブロックを、行インデックス `ilst` に移動します。`compq = V` の場合、シュールベクトル `Q` も並べ替えられます。`compq = N` の場合は変更されません。4 引数メソッドは、`compq = V` を指定して 5 引数メソッドを呼び出します。
