```julia
PartialQuickSort{T <: Union{Integer,OrdinalRange}}
```

ソート関数が部分クイックソートアルゴリズムを使用する必要があることを示します。`PartialQuickSort(k)`は`QuickSort`のようなもので、`v`が完全にソートされていた場合に`v[k]`に配置される要素を見つけてソートすることだけが求められます。

特徴:

  * *安定ではない*: 同じ値を比較した場合の要素の順序を保持しません（例: 大文字と小文字を無視した文字のソートにおける "a" と "A"）。
  * *メモリ内での*。
  * *分割統治法*: [`MergeSort`](@ref)に似たソート戦略。

`PartialQuickSort(k)`は必ずしも配列全体をソートするわけではないことに注意してください。例えば、

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
