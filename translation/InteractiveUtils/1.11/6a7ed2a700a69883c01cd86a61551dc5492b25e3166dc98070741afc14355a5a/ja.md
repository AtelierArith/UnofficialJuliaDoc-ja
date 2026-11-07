```julia
@code_llvm
```

関数またはマクロ呼び出しの引数を評価して型を判定し、その結果の式に対して [`code_llvm`](@ref) を呼び出します。省略可能なキーワード引数 `raw`、`dump_module`、`debuginfo`、`optimize` は、次のように関数呼び出しの前に値とともに指定します。

```julia
@code_llvm raw=true dump_module=true debuginfo=:default f(x)
@code_llvm optimize=false f(x)
```

`optimize` は、インライン化などの追加の最適化も適用するかどうかを制御します。`raw` を指定すると、すべてのメタデータと dbg.* 呼び出しが表示されます。`debuginfo` には `:source`（デフォルト）または `:none` を指定でき、コードコメントの詳細度を設定します。`dump_module` は、関数を含むモジュール全体を出力します。

関連項目: [`code_llvm`](@ref)、[`@code_warntype`](@ref)、[`@code_typed`](@ref)、[`@code_lowered`](@ref)、[`@code_native`](@ref)。
