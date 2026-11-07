```julia
ttyhastruecolor()
```

現在の端末が24ビットカラーに対応しているかどうかを示す真偽値を返します。

次のいずれかの条件を満たす場合、truecolorに対応していると判定します。

  * 環境変数 `COLORTERM` が `"truecolor"` または `"24bit"` に設定されている
  * 現在のterminfoで [`RGB` capability](https://invisible-island.net/ncurses/man/user_caps.5.html#h3-Recognized-Capabilities)[^1]（または旧式の `Tc` 機能[^2]）フラグが設定されている
  * 現在のterminfoに `setrgbf` と `setrgbb` の文字列[^3]がある
  * Unixシステムで、現在のterminfoの `colors` の値が `256` より大きい
  * VTEのバージョンが3600以上である（環境変数 `VTE_VERSION` から判定）
  * 現在の端末で環境変数 `XTERM_VERSION` が設定されている
  * 環境変数 `TERMINAL_PROGRAM` に基づき、現在の端末がiTermと判断される
  * 環境変数 `TERM` が linuxvt、rxvt、または st に対応している

[^1]: Ncurses 6.1で追加され、`TERM=*-direct` のterminfoで使用されています。

[^2]: 慣例 [added to tmux in 2016](https://github.com/tmux/tmux/commit/427b8204268af5548d09b830e101c59daa095df9)。後に `RGB` に置き換えられました。

[^3]: [Rüdiger Sonderfeld in 2013](https://lists.gnu.org/archive/html/bug-ncurses/2013-10/msg00007.html) による提案で、いくつかの端末エミュレーターに採用されています。

!!! note
    条件の整理が難しいのは、状況そのものが混乱しており、解決の見通しも立っていないためです。`COLORTERM` は広く受け入れられていますが、`ssh` セッションをまたいで渡されるのが `TERM` だけであるため、完全な解決策ではありません。端末が機能を宣言する場所としてはterminfoが当然ですが、ncurses/terminfoが標準機能（`RGB`）を宣言するまでに十分な年月がかかったため、ほかの方式もいくつか定着してしまいました。さらに、公式の `RGB` 機能は256色動作と*互換性がない*ため、端末エコシステムの分断を解消できません。

