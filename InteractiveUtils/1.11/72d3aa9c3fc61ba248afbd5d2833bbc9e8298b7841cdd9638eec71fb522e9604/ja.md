```julia
methodswith(typ[, module or function]; supertypes::Bool=false])
```

型 `typ` の引数を持つメソッドの配列を返します。

オプションの第二引数は、特定のモジュールまたは関数に検索を制限します（デフォルトはすべてのトップレベルモジュールです）。

キーワード `supertypes` が `true` の場合、型 `Any` を除く `typ` の親型を持つ引数も返します。

参照: [`methods`](@ref).
