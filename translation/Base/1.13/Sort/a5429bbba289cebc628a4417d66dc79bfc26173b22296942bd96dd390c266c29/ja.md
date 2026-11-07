```julia
PartialQuickSort{T <: Union{Integer,OrdinalRange}}
```

ソート関数に部分クイックソートアルゴリズムを使用するよう指定します。`PartialQuickSort(k)`は`QuickSort`に似ていますが、`v`を完全にソートした場合に`v[k]`に入る要素だけを見つけてソートすればよい点が異なります。

特徴:

  * *安定ではない*: 比較結果が等しい要素（たとえば、大文字と小文字を区別しない文字のソートにおける「a」と「A」）の順序を保持しません。
  * メモリ上で *インプレース* に処理します。
  * *分割統治法*: [`MergeSort`](@ref)に似たソート戦略です。

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
