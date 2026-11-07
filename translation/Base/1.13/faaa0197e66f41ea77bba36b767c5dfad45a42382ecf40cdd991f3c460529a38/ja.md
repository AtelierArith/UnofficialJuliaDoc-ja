```julia
@assert cond [text]
```

[`AssertionError`](@ref) を使うと、`cond` が `false` の場合に例外をスローします。これはアサーションを記述するための推奨構文です。アサーションとは、真であると想定される条件のことで、失敗した場合にデバッグの助けとしてユーザーが確認できます。省略可能なメッセージ `text` は、アサーションが失敗したときに表示されます。

!!! warning
    最適化レベルによっては、アサーションが無効になることがあります。そのため、アサーションはデバッグ用のツールとしてのみ使用し、認証の検証（パスワードの確認や配列の境界チェックなど）には使用しないでください。関数が正しく動作するために、`cond` の実行による副作用に依存してはなりません。


# Examples

```jldoctest
julia> @assert iseven(3) "3 is an odd number!"
ERROR: AssertionError: 3 is an odd number!

julia> @assert isodd(3) "What even are numbers?"
```
