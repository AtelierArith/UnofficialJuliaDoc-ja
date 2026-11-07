# [The World Age mechanism](@id man-world-age)

!!! note
    ワールドエイジは高度な概念です。大多数のJuliaユーザーにとって、ワールドエイジの仕組みはバックグラウンドで意識されることなく動作します。このドキュメントは、ワールドエイジに関連する問題やエラーメッセージに遭遇する可能性のある、ごく一部のユーザーを対象としています。


!!! compat "Julia 1.12"
    Julia 1.12より前のバージョンでは、ワールドエイジの仕組みはグローバルバインディングテーブルへの変更には適用されませんでした。この章のドキュメントはJulia 1.12以降を対象としています。


!!! warning
    このマニュアルの章では、説明の補助として、ワールドエイジや実行時データ構造を調べる内部関数を使用しています。特に断りのない限り、ワールドエイジの仕組みは安定したインターフェースではありません。パッケージから利用する場合は、安定したAPI（例：`invokelatest`）のみを使用してください。特に、ワールドエイジが常に整数である、あるいは線形順序を持つと仮定しないでください。


## World age in general

「ワールドエイジカウンター」は単調増加するカウンターであり、グローバルメソッドテーブルまたはグローバルバインディングテーブルに変更があるたびに増加します（例：メソッド定義、型定義、`import`/`using`宣言、（型付き）グローバル変数の作成、定数の定義）。

グローバルなワールドエイジカウンターの現在値は、（内部）関数[`Base.get_world_counter`](@ref)を使って取得できます。

```julia-repl
julia> Base.get_world_counter()
0x0000000000009632

julia> const x = 1

julia> Base.get_world_counter()
0x0000000000009633
```

さらに、各[`Task`](@ref)はローカルワールドエイジを保持しており、実行中のタスクからグローバルバインディングテーブルおよびメソッドテーブルのどの変更が見えるかを決定します。実行中のタスクのワールドエイジがグローバルワールドエイジカウンターを超えることはありませんが、任意の期間遅れることがあります。一般に「現在のワールドエイジ」とは、現在実行中のタスクのローカルワールドエイジを指します。現在のワールドエイジは、（内部）関数[`Base.tls_world_age`](@ref)を使って取得できます。

```julia-repl
julia> function f end
f (generic function with 0 methods)

julia> begin
           @show (Int(Base.get_world_counter()), Int(Base.tls_world_age()))
           Core.eval(@__MODULE__, :(f() = 1))
           @show (Int(Base.get_world_counter()), Int(Base.tls_world_age()))
           f()
       end
(Int(Base.get_world_counter()), Int(Base.tls_world_age())) = (38452, 38452)
(Int(Base.get_world_counter()), Int(Base.tls_world_age())) = (38453, 38452)
ERROR: MethodError: no method matching f()
The applicable method may be too new: running in current world age 38452, while global world is 38453.

Closest candidates are:
  f() (method too new to be called from this world context.)
   @ Main REPL[2]:3

Stacktrace:
 [1] top-level scope
   @ REPL[2]:5

julia> (f(), Int(Base.tls_world_age()))
(1, 38453)
```

ここでは、メソッド`f`の定義によってグローバルワールドカウンターは増加しましたが、現在のワールドエイジは変化しませんでした。その結果、`f`の定義は実行中のタスクから見えず、[`MethodError`](@ref)が発生しました。

!!! note
    メソッドエラーの表示には、`f()`がより新しいワールドエイジで利用可能であるという追加情報が含まれていました。この情報を追加するのはエラー表示であり、`MethodError`をスローしたタスクではありません。より新しいワールドエイジに`f()`の一致する定義が存在するかどうかにかかわらず、スローされる`MethodError`は同一です。


ただし、次のREPLプロンプトでは`f()`の定義が利用可能になっていたことに注意してください。これは、現在のタスクのワールドエイジが引き上げられていたためです。一般に、特定の構文（特にほとんどの定義）は、現在のタスクのワールドエイジを最新のグローバルワールドエイジまで引き上げます。これにより、現在のタスクおよび同時に実行中の他のタスクによるすべての変更が見えるようになります。次の文は現在のワールドエイジを引き上げます。

1. `Core.@latestworld`の明示的な呼び出し
2. 各トップレベル文の開始
3. 各REPLプロンプトの開始
4. 型または構造体の定義
5. メソッド定義
6. 定数宣言
7. グローバル変数の宣言（グローバル変数への代入は除く）
8. `using`、`import`、`export`、または`public`文
9. [`@eval`](@ref)など、その他の特定のマクロ（マクロの実装による）

ただし、現在のタスクのワールドエイジを永続的に引き上げられるのは、トップレベルに限られます。一般に、上記の文をトップレベル以外のスコープで使うと構文エラーになります。

```julia-repl
julia> f() = Core.@latestworld
ERROR: syntax: World age increment not at top level
Stacktrace:
 [1] top-level scope
   @ REPL[5]:1
```

ただし、`@eval`のように構文エラーにならない場合でも、ワールドエイジへの副作用は無視されます。

これらの規則により、Juliaは通常の関数の実行中にワールドエイジが変化しないと仮定できます。

```julia
function my_function()
    before = Base.tls_world_age()
    # Any arbitrary code
    after = Base.tls_world_age()
    @assert before === after # always true
end
```

