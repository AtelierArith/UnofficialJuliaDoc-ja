# Dates

```@meta
DocTestSetup = :(using Dates)
```

`Dates` モジュールは、日付を扱うための2つの型、[`Date`](@ref) と [`DateTime`](@ref) を提供します。それぞれ日単位とミリ秒単位の精度を持ち、どちらも抽象型 [`TimeType`](@ref) のサブタイプです。型を分けている理由は単純です。より高い精度に伴う複雑さを扱わずに済めば、コードを書くうえでも、考え方のうえでも、はるかに簡単になる操作があるためです。たとえば、[`Date`](@ref) 型は日付単位の精度しか持たない（つまり時、分、秒を持たない）ため、通常必要となるタイムゾーン、夏時間、うるう秒への配慮が不要になり、これらを扱わずに済みます。

[`Date`](@ref) と [`DateTime`](@ref) は、基本的にはどちらも不変の [`Int64`](@ref) ラッパーです。どちらの型も、唯一のフィールド `instant` は実際には `UTInstant{P}` 型であり、UT秒に基づいて連続的に増加する、計算機上の時間軸を表します [^1]。[`DateTime`](@ref) 型はタイムゾーンを認識しません（Pythonの用語では *naive*）。これはJava 8の *LocalDateTime* に相当します。タイムゾーン機能を追加するには、[IANA time zone database](https://www.iana.org/time-zones) をコンパイルする [TimeZones.jl package](https://github.com/JuliaTime/TimeZones.jl/) を使用できます。[`Date`](@ref) と [`DateTime`](@ref) は、どちらも先発グレゴリオ暦に従う [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) 規格に基づいています。注意点として、ISO 8601規格では紀元前（BC/BCE）の日付に独特の扱いがあります。一般には、紀元前最後の日である紀元前1年12月31日の翌日は紀元1年1月1日とされ、0年は存在しません。しかし、ISO規格では紀元前1年を0年と定めているため、`0000-12-31` は `0001-01-01` の前日となり、`-0001` 年（年の値がマイナス1です）は紀元前2年、`-0002` 年は紀元前3年、というようになります。

[^1]: UT秒という概念は、実は非常に根本的なものです。一般に受け入れられている時間の概念には、基本的に2種類あります。1つは地球の物理的な自転に基づくもの（1回転 = 1日）、もう1つはSI秒（固定された一定の値）に基づくものです。この2つは根本的に異なります。地球の自転を基準に定義される「UT秒」は、日によって絶対的な長さが異なる可能性があるのです。いずれにせよ、[`Date`](@ref) と [`DateTime`](@ref) がUT秒に基づいているのは、うるう秒などに伴う複雑さを避けるための、単純化ではあっても理にかなった仮定です。この時間の基準は、正式には [UT](https://en.wikipedia.org/wiki/Universal_Time)、またはUT1と呼ばれます。型をUT秒に基づかせることは、基本的には1分が常に60秒、1日が常に24時間であることを意味し、暦の日付を扱う際により自然な計算ができるようになります。

## Constructors

[`Date`](@ref) 型と [`DateTime`](@ref) 型は、整数または [`Period`](@ref) 型の値から構築するほか、パースやアジャスター（後述）を使って構築できます。

```jldoctest
julia> DateTime(2013)
2013-01-01T00:00:00

julia> DateTime(2013,7)
2013-07-01T00:00:00

julia> DateTime(2013,7,1)
2013-07-01T00:00:00

julia> DateTime(2013,7,1,12)
2013-07-01T12:00:00

julia> DateTime(2013,7,1,12,30)
2013-07-01T12:30:00

julia> DateTime(2013,7,1,12,30,59)
2013-07-01T12:30:59

julia> DateTime(2013,7,1,12,30,59,1)
2013-07-01T12:30:59.001

julia> Date(2013)
2013-01-01

julia> Date(2013,7)
2013-07-01

julia> Date(2013,7,1)
2013-07-01

julia> Date(Dates.Year(2013),Dates.Month(7),Dates.Day(1))
2013-07-01

julia> Date(Dates.Month(7),Dates.Year(2013))
2013-07-01
```

[`Date`](@ref) または [`DateTime`](@ref) のパースには、書式文字列を使用します。書式文字列では、パースする時間単位を格納する「スロット」を、*区切り文字付き*または*固定幅*として定義します。パース対象のテキストと書式文字列を、`Date("2015-01-01",dateformat"y-m-d")` または `DateTime("20150101",dateformat"yyyymmdd")` の形式で [`Date`](@ref) または [`DateTime`](@ref) のコンストラクターに渡します。

区切り文字付きスロットは、連続する2つの時間単位の間にパーサーが想定する区切り文字を指定することで定義します。たとえば `"y-m-d"` は、`"2014-07-16"` のような日付文字列の最初と2番目のスロットの間に、`-` という文字があることをパーサーに伝えます。`y`、`m`、`d` という文字は、それぞれのスロットでどの時間単位をパースするかを示します。

上記の `Date(2013)` などのコンストラクターと同様に、区切り文字付きの `DateFormat` では、前の部分が指定されていれば、日付や時刻の後続部分を省略できます。省略した部分には通常のデフォルト値が使われます。たとえば、`Date("1981-03", dateformat"y-m-d")` は `1981-03-01` を返し、`Date("31/12", dateformat"d/m/y")` は `0001-12-31` を返します。（年のデフォルト値は紀元1年であることに注意してください。）ただし、空文字列を渡すと、常に `ArgumentError` が送出されます。

固定幅スロットは、時間単位を表す文字を、区切り文字を挟まずに幅に相当する回数だけ繰り返して指定します。したがって、`dateformat"yyyymmdd"` は `"20140716"` のような日付文字列に対応します。パーサーは、区切り文字がないことと、ある時間単位の文字から次の時間単位の文字への切り替わり `"yyyymm"` によって、固定幅スロットを識別します。

月名のテキストをパースすることもでき、略称には `u`、正式名には `U` という文字を使用します。デフォルトでは英語の月名だけがサポートされるため、`u` は「Jan」「Feb」「Mar」などに、`U` は「January」「February」「March」などに対応します。名前から値へのマッピングを行う他の関数 [`dayname`](@ref) や [`monthname`](@ref) と同様に、カスタムロケールを読み込むこともできます。そのためには、月名の略称と正式名のそれぞれについて、`locale=>Dict{String,Int}` のマッピングを `MONTHTOVALUEABBR` と `MONTHTOVALUE` の辞書に渡します。

上記の例では、`dateformat""` 文字列マクロを使用しました。このマクロは、マクロ展開時に `DateFormat` オブジェクトを一度だけ作成し、コード片が複数回実行されても同じ `DateFormat` オブジェクトを使用します。

```jldoctest
julia> for i = 1:10^5
           Date("2015-01-01", dateformat"y-m-d")
       end
```

DateFormatオブジェクトを明示的に作成することもできます。

```jldoctest
julia> df = DateFormat("y-m-d");

julia> dt = Date("2015-01-01",df)
2015-01-01

julia> dt2 = Date("2015-01-02",df)
2015-01-02
```

または、ブロードキャストを使用できます。

```jldoctest
julia> years = ["2015", "2016"];

julia> Date.(years, DateFormat("yyyy"))
2-element Vector{Date}:
 2015-01-01
 2016-01-01
```

利便性のために、書式文字列を直接渡すこともできます（例：`Date("2015-01-01","y-m-d")`）。ただし、この形式では内部で毎回新しい `DateFormat` オブジェクトが作成されるため、同じ書式で繰り返しパースする場合には性能上のコストが発生します。

コンストラクターに加え、[`parse`](@ref) 関数と [`tryparse`](@ref) 関数を使って文字列から `Date` または `DateTime` を構築することもできます。これらの関数では、書式を指定する `DateFormat` 型の第3引数を任意で渡せます。たとえば `parse(Date, "06.23.2013", dateformat"m.d.y")`、またはデフォルトの書式を使う `tryparse(DateTime, "1999-12-31T23:59:59")` のように呼び出します。両関数の重要な違いは、[`tryparse`](@ref) では文字列が空または無効な書式であってもエラーを送出せず、代わりに `nothing` を返すことです。

!!! compat "Julia 1.9"
    Julia 1.9より前では、コンストラクターや `parse` に空文字列を渡してもエラーにはならず、呼び出しに応じて `DateTime(1)`、`Date(1)`、または `Time(0)` が返されていました。同様に、`tryparse` は `nothing` を返しませんでした。


パースと書式設定のテストおよび例の一式は、[`stdlib/Dates/test/io.jl`](https://github.com/JuliaLang/julia/blob/master/stdlib/Dates/test/io.jl) にあります。

## Durations/Comparisons

2つの [`Date`](@ref) または [`DateTime`](@ref) の間の時間の長さは、それぞれが内部で `UTInstant{Day}` と `UTInstant{Millisecond}` として表現されているため、簡単に求められます。[`Date`](@ref) の差は [`Day`](@ref) の数として、[`DateTime`](@ref) の差は [`Millisecond`](@ref) の数として返されます。同様に、[`TimeType`](@ref) の比較も、内部の計算機上の時点を比較するだけです（最終的には内部の [`Int64`](@ref) 値を比較します）。

```jldoctest
julia> dt = Date(2012,2,29)
2012-02-29

julia> dt2 = Date(2000,2,1)
2000-02-01

julia> dump(dt)
Date
  instant: Dates.UTInstant{Day}
    periods: Day
      value: Int64 734562

julia> dump(dt2)
Date
  instant: Dates.UTInstant{Day}
    periods: Day
      value: Int64 730151

julia> dt > dt2
true

julia> dt != dt2
true

julia> dt + dt2
ERROR: MethodError: no method matching +(::Date, ::Date)
[...]

julia> dt * dt2
ERROR: MethodError: no method matching *(::Date, ::Date)
[...]

julia> dt / dt2
ERROR: MethodError: no method matching /(::Date, ::Date)

julia> dt - dt2
4411 days

julia> dt2 - dt
-4411 days

julia> dt = DateTime(2012,2,29)
2012-02-29T00:00:00

julia> dt2 = DateTime(2000,2,1)
2000-02-01T00:00:00

julia> dt - dt2
381110400000 milliseconds
```

## Accessor Functions

[`Date`](@ref) 型と [`DateTime`](@ref) 型は単一の [`Int64`](@ref) 値として格納されているため、日付の各部分やフィールドはアクセサー関数で取得できます。小文字のアクセサーは、フィールドを整数として返します。

```jldoctest tdate
julia> t = Date(2014, 1, 31)
2014-01-31

julia> Dates.year(t)
2014

julia> Dates.month(t)
1

julia> Dates.week(t)
5

julia> Dates.day(t)
31
```

一方、先頭が大文字のアクセサーは、同じ値を対応する [`Period`](@ref) 型で返します。

```jldoctest tdate
julia> Dates.Year(t)
2014 years

julia> Dates.Day(t)
31 days
```

複数のフィールドを個別に取得するよりも、一度に取得したほうが効率がよいため、複合メソッドが用意されています。

```jldoctest tdate
julia> Dates.yearmonth(t)
(2014, 1)

julia> Dates.monthday(t)
(1, 31)

julia> Dates.yearmonthday(t)
(2014, 1, 31)
```

内部の `UTInstant` や整数値にアクセスすることもできます。

```jldoctest tdate
julia> dump(t)
Date
  instant: Dates.UTInstant{Day}
    periods: Day
      value: Int64 735264

julia> t.instant
Dates.UTInstant{Day}(Day(735264))

julia> Dates.value(t)
735264
```

## Query Functions

クエリー関数は、[`TimeType`](@ref) に関する暦の情報を提供します。たとえば、曜日に関する情報を取得できます。

```jldoctest tdate2
julia> t = Date(2014, 1, 31)
2014-01-31

julia> Dates.dayofweek(t)
5

julia> Dates.dayname(t)
"Friday"

julia> Dates.dayofweekofmonth(t) # 5th Friday of January
5
```

月に関する情報：

```jldoctest tdate2
julia> Dates.monthname(t)
"January"

julia> Dates.daysinmonth(t)
31
```

また、[`TimeType`](@ref) の年や四半期に関する情報も取得できます。

```jldoctest tdate2
julia> Dates.isleapyear(t)
false

julia> Dates.dayofyear(t)
31

julia> Dates.quarterofyear(t)
1

julia> Dates.dayofquarter(t)
31
```

[`dayname`](@ref) メソッドと [`monthname`](@ref) メソッドには、省略可能なキーワード引数 `locale` を渡すこともでき、他の言語やロケールの曜日名や月名を返すために使用できます。これらの関数には略称を返すバージョンもあり、それぞれ [`dayabbr`](@ref) と [`monthabbr`](@ref) です。まず、マッピングを `LOCALES` 変数に読み込みます。

```jldoctest tdate2
julia> french_months = ["janvier", "février", "mars", "avril", "mai", "juin",
                        "juillet", "août", "septembre", "octobre", "novembre", "décembre"];

julia> french_months_abbrev = ["janv","févr","mars","avril","mai","juin",
                              "juil","août","sept","oct","nov","déc"];

julia> french_days = ["lundi","mardi","mercredi","jeudi","vendredi","samedi","dimanche"];

julia> Dates.LOCALES["french"] = Dates.DateLocale(french_months, french_months_abbrev, french_days, [""]);
```

その後、上記の関数を使用して情報を取得できます。

```jldoctest tdate2
julia> Dates.dayname(t;locale="french")
"vendredi"

julia> Dates.monthname(t;locale="french")
"janvier"

julia> Dates.monthabbr(t;locale="french")
"janv"
```

曜日の略称は読み込んでいないため、`dayabbr` 関数を使おうとするとエラーが送出されます。

```jldoctest tdate2
julia> Dates.dayabbr(t;locale="french")
ERROR: BoundsError: attempt to access 1-element Vector{String} at index [5]
Stacktrace:
[...]
```

## TimeType-Period Arithmetic

どの言語や日付フレームワークを使う場合でも、日付と期間の演算がどのように処理されるかを理解しておくのはよい習慣です。対処すべき [tricky issues](https://codeblog.jonskeet.uk/2010/12/01/the-joys-of-date-time-arithmetic/) がいくつかあるためです（ただし、日単位の精度を持つ型では、はるかに少なくなります）。

`Dates` モジュールでは、[`Period`](@ref) の演算を行う際に、変更をできるだけ少なくするという単純な原則に従おうとしています。この方法は*暦に基づく演算*とも呼ばれ、会話の中で同じ計算を尋ねられたときに、おそらく直感的に思い浮かべる計算方法です。なぜこれが問題になるのでしょうか。典型的な例として、2014年1月31日に1か月を足してみましょう。答えは何になるでしょうか。Javascriptでは [March 3](https://markhneedham.com/blog/2009/01/07/javascript-add-a-month-to-a-date/)（31日と仮定）、PHPでは [March 2](https://stackoverflow.com/questions/5760262/php-adding-months-to-a-date-while-not-exceeding-the-last-day-of-the-month)（30日と仮定）になります。実際には、唯一の正解はありません。`Dates` モジュールでは、結果は2月28日です。これはどのように決まるのでしょうか。カジノでおなじみの、7-7-7をそろえるスロットマシンを考えてみてください。

7-7-7の代わりに、各スロットが年・月・日、つまりこの例では2014-01-31を表すと想像してください。この日付に1か月を足すと、月のスロットが増加し、2014-02-31になります。次に、日の数値が新しい月の最後の有効な日を超えていないかを確認します。超えていれば（上の例がそうです）、日の数値を最後の有効な日（28）まで引き下げます。この方法にはどのような影響があるでしょうか。この日付にもう1か月足してみましょう。結果は `2014-02-28 + Month(1) == 2014-03-28` です。3月の最終日になると思いましたか。残念ながらそうはなりません。7-7-7のスロットを思い出してください。変更するスロットをできるだけ少なくするので、まず月のスロットを1増やして2014-03-28とし、これは有効な日付なので、そこで完了します。一方、元の日付2014-01-31に2か月を足すと、予想どおり2014-03-31になります。この方法のもう1つの影響は、特定の順序を強制すると結合則が成り立たなくなることです（つまり、足す順序を変えると結果が異なります）。たとえば、次のようになります。

```jldoctest
julia> (Date(2014,1,29)+Dates.Day(1)) + Dates.Month(1)
2014-02-28

julia> (Date(2014,1,29)+Dates.Month(1)) + Dates.Day(1)
2014-03-01
```

ここでは何が起きているのでしょうか。最初の行では、1月29日に1日を足して2014-01-30とし、次に1か月を足して2014-02-30とした後、2014-02-28に切り下げています。2番目の例では、*先に*1か月を足して2014-02-29とし、それを2014-02-28に切り下げ、*その後で*1日を足して2014-03-01としています。このような場合に役立つ設計原則として、複数のPeriodがあるときには、その値や位置の順序ではなく、Periodの*型*によって演算順序を決めるというものがあります。つまり、常に `Year` を最初に足し、次に `Month`、その次に `Week`、という順序になります。そのため、次の例では結合則が*成り立ち*、期待どおりに動作します。

```jldoctest
julia> Date(2014,1,29) + Dates.Day(1) + Dates.Month(1)
2014-03-01

julia> Date(2014,1,29) + Dates.Month(1) + Dates.Day(1)
2014-03-01
```

ややこしいでしょうか。そうかもしれません。では、普通の `Dates` ユーザーはどうすればよいのでしょうか。要点は、月を扱うときに演算の結合順序を明示的に強制すると、予期しない結果になる場合があると認識しておくことです。それ以外は、期待どおりに動くはずです。幸い、UTで時間を扱う場合、日付と期間の演算における特殊なケースは、おおむねこれで尽きます（夏時間やうるう秒などを扱う「楽しさ」は避けられます）。

さらに、期間演算のオブジェクトはすべて、範囲と直接組み合わせて使えます。

```jldoctest
julia> dr = Date(2014,1,29):Day(1):Date(2014,2,3)
Date("2014-01-29"):Day(1):Date("2014-02-03")

julia> collect(dr)
6-element Vector{Date}:
 2014-01-29
 2014-01-30
 2014-01-31
 2014-02-01
 2014-02-02
 2014-02-03

julia> dr = Date(2014,1,29):Dates.Month(1):Date(2014,07,29)
Date("2014-01-29"):Month(1):Date("2014-07-29")

julia> collect(dr)
7-element Vector{Date}:
 2014-01-29
 2014-02-28
 2014-03-29
 2014-04-29
 2014-05-29
 2014-06-29
 2014-07-29
```

## Adjuster Functions

日付と期間の演算は便利ですが、日付に対して必要となる計算は、固定された期間の数というより、*暦*や*時間的な規則*に基づくものであることがよくあります。祝日はその典型です。多くの祝日は「メモリアルデー = 5月の最後の月曜日」や「感謝祭 = 11月の第4木曜日」といった規則に従っています。このような時間的な表現は、月の初日や末日、次の火曜日、第1および第3水曜日など、暦に対する相対的な規則を扱います。

`Dates` モジュールは、時間に関する規則を簡単かつ簡潔に表現するための便利なメソッド群を通じて、*アジャスター*APIを提供しています。最初のアジャスターメソッド群は、週、月、四半期、年の最初と最後を扱います。それぞれ、単一の [`TimeType`](@ref) を入力として受け取り、入力を基準とした目的の期間の最初または最後を返します。言い換えれば、その日付に*調整*します。

```jldoctest
julia> Dates.firstdayofweek(Date(2014,7,16)) # Adjusts the input to the Monday of the input's week
2014-07-14

julia> Dates.lastdayofmonth(Date(2014,7,16)) # Adjusts to the last day of the input's month
2014-07-31

julia> Dates.lastdayofquarter(Date(2014,7,16)) # Adjusts to the last day of the input's quarter
2014-09-30
```

次の2つの高階メソッド [`tonext`](@ref) と [`toprev`](@ref) は、第1引数として `DateFunction` を、あわせて開始点となる [`TimeType`](@ref) を受け取ることで、時間的な表現の扱いを一般化します。`DateFunction` は単なる関数（通常は無名関数）で、単一の [`TimeType`](@ref) を入力として受け取り、[`Bool`](@ref) を返します。`true` は調整条件を満たしたことを示します。たとえば、次のように使います。

```jldoctest
julia> istuesday = x->Dates.dayofweek(x) == Dates.Tuesday; # Returns true if the day of the week of x is Tuesday

julia> Dates.tonext(istuesday, Date(2014,7,13)) # 2014-07-13 is a Sunday
2014-07-15

julia> Dates.tonext(Date(2014,7,13), Dates.Tuesday) # Convenience method provided for day of the week adjustments
2014-07-15
```

より複雑な時間的表現には、doブロック構文と組み合わせると便利です。

```jldoctest
julia> Dates.tonext(Date(2014,7,13)) do x
           # Return true on the 4th Thursday of November (Thanksgiving)
           Dates.dayofweek(x) == Dates.Thursday &&
           Dates.dayofweekofmonth(x) == 4 &&
           Dates.month(x) == Dates.November
       end
2014-11-27
```

[`Base.filter`](@ref) メソッドを使うと、指定した範囲内で条件に合うすべての日付や時点を取得できます。

```jldoctest
# Pittsburgh street cleaning; Every 2nd Tuesday from April to November
# Date range from January 1st, 2014 to January 1st, 2015
julia> dr = Dates.Date(2014):Day(1):Dates.Date(2015);

julia> filter(dr) do x
           Dates.dayofweek(x) == Dates.Tue &&
           Dates.April <= Dates.month(x) <= Dates.Nov &&
           Dates.dayofweekofmonth(x) == 2
       end
8-element Vector{Date}:
 2014-04-08
 2014-05-13
 2014-06-10
 2014-07-08
 2014-08-12
 2014-09-09
 2014-10-14
 2014-11-11
```

その他の例やテストは、[`stdlib/Dates/test/adjusters.jl`](https://github.com/JuliaLang/julia/blob/master/stdlib/Dates/test/adjusters.jl) にあります。

## Period Types

期間とは、離散的で、ときには長さが不規則な時間のまとまりを、人間の視点で捉えたものです。1か月を考えてみましょう。日数に換算すると、年や月によって28、29、30、31のいずれにもなります。また、1年は365日ですが、うるう年には366日になります。[`Period`](@ref) 型は単純な [`Int64`](@ref) ラッパーであり、`Int64` に変換可能な任意の型の値をラップして構築します。たとえば、`Year(1)` や `Month(3.0)` のようにします。同じ型の [`Period`](@ref) 同士の演算は整数と同様に動作し、`Period-Real` の演算も限定的に利用できます。内部の整数は [`Dates.value`](@ref) で取り出せます。

```jldoctest
julia> y1 = Dates.Year(1)
1 year

julia> y2 = Dates.Year(2)
2 years

julia> y3 = Dates.Year(10)
10 years

julia> y1 + y2
3 years

julia> div(y3,y2)
5

julia> y3 - y2
8 years

julia> y3 % y2
0 years

julia> div(y3,3) # mirrors integer division
3 years

julia> Dates.value(Dates.Millisecond(10))
10
```

基本型の整数倍では表せない期間や時間の長さは、[`Dates.CompoundPeriod`](@ref) 型で表現できます。複合期間は、単純な [`Period`](@ref) 型から手動で構築できます。また、[`canonicalize`](@ref) 関数を使うと、期間を分解して [`Dates.CompoundPeriod`](@ref) に変換できます。これは、たとえば2つの `DateTime` の差のような時間の長さを、より扱いやすい表現に変換する際に特に便利です。

```jldoctest
julia> cp = Dates.CompoundPeriod(Day(1),Minute(1))
1 day, 1 minute

julia> t1 = DateTime(2018,8,8,16,58,00)
2018-08-08T16:58:00

julia> t2 = DateTime(2021,6,23,10,00,00)
2021-06-23T10:00:00

julia> canonicalize(t2-t1) # creates a CompoundPeriod
149 weeks, 6 days, 17 hours, 2 minutes
```

## Rounding

[`Date`](@ref) と [`DateTime`](@ref) の値は、[`floor`](@ref)、[`ceil`](@ref)、または [`round`](@ref) を使って、指定した分解能（たとえば1か月や15分）に丸めることができます。

```jldoctest
julia> floor(Date(1985, 8, 16), Dates.Month)
1985-08-01

julia> ceil(DateTime(2013, 2, 13, 0, 31, 20), Dates.Minute(15))
2013-02-13T00:45:00

julia> round(DateTime(2016, 8, 6, 20, 15), Dates.Day)
2016-08-07T00:00:00
```

数値の [`round`](@ref) メソッドは、等距離の場合にはデフォルトで偶数側に丸めますが、[`TimeType`](@ref)[`round`](@ref) メソッドでは、丸めモード `RoundNearestTiesUp` を使用します。（最も近い「偶数」の [`TimeType`](@ref) に丸めるとは何を意味するのか、想像しにくいでしょう。）利用可能な `RoundingMode` の詳細は、[API reference](@ref stdlib-dates-api) を参照してください。

丸めは通常、期待どおりに動作するはずですが、期待される動作が明らかでないケースもいくつかあります。

### Rounding Epoch

多くの場合、丸めの分解能として指定する期間（たとえば `Dates.Second(30)`）は、その1つ上の大きさの期間（この場合は `Dates.Minute(1)`）を割り切ります。しかし、そうでない場合の丸めの動作は、混乱を招くことがあります。[`DateTime`](@ref) を最も近い10時間単位に丸めると、どのような結果になるでしょうか。

```jldoctest
julia> round(DateTime(2016, 7, 17, 11, 55), Dates.Hour(10))
2016-07-17T12:00:00
```

時の値（12）は10で割り切れないため、不思議に思えるかもしれません。`2016-07-17T12:00:00` が選ばれた理由は、それが `0000-01-01T00:00:00` から17,676,660時間後であり、17,676,660は10で割り切れるからです。

Juliaの [`Date`](@ref) と [`DateTime`](@ref) の値はISO 8601規格に従って表現されるため、丸め計算に使う日数（およびミリ秒数）のカウントを始める基準点（「丸めのエポック」）には `0000-01-01T00:00:00` が選ばれています。（これは、[Rata Die notation](https://en.wikipedia.org/wiki/Rata_Die) を使用するJulia内部の [`Date`](@ref) の表現とは少し異なることに注意してください。ただし、エンドユーザーにとってはISO 8601規格が最も目に触れるため、混乱を最小限に抑えるよう、内部で使用する `0000-12-31T00:00:00` ではなく `0000-01-01T00:00:00` を丸めのエポックに選んでいます。）

丸めのエポックとして `0000-01-01T00:00:00` を使わない唯一の例外は、週単位に丸める場合です。最も近い週に丸めると、常に月曜日（ISO 8601で規定された週の最初の日）が返されます。そのため、週数を指定して丸める場合には、`0000-01-03T00:00:00`（ISO 8601で定義された0000年の最初の週の初日）を基準にします。

関連する例として、期待される動作が必ずしも明らかでないケースをもう1つ示します。`P` が [`Period`](@ref) 型であるとき、最も近い `P(2)` に丸めるとどうなるでしょうか。場合によっては（具体的には `P <: Dates.TimePeriod` のとき）、答えは明らかです。

```jldoctest
julia> round(DateTime(2016, 7, 17, 8, 55, 30), Dates.Hour(2))
2016-07-17T08:00:00

julia> round(DateTime(2016, 7, 17, 8, 55, 30), Dates.Minute(2))
2016-07-17T08:56:00
```

これらの期間は、それぞれの2倍の長さでも、1つ上の大きさの期間を割り切るため、結果は自然に見えます。しかし、2か月の場合は（これも1年を割り切りますが）、意外な答えになるかもしれません。

```jldoctest
julia> round(DateTime(2016, 7, 17, 8, 55, 30), Dates.Month(2))
2016-07-01T00:00:00
```

7月は7番目の月（奇数）なのに、なぜ7月1日に丸められるのでしょうか。重要なのは、月は1始まり（最初の月に1を割り当てる）であり、時、分、秒、ミリ秒（いずれも最初の値は0）とは異なることです。

つまり、[`DateTime`](@ref) を秒、分、時、または年の偶数倍に丸めると（ISO 8601の仕様には0年が含まれるため）、そのフィールドの値が偶数の [`DateTime`](@ref) が得られます。一方、[`DateTime`](@ref) を月の偶数倍に丸めると、月フィールドは奇数になります。月も年も含まれる日数が一定ではないため、偶数の日数に丸めた結果、日フィールドが偶数になるかどうかは一概にはいえません。

`Dates` モジュールからエクスポートされるメソッドの詳細は、[API reference](@ref stdlib-dates-api) を参照してください。

## [API reference](@id stdlib-dates-api)

### Dates and Time Types

```@docs
Dates.Period
Dates.CompoundPeriod
Dates.Instant
Dates.UTInstant
Dates.TimeType
Dates.DateTime
Dates.Date
Dates.Time
Dates.TimeZone
Dates.UTC
```

### Dates Functions

```@docs
Dates.DateTime(::Int64, ::Int64, ::Int64, ::Int64, ::Int64, ::Int64, ::Int64)
Dates.DateTime(::Dates.Period)
Dates.DateTime(::Function, ::Any...)
Dates.DateTime(::Dates.TimeType)
Dates.DateTime(::AbstractString, ::AbstractString)
Dates.format(::Dates.TimeType, ::AbstractString)
Dates.DateFormat
Dates.@dateformat_str
Dates.DateTime(::AbstractString, ::Dates.DateFormat)
Dates.Date(::Int64, ::Int64, ::Int64)
Dates.Date(::Dates.Period)
Dates.Date(::Function, ::Any, ::Any, ::Any)
Dates.Date(::Dates.TimeType)
Dates.Date(::AbstractString, ::AbstractString)
Dates.Date(::AbstractString, ::Dates.DateFormat)
Dates.Time(::Int64::Int64, ::Int64, ::Int64, ::Int64, ::Int64)
Dates.Time(::Dates.TimePeriod)
Dates.Time(::Function, ::Any...)
Dates.Time(::Dates.DateTime)
Dates.Time(::AbstractString, ::AbstractString)
Dates.Time(::AbstractString, ::Dates.DateFormat)
Dates.now()
Dates.now(::Type{Dates.UTC})
Base.eps(::Union{Type{DateTime}, Type{Date}, Type{Time}, TimeType})
```

#### Accessor Functions

```@docs
Dates.year
Dates.month
Dates.week
Dates.day
Dates.hour
Dates.minute
Dates.second
Dates.millisecond
Dates.microsecond
Dates.nanosecond
Dates.Year(::Dates.TimeType)
Dates.Month(::Dates.TimeType)
Dates.Week(::Dates.TimeType)
Dates.Day(::Dates.TimeType)
Dates.Hour(::DateTime)
Dates.Minute(::DateTime)
Dates.Second(::DateTime)
Dates.Millisecond(::DateTime)
Dates.Microsecond(::Dates.Time)
Dates.Nanosecond(::Dates.Time)
Dates.yearmonth
Dates.monthday
Dates.yearmonthday
```

#### Query Functions

```@docs
Dates.dayname
Dates.dayabbr
Dates.dayofweek
Dates.dayofmonth
Dates.dayofweekofmonth
Dates.daysofweekinmonth
Dates.monthname
Dates.monthabbr
Dates.daysinmonth
Dates.isleapyear
Dates.dayofyear
Dates.daysinyear
Dates.quarterofyear
Dates.dayofquarter
```

#### Adjuster Functions

```@docs
Base.trunc(::Dates.TimeType, ::Type{Dates.Period})
Dates.firstdayofweek
Dates.lastdayofweek
Dates.firstdayofmonth
Dates.lastdayofmonth
Dates.firstdayofyear
Dates.lastdayofyear
Dates.firstdayofquarter
Dates.lastdayofquarter
Dates.tonext(::Dates.TimeType, ::Int)
Dates.toprev(::Dates.TimeType, ::Int)
Dates.tofirst
Dates.tolast
Dates.tonext(::Function, ::Dates.TimeType)
Dates.toprev(::Function, ::Dates.TimeType)
```

#### Periods

```@docs
Dates.Period(::Any)
Dates.CompoundPeriod(::Vector{<:Dates.Period})
Dates.canonicalize
Dates.value
Dates.default
Dates.periods
```

#### Rounding Functions

`Date` と `DateTime` の値は、`floor`、`ceil`、または `round` を使って、指定した分解能（たとえば1か月や15分）に丸めることができます。

```@docs
Base.floor(::Dates.TimeType, ::Dates.Period)
Base.ceil(::Dates.TimeType, ::Dates.Period)
Base.round(::Dates.TimeType, ::Dates.Period, ::RoundingMode{:NearestTiesUp})
```

ほとんどの `Period` 値も、指定した分解能に丸めることができます。

```@docs
Base.floor(::Dates.ConvertiblePeriod, ::T) where T <: Dates.ConvertiblePeriod
Base.ceil(::Dates.ConvertiblePeriod, ::Dates.ConvertiblePeriod)
Base.round(::Dates.ConvertiblePeriod, ::Dates.ConvertiblePeriod, ::RoundingMode{:NearestTiesUp})
```

次の関数はエクスポートされていません。

```@docs
Dates.floorceil
Dates.epochdays2date
Dates.epochms2datetime
Dates.date2epochdays
Dates.datetime2epochms
```

#### Conversion Functions

```@docs
Dates.today
Dates.unix2datetime
Dates.datetime2unix
Dates.julian2datetime
Dates.datetime2julian
Dates.rata2datetime
Dates.datetime2rata
```

### Constants

曜日：

| 変数          | 略称    | 値 (Int) |
|:----------- |:----- |:------- |
| `Monday`    | `Mon` | 1       |
| `Tuesday`   | `Tue` | 2       |
| `Wednesday` | `Wed` | 3       |
| `Thursday`  | `Thu` | 4       |
| `Friday`    | `Fri` | 5       |
| `Saturday`  | `Sat` | 6       |
| `Sunday`    | `Sun` | 7       |

月：

| 変数          | 略称    | 値 (Int) |
|:----------- |:----- |:------- |
| `January`   | `Jan` | 1       |
| `February`  | `Feb` | 2       |
| `March`     | `Mar` | 3       |
| `April`     | `Apr` | 4       |
| `May`       | `May` | 5       |
| `June`      | `Jun` | 6       |
| `July`      | `Jul` | 7       |
| `August`    | `Aug` | 8       |
| `September` | `Sep` | 9       |
| `October`   | `Oct` | 10      |
| `November`  | `Nov` | 11      |
| `December`  | `Dec` | 12      |

#### Common Date Formatters

```@docs
ISODateTimeFormat
ISODateFormat
ISOTimeFormat
RFC1123Format
```

```@meta
DocTestSetup = nothing
```
