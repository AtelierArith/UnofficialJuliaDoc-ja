```julia
ScopedValue(x)
```

動的スコープ間で値を伝播するコンテナーを作成します。[`with`](@ref)を使うと、新しい動的スコープを作成して入ることができます。

値を設定できるのは新しい動的スコープに入るときだけです。また、参照される値は動的スコープの実行中、一定です。

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
    Scoped values は Julia 1.11 で導入されました。Julia 1.8 以降では、パッケージ ScopedValues.jl による互換実装を利用できます。

