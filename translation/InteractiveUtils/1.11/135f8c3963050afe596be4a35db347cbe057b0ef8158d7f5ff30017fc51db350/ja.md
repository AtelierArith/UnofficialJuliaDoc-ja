```julia
@code_typed
```

関数またはマクロ呼び出しの引数を評価して型を判定し、その結果の式に対して[`code_typed`](@ref)を呼び出します。追加の最適化（インライン化など）も適用するかどうかは、オプション引数`optimize`に次の値を指定して制御します。

```julia
@code_typed optimize=true foo(x)
```

関連項目：[`code_typed`](@ref)、[`@code_warntype`](@ref)、[`@code_lowered`](@ref)、[`@code_llvm`](@ref)、[`@code_native`](@ref)。
