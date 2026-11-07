```julia
Pkg.activate([s::String]; shared::Bool=false, io::IO=stderr)
Pkg.activate(; temp::Bool=false, shared::Bool=false, io::IO=stderr)
```

`s` で環境を有効化します。引数が指定されていない場合は、デフォルト環境に戻ります。有効な環境は、パッケージコマンドの実行による変更が適用される環境です。環境の有効化は現在の Julia セッションにのみ影響し、Julia を再起動すると引き継がれません（`--project` 起動フラグを使用する場合を除きます）。

# Returning to the default environment

`activate` に引数を指定しないと、デフォルトの共有環境（通常は `~/.julia/environments/v#.#/` 内の `@v#.#`）に戻ります。これは、プロジェクト環境を「無効化」して、ベースとなるパッケージ設定に戻る標準的な方法です。`deactivate` という独立したコマンドはありません。引数なしの `Pkg.activate()` がその役割を果たします。

# Activating a path

`s` が指定された場合、有効化するパスは次のように決まります。

  * `shared` が `true` の場合、デポスタック内の各デポから、`s` という名前の環境を探し、最初に見つかったものを有効化します。そのような環境が見つからない場合は、最初のデポに環境を作成して有効化します。
  * `temp` が `true` の場合、一時環境を作成して有効化します。この環境は Julia プロセスの終了時に削除されます。
  * `s` が既存のパスの場合、そのパスにある環境を有効化します。
  * `s` が現在のプロジェクト内のパッケージであり、`s` がパスを追跡している場合は、追跡先のパスにある環境を有効化します。
  * それ以外の場合、`s` は存在しないパスとして解釈され、そのパスが有効化されます。

# Examples

```julia
# Return to default environment (deactivate current project)
Pkg.activate()

# Activate a project in a specific directory
Pkg.activate("local/path")

# Activate a developed package by name
Pkg.activate("MyDependency")

# Create and activate a temporary environment
Pkg.activate(; temp=true)
```

[`LOAD_PATH`](https://docs.julialang.org/en/v1/base/constants/#Base.LOAD_PATH) も参照してください。
