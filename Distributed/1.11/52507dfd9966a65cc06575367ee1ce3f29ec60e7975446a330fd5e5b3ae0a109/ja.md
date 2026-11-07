```julia
@distributed
```

分散メモリ上で並列に実行する for ループは、次の形式です。

```julia
@distributed [reducer] for var = range
    body
end
```

指定した範囲は分割され、すべてのワーカーでローカルに実行されます。オプションのリデューサー関数を指定した場合、`@distributed` は各ワーカーでローカルなリダクションを行い、呼び出し元のプロセスで最終的なリダクションを行います。

リデューサー関数を指定しない場合、`@distributed` は非同期に実行されます。つまり、利用可能なすべてのワーカーで独立したタスクを起動し、完了を待たずに直ちに戻ります。完了を待つには、次のように呼び出しの前に [`@sync`](@ref) を付けます。

```julia
@sync @distributed for var = range
    body
end
```
