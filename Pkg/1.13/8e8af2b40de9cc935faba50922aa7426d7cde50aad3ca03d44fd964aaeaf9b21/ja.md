```julia
Pkg.status([pkgs...]; outdated::Bool=false, mode::PackageMode=PKGMODE_PROJECT, diff::Bool=false,
           compat::Bool=false, extensions::Bool=false, workspace::Bool=false, io::IO=stdout)
```

プロジェクト／マニフェストの状態を表示します。

`⌃` が付いたパッケージには、インストール可能な新しいバージョンがあります。たとえば、[`Pkg.update`](@ref) を使ってインストールできます。`⌅` が付いたパッケージには新しいバージョンがありますが、ほかのパッケージとの互換性の競合によりインストールできません。理由を確認するには、キーワード引数 `outdated=true` を設定してください。`[yanked]` が付いたパッケージは取り下げられたバージョンです。バグやセキュリティ上の脆弱性を含む可能性があるため、更新または置き換えてください。

`outdated=true` を設定すると、最新バージョンではないパッケージと、それぞれの最大バージョン、および最新バージョンを使用できない理由だけが表示されます。理由は、ほかのパッケージが互換性制約によって更新を妨げているか、プロジェクトファイルの互換性制約によるものです。たとえば、次のような状態が表示されたとします。

```julia-repl
julia> Pkg.status(; outdated=true)
Status `Manifest.toml`
⌃ [a8cc5b0e] Crayons v2.0.0 [<v3.0.0], (<v4.0.4)
⌅ [b8a86587] NearestNeighbors v0.4.8 (<v0.4.9) [compat]
⌅ [2ab3a3ac] LogExpFunctions v0.2.5 (<v0.3.0): SpecialFunctions
```

この場合、Crayons の最新バージョンは 4.0.4 ですが、現在のプロジェクトの `[compat]` セクションと互換性のある最新バージョンは 3.0.0 です。NearestNeighbors の最新バージョンは 0.4.9 ですが、プロジェクトの互換性制約により 0.4.8 に制限されています。LogExpFunctions の最新バージョンは 0.3.0 ですが、SpecialFunctions によって 0.2.5 に制限されています。

`mode` が `PKGMODE_PROJECT` の場合、プロジェクトに明示的に追加されたパッケージのみの状態を表示します。`mode` が `PKGMODE_MANIFEST` の場合、マニフェストに記載されたパッケージ（再帰的な依存関係）についても状態を表示します。引数としてパッケージが指定されている場合、出力はそのパッケージに限定されます。

`ext=true` を設定すると、拡張機能を持つ依存関係と、そのうち現在読み込まれている拡張機能の依存関係が表示されます。

`diff=true` を設定すると、環境が Git リポジトリ内にある場合、直近の Git コミットとの差分のみが表示されます。

`workspace=true` を設定すると、ワークスペース内のパッケージの（マージされた）状態が表示されます。

プロジェクト／マニフェストの状態を表示する代わりに Julia オブジェクトとして取得するには、[`Pkg.project`](@ref) および [`Pkg.dependencies`](@ref) を参照してください。

!!! compat "Julia 1.8"
    `⌃` および `⌅` の表示は Julia 1.8 で追加されました。キーワード引数 `outdated` を使用するには、Julia 1.8 以降が必要です。

