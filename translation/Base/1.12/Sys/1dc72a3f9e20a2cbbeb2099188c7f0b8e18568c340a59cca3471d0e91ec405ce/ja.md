```julia
Sys.total_memory()
```

RAMの合計メモリ（現在使用中のものを含む）をバイト単位で取得します。この量は、Linuxコントロールグループなどによって制約される場合があります。制約のない量については、`Sys.total_physical_memory()`を参照してください。
