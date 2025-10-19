```julia
@atomic var
@atomic order ex
```

`var` または `ex` を原子的に実行されるものとしてマークします。`order` が指定されていない場合、デフォルトは :sequentially_consistent です。

```julia
@atomic a.b.x = new
@atomic a.b.x += addend
@atomic :release a.b.x = new
@atomic :acquire_release a.b.x += addend
@atomic m[idx] = new
@atomic m[idx] += addend
@atomic :release m[idx] = new
@atomic :acquire_release m[idx] += addend
```

右側で表現されたストア操作を原子的に実行し、新しい値を返します。

代入（`=`）の場合、この操作は `setproperty!(a.b, :x, new)` に変換されるか、参照の場合は `setindex_atomic!(m, order, new, idx)` 呼び出しに変換され、`order` のデフォルトは `:sequentially_consistent` です。

任意の修正演算子の場合、この操作は `modifyproperty!(a.b, :x, op, addend)[2]` に変換されるか、参照の場合は `modifyindex_atomic!(m, order, op, addend, idx...)[2]` 呼び出しに変換され、`order` のデフォルトは `:sequentially_consistent` です。

```julia
@atomic a.b.x max arg2
@atomic a.b.x + arg2
@atomic max(a.b.x, arg2)
@atomic :acquire_release max(a.b.x, arg2)
@atomic :acquire_release a.b.x + arg2
@atomic :acquire_release a.b.x max arg2
@atomic m[idx] max arg2
@atomic m[idx] + arg2
@atomic max(m[idx], arg2)
@atomic :acquire_release max(m[idx], arg2)
@atomic :acquire_release m[idx] + arg2
@atomic :acquire_release m[idx] max arg2
```

右側で表現された二項演算を原子的に実行します。結果を最初の引数のフィールドまたは参照に格納し、値 `(old, new)` を返します。

この操作は `modifyproperty!(a.b, :x, func, arg2)` に変換されるか、参照の場合は `modifyindex_atomic!(m, order, func, arg2, idx)` 呼び出しに変換され、`order` のデフォルトは `:sequentially_consistent` です。

詳細については、マニュアルの [Per-field atomics](@ref) セクションを参照してください。

# 例

```jldoctest
julia> mutable struct Atomic{T}; @atomic x::T; end

julia> a = Atomic(1)
Atomic{Int64}(1)

julia> @atomic a.x # fetch field x of a, with sequential consistency
1

julia> @atomic :sequentially_consistent a.x = 2 # set field x of a, with sequential consistency
2

julia> @atomic a.x += 1 # increment field x of a, with sequential consistency
3

julia> @atomic a.x + 1 # increment field x of a, with sequential consistency
3 => 4

julia> @atomic a.x # fetch field x of a, with sequential consistency
4

julia> @atomic max(a.x, 10) # change field x of a to the max value, with sequential consistency
4 => 10

julia> @atomic a.x max 5 # again change field x of a to the max value, with sequential consistency
10 => 10
```

```jldoctest
julia> mem = AtomicMemory{Int}(undef, 2);

julia> @atomic mem[1] = 2 # set mem[1] to value 2 with sequential consistency
2

julia> @atomic :monotonic mem[1] # fetch the first value of mem, with monotonic consistency
2

julia> @atomic mem[1] += 1 # increment the first value of mem, with sequential consistency
3

julia> @atomic mem[1] + 1 # increment the first value of mem, with sequential consistency
3 => 4

julia> @atomic mem[1] # fetch the first value of mem, with sequential consistency
4

julia> @atomic max(mem[1], 10) # change the first value of mem to the max value, with sequential consistency
4 => 10

julia> @atomic mem[1] max 5 # again change the first value of mem to the max value, with sequential consistency
10 => 10
```

!!! compat "Julia 1.7"
    Atomic fields functionality requires at least Julia 1.7.


!!! compat "Julia 1.12"
    Atomic reference functionality requires at least Julia 1.12.

