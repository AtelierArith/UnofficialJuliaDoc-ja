```julia
Pkg.add(pkg::Union{String, Vector{String}}; preserve=PRESERVE_TIERED, target::Symbol=:deps, prefer_loaded_versions::Bool=Pkg.in_repl_mode())
Pkg.add(pkg::Union{PackageSpec, Vector{PackageSpec}}; preserve=PRESERVE_TIERED, target::Symbol=:deps, prefer_loaded_versions::Bool=Pkg.in_repl_mode())
```

現在のプロジェクトにパッケージを追加します。このパッケージは、Julia REPL で `import` キーワードと `using` キーワードを使って利用できるようになります。また、現在のプロジェクトがパッケージの場合は、そのパッケージ内でも利用できます。

アクティブな環境がパッケージである場合（Project に `name` フィールドと `uuid` フィールドの両方がある場合）、追加したバージョンを下限とする compat エントリが自動的に追加されます。

弱い依存関係として追加するには（`[weakdeps]` フィールド）、キーワード引数 `target=:weakdeps` を設定します。追加の依存関係として追加するには（`[extras]` フィールド）、`target=:extras` を設定します。

## Loaded Version Preference

Pkg REPL モード（`pkg> add`）からパッケージを追加すると、Pkg はデフォルトで、現在の Julia セッションですでに読み込まれているパッケージ（およびその依存関係）のバージョンを優先します。これにより、セッション内ですでに実行中のコードとの互換性を保ちやすくなります。その後、`pkg> up` を実行すると、互換性のある最新バージョンに更新できます。プログラムから `Pkg.add` を呼び出す場合、デフォルトの動作は逆で、再現性を高めるため、現在読み込まれているパッケージとは独立してバージョンが解決されます。デフォルトの動作を変更するには、`prefer_loaded_versions=true`/`false` を渡します。

!!! compat "Julia 1.13"
    `prefer_loaded_versions` キーワード引数を使うには、Julia 1.13 以降が必要です。


## Resolution Tiers

`Pkg` は、段階的なアルゴリズムを使って環境内のパッケージの組み合わせを解決します。`preserve` キーワード引数を使うと、解決アルゴリズムの特定の段階を指定できます。以下の表では、`preserve` に指定できる値を、制約の厳しい順に説明します。

| 値                           | 説明                                                         |
|:--------------------------- |:---------------------------------------------------------- |
| `PRESERVE_ALL_INSTALLED`    | `PRESERVE_ALL` と同様ですが、すでにインストールされているものだけを追加します             |
| `PRESERVE_ALL`              | 既存のすべての依存関係（再帰的な依存関係を含む）の状態を維持します                          |
| `PRESERVE_DIRECT`           | 既存のすべての直接依存関係の状態を維持します                                     |
| `PRESERVE_SEMVER`           | 直接依存関係のうち、semver 互換のバージョンを維持します                            |
| `PRESERVE_NONE`             | バージョン情報の維持を試みません                                           |
| `PRESERVE_TIERED_INSTALLED` | `PRESERVE_TIERED` と同様ですが、先に `PRESERVE_ALL_INSTALLED` を試します |
| `PRESERVE_TIERED`           | バージョン解決を成功させつつ、最も多くのバージョン情報を維持できる段階を使用します（デフォルト）           |
|                             |                                                            |

!!! note
    デフォルトの戦略を `PRESERVE_TIERED_INSTALLED` に変更するには、環境変数 `JULIA_PKG_PRESERVE_TIERED_INSTALLED` を true に設定します。


新しいパッケージをインストールすると、プロジェクトはプリコンパイルされます。詳しくは `pkg> ?precompile` を参照してください。

`PRESERVE_ALL_INSTALLED` 戦略では、追加したパッケージはすでにプリコンパイルされている可能性が高いです。そうでない場合は、この環境で解決されたパッケージのバージョンの組み合わせが、これまで解決・プリコンパイルされていないか、LRU キャッシュストレージによってプリコンパイルキャッシュが削除された可能性があります（`JULIA_MAX_NUM_PRECOMPILE_FILES` を参照）。

!!! compat "Julia 1.9"
    `PRESERVE_TIERED_INSTALLED` 戦略と `PRESERVE_ALL_INSTALLED` 戦略を使うには、Julia 1.9 以降が必要です。


!!! compat "Julia 1.11"
    `target` キーワード引数を使うには、Julia 1.11 以降が必要です。


# Examples

```julia
Pkg.add("Example") # Add a package from registry
Pkg.add("Example", target=:weakdeps) # Add a package as a weak dependency
Pkg.add("Example", target=:extras) # Add a package to the `[extras]` list
Pkg.add("Example"; prefer_loaded_versions=true) # Prefer the version of Example already loaded in this session, if any
Pkg.add("Example"; preserve=Pkg.PRESERVE_ALL) # Add the `Example` package and strictly preserve existing dependencies
Pkg.add(name="Example", version="0.3") # Specify version; latest release in the 0.3 series
Pkg.add(name="Example", version="0.3.1") # Specify version; exact release
Pkg.add(url="https://github.com/JuliaLang/Example.jl", rev="master") # From url to remote gitrepo
Pkg.add(url="/remote/mycompany/juliapackages/OurPackage") # From path to local gitrepo
Pkg.add(url="https://github.com/Company/MonoRepo", subdir="juliapkgs/Package.jl") # With subdir
```

新しいパッケージをインストールすると、プロジェクトはプリコンパイルされます。詳しくは [Environment Precompilation](@ref) を参照してください。

[`PackageSpec`](@ref)、[`Pkg.develop`](@ref) も参照してください。
