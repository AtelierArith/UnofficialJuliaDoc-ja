```
@atomiconce a.b.x = value
@atomiconce :sequentially_consistent a.b.x = value
@atomiconce :sequentially_consistent :monotonic a.b.x = value
```

値が以前に未設定であった場合に、条件付きで値を原子的に割り当て、`success::Bool`を返します。ここで、`success`は割り当てが完了したかどうかを示します。

この操作は`setpropertyonce!(a.b, :x, value)`呼び出しに変換されます。

詳細については、マニュアルの[Per-field atomics](@ref man-atomics)セクションを参照してください。

# 例

```jldoctest
julia> mutable struct AtomicOnce
           @atomic x
           AtomicOnce() = new()
       end

julia> a = AtomicOnce()
AtomicOnce(#undef)

julia> @atomiconce a.x = 1 # aのフィールドxを1に設定します。未設定の場合、順次一貫性を持って
true

julia> @atomic a.x # aのフィールドxを取得します。順次一貫性を持って
1

julia> @atomiconce a.x = 1 # aのフィールドxを1に設定します。未設定の場合、順次一貫性を持って
false
```

!!! compat "Julia 1.11"
    この機能は少なくともJulia 1.11が必要です。

