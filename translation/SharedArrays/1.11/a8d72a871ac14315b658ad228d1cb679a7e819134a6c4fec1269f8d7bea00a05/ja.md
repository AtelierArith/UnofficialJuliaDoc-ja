```julia
indexpids(S::SharedArray)
```

現在のワーカーのインデックスを、`SharedArray`をマッピングしているワーカーのリストの中で返します（つまり、`procs(S)`によって返されるのと同じリスト内で）、または`SharedArray`がローカルにマッピングされていない場合は0を返します。
