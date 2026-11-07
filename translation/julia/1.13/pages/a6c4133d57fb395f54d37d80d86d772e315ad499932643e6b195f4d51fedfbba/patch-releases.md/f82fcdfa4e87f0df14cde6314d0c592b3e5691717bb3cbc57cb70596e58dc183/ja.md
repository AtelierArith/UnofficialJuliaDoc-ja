# Contributing to patch releases

[creating a patch release](https://docs.julialang.org/en/v1/devdocs/build/distributing/#Point-releasing-101)のプロセスは、おおむね次のとおりです。

1. 対象となるマイナーリリースブランチ（例：`release-1.10`）をベースに、新しいブランチ（例：`backports-release-1.10`）を作成します。通常は、対応するプルリクエストも作成します。
2. 主に`master`からコミットをそのブランチに追加します（そのため「バックポート」と呼ばれます）。この作業の詳細は以下を参照してください。
3. そのブランチに対して、[BaseBenchmarks.jl](https://github.com/JuliaCI/BaseBenchmarks.jl)ベンチマークスイートと[PkgEval.jl](https://github.com/JuliaCI/PkgEval.jl)パッケージエコシステムのテストツールを実行します。通常、BaseBenchmarks.jlとPkgEval.jlは、バックポートブランチに関連付けられたプルリクエストから[Nanosoldier.jl](https://github.com/JuliaCI/Nanosoldier.jl)経由で実行します。問題があれば修正します。
4. すべてのテストとベンチマークの結果に問題がないことを確認したら、バックポートブランチを対応するリリースブランチにマージします（例：`backports-release-1.10`を`release-1.10`にマージ）。
5. 対象のマイナーリリースのバージョンを次のパッチバージョンに上げるプルリクエストを作成します。例：[this pull request](https://github.com/JuliaLang/julia/pull/37718)。
6. `@JuliaLang/releases`に連絡し、パッチリリースのタグ付けとウェブサイトの更新を依頼します。
7. 対象のマイナーリリースのバージョンを次のプレリリースパッチバージョンに上げるプルリクエストを作成します。例：[this pull request](https://github.com/JuliaLang/julia/pull/37724)。

上記の手順2、つまりコミットを`backports-release-X.Y`ブランチにバックポートする作業は、[`Backporter`](https://github.com/KristofferC/Backporter)によって大部分が自動化されています。Backporterは、該当する`backport-X.Y`タグが付いたマージ済みのプルリクエストを検索し、そのコミットを`backports-release-X.Y`ブランチにチェリーピックしようとします。介入なしで適用できるコミットもあれば、そうでないものもあります。後者は「手動」でのバックポートが必要となるため、協力していただけると大変助かります。Backporterは、自動でバックポートできたコミットと手動でのバックポートが必要なコミットを示すレポートを生成します。このレポートは通常、`backports-release-X.Y`に関連付けられたプルリクエストの最初の投稿にコピーされ、自動または手動でコミットがバックポートされるたびに更新されます。

手動でバックポートする場合、必要な権限があれば、バックポートを`backports-release-X.Y`ブランチに直接プッシュしてください。必要な権限がない場合は、手動バックポートを含むプルリクエストを`backports-release-X.Y`ブランチに対して作成してください。手動バックポートが`backports-release-X.Y`ブランチに反映されたら、対象コミットの元のプルリクエストから`backport-X.Y`タグを削除してください。
