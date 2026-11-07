```julia
@world(sym, world)
```

バインディング `sym` をワールド `world` で解決します。固定されたワールドで任意のコードを実行する方法については、[`invoke_in_world`](@ref) を参照してください。`world` は `UnitRange` の場合があり、その場合、バインディングが有効で、ワールド範囲全体で同じ値を持たない限り、マクロはエラーになります。

特例として、ワールド `∞` は常に最新のワールドを指します。これは、そのワールドが現在実行中のワールドより新しい場合も同様です。

`@world` マクロは、主に現在のワールドでは利用できなくなったバインディングを表示する際に使われます。

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
    この機能を使うには、Julia 1.12 以降が必要です。

