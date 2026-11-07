```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/stdlib/Random/docs/src/index.md"
```

# Random Numbers

```@meta
DocTestSetup = :(using Random)
```

Juliaでは、デフォルトで[Xoshiro256++](https://prng.di.unimi.it/)アルゴリズムを使って乱数を生成し、状態は`Task`ごとに管理されます。`AbstractRNG`型を継承すれば、ほかのRNG型を組み込むこともでき、複数の乱数ストリームを生成できます。

`Random`パッケージがエクスポートするPRNG（疑似乱数生成器）は次のとおりです。

  * `TaskLocalRNG`: 現在アクティブなタスクローカルのストリームを表すトークンです。親タスクから決定論的にシードされるか、プログラム開始時に`RandomDevice`（システム乱数を使用）によってシードされます。
  * `Xoshiro`: Xoshiro256++アルゴリズムを使い、小さな状態ベクトルと高い性能で、高品質な乱数ストリームを生成します。
  * `RandomDevice`: OSが提供するエントロピーを使います。暗号学的に安全な乱数（CS(P)RNG）に利用できます。
  * `MersenneTwister`: 以前のJuliaでデフォルトだった、もう一つの高品質なPRNGです。かなり高速ですが、状態ベクトルの保存と乱数列の生成に、より多くの領域を必要とします。

乱数生成に関係するほとんどの関数は、最初の引数として省略可能な`AbstractRNG`オブジェクトを受け取ります。また、乱数値の配列を生成するために、次元指定`dims...`（タプルで指定することもできます）を受け取る関数もあります。マルチスレッドプログラムでは、スレッドセーフにするため、通常はスレッドやタスクごとに異なるRNGオブジェクトを使ってください。ただし、Julia 1.3以降、デフォルトのRNGはスレッドセーフです（1.6まではスレッドごと、それ以降はタスクごとのRNGを使用します）。

用意されているRNGは、次の型の一様乱数を生成できます: [`Float16`](@ref)、[`Float32`](@ref)、[`Float64`](@ref)、[`BigFloat`](@ref)、[`Bool`](@ref)、[`Int8`](@ref)、[`UInt8`](@ref)、[`Int16`](@ref)、[`UInt16`](@ref)、[`Int32`](@ref)、[`UInt32`](@ref)、[`Int64`](@ref)、[`UInt64`](@ref)、[`Int128`](@ref)、[`UInt128`](@ref)、[`BigInt`](@ref)（またはこれらの型の複素数）。浮動小数点の乱数は``[0, 1)``上で一様に生成されます。`BigInt`は上限のない整数を表すため、区間を指定する必要があります（例: `rand(big.(1:6))`）。

さらに、一部の`AbstractFloat`型および`Complex`型では、正規分布と指数分布が実装されています。詳しくは[`randn`](@ref)および[`randexp`](@ref)を参照してください。

ほかの分布から乱数を生成するには、[Distributions.jl](https://juliastats.org/Distributions.jl/stable/)パッケージを参照してください。

!!! warning
    乱数の生成方法の詳細は実装上の仕様とみなされるため、バージョン変更後には、バグ修正や高速化によって生成される乱数ストリームが変わることがあります。そのため、単体テストで特定のシードや生成された乱数ストリームに依存することは推奨されません。代わりに、対象のメソッドが満たすべき性質をテストしてください。


## Random numbers module

```@docs
Random.Random
```

## Random generation functions

```@docs
Random.rand
Random.rand!
Random.bitrand
Random.randn
Random.randn!
Random.randexp
Random.randexp!
Random.randstring
```

## Subsequences, permutations and shuffling

```@docs
Random.randsubseq
Random.randsubseq!
Random.randperm
Random.randperm!
Random.randcycle
Random.randcycle!
Random.shuffle
Random.shuffle!
```

## Generators (creation and seeding)

```@docs
Random.default_rng
Random.seed!
Random.AbstractRNG
Random.TaskLocalRNG
Random.Xoshiro
Random.MersenneTwister
Random.RandomDevice
```

## [Hooking into the `Random` API](@id rand-api-hook)

`Random`の機能を拡張する方法は、大きく分けて次の2つあります。

1. 独自の型の乱数値を生成する
2. 新しい生成器を作成する

1)のAPIはかなり実用的ですが、比較的新しいため、今後の`Random`モジュールのリリースで変更される可能性があります。たとえば、通常使われるほかのメソッドを自動的に動作させるには、通常`rand`メソッドを1つ実装するだけで十分です。

2)のAPIはまだ初歩的で、一般的な型の値を生成できるようにするには、実装者が必要以上の作業を求められる場合があります。

