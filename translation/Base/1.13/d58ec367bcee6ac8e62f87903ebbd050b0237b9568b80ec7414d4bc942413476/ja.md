```julia
@static
```

マクロ展開時に式を部分評価します。

これは、OS依存の関数を呼び出す`ccall`など、場合によっては無効になる構文や、インポートされていないパッケージで定義されたマクロを扱う際に便利です。

`@static`には条件式が必要です。条件式は、`if`文、三項演算子、または`&&``||`のいずれかで記述できます。条件式は、マクロを再帰的に展開し、生成された式をloweringして実行することで評価されます。その後、一致する分岐があればそれが返されます。条件式の他の分岐は、マクロ展開（およびloweringや実行）が行われる前に削除されます。

# Example

macOSでのみ有効な式`expr`を解析したいとします。この問題は、`@static`と`@static if Sys.isapple() expr end`を使って解決できます。macOS向けの`expr_apple`と、その他のOS向けの`expr_others`がある場合、`@static`を使った解決方法は`@static Sys.isapple() ? expr_apple : expr_others`となります。
