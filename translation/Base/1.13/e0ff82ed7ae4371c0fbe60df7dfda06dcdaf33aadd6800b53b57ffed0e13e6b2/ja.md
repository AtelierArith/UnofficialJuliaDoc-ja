```julia
Base.@constprop setting [ex]
```

注釈を付けた関数に対する、関数間定数伝播のモードを制御します。

次の2つの`setting`がサポートされています。

  * `Base.@constprop :aggressive [ex]`: 定数伝播を積極的に適用します。戻り値の型が引数の値に依存するメソッドでは、コンパイル時間が増える代わりに、型推論の結果が改善されることがあります。
  * `Base.@constprop :none [ex]`: 定数伝播を無効にします。Juliaが通常なら定数伝播の対象と判断する関数では、コンパイル時間を短縮できる場合があります。よくある例として、`Bool`または`Symbol`の値を取る引数やキーワード引数を持つ関数があります。

`Base.@constprop`は、関数定義の直前または関数本体内に適用できます。

```julia
# annotate long-form definition
Base.@constprop :aggressive function longdef(x)
    ...
end

# annotate short-form definition
Base.@constprop :aggressive shortdef(x) = ...

# annotate anonymous function that a `do` block creates
f() do
    Base.@constprop :aggressive
    ...
end
```

!!! compat "Julia 1.10"
    関数本体内での使用には、Julia 1.10以降が必要です。

