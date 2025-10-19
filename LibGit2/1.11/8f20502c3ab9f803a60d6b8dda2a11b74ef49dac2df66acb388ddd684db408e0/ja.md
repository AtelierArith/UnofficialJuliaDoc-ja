```julia
merge_analysis(repo::GitRepo, anns::Vector{GitAnnotated}) -> analysis, preference
```

注釈付きブランチの先端 `anns` が指すブランチで分析を実行し、それらがどのような状況でマージできるかを判断します。たとえば、`anns[1]` が単に `anns[2]` の祖先である場合、`merge_analysis` はファストフォワードマージが可能であると報告します。

2つの出力、`analysis` と `preference` を返します。`analysis` にはいくつかの可能な値があります：  

  * `MERGE_ANALYSIS_NONE`: `anns` の要素をマージすることはできません。
  * `MERGE_ANALYSIS_NORMAL`: HEAD とユーザーがマージしたいコミットがすべて共通の祖先から分岐している通常のマージ。この場合、変更を解決する必要があり、競合が発生する可能性があります。
  * `MERGE_ANALYSIS_UP_TO_DATE`: ユーザーがマージしたいすべての入力コミットは HEAD から到達可能であるため、マージを行う必要はありません。
  * `MERGE_ANALYSIS_FASTFORWARD`: 入力コミットは HEAD の子孫であるため、マージを行う必要はありません - 代わりに、ユーザーは単に入力コミットをチェックアウトできます。
  * `MERGE_ANALYSIS_UNBORN`: リポジトリの HEAD が存在しないコミットを指しています。マージは不可能ですが、入力コミットをチェックアウトすることは可能かもしれません。

`preference` にはいくつかの可能な値があります：  

  * `MERGE_PREFERENCE_NONE`: ユーザーに好みはありません。
  * `MERGE_PREFERENCE_NO_FASTFORWARD`: ファストフォワードマージを許可しません。
  * `MERGE_PREFERENCE_FASTFORWARD_ONLY`: ファストフォワードマージのみを許可し、他のタイプ（競合を引き起こす可能性がある）を許可しません。

`preference` はリポジトリまたはグローバルな git 設定を通じて制御できます。
