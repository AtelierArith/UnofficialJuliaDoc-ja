```julia
@world(sym, world)
```

`sym` の束縛を `world` のワールドで解決します。固定されたワールドで任意のコードを実行する方法については、[`invoke_in_world`](@ref) を参照してください。`world` は `UnitRange` の場合があります。その場合、束縛が有効で、ワールド範囲全体で同じ値を持たない限り、マクロはエラーになります。

特例として、ワールド `∞` は、現在実行中のワールドより新しい場合でも、常に最新のワールドを指します。

`@world` マクロは、主に現在のワールドでは利用できなくなった束縛を表示するために使われます。

## Example

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
    この機能を利用するには、Julia 1.12 以降が必要です。

