```julia
LOAD_PATH
```

コードの読み込み時に、プロジェクト環境またはパッケージディレクトリとして扱う `using` 文と `import` 文のパスを格納する配列です。[`JULIA_LOAD_PATH`](@ref JULIA_LOAD_PATH) 環境変数が設定されている場合はその値に基づいて設定され、設定されていない場合は `["@", "@v#.#", "@stdlib"]` が既定値になります。`@` で始まるエントリには、次の特別な意味があります。

  * `@` は「現在アクティブな環境」を指します。その初期値は、[`JULIA_PROJECT`](@ref JULIA_PROJECT) 環境変数または `--project` コマンドラインオプションによって決まります。
  * `@stdlib` は、現在の Julia インストールにおける標準ライブラリディレクトリの絶対パスに展開されます。
  * `@name` は名前付き環境を指します。名前付き環境はデポ（[`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH) を参照）の `environments` サブディレクトリに保存されます。ユーザーの名前付き環境は `~/.julia/environments` に保存されるため、`@name` は、`~/.julia/environments/name` に存在し、`Project.toml` ファイルを含む環境を指します。`name` に `#` 文字が含まれている場合、その文字は Julia のバージョン番号のメジャー、マイナー、パッチの各要素に置き換えられます。たとえば、Julia 1.2 を実行している場合、`@v#.#` は `@v1.2` に展開され、その名前の環境が検索されます。通常は `~/.julia/environments/v1.2` にあります。

プロジェクトやパッケージの検索に使われる `LOAD_PATH` の展開後の値は、`Base.load_path()` 関数を呼び出すと確認できます。

[`JULIA_LOAD_PATH`](@ref JULIA_LOAD_PATH)、[`JULIA_PROJECT`](@ref JULIA_PROJECT)、[`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH)、[Code Loading](@ref code-loading) も参照してください。
