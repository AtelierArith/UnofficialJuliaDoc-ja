```julia
Semaphore(sem_size)
```

同時に使用できる acquire の数が最大 `sem_size` となるカウントセマフォを作成します。各 acquire には、対応する release が必要です。

acquire/release の呼び出しでは、acquire & release のメモリ順序が保証されます。
