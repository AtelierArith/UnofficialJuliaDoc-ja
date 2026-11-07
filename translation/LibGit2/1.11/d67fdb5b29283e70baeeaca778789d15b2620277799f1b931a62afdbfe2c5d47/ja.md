```julia
merge_analysis(repo::GitRepo, anns::Vector{GitAnnotated}) -> analysis, preference
```

注釈付きブランチ先端が指すコミット `anns` を解析し、どのような場合にマージできるかを判定します。たとえば、`anns[1]` が単に `ann[2]` の祖先である場合、`merge_analysis` はファストフォワードマージが可能であると報告します。

出力は `analysis` と `preference` の2つです。`analysis` には、次のいずれかの値を指定できます。     * `MERGE_ANALYSIS_NONE`: `anns` の要素をマージできません。     * `MERGE_ANALYSIS_NORMAL`: 通常のマージです。HEAD と、ユーザーがマージしようとしているコミットが、すべて共通の祖先から分岐しています。この場合、変更を解決する必要があり、競合が発生する可能性があります。     * `MERGE_ANALYSIS_UP_TO_DATE`: ユーザーがマージしようとしている入力コミットはすべて HEAD から到達可能なため、マージは不要です。     * `MERGE_ANALYSIS_FASTFORWARD`: 入力コミットは HEAD の子孫であるため、マージは不要です。代わりに、ユーザーは入力コミットをチェックアウトできます。     * `MERGE_ANALYSIS_UNBORN`: リポジトリの HEAD が存在しないコミットを参照しています。マージはできませんが、入力コミットをチェックアウトできる場合があります。

`preference` にも、次のいずれかの値を指定できます。     * `MERGE_PREFERENCE_NONE`: ユーザーに希望はありません。     * `MERGE_PREFERENCE_NO_FASTFORWARD`: ファストフォワードマージを一切許可しません。     * `MERGE_PREFERENCE_FASTFORWARD_ONLY`: ファストフォワードマージのみを許可し、それ以外の種類のマージ（競合が発生する可能性があるもの）は許可しません。

`preference` は、リポジトリまたはグローバルの Git 設定で制御できます。