この不変条件により、Juliaはグローバルデータ構造の現在の状態に基づいて最適化を行いながら、それらのデータ構造を変更する機能を明確に定義された形で提供できます。

## Temporarily raising the world age using `invokelatest`

前述のとおり、タスクがトップレベル文を実行している場合を除き、`Task`の実行中にワールドエイジを永続的に引き上げることはできません。ただし、`invokelatest`を使えば、スコープ内で一時的にワールドエイジを変更できます。

```jldoctest
julia> function f end
f (generic function with 0 methods)

julia> begin
           Core.eval(@__MODULE__, :(f() = 1))
           invokelatest(f)
       end
1
```

`invokelatest`は、現在のタスクのワールドエイジを最新のグローバルワールドエイジ（`invokelatest`に入った時点）まで一時的に引き上げ、指定された関数を実行します。`invokelatest`を抜けると、ワールドエイジは元の値に戻ります。

## World age and const struct redefinitions

メソッドの再定義について前述した意味論は、定数の再定義にも適用されます。

```jldoctest
julia> const x = 1
1

julia> get_const() = x
get_const (generic function with 1 method)

julia> begin
           @show get_const()
           Core.eval(@__MODULE__, :(const x = 2))
           @show get_const()
           Core.@latestworld
           @show get_const()
       end
get_const() = 1
get_const() = 1
get_const() = 2
2
```

ただし、誤解のないように付け加えると、通常のグローバル変数への代入には適用されず、その変更は直ちに見えるようになります。

```jldoctest
julia> global y = 1
1

julia> get_global() = y
get_global (generic function with 1 method)

julia> begin
           @show get_global()
           Core.eval(@__MODULE__, :(y = 2))
           @show get_global()
       end
get_global() = 1
get_global() = 2
2
```

定数の再代入に関する特殊なケースの一つが、構造体型の再定義です。

```jldoctest; filter = r"\@world\(MyStruct, \d+\:\d+\)"
julia> struct MyStruct
           x::Int
       end

julia> const one_field = MyStruct(1)
MyStruct(1)

julia> struct MyStruct
           x::Int
           y::Float64
       end

julia> const two_field = MyStruct(1, 2.0)
MyStruct(1, 2.0)

julia> one_field
@world(MyStruct, 38452:38455)(1)

julia> two_field
MyStruct(1, 2.0)
```

内部的には、`MyStruct`の2つの定義は完全に別個の型です。しかし、新しい`MyStruct`型を定義すると、元の`MyStruct`定義に対するデフォルトのバインディングはなくなります。それでもこれらの型にアクセスできるようにするには、特殊な[`@world`](@ref)マクロを使って、以前のワールドにおける名前の意味を参照できます。ただし、この機能はイントロスペクション専用です。また、ワールドエイジの数値はプリコンパイルをまたいで安定していないため、一般に不透明な値として扱う必要があります。

### Binding partition introspection

特定のワールドエイジにおいて、あるバインディングが何を意味するかについて、システムの解釈を調べると役立つ場合があります。`Core.Binding`のデフォルト表示は、その概要を把握するのに役立ちます（例として、前述の`MyStruct`を見てください）。

```julia-repl
julia> convert(Core.Binding, GlobalRef(@__MODULE__, :MyStruct))
Binding Main.MyStruct
   38456:∞ - constant binding to MyStruct
   38452:38455 - constant binding to @world(MyStruct, 38452:38455)
   38451:38451 - backdated constant binding to @world(MyStruct, 38452:38455)
   0:38450 - backdated constant binding to @world(MyStruct, 38452:38455)
```

## World age and `using`/`import`

`using`および`import`を介して提供されるバインディングも、ワールドエイジの仕組みを通じて動作します。バインディングの解決は、現在のワールドエイジで見える`import`および`using`の定義に基づくステートレスな関数です。たとえば、次のようになります。

```julia-repl
julia> module M1; const x = 1; export x; end

julia> module M2; const x = 2; export x; end

julia> using .M1

julia> x
1

julia> using .M2

julia> x
ERROR: UndefVarError: `x` not defined in `Main`
Hint: It looks like two or more modules export different bindings with this name, resulting in ambiguity. Try explicitly importing it from a particular module, or qualifying the name with the module it should come from.

julia> convert(Core.Binding, GlobalRef(@__MODULE__, :x))
Binding Main.x
   38458:∞ - ambiguous binding - guard entry
   38457:38457 - implicit `using` resolved to constant 1
```

## World age capture

一部の言語機能は、現在のタスクのワールドエイジを捕捉します。最も一般的な例の一つは、新しいタスクの作成です。新しく作成されたタスクは、作成時に作成元タスクのローカルワールドエイジを引き継ぎ、そのワールドエイジを保持します。その後、作成元タスクのワールドエイジが引き上げられても、明示的に引き上げない限り変わりません。

```julia-repl
julia> const x = 1

julia> t = @task (wait(); println("Running now"); x);

julia> const x = 2

julia> schedule(t);
Running now

julia> x
2

julia> fetch(t)
1
```

タスクに加えて、不透明クロージャも作成時のワールドエイジを捕捉します。[`Base.Experimental.@opaque`](@ref)を参照してください。

```@docs
Base.@world
Base.get_world_counter
Base.tls_world_age
Base.invoke_in_world
Base.Experimental.@opaque
```
