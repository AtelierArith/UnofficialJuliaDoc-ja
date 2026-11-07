```julia
tryparsenext_internal(::Type{<:TimeType}, str, pos, len, df::DateFormat, raise=false)
```

`DateFormat`内の指示に従って文字列を解析します。指定された`TimeType`型によって、返されるトークンの型と順序が決まります。指定された`DateFormat`または文字列に必須のトークンが含まれていない場合は、デフォルト値が使用されます。文字列を解析できない場合、`raise`がfalseなら返り値は`nothing`となり、そうでなければ例外がスローされます。

解析に成功すると、2要素のタプル`(values, pos)`を返します。

  * `values::Tuple`: 渡された型で指定された各トークンの値を含むタプル。
  * `pos::Int`: 解析が停止した位置の文字インデックス。
