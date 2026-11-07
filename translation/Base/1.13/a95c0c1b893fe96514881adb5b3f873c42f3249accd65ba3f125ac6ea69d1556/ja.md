```julia
contains(needle)
```

引数に`needle`が含まれているかどうかを判定する関数、つまり`haystack -> contains(haystack, needle)`と同等の関数を作成します。

返される関数の型は`Base.Fix2{typeof(contains)}`であり、これを使って特化したメソッドを実装できます。
