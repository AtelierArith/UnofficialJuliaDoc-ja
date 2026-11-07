```julia
foreignface(face) -> Face
```

別の StyledStrings のコピーから `face`（`Face`）を再構築し、自分たちのコピーのものにします。

StyledStrings は複数のコピーを同時に読み込めます。REPL は標準ライブラリのプライベートなコピー上で動作しますが、これはユーザーコードが読み込むコピーとは限りません（`Base.require_stdlib` を参照）。また、最後に読み込まれたコピーの `Base.AnnotatedDisplay` フックだけが有効です。REPL が出力に付加する `Face`（たとえば、括弧のハイライト）は、`getface` に到達した時点で、自分たちの `Face` 型ではない値になっています。ただし、フィールドは同じで、Base 型の値、またはもう一方のコピーの `SimpleColor` を保持しています。
