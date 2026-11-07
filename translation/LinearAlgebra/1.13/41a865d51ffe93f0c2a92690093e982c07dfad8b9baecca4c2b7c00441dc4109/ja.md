```julia
@stable_muladdmul
```

引数に`MulAddMul(alpha, beta)`コンストラクターを含む関数呼び出しを、`isone(alpha)`と`iszero(beta)`の取り得る値に応じた分岐に置き換え、各分岐で`MulAddMul{isone(alpha), iszero(beta)}`を明示的に構築します。たとえば、'f(x, y, MulAddMul(alpha, beta))`は次のように変換されます。

```julia
if isone(alpha)
    if iszero(beta)
        f(x, y, MulAddMul{true, true, typeof(alpha), typeof(beta)}(alpha, beta))
    else
        f(x, y, MulAddMul{true, false, typeof(alpha), typeof(beta)}(alpha, beta))
    end
else
    if iszero(beta)
        f(x, y, MulAddMul{false, true, typeof(alpha), typeof(beta)}(alpha, beta))
    else
        f(x, y, MulAddMul{false, false, typeof(alpha), typeof(beta)}(alpha, beta))
    end
end
```

これにより、`MulAddMul(alpha, beta)`コンストラクターによる型不安定性を回避できます。この型不安定性は、alphaとzeroが定数でない場合に実行時ディスパッチを引き起こします。
