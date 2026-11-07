```julia
create_prompt(events::Channel{Symbol}, term, prefix, terminal_properties)
```

既存の`term`を使って、`events`に紐づくカスタムREPLプロンプトを初期化します。

メインREPLのMIStateにある`terminal_properties`は、履歴検索のMIStateと共有されます。これにより、キーマップが解析したDA1/OSC応答は同じオブジェクトを更新します。

入力処理と表示に使える状態のタプル`(term, prompt, istate, pstate)`を返します。
