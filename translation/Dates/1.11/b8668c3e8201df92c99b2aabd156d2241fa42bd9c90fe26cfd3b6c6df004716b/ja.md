```julia
tryparsenext(tok::AbstractDateToken, str::String, i::Int, len::Int, locale::DateLocale)
```

`tryparsenext` は、`str` の `i` 番目のインデックスから始まる `tok` トークンを解析します。`len` は文字列の長さです。解析には、任意で `locale` を使用できます。`tryparsenext` メソッドでロケールが不要な場合は、メソッド定義でその引数を省略できます。

解析に成功すると、次の2要素からなるタプル `(res, idx)` を返します。

  * `res` は解析結果です。
  * `idx::Int` は、解析が終了したインデックスの次のインデックスです。
