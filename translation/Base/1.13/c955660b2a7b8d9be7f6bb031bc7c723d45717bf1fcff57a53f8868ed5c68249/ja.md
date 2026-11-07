```julia
@atomicswap a.b.x = new
@atomicswap :sequentially_consistent a.b.x = new
@atomicswap m[idx] = new
@atomicswap :sequentially_consistent m[idx] = new
```

`new`を`a.b.x`に格納します（参照の場合は`m[idx]`）。また、以前の値である`a.b.x`（参照の場合は`m[idx]`に格納されていた値）を返します。

この操作は、`swapproperty!(a.b, :x, new)`呼び出しに変換されます。参照の場合は`swapindex_atomic!(mem, order, new, idx)`呼び出しとなり、`order`のデフォルト値は`:sequentially_consistent`です。

詳細については、マニュアルの[Per-field atomics](@ref man-atomics)セクションを参照してください。

# Examples

```jldoctest
julia> mutable struct Atomic{T}; @atomic x::T; end

julia> a = Atomic(1)
Atomic{Int64}(1)

julia> @atomicswap a.x = 2+2 # replace field x of a with 4, with sequential consistency
1

julia> @atomic a.x # fetch field x of a, with sequential consistency
4
```

```jldoctest
julia> mem = AtomicMemory{Int}(undef, 2);

julia> @atomic mem[1] = 1;

julia> @atomicswap mem[1] = 4 # replace the first value of `mem` with 4, with sequential consistency
1

julia> @atomic mem[1] # fetch the first value of mem, with sequential consistency
4
```

!!! compat "Julia 1.7"
    Atomicフィールド機能には、Julia 1.7以降が必要です。


!!! compat "Julia 1.12"
    Atomic参照機能には、Julia 1.12以降が必要です。

