```julia
ScopedValue(x)
```

動的スコープ間で値を伝播するコンテナーを作成します。新しい動的スコープを作成して入るには、[`with`](@ref)を使用します。

値を設定できるのは、新しい動的スコープに入るときだけです。参照される値は、動的スコープの実行中は一定です。

動的スコープはタスク間で伝播します。

# Examples

```jldoctest
julia> using Base.ScopedValues;

julia> const sval = ScopedValue(1);

julia> sval[]
1

julia> with(sval => 2) do
           sval[]
       end
2

julia> sval[]
1
```

!!! compat "Julia 1.11"
    スコープ付き値は Julia 1.11 で導入されました。Julia 1.8 以降では、ScopedValues.jl パッケージから互換実装を利用できます。

