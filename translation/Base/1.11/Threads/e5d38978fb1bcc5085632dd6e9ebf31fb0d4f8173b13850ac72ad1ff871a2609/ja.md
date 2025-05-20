```
Threads.atomic_cas!(x::Atomic{T}, cmp::T, newval::T) where T
```

原子比較と設定 `x`

`x` の値を `cmp` と原子比較します。等しい場合、`newval` を `x` に書き込みます。そうでない場合、`x` は変更されずにそのままです。`x` の古い値を返します。返された値を `cmp` と比較することで（`===` を介して）、`x` が変更されたかどうか、そして現在 `newval` の新しい値を保持しているかを知ることができます。

詳細については、LLVM の `cmpxchg` 命令を参照してください。

この関数はトランザクションセマンティクスを実装するために使用できます。トランザクションの前に、`x` の値を記録します。トランザクションの後、`x` がその間に変更されていない場合のみ新しい値が保存されます。

# 例

```jldoctest
julia> x = Threads.Atomic{Int}(3)
Base.Threads.Atomic{Int64}(3)

julia> Threads.atomic_cas!(x, 4, 2);

julia> x
Base.Threads.Atomic{Int64}(3)

julia> Threads.atomic_cas!(x, 3, 2);

julia> x
Base.Threads.Atomic{Int64}(2)
```
