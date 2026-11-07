```julia
PartialQuickSort{T <: Union{Integer,OrdinalRange}}
```

ソート関数に部分クイックソートアルゴリズムを使うよう指定します。`PartialQuickSort(k)`は`QuickSort`に似ていますが、`v`を完全にソートした場合に`v[k]`に入る要素だけを見つけてソートすれば十分です。

特徴:

  * *安定ではない*: 比較結果が等しい要素の順序を保持しません（たとえば、大文字と小文字を区別しない文字のソートにおける「a」と「A」）。
  * メモリ上で*インプレース*に処理します。
  * *分割統治法*: ソート戦略は[`MergeSort`](@ref)に似ています。

`PartialQuickSort(k)`は、配列全体をソートするとは限りません。たとえば、

```jldoctest
julia> x = rand(100);

julia> k = 50:100;

julia> s1 = sort(x; alg=QuickSort);

julia> s2 = sort(x; alg=PartialQuickSort(k));

julia> map(issorted, (s1, s2))
(true, false)

julia> map(x->issorted(x[k]), (s1, s2))
(true, true)

julia> s1[k] == s2[k]
true
```
