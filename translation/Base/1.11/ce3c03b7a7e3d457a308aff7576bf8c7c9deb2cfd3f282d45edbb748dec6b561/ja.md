```
@boundscheck(blk)
```

式 `blk` を境界チェックブロックとして注釈し、[`@inbounds`](@ref) によって省略されることを許可します。

!!! note
    `@boundscheck` が書かれている関数は、その呼び出し元にインライン化される必要があり、そうでないと `@inbounds` は効果を持ちません。


# 例

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
    `@boundscheck` 注釈は、ライブラリ作成者として、*他のコード* が [`@inbounds`](@ref) を使用してあなたの境界チェックを削除することを許可するためのオプトインを可能にします。そこに記載されているように、呼び出し元は、`@inbounds` を使用する前に、自分がアクセスするインデックスが有効であることを確認する必要があります。たとえば、あなたの [`AbstractArray`](@ref) サブクラスへのインデックス付けでは、インデックスをその [`axes`](@ref) と照らし合わせて確認する必要があります。したがって、`@boundscheck` 注釈は、その動作が正しいことが確実である場合にのみ、[`getindex`](@ref) または [`setindex!`](@ref) の実装に追加されるべきです。

