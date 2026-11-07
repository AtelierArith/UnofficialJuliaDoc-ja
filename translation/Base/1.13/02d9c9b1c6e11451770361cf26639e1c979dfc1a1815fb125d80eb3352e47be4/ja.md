```julia
@__FUNCTION__
```

最も内側で囲んでいる関数オブジェクトを取得します。

!!! note
    `@__FUNCTION__`のスコープ動作は`return`と同じです。クロージャ内で使うと、外側の関数ではなくクロージャを参照します。[`@spawn`](@ref Threads.@spawn)や[`@async`](@ref)など、一部のマクロは入力をクロージャでラップします。そのようなコード内で`@__FUNCTION__`を使うと、囲んでいる関数ではなく、マクロが作成したクロージャを参照します。


# Examples

`@__FUNCTION__`を使うと、再帰的な無名関数を定義できます。

```jldoctest
julia> factorial = (n -> n <= 1 ? 1 : n * (@__FUNCTION__)(n - 1));

julia> factorial(5)
120
```

`@__FUNCTION__`は`nameof`と組み合わせることで、関数本体の中から関数名を特定できます。

```jldoctest
julia> bar() = nameof(@__FUNCTION__);

julia> bar()
:bar
```

!!! compat "Julia 1.13"
    このマクロを使うには、Julia 1.13以降が必要です。

