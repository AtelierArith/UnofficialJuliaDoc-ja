```julia
Pkg.activate([s::String]; shared::Bool=false, io::IO=stderr)
Pkg.activate(; temp::Bool=false, shared::Bool=false, io::IO=stderr)
```

`s`で環境をアクティブにします。アクティブな環境は、パッケージコマンドを実行することで変更される環境です。アクティブにされるパスのロジックは以下の通りです：

  * `shared`が`true`の場合、デポスタック内のデポから最初に存在する`s`という名前の環境がアクティブにされます。そのような環境が存在しない場合は、最初のデポにその環境を作成してアクティブにします。
  * `temp`が`true`の場合、これは一時的な環境を作成してアクティブにし、juliaプロセスが終了すると削除されます。
  * `s`が既存のパスである場合、そのパスの環境をアクティブにします。
  * `s`が現在のプロジェクト内のパッケージであり、`s`がパスを追跡している場合、追跡されたパスの環境をアクティブにします。
  * それ以外の場合、`s`は存在しないパスとして解釈され、それがアクティブにされます。

`activate`に引数が与えられない場合、最初に`LOAD_PATH`で見つかったプロジェクトを使用します（`"@"`は無視されます）。`LOAD_PATH`のデフォルト値の場合、結果は`@v#.#`環境をアクティブにすることになります。

# 例

```julia
Pkg.activate()
Pkg.activate("local/path")
Pkg.activate("MyDependency")
Pkg.activate(; temp=true)
```

[`LOAD_PATH`](https://docs.julialang.org/en/v1/base/constants/#Base.LOAD_PATH)も参照してください。
