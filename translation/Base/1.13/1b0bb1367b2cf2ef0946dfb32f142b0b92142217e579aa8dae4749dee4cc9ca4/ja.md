```julia
@boundscheck(blk)
```

式 `blk` を境界チェックブロックとして注釈し、[`@inbounds`](@ref) によって省略できるようにします。

!!! note
    `@inbounds` の効果を得るには、`@boundscheck` が記述された関数を呼び出し元にインライン化する必要があります。


# Examples

```jldoctest; filter = r"Stacktrace:(\n \[[0-9]+\].*)*"
julia> @inline function g(A, i)
           @boundscheck checkbounds(A, i)
           return "accessing ($A)[$i]"
       end;

julia> f1() = return g(1:2, -1);

julia> f2() = @inbounds return g(1:2, -1);

julia> f1()
ERROR: BoundsError: attempt to access 2-element UnitRange{Int64} at index [-1]
Stacktrace:
 [1] throw_boundserror(::UnitRange{Int64}, ::Tuple{Int64}) at ./abstractarray.jl:455
 [2] checkbounds at ./abstractarray.jl:420 [inlined]
 [3] g at ./none:2 [inlined]
 [4] f1() at ./none:1
 [5] top-level scope

julia> f2()
"accessing (1:2)[-1]"
```

!!! warning
    `@boundscheck` 注釈を付けると、ライブラリの作成者は、[`@inbounds`](@ref) を使って *他のコード* が自身の境界チェックを削除できるようにすることを選択できます。そこで述べられているように、呼び出し元は `@inbounds` を使用する前に、自身が利用できる情報を使ってアクセスが有効であることを確認する必要があります。たとえば、独自の [`AbstractArray`](@ref) サブクラスをインデックス指定する場合は、その [`axes`](@ref) に対してインデックスをチェックします。したがって、`@boundscheck` 注釈は、動作が正しいと確信できた後にのみ、[`getindex`](@ref) または [`setindex!`](@ref) の実装に追加してください。

