```julia
@atomicreplace a.b.x expected => desired
@atomicreplace :sequentially_consistent a.b.x expected => desired
@atomicreplace :sequentially_consistent :monotonic a.b.x expected => desired
@atomicreplace m[idx] expected => desired
@atomicreplace :sequentially_consistent m[idx] expected => desired
@atomicreplace :sequentially_consistent :monotonic m[idx] expected => desired
```

ペアで指定された条件付き置換をアトミックに実行し、値 `(old, success::Bool)` を返します。置換が完了したかどうかは `success` で示されます。

この操作は `replaceproperty!(a.b, :x, expected, desired)` に変換されます。参照の場合は `replaceindex_atomic!(mem, success_order, fail_order, expected, desired, idx)` の呼び出しに変換され、どちらの順序もデフォルトでは `:sequentially_consistent` です。

詳しくは、マニュアルの [Per-field atomics](@ref man-atomics) セクションを参照してください。

# Examples

```jldoctest
julia> mutable struct Atomic{T}; @atomic x::T; end

julia> a = Atomic(1)
Atomic{Int64}(1)

julia> @atomicreplace a.x 1 => 2 # replace field x of a with 2 if it was 1, with sequential consistency
(old = 1, success = true)

julia> @atomic a.x # fetch field x of a, with sequential consistency
2

julia> @atomicreplace a.x 1 => 3 # replace field x of a with 2 if it was 1, with sequential consistency
(old = 2, success = false)

julia> xchg = 2 => 0; # replace field x of a with 0 if it was 2, with sequential consistency

julia> @atomicreplace a.x xchg
(old = 2, success = true)

julia> @atomic a.x # fetch field x of a, with sequential consistency
0
```

```jldoctest
julia> mem = AtomicMemory{Int}(undef, 2);

julia> @atomic mem[1] = 1;

julia> @atomicreplace mem[1] 1 => 2 # replace the first value of mem with 2 if it was 1, with sequential consistency
(old = 1, success = true)

julia> @atomic mem[1] # fetch the first value of mem, with sequential consistency
2

julia> @atomicreplace mem[1] 1 => 3 # replace field x of a with 2 if it was 1, with sequential consistency
(old = 2, success = false)

julia> xchg = 2 => 0; # replace field x of a with 0 if it was 2, with sequential consistency

julia> @atomicreplace mem[1] xchg
(old = 2, success = true)

julia> @atomic mem[1] # fetch the first value of mem, with sequential consistency
0
```

!!! compat "Julia 1.7"
    Atomic フィールド機能を使用するには、Julia 1.7 以降が必要です。


!!! compat "Julia 1.12"
    Atomic 参照機能を使用するには、Julia 1.12 以降が必要です。

