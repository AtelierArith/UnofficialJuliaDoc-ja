```
tryparsenext_internal(::Type{<:TimeType}, str, pos, len, df::DateFormat, raise=false)
```

`DateFormat`内の指示に従って文字列を解析します。指定された`TimeType`型は、返されるトークンの型と順序を決定します。指定された`DateFormat`または文字列が必要なトークンを提供しない場合、デフォルト値が使用されます。文字列を解析できない場合、`raise`がfalseであれば返される値は`nothing`、それ以外の場合は例外がスローされます。

成功した場合、2要素のタプル`(values, pos)`を返します：

  * `values::Tuple`: 渡された型によって指定された各トークンの値を含むタプル。
  * `pos::Int`: 解析が停止した文字インデックス。
