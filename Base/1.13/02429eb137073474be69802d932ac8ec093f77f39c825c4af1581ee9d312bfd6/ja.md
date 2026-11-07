```julia
TwicePrecision{T}(hi::T, lo::T)
TwicePrecision{T}((num, denom))
```

`T`の2倍の精度を持つ数値です。たとえば、`T = Float64`の場合は4倍精度になります。

!!! warning
    `TwicePrecision`は、浮動小数点範囲の精度を高めるために使われる内部型であり、外部からの使用を想定していません。実際のコードでこれらを見かけた場合、範囲のフィールドに直接アクセスしている可能性が最も高いです。代わりに、関数インターフェースを使用してください。つまり、`r.step`ではなく`step(r)`を使用します。


# Extended help

`hi`は上位ビット（最上位ビット）を、`lo`は下位ビット（最下位ビット）を表します。有理数値`num//denom`は、`TwicePrecision{T}((num, denom))`という構文を使って簡単に近似できます。

`T<:Union{Float16,Float32,Float64}`を使って「正確な」`StepRangeLen`を構築する場合、`ref`には範囲内で絶対値が最小の要素を指定し、`offset`には対応するインデックスを設定してください。効率上、`step`とインデックスの乗算は2倍精度では行われません。そのため、`step.hi`の`bits`表現には、`(0:len-1)*step.hi`が正確（丸め誤差がない）になるだけの末尾のゼロが必要です。`step`を有理数として正確に表現できる`num//denom`がある場合は、次のようにして`step`を構築できます。

```julia
step = TwicePrecision{T}((num, denom), nb)
```

ここで、`nb`は`step.hi`の末尾にあるゼロビットの数です。範囲の場合は、`nb = ceil(Int, log2(len-1))`を設定できます。
