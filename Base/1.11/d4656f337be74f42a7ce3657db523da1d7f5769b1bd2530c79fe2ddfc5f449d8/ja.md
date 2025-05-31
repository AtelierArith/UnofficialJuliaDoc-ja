```
@main
```

このマクロは、現在のモジュール内のバインディング `main` がエントリーポイントと見なされることを示すために使用されます。エントリーポイントの正確な意味は、CLI ドライバーによって異なります。

`julia` ドライバーでは、`Main.main` がエントリーポイントとしてマークされている場合、スクリプトの実行が完了すると自動的に呼び出されます。

`@main` マクロは単独で使用することも、関数定義の一部として使用することもできますが、後者の場合は括弧が必要です。特に、以下は同等です：

```
function (@main)(args)
    println("Hello World")
end
```

```
function main(ARGS)
end
@main
```

## 詳細な意味

エントリーポイントの意味は、バインディングの所有者に付随します。特に、マークされたエントリーポイントが `Main` にインポートされると、`Main` 内でエントリーポイントとして扱われます：

```
module MyApp
    export main
    (@main)(args) = println("Hello World")
end
using .MyApp
# `julia` はスクリプトの実行が終了した時に MyApp.main を実行します
```

特に、意味はメソッドや名前には付随しないことに注意してください：

```
module MyApp
    (@main)(args) = println("Hello World")
end
const main = MyApp.main
# `julia` は `Main` に別の `@main` アノテーションがない限り MyApp.main を *実行しません*
```

!!! compat "Julia 1.11"
    このマクロは Julia 1.11 で新しく追加されました。現在、`@main` の正確な意味はまだ変更される可能性があります。

