```julia
read_annotation!(state::State, i::Int, char::Char, newstyles::Vector) -> Bool
```

`i`（`char`）の注釈を読み取り、読み取ったスタイルを`newstyles`にプッシュします。

空白を読み飛ばし、`state.s`の次の文字を確認して注釈の形式を判定し、次のように適切な専用関数を使って解析します。

  * `:`：注釈の終端。何もしない
  * `(`：インラインのフェイス宣言。`read_inlineface!`を使う
  * それ以外：`read_face_or_keyval!`を使う

注釈の解析後、直後に読み取る注釈があるかどうかを示すブール値を返します。
