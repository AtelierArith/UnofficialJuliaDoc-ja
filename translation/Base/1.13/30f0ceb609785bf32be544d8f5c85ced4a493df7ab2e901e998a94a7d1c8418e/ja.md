```julia
Semaphore(sem_size)
```

同時に使用できる acquire の数を最大 `sem_size` に制限するカウンティングセマフォを作成します。各 acquire には、対応する release が必要です。

acquire/release の呼び出しでは、acquire と release のメモリ順序が保証されます。
