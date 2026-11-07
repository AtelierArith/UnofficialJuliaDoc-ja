```julia
code_lowered(f, types; generated=true, debuginfo=:default)
```

指定されたジェネリック関数と型シグネチャに一致するメソッドについて、lowered form（IR）の配列を返します。

`generated` が `false` の場合、返される `CodeInfo` インスタンスはフォールバック実装に対応します。フォールバック実装が存在しない場合はエラーがスローされます。`generated` が `true` の場合、これらの `CodeInfo` インスタンスは、ジェネレーターを展開して得られるメソッド本体に対応します。

キーワード `debuginfo` は、出力に含まれるコードメタデータの量を制御します。

`generated` が `true` であり、対応するメソッドのいずれかが `@generated` メソッドである場合、`types` が具象型でなければエラーがスローされることに注意してください。
