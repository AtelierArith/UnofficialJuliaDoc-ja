```
contains(needle)
```

引数が `needle` を含むかどうかをチェックする関数を作成します。すなわち、`haystack -> contains(haystack, needle)` と同等の関数です。

返される関数は `Base.Fix2{typeof(contains)}` 型であり、特化したメソッドを実装するために使用できます。
