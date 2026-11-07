```julia
newindex(argument, I)
newindex(I, keep, default)
```

ブロードキャストされた次元がソースに適切に制約されるよう、インデックス `I` を再計算します。

2つの方法がサポートされており、どちらも `I` に [`CartesianIndex`](@ref) または `Int` を指定できます。

  * `newindex(argument, I)` は、`argument` の軸に基づいて `I` を動的に制約します。
  * `newindex(I, keep, default)` は、事前計算されたタプル `keeps` と `defaults` を使って `I` を制約します。

      * `keep` は `Bool` のタプルです。`keep[d] == true` は、`I` の次元 `d` をそのまま保持することを意味します。
      * `default` は整数のタプルで、`keep[d] == false` の場合に、次元 `d` で使用するインデックスを指定します。

    `I` に含まれるインデックスのうち、`keep` タプルの長さを超える分は切り捨てられます。`keep` タプルと `default` タプルは、`newindexer(argument)` で作成できます。
