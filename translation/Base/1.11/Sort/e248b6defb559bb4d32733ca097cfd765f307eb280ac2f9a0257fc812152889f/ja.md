```
クイックソート
```

ソート関数はクイックソートアルゴリズムを使用する必要があり、これは*安定ではありません*。

特徴：

  * *安定ではない*: 等しいと比較される要素の順序を保持しません（例："a"と"A"が大文字と小文字を無視した文字のソートで）。
  * メモリ内での*インプレース*。
  * *分割統治法*: [`マージソート`](@ref)に似たソート戦略。
  * 大規模コレクションに対して*良好なパフォーマンス*。