### Generating random values of custom types

分布から乱数値を生成する際には、さまざまなトレードオフが生じることがあります。離散分布の[alias table](https://en.wikipedia.org/wiki/Alias_method)や、1変量分布の[“squeezing” functions](https://en.wikipedia.org/wiki/Rejection_sampling)のように、値を*事前計算*しておくと、サンプリングを大幅に高速化できます。どの程度の情報を事前計算するかは、その分布から生成する値の個数によって変わります。また、乱数生成器によっては、アルゴリズムが利用できる特性を備えている場合もあります。

`Random`モジュールは、こうした問題に対応するため、カスタマイズ可能な乱数値取得の仕組みを定義しています。`rand`を呼び出すたびに*サンプラー*が生成されます。このサンプラーは、上記のトレードオフを考慮してカスタマイズできます。具体的には、`Sampler`にメソッドを追加します。このメソッドは、乱数生成器、分布を特徴づけるオブジェクト、繰り返し回数の目安に応じてディスパッチされます。現在、繰り返し回数の目安には、1回のサンプルを表す`Val{1}`と、任意の回数を表す`Val{Inf}`が使われます。`Random.Repetition`はその両方の別名です。

`Sampler`が返すオブジェクトを使って、乱数値を生成します。サンプリング可能な値`X`の乱数生成インターフェースを実装する場合は、次のメソッドを定義してください。

```julia
rand(rng, sampler)
```

これは、`Sampler(rng, X, repetition)`が返す特定の`sampler`に対して定義します。

サンプラーには、`rand(rng, sampler)`を実装する任意の値を使えますが、多くの用途では、次の定義済みサンプラーで十分です。

1. `SamplerType{T}()`は、型`T`（例: `rand(Int)`）から値を取り出すサンプラーの実装に使えます。これは、*型*に対して`Sampler`が返すデフォルト値です。
2. `SamplerTrivial(self)`は、`self`を単純にラップするものです。`[]`でアクセスできます。事前計算が不要な場合（例: `rand(1:3)`）に推奨されるサンプラーであり、*値*に対して`Sampler`が返すデフォルト値です。
3. `SamplerSimple(self, data)`には、追加のフィールド`data`もあります。このフィールドには任意の事前計算値を格納でき、その値は`Sampler`の*カスタムメソッド*で計算します。

それぞれの例を示します。ここでは、アルゴリズムの選択はRNGに依存しないものとし、シグネチャには`AbstractRNG`を使います。

```@docs
Random.Sampler
Random.SamplerType
Random.SamplerTrivial
Random.SamplerSimple
```

事前計算と実際の値の生成を分離することはAPIの一部であり、ユーザーも利用できます。たとえば、ループ内で`rand(rng, 1:20)`を繰り返し呼び出す場合、この分離を活用するには次のようにします。

```julia
rng = Xoshiro()
sp = Random.Sampler(rng, 1:20) # or Random.Sampler(Xoshiro, 1:20)
for x in X
    n = rand(rng, sp) # similar to n = rand(rng, 1:20)
    # use n
end
```

これは標準ライブラリでも使われている仕組みです。たとえば、乱数配列生成のデフォルト実装（`rand(1:20, 10)`など）で利用されています。

#### Generating values from a type

型`T`については、`rand(T)`が定義されていれば、型`T`のオブジェクトが生成されるものと、現在は想定されています。`SamplerType`は*型に対するデフォルトのサンプラー*です。型`T`の値を生成するには、`rand(rng::AbstractRNG, ::Random.SamplerType{T})`メソッドを定義し、`rand(rng, T)`が返すことを期待される値を返すようにします。

例として、面の数`n`が可変で、`1`から`n`までの番号が付いた`Die`型を実装します。`rand(Die)`で、面が4つ以上20個以下の`Die`をランダムに生成したいとします。

```jldoctest Die
struct Die
    nsides::Int # number of sides
end

Random.rand(rng::AbstractRNG, ::Random.SamplerType{Die}) = Die(rand(rng, 4:20))

# output

```

これで、`Die`のスカラー用および配列用メソッドが期待どおりに動作します。

```jldoctest Die; setup = :(Random.seed!(1))
julia> rand(Die)
Die(5)

julia> rand(Xoshiro(0), Die)
Die(10)

julia> rand(Die, 3)
3-element Vector{Die}:
 Die(9)
 Die(15)
 Die(14)

julia> a = Vector{Die}(undef, 3); rand!(a)
3-element Vector{Die}:
 Die(19)
 Die(7)
 Die(17)
```

#### A simple sampler without pre-computed data

ここでは、コレクション用のサンプラーを定義します。事前計算データが不要なら、`SamplerTrivial`サンプラーで実装できます。これは実際には、*値に対するデフォルトのフォールバック*です。

型`S`のオブジェクトから乱数を生成するには、次のメソッドを定義します: `rand(rng::AbstractRNG, sp::Random.SamplerTrivial{S})`。ここで`sp`は、型`S`のオブジェクトを単純にラップしており、`sp[]`からアクセスできます。先ほどの`Die`の例を続けて、今度は`rand(d::Die)`が、`Int`を生成するようにします。これは`d`の面のいずれかに対応します。

```jldoctest Die; setup = :(Random.seed!(1))
julia> Random.rand(rng::AbstractRNG, d::Random.SamplerTrivial{Die}) = rand(rng, 1:d[].nsides);

julia> rand(Die(4))
1

julia> rand(Die(4), 3)
3-element Vector{Any}:
 2
 3
 3
```

コレクション型`S`については、`rand(::S)`が定義されていれば、型`eltype(S)`のオブジェクトが生成されるものと、現在は想定されています。直前の例では`Vector{Any}`が生成されます。これは`eltype(Die) == Any`が理由です。これを解決するには、`Base.eltype(::Type{Die}) = Int`を定義します。

#### Generating values for an `AbstractFloat` type

`AbstractFloat`型は特別扱いされます。デフォルトでは、型の値域全体ではなく、`[0,1)`から乱数値が生成されるためです。`T <: AbstractFloat`に対して、次のメソッドを実装してください: `Random.rand(::AbstractRNG, ::Random.SamplerTrivial{Random.CloseOpen01{T}})`

#### An optimized sampler with pre-computed data

離散分布を考えます。数値`1:n`が、合計が1になる所定の確率で選ばれます。この分布から多数の値を得る場合、最速の方法は[alias table](https://en.wikipedia.org/wiki/Alias_method)を使うことです。ここでは、そのテーブルを構築するアルゴリズムは示しませんが、代わりに`make_alias_table(probabilities)`で利用できるものとし、`draw_number(rng, alias_table)`でそこから乱数を取り出せるとします。

分布が次のように記述されるとします。

```julia
struct DiscreteDistribution{V <: AbstractVector}
    probabilities::V
end
```

また、必要な値の個数にかかわらず、*常に*エイリアステーブルを構築したいとします（この後、カスタマイズ方法を説明します）。次のメソッドを定義して、

```julia
Random.eltype(::Type{<:DiscreteDistribution}) = Int

function Random.Sampler(::Type{<:AbstractRNG}, distribution::DiscreteDistribution, ::Repetition)
    SamplerSimple(distribution, make_alias_table(distribution.probabilities))
end
```

事前計算データを持つサンプラーを返すようにします。その後、

```julia
function rand(rng::AbstractRNG, sp::SamplerSimple{<:DiscreteDistribution})
    draw_number(rng, sp.data)
end
```

を使って値を取り出します。

#### Custom sampler types

事前計算データを扱う用途のほとんどでは、`SamplerSimple`型で十分です。ただし、独自のサンプラー型の使い方を示すため、ここでは`SamplerSimple`に似たものを実装します。

先ほどの`Die`の例に戻ります。`rand(::Die)`は範囲から乱数を生成するため、この最適化を適用できます。独自のサンプラーを`SamplerDie`と名付けます。

```julia
import Random: Sampler, rand

struct SamplerDie <: Sampler{Int} # generates values of type Int
    die::Die
    sp::Sampler{Int} # this is an abstract type, so this could be improved
end

Sampler(RNG::Type{<:AbstractRNG}, die::Die, r::Random.Repetition) =
    SamplerDie(die, Sampler(RNG, 1:die.nsides, r))
# the `r` parameter will be explained later on

rand(rng::AbstractRNG, sp::SamplerDie) = rand(rng, sp.sp)
```

これで、`sp = Sampler(rng, die)`を使ってサンプラーを取得し、`rng`を含む任意の`rand`呼び出しで、`die`の代わりに`sp`を使えます。上の単純な例では、`die`を`SamplerDie`に格納する必要はありませんが、実際にはそうすることがよくあります。

もちろん、このパターンは非常によく使われるため、上で使ったヘルパー型`Random.SamplerSimple`が用意されています。これを使えば、`SamplerDie`を定義する必要はありません。次のようにして、事前計算と生成を分離できます。

```julia
Sampler(RNG::Type{<:AbstractRNG}, die::Die, r::Random.Repetition) =
    SamplerSimple(die, Sampler(RNG, 1:die.nsides, r))

rand(rng::AbstractRNG, sp::SamplerSimple{Die}) = rand(rng, sp.data)
```

ここで`sp.data`は、`SamplerSimple`コンストラクターの呼び出しにおける2番目のパラメーター（この場合は`Sampler(rng, 1:die.nsides, r)`）を指します。`Die`オブジェクトには、`sp[]`からアクセスできます。

`SamplerDie`と同様に、独自のサンプラーはすべて`Sampler{T}`のサブタイプでなければなりません。ここで`T`は生成される値の型です。`SamplerSimple(x, data) isa Sampler{eltype(x)}`であるため、`SamplerSimple`の第1引数に指定できる型には制約があります（`Die`の例のように、`SamplerSimple`を使うことを推奨します。この例では、`x`をそのまま転送しながら`Sampler`メソッドを定義しています）。同様に、`SamplerTrivial(x) isa Sampler{eltype(x)}`です。

ほかのケース向けには、`Random.SamplerTag`というヘルパー型も用意されています。ただし、これは内部APIとみなされており、適切な非推奨化の手続きを経ずにいつでも変更される可能性があります。

#### Using distinct algorithms for scalar or array generation

生成する値が少数か多数かによって、アルゴリズムの選択が変わる場合があります。これは`Sampler`コンストラクターの第3パラメーターで扱います。`Die`用に、少数の乱数値の生成に使う`SamplerDie1`と、多数の値の生成に使う`SamplerDieMany`という2つのヘルパー型を定義したとします。これらの型は次のように使えます。

```julia
Sampler(RNG::Type{<:AbstractRNG}, die::Die, ::Val{1}) = SamplerDie1(...)
Sampler(RNG::Type{<:AbstractRNG}, die::Die, ::Val{Inf}) = SamplerDieMany(...)
```

もちろん、これらの型に対しても`rand`を定義する必要があります（つまり、`rand(::AbstractRNG, ::SamplerDie1)`と`rand(::AbstractRNG, ::SamplerDieMany)`です）。通常どおり、独自の型が不要なら`SamplerTrivial`と`SamplerSimple`を使えます。

注: `Sampler(rng, x)`は`Sampler(rng, x, Val(Inf))`の略記であり、`Random.Repetition`は`Union{Val{1}, Val{Inf}}`の別名です。

### Creating new generators

APIはまだ明確に定義されていませんが、目安として次の点に従ってください。

1. 「基本」型（`Base`における`isbitstype`整数型および浮動小数点型）を生成する`rand`メソッドは、必要に応じて、このRNG専用に定義してください。
2. `AbstractRNG`を受け取る、ドキュメント化されたほかの`rand`メソッドは、1)で依存するメソッドが実装されていれば、そのまま動作するはずです。ただし、最適化の余地があれば、このRNG向けに特化してもかまいません。
3. 疑似RNGに対する`copy`は、呼び出し時点から元のRNGとまったく同じ乱数列を、同じ方法で生成する独立したコピーを返す必要があります。これが実現できない場合（ハードウェアベースのRNGなど）は、`copy`を実装してはいけません。

1)については、`rand`メソッドが偶然そのまま動作する場合もありますが、公式にはサポートされていません。今後のリリースで警告なく動作しなくなる可能性があります。

