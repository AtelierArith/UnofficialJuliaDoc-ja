```
Pkg.status([pkgs...]; outdated::Bool=false, mode::PackageMode=PKGMODE_PROJECT, diff::Bool=false, compat::Bool=false, extensions::Bool=false, io::IO=stdout)
```

プロジェクト/マニフェストのステータスを出力します。

`⌃`でマークされたパッケージは、新しいバージョンがインストール可能であり、例えば[`Pkg.update`](@ref)を通じてインストールできます。`⌅`でマークされたパッケージは、新しいバージョンが利用可能ですが、他のパッケージとの互換性の衝突によりインストールできません。その理由を確認するには、キーワード引数`outdated=true`を設定してください。

`outdated=true`を設定すると、最新バージョンでないパッケージ、その最大バージョン、および最新バージョンでない理由（他のパッケージが互換性の制約によりそれらを保持しているか、プロジェクトファイル内の互換性による）だけが表示されます。例として、次のようなステータス出力が得られます：

```
pkg> Pkg.status(; outdated=true)
Status `Manifest.toml`
⌃ [a8cc5b0e] Crayons v2.0.0 [<v3.0.0], (<v4.0.4)
⌅ [b8a86587] NearestNeighbors v0.4.8 (<v0.4.9) [compat]
⌅ [2ab3a3ac] LogExpFunctions v0.2.5 (<v0.3.0): SpecialFunctions
```

これは、Crayonsの最新バージョンが4.0.4であるが、現在のプロジェクトの`[compat]`セクションで互換性のある最新バージョンは3.0.0であることを意味します。NearestNeighborsの最新バージョンは0.4.9ですが、プロジェクト内の互換性制約により0.4.8に制限されています。LogExpFunctionsの最新バージョンは0.3.0ですが、SpecialFunctionsがそれを0.2.5に制限しています。

`mode`が`PKGMODE_PROJECT`の場合、プロジェクトに含まれるパッケージ（明示的に追加されたもの）についてのみステータスを出力します。`mode`が`PKGMODE_MANIFEST`の場合、マニフェストに含まれるパッケージ（再帰的依存関係）についてもステータスを出力します。引数としてリストされたパッケージがある場合、出力はそれらのパッケージに制限されます。

`ext=true`を設定すると、現在ロードされている拡張機能の依存関係と、それらの依存関係が表示されます。

`diff=true`を設定すると、環境がgitリポジトリ内にある場合、出力は最後のgitコミットと比較した差分に制限されます。

[`Pkg.project`](@ref)および[`Pkg.dependencies`](@ref)を参照して、プロジェクト/マニフェストのステータスを印刷するのではなく、Juliaオブジェクトとして取得します。

!!! compat "Julia 1.8"
    `⌃`および`⌅`インジケーターはJulia 1.8で追加されました。`outdated`キーワード引数は少なくともJulia 1.8が必要です。

