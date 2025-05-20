```
@code_llvm
```

関数またはマクロ呼び出しの引数を評価し、その型を決定し、結果の式に対して[`code_llvm`](@ref)を呼び出します。オプションのキーワード引数`raw`、`dump_module`、`debuginfo`、`optimize`を関数呼び出しの前に配置して設定します。例えば、次のようにします：

```
@code_llvm raw=true dump_module=true debuginfo=:default f(x)
@code_llvm optimize=false f(x)
```

`optimize`は、インライン化などの追加の最適化が適用されるかどうかを制御します。`raw`はすべてのメタデータとdbg.*呼び出しを表示可能にします。`debuginfo`は、コードコメントの冗長性を指定するために`:source`（デフォルト）または`:none`のいずれかである必要があります。`dump_module`は、関数をカプセル化する全体のモジュールを印刷します。

関連情報: [`code_llvm`](@ref)、[`@code_warntype`](@ref)、[`@code_typed`](@ref)、[`@code_lowered`](@ref)、[`@code_native`](@ref)。
