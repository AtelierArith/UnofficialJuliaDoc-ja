```julia
indexpids(S::SharedArray)
```

現在のワーカーのインデックスを、`SharedArray` に対応するワーカーのリスト（つまり、`procs(S)` が返す同じリスト）内で返します。`SharedArray` がローカルにマッピングされていない場合は、0 を返します。
