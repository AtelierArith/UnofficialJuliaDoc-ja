```julia
@atomicswap a.b.x = new
@atomicswap :sequentially_consistent a.b.x = new
@atomicswap m[idx] = new
@atomicswap :sequentially_consistent m[idx] = new
```

`new`を`a.b.x`（参照の場合は`m[idx]`）に格納し、`a.b.x`の古い値（それぞれ`m[idx]`に格納されていた古い値）を返します。

この操作は、`swapproperty!(a.b, :x, new)`または、参照の場合は`swapindex_atomic!(mem, order, new, idx)`呼び出しに変換され、`order`はデフォルトで`:sequentially_consistent`になります。

詳細については、マニュアルの[Per-field atomics](@ref man-atomics)セクションを参照してください。

# 例

```jldoctest
julia> mutable struct Atomic{T}; @atomic x::T; end

julia> a = Atomic(1)
Atomic{Int64}(1)

julia> @atomicswap a.x = 2+2 # aのフィールドxを4に置き換え、順序の一貫性を持つ
1

julia> @atomic a.x # aのフィールドxを取得し、順序の一貫性を持つ
4
```

```jldoctest
julia> mem = AtomicMemory{Int}(undef, 2);

julia> @atomic mem[1] = 1;

julia> @atomicswap mem[1] = 4 # `mem`の最初の値を4に置き換え、順序の一貫性を持つ
1

julia> @atomic mem[1] # memの最初の値を取得し、順序の一貫性を持つ
4
```

!!! compat "Julia 1.7"
    Atomic fields機能は、少なくともJulia 1.7が必要です。


!!! compat "Julia 1.12"
    Atomic reference機能は、少なくともJulia 1.12が必要です。

