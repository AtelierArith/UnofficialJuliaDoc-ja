```
isequal(x, y) -> Bool
```

`==`[@ref]と似ていますが、浮動小数点数と欠損値の扱いが異なります。`isequal`はすべての浮動小数点`NaN`値を互いに等しいと見なし、`-0.0`を`0.0`とは異なるものと見なし、[`missing`](@ref)を`missing`と等しいと見なします。常に`Bool`値を返します。

`isequal`は同値関係です - それは反射的（`===`は`isequal`を含意）、対称的（`isequal(a, b)`は`isequal(b, a)`を含意）、および推移的（`isequal(a, b)`および`isequal(b, c)`は`isequal(a, c)`を含意）です。

# 実装

`isequal`のデフォルト実装は`==`を呼び出すため、浮動小数点値を含まない型は一般的に`==`を定義するだけで済みます。

`isequal`はハッシュテーブル（`Dict`）で使用される比較関数です。`isequal(x,y)`は`hash(x) == hash(y)`を含意しなければなりません。

これは通常、カスタム`==`または`isequal`メソッドが存在する型は、対応する[`hash`](@ref)メソッドを実装しなければならないことを意味します（その逆も同様です）。コレクションは通常、すべての内容に対して再帰的に`isequal`を呼び出すことで`isequal`を実装します。

さらに、`isequal`は[`isless`](@ref)と関連しており、これらは一緒に固定された全順序を定義します。ここで、`isequal(x, y)`、`isless(x, y)`、または`isless(y, x)`のうちの正確に1つが`true`でなければならず（他の2つは`false`）、成り立ちます。

スカラー型は一般的に、浮動小数点数を表す場合を除いて、`==`とは別に`isequal`を実装する必要はありません。これは、`isnan`、`signbit`、および`==`に基づいて提供される一般的なフォールバックよりも効率的な実装が可能な場合です。

# 例

```jldoctest
julia> isequal([1., NaN], [1., NaN])
true

julia> [1., NaN] == [1., NaN]
false

julia> 0.0 == -0.0
true

julia> isequal(0.0, -0.0)
false

julia> missing == missing
missing

julia> isequal(missing, missing)
true
```
