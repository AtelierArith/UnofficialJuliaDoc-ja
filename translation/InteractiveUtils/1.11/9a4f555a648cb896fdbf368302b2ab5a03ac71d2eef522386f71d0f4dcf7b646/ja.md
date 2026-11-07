```julia
code_warntype([io::IO], f, types; debuginfo=:default)
```

指定されたジェネリック関数と型シグネチャに一致するメソッドについて、低レベル化された AST と型推論後の AST を `io` に出力します。デフォルトは `stdout` です。AST には、パフォーマンス上の問題につながる可能性がある非具象型が目立つように注釈が付けられます（色を表示できる場合は赤で表示）。これは、型が不安定である可能性を警告するものです。

非具象型がすべてパフォーマンス上の問題になるわけではありません。また、特定の型のパフォーマンス特性は、コンパイラーの実装詳細です。`code_warntype` は、パフォーマンス上の懸念となる可能性がある型を赤で表示する方針を取るため、パフォーマンスに影響しない型も赤で表示されることがあります。具象型の小さなユニオンは通常問題にならないため、黄色で強調表示されます。

キーワード引数 `debuginfo` には、コードコメントの詳細度を指定する `:source`、`:none`、`:default` のいずれかを指定できます。ユーザーが `Base.IRShow.default_debuginfo[]` を変更しない限り、値 `:default` は `:source` と同じです。

詳しくは、マニュアルの「Performance Tips」ページにある [`@code_warntype`](@ref man-code-warntype) セクションを参照してください。

関連項目: [`@code_warntype`](@ref)、[`code_typed`](@ref)、[`code_lowered`](@ref)、[`code_llvm`](@ref)、[`code_native`](@ref)。
