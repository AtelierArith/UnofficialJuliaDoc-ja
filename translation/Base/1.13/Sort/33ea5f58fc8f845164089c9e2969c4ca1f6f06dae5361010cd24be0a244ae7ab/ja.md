```julia
CountingSort() isa Base.Sort.Algorithm
```

計数ソートアルゴリズムを使用します。

`CountingSort` は、整数をソートするアルゴリズムです。時間計算量と空間計算量はいずれも Θ(length + range) です。入力に含まれる各値の出現回数を数え、そのカウントを順にたどりながら、値をソート済みの順序で入力に書き戻します。
