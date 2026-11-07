```julia
flags(x)
```

構文要素のフラグビットを返します。これらの値を調べるには、次の述語を使うことを推奨します。`is_trivia`、`is_prefix_call`、`is_infix_op_call`、`is_prefix_op_call`、`is_postfix_op_call`、`is_dotted`、`is_suffixed`、`is_decorated`。

または、`numeric_flags`を使ってフラグの数値部分を抽出します。
