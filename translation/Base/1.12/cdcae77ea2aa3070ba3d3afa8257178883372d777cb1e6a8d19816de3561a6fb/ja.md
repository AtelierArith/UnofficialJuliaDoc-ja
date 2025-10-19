```julia
@atomiconce a.b.x = value
@atomiconce :sequentially_consistent a.b.x = value
@atomiconce :sequentially_consistent :monotonic a.b.x = value
@atomiconce m[idx] = value
@atomiconce :sequentially_consistent m[idx] = value
@atomiconce :sequentially_consistent :monotonic m[idx] = value
```

値が以前に未設定であった場合、条件付きで値を原子的に割り当てます。返される値 `success::Bool` は、割り当てが完了したかどうかを示します。

この操作は `setpropertyonce!(a.b, :x, value)` に変換されるか、参照の場合は `setindexonce_atomic!(m, success_order, fail_order, value, idx)` 呼び出しに変換され、両方の順序はデフォルトで `:sequentially_consistent` になります。

詳細については、マニュアルの [Per-field atomics](@ref man-atomics) セクションを参照してください。

# 例

```jldoctest
julia> mutable struct AtomicOnce
           @atomic x
           AtomicOnce() = new()
       end

julia> a = AtomicOnce()
AtomicOnce(#undef)

julia> @atomiconce a.x = 1 # aのフィールドxを1に設定します。未設定の場合、順序はsequential consistencyです。
true

julia> @atomic a.x # aのフィールドxを取得します。順序はsequential consistencyです。
1

julia> @atomiconce :monotonic a.x = 2 # aのフィールドxを1に設定します。未設定の場合、順序はmonotonic consistencyです。
false
```

```jldoctest
julia> mem = AtomicMemory{Vector{Int}}(undef, 1);

julia> isassigned(mem, 1)
false

julia> @atomiconce mem[1] = [1] # memの最初の値を[1]に設定します。未設定の場合、順序はsequential consistencyです。
true

julia> isassigned(mem, 1)
true

julia> @atomic mem[1] # memの最初の値を取得します。順序はsequential consistencyです。
1-element Vector{Int64}:
 1

julia> @atomiconce :monotonic mem[1] = [2] # memの最初の値を[2]に設定します。未設定の場合、順序はmonotonicです。
false

julia> @atomic mem[1]
1-element Vector{Int64}:
 1
```

!!! compat "Julia 1.11"
    原子的フィールド機能は、少なくともJulia 1.11が必要です。


!!! compat "Julia 1.12"
    原子的参照機能は、少なくともJulia 1.12が必要です。

