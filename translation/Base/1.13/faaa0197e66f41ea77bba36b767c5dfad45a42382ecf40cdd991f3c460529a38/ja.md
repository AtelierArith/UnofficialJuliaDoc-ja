```julia
@assert cond [text]
```

[`AssertionError`](@ref)を、`cond`が`false`の場合にスローします。これは、真であると想定される条件を記述するための、推奨される構文です。条件が満たされない場合にデバッグの助けとして確認できるよう、アサーションを記述します。省略可能なメッセージ`text`は、アサーションに失敗したときに表示されます。

!!! warning
    アサーションは、最適化レベルによっては無効になることがあります。そのため、アサーションはデバッグ用にのみ使用し、認証の検証（パスワードの確認や配列の境界チェックなど）には使用しないでください。関数が正しく動作するために、`cond`の実行による副作用に依存してはなりません。


# Examples

```jldoctest
julia> @assert iseven(3) "3 is an odd number!"
ERROR: AssertionError: 3 is an odd number!

julia> @assert isodd(3) "What even are numbers?"
```
