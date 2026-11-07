# [Scoped Values](@id scoped-values)

Scoped valueは、Juliaにおける動的スコープの実装を提供します。

!!! note "レキシカルスコープと動的スコープ"
    [Lexical scoping](@ref scope-of-variables) はJuliaのデフォルトの動作です。レキシカルスコープでは、変数のスコープはプログラムのレキシカル（テキスト上の）構造によって決まります。動的スコープでは、プログラムの実行中に最後に代入された値に変数が束縛されます。


Scoped valueの状態は、プログラムの実行経路によって変わります。そのため、同じScoped valueについて、複数の異なる値を同時に観測することがあります。

!!! compat "Julia 1.11"
    Scoped valueはJulia 1.11で導入されました。Julia 1.8以降では、ScopedValues.jlパッケージで互換実装を利用できます。


最も簡単な使い方では、デフォルト値を指定して [`ScopedValue`](@ref Base.ScopedValues.ScopedValue) を作成し、[`with`](@ref Base.ScopedValues.with) または [`@with`](@ref Base.ScopedValues.@with) を使って新しい動的スコープに入ります。新しいスコープは、親スコープ（および再帰的にすべての外側のスコープ）の値をすべて引き継ぎます。指定したScoped valueの値は、以前の定義より優先されます。

まず、**レキシカル**スコープの例を見てみましょう。`let` 文は新しいレキシカルスコープを開始し、その中では外側で定義された `x` が内側の定義によって隠されます。

```jldoctest
julia> x = 1
1

julia> let x = 5
           @show x
       end;
x = 5

julia> @show x;
x = 1
```

次の例では、Juliaがレキシカルスコープを使うため、`f` の本体にある変数 `x` は、グローバルスコープで定義された `x` を参照します。そのため、`let` スコープに入っても、`f` が観測する値は変わりません。

```jldoctest
julia> x = 1
1

julia> f() = @show x
f (generic function with 1 method)

julia> let x = 5
           f()
       end;
x = 1

julia> f();
x = 1
```

ここで `ScopedValue` を使うと、**動的**スコープを利用できます。

```jldoctest
julia> using Base.ScopedValues

julia> x = ScopedValue(1)
ScopedValue{Int64}(1)

julia> f() = @show x[]
f (generic function with 1 method)

julia> with(x=>5) do
           f()
       end;
x[] = 5

julia> f();
x[] = 1
```

`ScopedValue` の観測値は、プログラムの実行経路によって変わることに注意してください。

Scoped valueを指す `const` 変数を使うと便利な場合がよくあります。また、1回の `with` 呼び出しで、複数の `ScopedValue` の値を設定できます。

```julia
using Base.ScopedValues

f() = @show a[]
g() = @show b[]

const a = ScopedValue(1)
const b = ScopedValue(2)

f() # a[] = 1
g() # b[] = 2

# Enter a new dynamic scope and set value.
with(a => 3) do
    f() # a[] = 3
    g() # b[] = 2
    with(a => 4, b => 5) do
        f() # a[] = 4
        g() # b[] = 5
    end
    f() # a[] = 3
    g() # b[] = 2
end

f() # a[] = 1
g() # b[] = 2
```

`ScopedValues` は、`with` のマクロ版です。式 `@with var=>val expr` は、新しい動的スコープ内で `expr` を評価し、そのスコープでは `var` に `val` が設定されます。`@with var=>val expr` は `with(var=>val) do expr end` と同等です。ただし、`with` には引数を取らないクロージャまたは関数が必要で、その分、呼び出しフレームが1つ増えます。例として、次の関数 `f` を考えてみましょう。

```julia
using Base.ScopedValues
const a = ScopedValue(1)
f(x) = a[] + x
```

`f` を、`a` に `2` を設定した動的スコープ内で実行するには、`with` を使います。

```julia
with(() -> f(10), a=>2)
```

ただし、この方法では `f` を引数なしの関数で包む必要があります。呼び出しフレームの増加を避けたい場合は、`@with` マクロを使えます。

```julia
@with a=>2 f(10)
```

!!! note
    タスクの作成時点で、動的スコープは [`Task`](@ref) に引き継がれます。一方、動的スコープは `Distributed.jl` 操作を通じては伝播しません。


次の例では、タスクを起動する前に新しい動的スコープに入ります。親タスクと2つの子タスクは、同じScoped valueについて、それぞれ独立した値を同時に観測します。

```julia
using Base.ScopedValues
import Base.Threads: @spawn

const scoped_val = ScopedValue(1)
@sync begin
    with(scoped_val => 2)
        @spawn @show scoped_val[] # 2
    end
    with(scoped_val => 3)
        @spawn @show scoped_val[] # 3
    end
    @show scoped_val[] # 1
end
```

Scoped valueはスコープ内では一定ですが、Scoped valueに可変状態を格納することもできます。ただし、並行プログラミングでは、グローバル変数に関する通常の注意点が当てはまることを忘れないでください。

