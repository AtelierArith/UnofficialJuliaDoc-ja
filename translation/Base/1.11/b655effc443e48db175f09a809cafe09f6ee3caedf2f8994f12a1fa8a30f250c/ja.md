```
LOAD_PATH
```

`using` および `import` ステートメントのためのパスの配列で、コードを読み込む際にプロジェクト環境またはパッケージディレクトリとして考慮されます。これは、設定されている場合は [`JULIA_LOAD_PATH`](@ref JULIA_LOAD_PATH) 環境変数に基づいて populated されます。そうでない場合は、デフォルトで `["@", "@v#.#", "@stdlib"]` になります。`@` で始まるエントリには特別な意味があります：

  * `@` は「現在のアクティブ環境」を指し、その初期値は最初に [`JULIA_PROJECT`](@ref JULIA_PROJECT) 環境変数または `--project` コマンドラインオプションによって決定されます。
  * `@stdlib` は、現在の Julia インストールの標準ライブラリディレクトリの絶対パスに展開されます。
  * `@name` は名前付き環境を指し、これは `environments` サブディレクトリの下にあるデポに保存されます（[`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH) を参照）。ユーザーの名前付き環境は `~/.julia/environments` に保存されるため、`@name` は `~/.julia/environments/name` に環境が存在し、`Project.toml` ファイルが含まれている場合、その環境を指します。`name` に `#` 文字が含まれている場合、それは Julia バージョン番号のメジャー、マイナー、パッチコンポーネントに置き換えられます。たとえば、Julia 1.2 を実行している場合、`@v#.#` は `@v1.2` に展開され、その名前の環境を探します。通常は `~/.julia/environments/v1.2` にあります。

プロジェクトやパッケージを検索するために完全に展開された `LOAD_PATH` の値は、`Base.load_path()` 関数を呼び出すことで確認できます。

他にも [`JULIA_LOAD_PATH`](@ref JULIA_LOAD_PATH)、[`JULIA_PROJECT`](@ref JULIA_PROJECT)、[`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH)、および [Code Loading](@ref code-loading) を参照してください。
