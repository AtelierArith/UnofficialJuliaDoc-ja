```julia
methodswith(typ[, module or function]; supertypes::Bool=false)
```

`typ`型の引数を持つメソッドの配列を返します。

省略可能な第2引数を指定すると、検索対象を特定のモジュールまたは関数に限定できます（デフォルトでは、すべてのトップレベルモジュールが対象です）。

キーワード引数`supertypes`が`true`の場合、親型が`typ`である引数も返します。ただし、型が`Any`のものは除外されます。

関連項目: [`methods`](@ref)。
