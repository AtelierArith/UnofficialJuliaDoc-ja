```
@distributed
```

分散メモリの並列forループの形式：

```
@distributed [reducer] for var = range
    body
end
```

指定された範囲は分割され、すべてのワーカーでローカルに実行されます。オプションのリデューサ関数が指定されている場合、`@distributed`は各ワーカーでローカルなリデュースを行い、呼び出しプロセスで最終的なリデュースを行います。

リデューサ関数がない場合、`@distributed`は非同期に実行されます。つまり、すべての利用可能なワーカーで独立したタスクを生成し、完了を待たずにすぐに戻ります。完了を待つには、呼び出しの前に[`@sync`](@ref)を付けます。例えば：

```
@sync @distributed for var = range
    body
end
```
