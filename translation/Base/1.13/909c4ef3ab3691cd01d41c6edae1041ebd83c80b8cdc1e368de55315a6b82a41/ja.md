```julia
@main
```

このマクロは、現在のモジュールにあるバインディング `main` がエントリポイントとして扱われることを示します。エントリポイントの具体的な意味は、CLI ドライバーによって異なります。

`julia` ドライバーでは、`Main.main` がエントリポイントとして指定されている場合、スクリプトの実行完了時に自動的に呼び出されます。

`@main` マクロは単独で使用することも、関数定義の一部として使用することもできます。次の例は同等です。

```julia
function @main(args)
    println("Hello World")
end
```

```julia
function main(args)
end
@main
```

## Detailed semantics

エントリポイントとしての意味は、バインディングの所有者に付与されます。特に、エントリポイントとして指定されたものを `Main` にインポートすると、`Main` ではエントリポイントとして扱われます。

```julia
module MyApp
    export main
    @main(args) = println("Hello World")
end
using .MyApp
# `julia` Will execute MyApp.main at the conclusion of script execution
```

特に、この意味はメソッドや名前には付与されないことに注意してください。

```julia
module MyApp
    @main(args) = println("Hello World")
end
const main = MyApp.main
# `julia` Will *NOT* execute MyApp.main unless there is a separate `@main` annotation in `Main`
```

!!! compat "Julia 1.11"
    このマクロは Julia 1.11 で導入されました。現時点では、`@main` の具体的な意味は、今後変更される可能性があります。