仮想的な`MyRNG`生成器に対する新しい`rand`メソッドと、値指定`s`（例: `s == Int`または`s == 1:10`）を定義するには、`s`が型の場合、型`S==typeof(s)`または`S==Type{s}`に対して、先ほどと同じ2つのメソッドを定義する必要があります。

1. `Sampler(::Type{MyRNG}, ::S, ::Repetition)`。たとえば、型`SamplerS`のオブジェクトを返します。
2. `rand(rng::MyRNG, sp::SamplerS)`

`Sampler(rng::AbstractRNG, ::S, ::Repetition)`が、すでに`Random`モジュールで定義されている場合もあります。その場合、実際には手順1)を省略して（この特定のRNG型向けに生成を特化したい場合）、対応する`SamplerS`型を使うこともできます。ただし、この型は内部実装の詳細とみなされており、予告なく変更される可能性があります。

#### Specializing array generation

RNG型によっては、事前計算と生成の分離を使うより、専用メソッドで乱数配列を生成するほうが効率的な場合があります。たとえば`MersenneTwister`は、配列に乱数値を直接書き込みます。

`MyRNG`と指定`s`に対してこの特化を実装し、型`S`の要素を生成するには、次のメソッドを定義できます: `rand!(rng::MyRNG, a::AbstractArray{S}, ::SamplerS)`。ここで`SamplerS`は、`Sampler(MyRNG, s, Val(Inf))`が返すサンプラーの型です。`AbstractArray`ではなく、そのサブタイプ（例: `Array{S}`）に対してのみ機能を実装することもできます。`rand`の非変更配列メソッドは、内部でこの特化メソッドを自動的に呼び出します。

