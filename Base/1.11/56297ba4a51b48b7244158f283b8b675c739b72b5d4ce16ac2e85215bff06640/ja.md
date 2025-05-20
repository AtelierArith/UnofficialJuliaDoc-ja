```
Base.@constprop 設定 [ex]
```

注釈付き関数のための手続き間定数伝播のモードを制御します。

2つの `setting` がサポートされています：

  * `Base.@constprop :aggressive [ex]`: 定数伝播を積極的に適用します。戻り値の型が引数の値に依存するメソッドの場合、これは追加のコンパイル時間のコストで推論結果を改善する可能性があります。
  * `Base.@constprop :none [ex]`: 定数伝播を無効にします。これにより、Juliaが定数伝播に値すると思われる関数のコンパイル時間を短縮できます。一般的なケースは、`Bool` または `Symbol` 値の引数やキーワード引数を持つ関数です。

`Base.@constprop` は、関数定義の直前または関数本体内で適用できます。

```julia
# 長形式の定義に注釈を付ける
Base.@constprop :aggressive function longdef(x)
    ...
end

# 短形式の定義に注釈を付ける
Base.@constprop :aggressive shortdef(x) = ...

# `do` ブロックが作成する無名関数に注釈を付ける
f() do
    Base.@constprop :aggressive
    ...
end
```

!!! compat "Julia 1.10"
    関数本体内での使用は、少なくとも Julia 1.10 が必要です。

