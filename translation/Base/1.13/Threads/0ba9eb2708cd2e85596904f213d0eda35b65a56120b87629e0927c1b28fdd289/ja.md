```julia
Threads.atomic_cas!(x::Atomic{T}, cmp::T, newval::T) where T
```

アトミックな比較交換 `x`

`x` の値を `cmp` とアトミックに比較します。一致した場合は、`newval` を `x` に書き込みます。一致しない場合、`x` は変更されません。古い値を `x` で返します。返された値を `cmp` と比較することで（`===` を使用）、`x` が変更され、新しい値 `newval` を保持しているかどうかがわかります。

詳しくは、LLVM の `cmpxchg` 命令を参照してください。

この関数は、トランザクションのセマンティクスを実装するために使用できます。トランザクションの前に、`x` の値を記録しておきます。トランザクションの後、新しい値は、途中で `x` が変更されていない場合にのみ保存されます。

# Examples

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
