```
Threads.atomic_fence()
```

逐次一致性メモリフェンスを挿入します

逐次一致性の順序セマンティクスを持つメモリフェンスを挿入します。これは、取得/解放の順序が不十分なアルゴリズムがあるため、必要です。

これは非常に高価な操作である可能性があります。Juliaの他のすべての原子操作にはすでに取得/解放のセマンティクスがあるため、明示的なフェンスはほとんどの場合必要ありません。

詳細については、LLVMの`fence`命令を参照してください。
