```
Pkg.add(pkg::Union{String, Vector{String}}; preserve=PRESERVE_TIERED, target::Symbol=:deps)
Pkg.add(pkg::Union{PackageSpec, Vector{PackageSpec}}; preserve=PRESERVE_TIERED, target::Symbol=:deps)
```

現在のプロジェクトにパッケージを追加します。このパッケージは、Julia REPLで`import`および`using`キーワードを使用することで利用可能になり、現在のプロジェクトがパッケージである場合、そのパッケージ内でも利用可能です。

アクティブな環境がパッケージである場合（プロジェクトに`name`および`uuid`フィールドが両方とも存在する場合）、追加されたバージョンの下限を持つ互換性エントリが自動的に追加されます。

弱依存関係として追加するには（`[weakdeps]`フィールドに）、キーワード引数`target=:weakdeps`を設定します。追加の依存関係として追加するには（`[extras]`フィールドに）、`target=:extras`を設定します。

## 解決ティア

`Pkg`は、ティアードアルゴリズムを使用して環境内のパッケージのセットを解決します。`preserve`キーワード引数を使用すると、解決アルゴリズムの特定のティアにキーを設定できます。以下の表は、`preserve`の引数値を厳しさの順に説明しています：

| 値                           | 説明                                                         |
|:--------------------------- |:---------------------------------------------------------- |
| `PRESERVE_ALL_INSTALLED`    | `PRESERVE_ALL`のように、すでにインストールされているものだけを追加します                |
| `PRESERVE_ALL`              | すべての既存の依存関係の状態を保持します（再帰的依存関係を含む）                           |
| `PRESERVE_DIRECT`           | すべての既存の直接依存関係の状態を保持します                                     |
| `PRESERVE_SEMVER`           | 直接依存関係のセマンティックバージョン互換のバージョンを保持します                          |
| `PRESERVE_NONE`             | バージョン情報を保持しようとしません                                         |
| `PRESERVE_TIERED_INSTALLED` | `PRESERVE_TIERED`のように、ただし最初に`PRESERVE_ALL_INSTALLED`が試されます |
| `PRESERVE_TIERED`           | 最も多くのバージョン情報を保持しながら、バージョン解決が成功するティアを使用します（これがデフォルトです）      |

!!! note
    デフォルトの戦略を`PRESERVE_TIERED_INSTALLED`に変更するには、環境変数`JULIA_PKG_PRESERVE_TIERED_INSTALLED`をtrueに設定します。


新しいパッケージのインストール後、プロジェクトはプリコンパイルされます。詳細については`pkg> ?precompile`を参照してください。

`PRESERVE_ALL_INSTALLED`戦略では、新しく追加されたパッケージはすでにプリコンパイルされている可能性が高いですが、そうでない場合は、これはこの環境で解決されてプリコンパイルされたパッケージバージョンの組み合わせがまだ解決されていないか、プリコンパイルキャッシュがLRUキャッシュストレージによって削除されたためです（`JULIA_MAX_NUM_PRECOMPILE_FILES`を参照）。

!!! compat "Julia 1.9"
    `PRESERVE_TIERED_INSTALLED`および`PRESERVE_ALL_INSTALLED`戦略は、少なくともJulia 1.9が必要です。


!!! compat "Julia 1.11"
    `target`キーワード引数は、少なくともJulia 1.11が必要です。


# 例

```julia
Pkg.add("Example") # レジストリからパッケージを追加
Pkg.add("Example", target=:weakdeps) # 弱依存関係としてパッケージを追加
Pkg.add("Example", target=:extras) # `[extras]`リストにパッケージを追加
Pkg.add("Example"; preserve=Pkg.PRESERVE_ALL) # `Example`パッケージを追加し、既存の依存関係を厳密に保持
Pkg.add(name="Example", version="0.3") # バージョンを指定；0.3シリーズの最新リリース
Pkg.add(name="Example", version="0.3.1") # バージョンを指定；正確なリリース
Pkg.add(url="https://github.com/JuliaLang/Example.jl", rev="master") # リモートgitリポジトリからのURL
Pkg.add(url="/remote/mycompany/juliapackages/OurPackage") # ローカルgitリポジトリへのパス
Pkg.add(url="https://github.com/Company/MonoRepo", subdir="juliapkgs/Package.jl)") # サブディレクトリ付き
```

新しいパッケージのインストール後、プロジェクトはプリコンパイルされます。詳細は[環境のプリコンパイル](@ref)を参照してください。

また、[`PackageSpec`](@ref)、[`Pkg.develop`](@ref)も参照してください。
