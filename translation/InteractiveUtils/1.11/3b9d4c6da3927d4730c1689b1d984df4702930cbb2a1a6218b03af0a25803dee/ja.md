```julia
gen_call_with_extracted_types(__module__, fcn, ex, kws = Expr[]; is_source_reflection = !is_code_macro(fcn), supports_binding_reflection = false, use_signature_tuple = false)
```

入力式 `ex` を関数呼び出しまたは束縛へのアクセスとして分解し、次のいずれかを呼び出すコードを生成します。

  * `fcn(f, tt; kws...)`
  * `fcn(sigt; kws...)` # `use_signature_tuple = true` の場合
  * `fcn(mod, name; kws...)` # `supports_binding_reflection = true` の場合

## `fcn` API requirements

`fcn` は、次の API を満たすことが期待されるユーザー関数です。

  * `fcn(f, tt)`: `f` は値（`typeof(sum)` ではなく、`sum` など）であり、`tt := Tuple{argtypes...}` は引数の型を保持する `Tuple` です。`f` は `Core.OpaqueClosure` でもかまいません。

`use_signature_tuple = true` の場合:

  * `fcn(sigt)`: `sigt := Tuple{typeof(f), argtypes...}` は、イントロスペクションに使用する低レベルのシグネチャタプルを表します。

`supports_binding_reflection = true` の場合:

  * `fcn(mod::Module, name::Symbol)`: `name` は、`mod` に存在する場合もしない場合もある束縛の名前です。

!!! warning
    この関数は公開 API ではなく、互換性を損なう変更が加えられる可能性があります。ただし、マクロの開発者にとって非常に便利な場合があり、すでに一定数のパッケージで使われていることも認識しています。そのため、破壊的変更を避けるよう最善を尽くします。


## Examples

使い始める際に役立つ使用例をいくつか紹介します。

一般的な「コード」マクロ（`@code_typed`、`@code_llvm`、`@code_native` など）の場合:

```julia
    gen_call_with_extracted_types(__module__, fcn, ex, kws; is_source_reflection = false, use_signature_tuple = true #= may be false =#)
```

ソースリフレクションマクロ（`@which`、`@edit`、`@less` など）の場合:

```julia
    gen_call_with_extracted_types(__module__, fcn, ex, kws; is_source_reflection = true, use_signature_tuple = true #= may be false =#)
```

# Extended help

## Type annotations

呼び出し可能オブジェクトや任意の引数には、具体的な値の代わりに型注釈を使用できます。生成されるコードでは、実行時に値の型を取り出すのではなく、型注釈の右辺がそのまま使われます。

!!! compat "Julia 1.13"
    型注釈を使うには、Julia 1.13 以降が必要です。


これは、特に呼び出し可能オブジェクト（その場で手作業により構築するのが難しいものなど）や、具体型ではない型を指定したい場合に便利です。ただし、呼び出し可能オブジェクトをサポートするには、`use_signature_tuple` を true に設定する必要があります。これはデフォルトではありません（下記の該当セクションを参照）。

型パラメーターの制約も、`where` 構文で指定できます。これにより、次のような書き方が可能になります。

  * `f(x::Vector{T}, y::T) where {T}`
  * `(::Returns{T})() where {T<:Real}`
  * `(::MyPolynomial{N,T})(::T, ::AbstractArray{T,N}) where {N,T}`

`x + ::Float64` のように、型注釈付きの式と実行時の値を混在させることもできます。

## Broadcasting

`ex` がブロードキャスト式（ブロードキャスト代入 `a .+= b` またはブロードキャスト関数呼び出し `a .+ b`）の場合、この式に対応する関数は実際には存在しません。これは、lowering によって複数の呼び出しに変換されるためです。

`is_source_reflection` が true の場合、`fcn` は来歴情報を使うものと想定します（たとえば、ソース位置に移動する `@edit` や、入力に一致するメソッドを取得する `@which` など）。この場合、どの式を意味上のソースとして渡すべきか（`broadcasted` か、`materialize` か、それ以外か）が明確でないため、例外を投げる式を返します。

一方、来歴情報が不要な場合は、その場でブロードキャストを実行する中間関数を定義し、その関数を使って処理を続けます。たとえば、入力式 `a .+ b` に対して、無名関数 `(a, b) -> a .+ b` を生成し、ユーザーがこの無名関数を呼び出した場合と同様に `fcn` を呼び出します。これは、たとえば `@code_typed` や `@code_llvm` のように、式を対応する生成コードに変換するマクロの多くで望ましい動作です。

## Binding reflection

`a.b`（または `a.b.c` など）の形式の式は、デフォルトでは `getproperty` の呼び出しとして解釈されます。ただし、左辺（`a`、`a.b` など）に対応する値がモジュールの場合、実装によっては関数呼び出しではなく、束縛の検索を行いたいことがあります。その場合は、`supports_binding_reflection` を `true` に設定すると、`fcn(a, :b)`（または `fcn(a.b, :c)` など）を呼び出すコードが生成されます。

## Tuple signature type

`use_signature_tuple = true` の場合、`Tuple{ft, argtypes...}` からなる単一のタプルが作られ、`fcn` に渡されます。このとき、`fcn` は、変換を加えずに `ft` を呼び出し可能な型として使うことが期待されます。

この動作は、型注釈付きの呼び出し可能オブジェクトをサポートするために必要です。

この要件を理解するために、`code_typed` を例に考えてみましょう。`code_typed(f, ())` は入力をシグネチャ `Tuple{typeof(f)}` として解釈し、`code_typed(Returns{Int}, ())` はそれを型コンストラクターに対応するシグネチャ `Tuple{Type{Returns{Int}}}` として解釈します。この曖昧さを解消するには、`code_typed` が関数型を直接受け取る実装をサポートする必要があります。この実装は、`fcn(sigt::Type{<:Tuple})` に対するメソッドとして扱われます。
