```julia
Sys.total_memory()
```

RAMの総メモリ量（現在使用中の分を含む）をバイト単位で取得します。この量は、Linuxのコントロールグループなどによって制限される場合があります。制限のないメモリ量については、`Sys.total_physical_memory()`を参照してください。
