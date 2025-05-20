```
tryparsenext(tok::AbstractDateToken, str::String, i::Int, len::Int, locale::DateLocale)
```

`tryparsenext` は、インデックス `i` から始まる `str` 内の `tok` トークンを解析します。 `len` は文字列の長さです。解析はオプションで `locale` に基づくことができます。`tryparsenext` メソッドがロケールを必要としない場合、メソッド定義で引数を省略できます。

解析が成功した場合、2つの要素からなるタプル `(res, idx)` を返します。ここで：

  * `res` は解析の結果です。
  * `idx::Int` は、解析が終了したインデックスの *後* のインデックスです。
