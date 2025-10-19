```julia
as
```

`as` は、名前の衝突を回避するためや名前を短縮するために、`import` または `using` によってスコープに持ち込まれた識別子の名前を変更するためのキーワードとして使用されます。 (`import` または `using` ステートメントの外では、`as` はキーワードではなく、通常の識別子として使用できます。)

`import LinearAlgebra as LA` は、インポートされた `LinearAlgebra` 標準ライブラリを `LA` としてスコープに持ち込みます。

`import LinearAlgebra: eigen as eig, cholesky as chol` は、`LinearAlgebra` から `eigen` および `cholesky` メソッドをそれぞれ `eig` と `chol` としてスコープに持ち込みます。

`as` は、個々の識別子がスコープに持ち込まれる場合にのみ `using` と一緒に機能します。たとえば、`using LinearAlgebra: eigen as eig` または `using LinearAlgebra: eigen as eig, cholesky as chol` は機能しますが、`using LinearAlgebra as LA` は無効な構文です。なぜなら、`LinearAlgebra` からエクスポートされた *すべての* 名前を `LA` に変更することは意味がないからです。
