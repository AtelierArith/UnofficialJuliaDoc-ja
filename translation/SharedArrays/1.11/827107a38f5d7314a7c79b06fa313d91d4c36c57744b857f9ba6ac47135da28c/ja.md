```julia
indexpids(S::SharedArray)
```

`SharedArray`（つまり、`procs(S)`が返すものと同じリスト）における現在のワーカーのインデックスを返します。`SharedArray`がローカルにマッピングされていない場合は、0を返します。
