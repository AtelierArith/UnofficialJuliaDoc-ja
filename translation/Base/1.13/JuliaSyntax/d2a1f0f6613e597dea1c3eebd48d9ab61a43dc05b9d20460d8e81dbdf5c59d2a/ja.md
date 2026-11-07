```julia
flags(x)
```

構文要素のフラグビットを返します。フラグの確認には、`is_trivia`、`is_prefix_call`、`is_infix_op_call`、`is_prefix_op_call`、`is_postfix_op_call`、`is_dotted`、`is_suffixed`、`is_decorated` の各述語を使うことを推奨します。

または、`numeric_flags` を使ってフラグの数値部分を取り出します。
