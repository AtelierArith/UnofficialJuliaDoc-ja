```
batchsplit(c; min_batch_count=1, max_batch_size=100) -> iterator
```

Split a collection into at least `min_batch_count` batches.

Equivalent to `partition(c, max_batch_size)` when `length(c) >> max_batch_size`.
