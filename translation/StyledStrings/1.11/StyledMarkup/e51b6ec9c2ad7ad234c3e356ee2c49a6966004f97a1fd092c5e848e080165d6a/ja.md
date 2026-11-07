```julia
read_annotation!(state::State, i::Int, char::Char, newstyles::Vector) -> Bool
```

`i`（`char`）の注釈を読み取り、読み取ったスタイルを`newstyles`にプッシュします。

空白を読み飛ばし、`state.s`の次の文字を確認して注釈の形式を判定し、次のように適切な専用関数を使って解析します。

  * `:`（注釈の終端）の場合は何もしません
  * `(`（インラインのフェイス宣言）の場合は`read_inlineface!`を使います
  * それ以外の場合は`read_face_or_keyval!`を使います

注釈を解析した後、直後に読み取る注釈があるかどうかを示す真偽値を返します。
