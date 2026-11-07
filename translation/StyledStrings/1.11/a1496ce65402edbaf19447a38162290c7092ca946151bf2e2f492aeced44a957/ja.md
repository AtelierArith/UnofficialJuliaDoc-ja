```julia
foreignface(face) -> Face
```

別の StyledStrings のコピーから `face`（`Face`）を再構築し、自分たちのコピーのものにします。

StyledStrings は複数のコピーを同時に読み込めます。REPL は標準ライブラリのプライベートなコピー上で動作しますが、これはユーザーコードが読み込むコピーとは限りません（`Base.require_stdlib` を参照）。また、有効になるのは最後に読み込まれたコピーの `Base.AnnotatedDisplay` フックだけです。REPL が出力に付加する `Face`（たとえば、括弧の強調表示）は、最終的に `getface` に到達します。その値は、こちらの `Face` 型ではありませんが、同じフィールドを持ち、Base 型の値、または別のコピーの `SimpleColor` を保持しています。
