# The World Age mechanism

!!! note
    ワールドエイジは高度な概念です。ほとんどのJuliaユーザーにとって、ワールドエイジメカニズムはバックグラウンドで目に見えない形で動作します。このドキュメントは、ワールドエイジに関連する問題やエラーメッセージに遭遇する可能性のある少数のユーザーのために作成されています。


!!! compat "Julia 1.12"
    Julia 1.12以前は、ワールドエイジメカニズムはグローバルバインディングテーブルの変更には適用されませんでした。この章のドキュメントはJulia 1.12+に特有のものです。


!!! warning
    このマニュアルの章では、内部関数を使用して世界の年齢とランタイムデータ構造を調査し、説明の助けとしています。一般的に、特に記載がない限り、世界の年齢メカニズムは安定したインターフェースではなく、安定したAPI（例：`invokelatest`）を通じてパッケージ内でのみ相互作用するべきです。特に、世界の年齢が常に整数であるとは限らないことや、線形順序を持つとは限らないことを前提にしないでください。


## World age in general

「ワールドエイジカウンター」は、グローバルメソッドテーブルまたはグローバルバインディングテーブルへの変更ごとにインクリメントされる単調増加カウンターです（例：メソッド定義、型定義、`import`/`using` 宣言、（型付き）グローバルの作成または定数の定義を通じて）。

グローバルワールドエイジカウンターの現在の値は、(内部)関数 [`Base.get_world_counter`](@ref) を使用して取得できます。

```julia-repl
julia> Base.get_world_counter()
0x0000000000009632

julia> const x = 1

julia> Base.get_world_counter()
0x0000000000009633
```

さらに、各 [`Task`](@ref) は、実行中のタスクに現在表示されているグローバルバインディングおよびメソッドテーブルの変更を決定するローカルワールドエイジを格納します。実行中のタスクのワールドエイジは、グローバルワールドエイジカウンターを超えることはありませんが、それに対して任意に遅れる可能性があります。一般的に「現在のワールドエイジ」という用語は、現在実行中のタスクのローカルワールドエイジを指します。現在のワールドエイジは、（内部）関数 [`Base.tls_world_age`](@ref) を使用して取得できます。

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

ここでは、グローバルワールドカウンターを増加させるメソッド `f` の定義がありますが、現在のワールドエイジは変わりませんでした。その結果、`f` の定義は現在実行中のタスクでは見えず、[`MethodError`](@ref) が生成されました。

!!! note
    メソッドエラーの印刷は、`f()`が新しいワールドエイジで利用可能であるという追加情報を提供しました。この情報は、`MethodError`をスローしたタスクではなく、エラー表示によって追加されます。スローされた`MethodError`は、新しいワールドエイジに`f()`の一致する定義が存在するかどうかにかかわらず同一です。


しかし、`f()`の定義は次のREPLプロンプトで利用可能であったことに注意してください。これは、現在のタスクのワールドエイジが上昇したためです。一般に、特定の構文構造（特にほとんどの定義）は、現在のタスクのワールドエイジを最新のグローバルワールドエイジに引き上げるため、すべての変更（現在のタスクからのものと、同時に実行されている他のタスクからのものの両方）が可視化されます。次の文は現在のワールドエイジを上昇させます：

1. `Core.@latestworld`の明示的な呼び出し
2. すべてのトップレベルステートメントの開始
3. すべてのREPLプロンプトの開始
4. 任意の型または構造体の定義
5. 任意のメソッド定義
6. 任意の定数宣言
7. グローバル変数の宣言（ただし、グローバル変数の代入は除く）
8. 任意の `using`、`import`、`export` または `public` ステートメント
9. 特定の他のマクロ、例えば [`@eval`](@ref) （マクロの実装に依存します）

ただし、現在のタスクの世界の年齢は、最上位レベルでのみ永続的に増加する可能性があることに注意してください。一般的なルールとして、上記のいずれかの文を非最上位スコープで使用することは構文エラーです：

