```julia
Diagnostic(first_byte, last_byte; [error="msg" | warning="msg"])
```

ソースコードのバイト範囲 first*byte:last*byte を示す診断メッセージと、`warning` または `error` のメッセージ。

メッセージは簡潔で事実に即したものとし、装飾を加えないでください。

  * 簡潔に：「説明するより、見せる」。可能であれば、バイト範囲を使って元のソースコードに注釈を付け、何が問題なのかをユーザーに示しましょう。
  * 事実に即して：ユーザーをたしなめても役には立ちません。中立的な口調で、何が問題なのかを穏やかに示しましょう。
  * 装飾：大文字・小文字、句読点、診断の種類（「error」／「warning」）は省略してください。これらの装飾はフォーマット用コードで追加されます。

TODO: いずれ、より適切な注釈を付けられるよう、Diagnostic が複数のサブ範囲を扱えるようにしたいと思います。Rust が示す優れた先例に倣いましょう：[rustc_errors::Diagnostic](https://doc.rust-lang.org/stable/nightly-rustc/rustc_errors/struct.Diagnostic.html)。

TODO: 詳細情報を参照するための診断コードを使って、複数の文からなる拡張説明に対応したいと思います。この点でも、Rust は優れた手本です。
