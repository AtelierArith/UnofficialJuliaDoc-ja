```julia
islocked(lock) -> Status (Boolean)
```

`lock`が任意のタスク/スレッドによって保持されているかどうかを確認します。この関数単独では同期に使用すべきではありません。しかし、`islocked`を[`trylock`](@ref)と組み合わせることで、*`typeof(lock)`がサポートしている場合*にテスト・アンド・テスト・アンド・セットや指数バックオフアルゴリズムを書くために使用できます（そのドキュメントを参照してください）。

# Extended help

例えば、以下のように指数バックオフを実装することができます、もし`lock`の実装が以下に文書化された特性を満たしている場合。

```julia
nspins = 0
while true
    while islocked(lock)
        GC.safepoint()
        nspins += 1
        nspins > LIMIT && error("timeout")
    end
    trylock(lock) && break
    backoff()
end
```

## Implementation

ロックの実装は、以下の特性を持つ`islocked`を定義し、そのドキュメントに記載することを推奨します。

  * `islocked(lock)`はデータ競合がありません。
  * `islocked(lock)`が`false`を返す場合、他のタスクからの干渉がなければ、`trylock(lock)`の即時呼び出しは成功しなければなりません（`true`を返します）。