Scoped valueに可変状態への参照を格納する場合にも注意が必要です。新しい動的スコープに入るときに、明示的に [unshare mutable state](@ref unshare_mutable_state) したほうがよい場合があります。

```julia
using Base.ScopedValues
import Base.Threads: @spawn

const sval_dict = ScopedValue(Dict())

# Example of using a mutable value wrongly
@sync begin
    # `Dict` is not thread-safe the usage below is invalid
    @spawn (sval_dict[][:a] = 3)
    @spawn (sval_dict[][:b] = 3)
end

@sync begin
    # If we instead pass a unique dictionary to each
    # task we can access the dictionaries race free.
    with(sval_dict => Dict()) do
        @spawn (sval_dict[][:a] = 3)
    end
    with(sval_dict => Dict()) do
        @spawn (sval_dict[][:b] = 3)
    end
end
```

## Example

次の例では、Scoped valueを使ってWebアプリケーションの権限チェックを実装します。リクエストの権限を判定した後、新しい動的スコープに入り、Scoped value `LEVEL` に値を設定します。アプリケーションのほかの部分からScoped valueを参照すると、適切な値を取得できます。タスクローカルストレージやグローバル変数などの方法は、このような値の伝播には適していません。代わりに使える方法は、呼び出しチェーン全体を通じて値を渡すことだけでした。

```julia
using Base.ScopedValues

const LEVEL = ScopedValue(:GUEST)

function serve(request, response)
    level = isAdmin(request) ? :ADMIN : :GUEST
    with(LEVEL => level) do
        Threads.@spawn handle(request, response)
    end
end

function open(connection::Database)
    level = LEVEL[]
    if level !== :ADMIN
        error("Access disallowed")
    end
    # ... open connection
end

function handle(request, response)
    # ...
    open(Database(#=...=#))
    # ...
end
```

## Idioms

### [Unshare mutable state](@id unshare_mutable_state)

```julia
using Base.ScopedValues
import Base.Threads: @spawn

const sval_dict = ScopedValue(Dict())

# If you want to add new values to the dict, instead of replacing
# it, unshare the values explicitly. In this example we use `merge`
# to unshare the state of the dictionary in parent scope.
@sync begin
    with(sval_dict => merge(sval_dict[], Dict(:a => 10))) do
        @spawn @show sval_dict[][:a]
    end
    @spawn sval_dict[][:a] = 3 # Not a race since they are unshared.
end
```

### Scoped values as globals

Scoped valueの値にアクセスするには、そのScoped value自体が（レキシカル）スコープ内にある必要があります。そのため、多くの場合、Scoped valueは定数のグローバル変数として使うのがよいでしょう。

```julia
using Base.ScopedValues
const sval = ScopedValue(1)
```

実際、Scoped valueは隠れた関数引数と考えることができます。

ただし、グローバル変数以外の用途に使えないわけではありません。

```julia
using Base.ScopedValues
import Base.Threads: @spawn

function main()
    role = ScopedValue(:client)

    function launch()
        #...
        role[]
    end

    @with role => :server @spawn launch()
    launch()
end
```

とはいえ、このような場合は、関数の引数を直接渡すほうが簡単だったかもしれません。

### Very many ScopedValues

あるモジュールで多数の `ScopedValue` を作成することになった場合は、それらを保持する専用の構造体を使うほうがよいかもしれません。

```julia
using Base.ScopedValues

Base.@kwdef struct Configuration
    color::Bool = false
    verbose::Bool = false
end

const CONFIG = ScopedValue(Configuration(color=true))

@with CONFIG => Configuration(color=CONFIG[].color, verbose=true) begin
    @show CONFIG[].color # true
    @show CONFIG[].verbose # true
end
```

## API docs

```@docs
Base.ScopedValues.AbstractScopedValue
Base.ScopedValues.ScopedValue
Base.ScopedValues.LazyScopedValue
Base.ScopedValues.with
Base.ScopedValues.@with
Base.isassigned(::Base.ScopedValues.ScopedValue)
Base.ScopedValues.get
```

## Implementation notes and performance

`Scope` は永続辞書を使います。検索と挿入は `O(log(32, n))` です。動的スコープに入る際には少量のデータがコピーされ、変更されていないデータはほかのスコープと共有されます。

`Scope` オブジェクト自体はユーザー向けのものではなく、Juliaの将来のバージョンで変更される可能性があります。

## Design inspiration

この設計は [JEPS-429](https://openjdk.org/jeps/429) に大きな影響を受けています。これはさらに、多くのLisp方言における動的スコープの自由変数に着想を得たものです。特に、Interlisp-Dとそのディープバインディング方式が参考になっています。

以前には、[PEPS-567](https://peps.python.org/pep-0567/) のようなコンテキスト変数を使う設計も検討され、Juliaでは [ContextVariablesX.jl](https://github.com/tkf/ContextVariablesX.jl) として実装されていました。
