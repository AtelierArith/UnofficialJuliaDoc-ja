```julia
ScratchQuickSort(next::Base.Sort.Algorithm=Base.Sort.SMALL_ALGORITHM) isa Base.Sort.Algorithm
ScratchQuickSort(lo::Union{Integer, Missing}, hi::Union{Integer, Missing}=lo, next::Base.Sort.Algorithm=Base.Sort.SMALL_ALGORITHM) isa Base.Sort.Algorithm
```

`next`アルゴリズムを基本ケースとして、`ScratchQuickSort`アルゴリズムを使用します。

`ScratchQuickSort`は`QuickSort`に似ていますが、スクラッチ領域を利用することで処理を高速化し、安定性を維持できる可能性もあります。

`lo`と`hi`が指定されている場合、範囲`lo:hi`内の要素を見つけてソートします。その過程でほかの要素も並べ替えられますが、必ずしもソートされるとは限りません。`lo`または`hi`が`missing`の場合、それぞれ入力の最初または最後のインデックスとして扱われます。

`lo`と`hi`は、`AbstractUnitRange`として同時に指定できます。

特徴:

  * *安定*: 比較結果が等しい要素の順序を保持します（例: 大文字と小文字を区別しない文字のソートにおける「a」と「A」）。
  * メモリ上で *インプレースではない*。
  * *分割統治法*: [`QuickSort`](@ref)に似たソート戦略。
  * `length(lo:hi)`が定数の場合、*線形の実行時間*。
  * 病的なケースでは *最悪時の実行時間が二次*。

（悪意のない入力では、発生する可能性は極めて低い）
