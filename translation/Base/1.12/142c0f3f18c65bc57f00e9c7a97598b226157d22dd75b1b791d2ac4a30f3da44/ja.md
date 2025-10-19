```julia
@atomicreplace a.b.x expected => desired
@atomicreplace :sequentially_consistent a.b.x expected => desired
@atomicreplace :sequentially_consistent :monotonic a.b.x expected => desired
@atomicreplace m[idx] expected => desired
@atomicreplace :sequentially_consistent m[idx] expected => desired
@atomicreplace :sequentially_consistent :monotonic m[idx] expected => desired
```

ペアによって表現された条件付き置換を原子的に実行し、値 `(old, success::Bool)` を返します。ここで `success` は置換が完了したかどうかを示します。

この操作は `replaceproperty!(a.b, :x, expected, desired)` または参照の場合は `replaceindex_atomic!(mem, success_order, fail_order, expected, desired, idx)` 呼び出しに変換され、両方の順序はデフォルトで `:sequentially_consistent` になります。

詳細についてはマニュアルの [Per-field atomics](@ref man-atomics) セクションを参照してください。

# 例

```jldoctest
julia> mutable struct Atomic{T}; @atomic x::T; end

julia> a = Atomic(1)
Atomic{Int64}(1)

julia> @atomicreplace a.x 1 => 2 # aのフィールドxを1であれば2に置換し、順序は逐次的整合性
(old = 1, success = true)

julia> @atomic a.x # aのフィールドxを取得し、順序は逐次的整合性
2

julia> @atomicreplace a.x 1 => 3 # aのフィールドxを1であれば2に置換し、順序は逐次的整合性
(old = 2, success = false)

julia> xchg = 2 => 0; # aのフィールドxを2であれば0に置換し、順序は逐次的整合性

julia> @atomicreplace a.x xchg
(old = 2, success = true)

julia> @atomic a.x # aのフィールドxを取得し、順序は逐次的整合性
0
```

```jldoctest
julia> mem = AtomicMemory{Int}(undef, 2);

julia> @atomic mem[1] = 1;

julia> @atomicreplace mem[1] 1 => 2 # memの最初の値を1であれば2に置換し、順序は逐次的整合性
(old = 1, success = true)

julia> @atomic mem[1] # memの最初の値を取得し、順序は逐次的整合性
2

julia> @atomicreplace mem[1] 1 => 3 # aのフィールドxを1であれば2に置換し、順序は逐次的整合性
(old = 2, success = false)

julia> xchg = 2 => 0; # aのフィールドxを2であれば0に置換し、順序は逐次的整合性

julia> @atomicreplace mem[1] xchg
(old = 2, success = true)

julia> @atomic mem[1] # memの最初の値を取得し、順序は逐次的整合性
0
```

!!! compat "Julia 1.7"
    原子的フィールド機能は少なくともJulia 1.7が必要です。


!!! compat "Julia 1.12"
    原子的参照機能は少なくともJulia 1.12が必要です。

