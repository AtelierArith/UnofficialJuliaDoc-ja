```
batchsplit(c; min_batch_count=1, max_batch_size=100) -> iterator
```

コレクションを少なくとも `min_batch_count` バッチに分割します。

`length(c) >> max_batch_size` の場合、`partition(c, max_batch_size)` と同等です。
