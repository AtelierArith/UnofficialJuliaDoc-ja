```julia
ScratchQuickSort(next::Base.Sort.Algorithm=Base.Sort.SMALL_ALGORITHM) isa Base.Sort.Algorithm
ScratchQuickSort(lo::Union{Integer, Missing}, hi::Union{Integer, Missing}=lo, next::Base.Sort.Algorithm=Base.Sort.SMALL_ALGORITHM) isa Base.Sort.Algorithm
```

`ScratchQuickSort` アルゴリズムを使用し、`next` アルゴリズムを基底ケースとします。

`ScratchQuickSort` は `QuickSort` に似ていますが、スクラッチ領域を使うことで処理を高速化し、安定性を維持できる可能性もあります。

`lo` と `hi` が指定されている場合、`lo:hi` の範囲内の要素を見つけて並べ替えます。その過程でほかの要素の順序も変更されますが、必ずしも並べ替えられるとは限りません。`lo` または `hi` が `missing` の場合、それぞれ入力の最初または最後のインデックスとして扱われます。

`lo` と `hi` は、`AbstractUnitRange` として同時に指定できます。

特徴:

  * *安定*: 比較結果が等しい要素の順序を維持します（例: 大文字と小文字を区別しない文字のソートにおける「a」と「A」）。
  * メモリ上で *インプレースではない*。
  * *分割統治法*: [`QuickSort`](@ref) に似たソート戦略。
  * `length(lo:hi)` が定数の場合、*実行時間は線形*。
  * 病的なケースでは *最悪実行時間は二次*。

（悪意のない入力では、発生する可能性は極めて低い）
