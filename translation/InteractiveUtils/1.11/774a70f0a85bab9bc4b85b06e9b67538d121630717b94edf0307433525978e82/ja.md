```
@code_typed
```

関数またはマクロ呼び出しの引数を評価し、その型を決定し、結果の式に対して[`code_typed`](@ref)を呼び出します。オプション引数`optimize`を使用して

```
@code_typed optimize=true foo(x)
```

追加の最適化（インライン化など）が適用されるかどうかを制御します。

関連情報: [`code_typed`](@ref), [`@code_warntype`](@ref), [`@code_lowered`](@ref), [`@code_llvm`](@ref), [`@code_native`](@ref).