```@meta
DocTestSetup = nothing
```

# Reproducibility

指定したシードで初期化したRNGを使えば、プログラムを複数回実行しても同じ疑似乱数列を再現できます。ただし、Juliaのマイナーリリース（例: 1.3から1.4）によって、特定のシードから生成される疑似乱数列が*変わることがあります*。（[`rand`](@ref)のような低レベル関数が生成する列に変更がなくても、アルゴリズムの更新によって、[`randsubseq`](@ref)のような高レベル関数の出力が変わる場合があります。）その理由は、疑似乱数ストリームが決して変わらないことを保証すると、アルゴリズムの改善が大きく制限されるためです。

乱数データの完全な再現性を保証する必要がある場合は、データをそのまま保存することをお勧めします（例: 科学論文の補足資料として添付する）。もちろん、ビット単位の再現性が必要なら、特定のJuliaバージョンとパッケージマニフェストを指定する方法もあります。

特定の「乱数」データに依存するソフトウェアテストでは、通常、データを保存するか、テストコードに埋め込むか、[StableRNGs.jl](https://github.com/JuliaRandom/StableRNGs.jl)のようなサードパーティパッケージを使ってください。一方、*ほとんどの*乱数データで成功すべきテスト（例: ランダム行列`A = randn(n,n)`に対する`A \ (A*x) ≈ x`のテスト）では、固定シードのRNGを使うと、テストを何度も実行した際に、極めて起こりにくいデータ（たとえば、非常に悪条件な行列）が原因で失敗するのを防げます。

乱数サンプルが従う統計的な*分布*は、Juliaのどのマイナーリリース間でも同じであることが保証されています。