```julia-repl
julia> f() = Core.@latestworld
ERROR: syntax: World age increment not at top level
Stacktrace:
 [1] top-level scope
   @ REPL[5]:1
```

それがない場合（例えば `@eval` の場合）、世界の年齢の副作用は無視されます。

これらのルールの結果、ジュリアは通常の関数の実行中に世界の年齢が変わらないと仮定することができます。

```julia
function my_function()
    before = Base.tls_world_age()
    # Any arbitrary code
    after = Base.tls_world_age()
    @assert before === after # always true
end
```

これは、Juliaがそのグローバルデータ構造の現在の状態に基づいて最適化を行うことを可能にする重要な不変条件であり、同時にこれらのデータ構造を変更する明確な能力を持つことを意味します。

## Temporarily raising the world age using `invokelatest`

上記のように、`Task`の実行中にタスクがトップレベルのステートメントを実行していない限り、世界の年齢を恒久的に上げることはできません。しかし、`invokelatest`を使用してスコープ内で一時的に世界の年齢を変更することは可能です：

```jldoctest
julia> function f end
f (generic function with 0 methods)

julia> begin
           Core.eval(@__MODULE__, :(f() = 1))
           invokelatest(f)
       end
1
```

`invokelatest` は、現在のタスクのワールドエイジを最新のグローバルワールドエイジ（`invokelatest` に入るとき）に一時的に引き上げ、提供された関数を実行します。`invokelatest` から出ると、ワールドエイジは以前の値に戻ることに注意してください。

## World age and const struct redefinitions

上記で説明したメソッドの再定義に関するセマンティクスは、定数の再定義にも適用されます：

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

ただし、誤解を避けるために、これらはグローバル変数への通常の代入には適用されず、これは即座に可視化されます：

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

定数再割り当ての特定の特別なケースは、構造体型の再定義です：

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

内部的には、`MyStruct`の2つの定義は完全に別々の型です。しかし、新しい`MyStruct`型が定義された後は、元の`MyStruct`の定義に対するデフォルトのバインディングはもはや存在しません。それでもこれらの型へのアクセスを容易にするために、特別な[`@world`](@ref)マクロを使用して、以前の世界における名前の意味にアクセスすることができます。ただし、この機能はイントロスペクション専用であり、特にワールドエイジ番号はプリコンパイル間で安定しておらず、一般的には不透明に扱うべきであることに注意してください。

### Binding partition introspection

特定のケースでは、システムが特定の世界の年齢においてバインディングが何を意味するかを内省することが役立つ場合があります。`Core.Binding`のデフォルト表示印刷は、上記の`MyStruct`の例など、役立つ要約を提供します。

```julia-repl
julia> convert(Core.Binding, GlobalRef(@__MODULE__, :MyStruct))
Binding Main.MyStruct
   38456:∞ - constant binding to MyStruct
   38452:38455 - constant binding to @world(MyStruct, 38452:38455)
   38451:38451 - backdated constant binding to @world(MyStruct, 38452:38455)
   0:38450 - backdated constant binding to @world(MyStruct, 38452:38455)
```

## World age and `using`/`import`

`using` と `import` を介して提供されるバインディングも、ワールドエイジメカニズムを介して動作します。バインディングの解決は、現在のワールドエイジで可視の `import` および `using` 定義の無状態関数です。例えば：

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

特定の言語機能は、現在のタスクの世界の年齢をキャプチャします。これらの中で最も一般的なものの1つは、新しいタスクの作成です。新しく作成されたタスクは、作成時に作成タスクのローカルな世界の年齢を継承し、元のタスクがその世界の年齢を上げた場合でも、明示的に上げられない限り、その世界の年齢を保持します。

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

タスクに加えて、不透明なクロージャは作成時のワールドエイジもキャプチャします。[`Base.Experimental.@opaque`](@ref)を参照してください。

```@docs
Base.@world
Base.get_world_counter
Base.tls_world_age
Base.invoke_in_world
Base.Experimental.@opaque
```
