```julia
Diagnostic(first_byte, last_byte; [error="msg" | warning="msg"])
```

`warning` または `error` のメッセージを含む、ソースコードのバイト範囲 first*byte:last*byte を示す診断メッセージ。

メッセージは簡潔で事実に即したものとし、装飾を含めないでください。

  * 簡潔に：「説明するより、見せる」。可能であれば、バイト範囲を使って元のソースコードに注釈を付け、何が問題なのかをユーザーに示しましょう。
  * 事実に即して：ユーザーをたしなめても役には立ちません。中立的な表現で、何が問題なのかを穏やかに示しましょう。
  * 装飾：大文字・小文字、句読点、診断の種類（「error」／「warning」）は省略してください。これらの装飾はフォーマット処理で追加されます。

TODO: より適切な注釈を付けられるよう、将来的には Diagnostic が複数のサブ範囲を扱えるようにしたいところです。Rust の [rustc_errors::Diagnostic](https://doc.rust-lang.org/stable/nightly-rustc/rustc_errors/struct.Diagnostic.html) が示す優れた先例に倣いましょう。

TODO: 診断コードを使って詳細情報を参照できるようにし、複数の文からなる拡張説明にも対応したいところです。この点でも、Rust は優れた先例です。
