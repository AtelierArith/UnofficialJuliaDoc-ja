```
setrounding(T, mode)
```

浮動小数点型 `T` の丸めモードを設定し、基本的な算術関数（[`+`](@ref), [`-`](@ref), [`*`](@ref), [`/`](@ref) および [`sqrt`](@ref)）と型変換の丸めを制御します。デフォルトの [`RoundNearest`](@ref) 以外の丸めモードを使用すると、他の数値関数が不正確または無効な値を返す可能性があります。

現在、これは `T == BigFloat` の場合にのみサポートされています。

!!! warning
    この関数はスレッドセーフではありません。すべてのスレッドで実行されるコードに影響を与えますが、設定を使用する計算と同時に呼び出された場合、その動作は未定義です。

