```julia
@world(sym, world)
```

ワールド `world` で `sym` のバインディングを解決します。固定されたワールドで任意のコードを実行するための [`invoke_in_world`](@ref) を参照してください。`world` は `UnitRange` である場合があり、その場合、バインディングが有効であり、ワールド範囲全体で同じ値を持たない限り、マクロはエラーになります。

特別なケースとして、ワールド `∞` は常に最新のワールドを指し、そのワールドが現在実行中のワールドよりも新しい場合でも同様です。

`@world` マクロは、現在のワールドでもはや利用できないバインディングの印刷に主に使用されます。

## 例

```julia-repl
julia> struct Foo; a::Int; end
Foo

julia> fold = Foo(1)

julia> Int(Base.get_world_counter())
26866

julia> struct Foo; a::Int; b::Int end
Foo

julia> fold
@world(Foo, 26866)(1)
```

!!! compat "Julia 1.12"
    この機能は少なくとも Julia 1.12 が必要です。

