```
maxintfloat(T=Float64)
```

与えられた浮動小数点型 `T`（デフォルトは `Float64`）で正確に表現される最大の連続整数値の浮動小数点数です。

つまり、`maxintfloat` は、`n+1` が型 `T` で*正確に*表現できない最小の正の整数値の浮動小数点数 `n` を返します。

`Integer` 型の値が必要な場合は、`Integer(maxintfloat(T))` を使用してください。
