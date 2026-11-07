```julia
@atomiconce a.b.x = value
@atomiconce :sequentially_consistent a.b.x = value
@atomiconce :sequentially_consistent :monotonic a.b.x = value
@atomiconce m[idx] = value
@atomiconce :sequentially_consistent m[idx] = value
@atomiconce :sequentially_consistent :monotonic m[idx] = value
```

値がまだ設定されていない場合に、条件付き代入をアトミックに実行します。返される値 `success::Bool` は、代入が完了したかどうかを示します。

この操作は `setpropertyonce!(a.b, :x, value)` に変換されます。参照の場合は `setindexonce_atomic!(m, success_order, fail_order, value, idx)` の呼び出しに変換され、どちらも順序の既定値は `:sequentially_consistent` です。

詳細については、マニュアルの [Per-field atomics](@ref man-atomics) セクションを参照してください。

# Examples

```jldoctest
julia> mutable struct AtomicOnce
           @atomic x
           AtomicOnce() = new()
       end

julia> a = AtomicOnce()
AtomicOnce(#undef)

julia> @atomiconce a.x = 1 # set field x of a to 1, if unset, with sequential consistency
true

julia> @atomic a.x # fetch field x of a, with sequential consistency
1

julia> @atomiconce :monotonic a.x = 2 # set field x of a to 1, if unset, with monotonic consistence
false
```

```jldoctest
julia> mem = AtomicMemory{Vector{Int}}(undef, 1);

julia> isassigned(mem, 1)
false

julia> @atomiconce mem[1] = [1] # set the first value of mem to [1], if unset, with sequential consistency
true

julia> isassigned(mem, 1)
true

julia> @atomic mem[1] # fetch the first value of mem, with sequential consistency
1-element Vector{Int64}:
 1

julia> @atomiconce :monotonic mem[1] = [2] # set the first value of mem to [2], if unset, with monotonic
false

julia> @atomic mem[1]
1-element Vector{Int64}:
 1
```

!!! compat "Julia 1.11"
    アトミックフィールド機能には、Julia 1.11 以降が必要です。


!!! compat "Julia 1.12"
    アトミック参照機能には、Julia 1.12 以降が必要です。

