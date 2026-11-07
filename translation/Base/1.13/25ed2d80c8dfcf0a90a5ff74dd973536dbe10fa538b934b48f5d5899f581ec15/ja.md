```julia
isequal(x, y)::Bool
```

[`==`](@ref)と同様ですが、浮動小数点数と欠損値の扱いが異なります。`isequal`は、すべての浮動小数点数の`NaN`値を互いに等しいものとして扱い、`-0.0`を`0.0`とは等しくないものとして扱い、[`missing`](@ref)を`missing`と等しいものとして扱います。常に`Bool`値を返します。

`isequal`は同値関係です。すなわち、反射的（`===`ならば`isequal`）、対称的（`isequal(a, b)`ならば`isequal(b, a)`）、推移的（`isequal(a, b)`かつ`isequal(b, c)`ならば`isequal(a, c)`）です。

# Implementation

`isequal`のデフォルト実装は`==`を呼び出すため、浮動小数点値を含まない型では、通常`==`を定義するだけで十分です。

`isequal`は、ハッシュテーブル（`Dict`）で使われる比較関数です。`isequal(x,y)`ならば、`hash(x) == hash(y)`でなければなりません。

通常、カスタムの`==`または`isequal`メソッドが定義されている型では、それに対応する[`hash`](@ref)メソッドも実装する必要があります（逆も同様です）。コレクションでは通常、すべての要素に対して再帰的に`isequal`を呼び出すことで、`isequal`を実装します。

さらに、`isequal`は[`isless`](@ref)と連携し、固定された全順序を定義します。このとき、`isequal(x, y)`、`isless(x, y)`、`isless(y, x)`のうち、`true`であるものは必ず1つだけで、残り2つは`false`でなければなりません。

スカラー型では一般に、`isequal`を`==`とは別に実装する必要はありません。ただし、浮動小数点数を表す型で、汎用フォールバック実装（`isnan`、`signbit`、`==`に基づくもの）より効率的な実装が可能な場合は除きます。

# Examples

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
