```
ScopedValue(x)
```

動的スコープを通じて値を伝播させるコンテナを作成します。新しい動的スコープを作成して入るには、[`with`](@ref)を使用します。

値は新しい動的スコープに入るときにのみ設定でき、参照される値は動的スコープの実行中は一定です。

動的スコープはタスクを通じて伝播します。

# 例

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
    スコープ付き値はJulia 1.11で導入されました。Julia 1.8+では、ScopedValues.jlパッケージから互換性のある実装が利用可能です。

