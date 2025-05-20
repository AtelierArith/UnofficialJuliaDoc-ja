```
indexpids(S::SharedArray)
```

現在のワーカーのインデックスを、`SharedArray` のワーカーのリスト（すなわち、`procs(S)` が返すのと同じリスト）で返します。`SharedArray` がローカルにマッピングされていない場合は 0 を返します。
