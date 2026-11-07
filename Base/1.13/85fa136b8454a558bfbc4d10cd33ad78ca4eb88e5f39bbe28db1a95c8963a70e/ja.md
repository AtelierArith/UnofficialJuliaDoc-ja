```julia
islocked(lock) -> Status (Boolean)
```

`lock`が、いずれかのタスクまたはスレッドによって保持されているかどうかを確認します。この関数だけを同期に使用してはいけません。ただし、`islocked`と[`trylock`](@ref)を組み合わせれば、`typeof(lock)`がサポートしている場合に限り（ドキュメントを参照）、test-and-test-and-setアルゴリズムや指数バックオフアルゴリズムを実装できます。

# Extended help

たとえば、`lock`の実装が以下に記載する特性を満たしていれば、次のように指数バックオフを実装できます。

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

ロックの実装では、以下の特性を持つ`islocked`を定義し、その旨をdocstringに記載することを推奨します。

  * `islocked(lock)`はデータ競合が発生しない。
  * `islocked(lock)`が`false`を返した場合、他のタスクによる干渉がなければ、直後に`trylock(lock)`を呼び出すと成功し（`true`を返し）なければならない。
