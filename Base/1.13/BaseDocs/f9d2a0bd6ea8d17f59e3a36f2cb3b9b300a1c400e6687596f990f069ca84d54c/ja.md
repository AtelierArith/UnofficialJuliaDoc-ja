_import(to::Module, from::Module, asname::Symbol, [sym::Symbol, imported::Bool])

5つの引数をすべて指定すると、モジュール `from` から `sym` をインポートし、`to` 内で `asname` という名前を付けます。`imported` は、`import` によって作成されたバインディングでは true です（`using A: ...` の場合は false に設定します）。

最初の3つの引数だけを指定すると、`to` 内に、モジュール `from` のバインディングを `asname` という名前で作成します。
