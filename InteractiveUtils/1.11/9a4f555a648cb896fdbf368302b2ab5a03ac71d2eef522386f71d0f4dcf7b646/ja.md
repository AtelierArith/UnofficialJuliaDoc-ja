```julia
code_warntype([io::IO], f, types; debuginfo=:default)
```

指定されたジェネリック関数と型シグネチャに一致するメソッドについて、低レベル化されたASTと型推論後のASTを、`io`（デフォルトは`stdout`）に出力します。ASTには、パフォーマンス上問題となる可能性のある非具象型が目立つように注釈が付けられます（色を表示できる場合は赤色）。これにより、型が不安定である可能性を警告します。

非具象型がすべてパフォーマンス上の問題になるわけではありません。また、特定の型のパフォーマンス特性は、コンパイラの実装詳細です。`code_warntype`は、パフォーマンス上の懸念となる可能性があれば型を赤色で表示する方針を取るため、実際にはパフォーマンスに影響しない型も赤色で表示されることがあります。具象型の小さなユニオンは通常問題にならないため、黄色で強調表示されます。

キーワード引数`debuginfo`には、コードコメントの詳細度を指定する`:source`、`:none`、`:default`のいずれかを指定できます。ユーザーが`Base.IRShow.default_debuginfo[]`を変更しない限り、`:default`は`:source`と同じです。

詳しくは、マニュアルの「パフォーマンスのヒント」ページにある[`@code_warntype`](@ref man-code-warntype)のセクションを参照してください。

関連項目：[`@code_warntype`](@ref)、[`code_typed`](@ref)、[`code_lowered`](@ref)、[`code_llvm`](@ref)、[`code_native`](@ref)。
