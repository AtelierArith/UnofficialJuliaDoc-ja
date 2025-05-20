# Dates

```@meta
DocTestSetup = :(using Dates)
```

`Dates` モジュールは、日付を扱うための2つのタイプを提供します: [`Date`](@ref) と [`DateTime`](@ref) で、それぞれ日単位とミリ秒単位の精度を表します。両者は抽象型 [`TimeType`](@ref) のサブタイプです。異なるタイプの動機は単純です: 一部の操作は、より高い精度の複雑さに対処する必要がないとき、コードと精神的な推論の両方の観点からはるかに簡単になります。例えば、`4d61726b646f776e2e436f64652822222c2022446174652229_40726566` タイプは単一の日付の精度（すなわち、時間、分、または秒は含まれない）にのみ解決されるため、タイムゾーン、夏時間、うるう秒に関する通常の考慮事項は不要であり、回避されます。

両方の [`Date`](@ref) と [`DateTime`](@ref) は基本的に不変の [`Int64`](@ref) ラッパーです。どちらのタイプの単一の `instant` フィールドは実際には `UTInstant{P}` タイプで、UT秒に基づく連続的に増加する機械のタイムラインを表します [^1]。`4d61726b646f776e2e436f64652822222c20224461746554696d652229_40726566` タイプはタイムゾーンを認識していません（Pythonの用語で言うと*ナイーブ*）、Java 8の *LocalDateTime* に類似しています。追加のタイムゾーン機能は [TimeZones.jl package](https://github.com/JuliaTime/TimeZones.jl/) を通じて追加でき、これは [IANA time zone database](https://www.iana.org/time-zones) をコンパイルします。両方の `4d61726b646f776e2e436f64652822222c2022446174652229_40726566` と `4d61726b646f776e2e436f64652822222c20224461746554696d652229_40726566` は、プロレプティックグレゴリオ暦に従う [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) 標準に基づいています。1つの注意点は、ISO 8601標準がBC/BCEの日付に関して特に厳密であることです。一般的に、BC/BCE時代の最終日である1-12-31 BC/BCEの後には1-1-1 AD/CEが続くため、年ゼロは存在しません。しかし、ISO標準は1 BC/BCEを年ゼロと見なしているため、`0000-12-31` は `0001-01-01` の前日であり、年 `-0001`（はい、年のマイナス1）は2 BC/BCE、年 `-0002` は3 BC/BCE、などとなります。

[^1]: The notion of the UT second is actually quite fundamental. There are basically two different notions of time generally accepted, one based on the physical rotation of the earth (one full rotation = 1 day), the other based on the SI second (a fixed, constant value). These are radically different! Think about it, a "UT second", as defined relative to the rotation of the earth, may have a different absolute length depending on the day! Anyway, the fact that [`Date`](@ref) and [`DateTime`](@ref) are based on UT seconds is a simplifying, yet honest assumption so that things like leap seconds and all their complexity can be avoided. This basis of time is formally called [UT](https://en.wikipedia.org/wiki/Universal_Time) or UT1. Basing types on the UT second basically means that every minute has 60 seconds and every day has 24 hours and leads to more natural calculations when working with calendar dates.

## Constructors

[`Date`](@ref) および [`DateTime`](@ref) タイプは、整数または [`Period`](@ref) タイプによって構築することができ、パースまたはアジャスターを通じて行うことができます（詳細は後で説明します）：

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

[`Date`](@ref) または [`DateTime`](@ref) の解析は、フォーマット文字列を使用して行われます。フォーマット文字列は、解析するための期間を含む *区切り* または *固定幅* の「スロット」を定義するという概念に基づいて機能し、解析するテキストとフォーマット文字列を `4d61726b646f776e2e436f64652822222c2022446174652229_40726566` または `4d61726b646f776e2e436f64652822222c20224461746554696d652229_40726566` コンストラクタに渡します。形式は `Date("2015-01-01",dateformat"y-m-d")` または `DateTime("20150101",dateformat"yyyymmdd")` です。

区切りスロットは、2つの連続する期間の間にパーサーが期待する区切り文字を指定することでマークされます。したがって、`"y-m-d"`は、日付文字列`"2014-07-16"`の最初と2番目のスロットの間に`-`文字があることをパーサーに知らせます。`y`、`m`、および`d`の文字は、各スロットでどの期間を解析するかをパーサーに知らせます。

上記のコンストラクタの例 `Date(2013)` のように、区切り付きの `DateFormat` は、前の部分が与えられている限り、日付や時刻の欠落した部分を許可します。他の部分には通常のデフォルト値が与えられます。例えば、`Date("1981-03", dateformat"y-m-d")` は `1981-03-01` を返し、`Date("31/12", dateformat"d/m/y")` は `0001-12-31` を返します。（デフォルトの年は1年AD/CEです。）ただし、空の文字列は常に `ArgumentError` をスローします。

固定幅スロットは、幅に対応する回数だけピリオド文字を繰り返すことで指定され、文字の間に区切りはありません。したがって、`dateformat"yyyymmdd"`は、`"20140716"`のような日付文字列に対応します。パーサーは、区切りがないことによって固定幅スロットを区別し、1つのピリオド文字から次のピリオド文字への遷移`"yyyymm"`に注目します。

テキスト形式の月の解析は、略称とフルネームの月名にそれぞれ対応する `u` と `U` 文字を通じてサポートされています。デフォルトでは、英語の月名のみがサポートされているため、`u` は "Jan"、"Feb"、"Mar" などに対応し、`U` は "January"、"February"、"March" などに対応します。他の名前=>値マッピング関数 [`dayname`](@ref) と [`monthname`](@ref) と同様に、カスタムロケールは、略称とフルネームの月名にそれぞれ `MONTHTOVALUEABBR` と `MONTHTOVALUE` 辞書に `locale=>Dict{String,Int}` マッピングを渡すことでロードできます。

上記の例では、`dateformat""`文字列マクロが使用されました。このマクロは、マクロが展開されるときに一度だけ`DateFormat`オブジェクトを作成し、コードスニペットが複数回実行されても同じ`DateFormat`オブジェクトを使用します。

```jldoctest
julia> for i = 1:10^5
           Date("2015-01-01", dateformat"y-m-d")
       end
```

または、DateFormatオブジェクトを明示的に作成することもできます：

```jldoctest
julia> df = DateFormat("y-m-d");

julia> dt = Date("2015-01-01",df)
2015-01-01

julia> dt2 = Date("2015-01-02",df)
2015-01-02
```

代わりに、ブロードキャスティングを使用します：

```jldoctest
julia> years = ["2015", "2016"];

julia> Date.(years, DateFormat("yyyy"))
2-element Vector{Date}:
 2015-01-01
 2016-01-01
```

便宜上、フォーマット文字列を直接渡すこともできます（例：`Date("2015-01-01","y-m-d")`）。ただし、この形式は同じフォーマットを繰り返し解析する場合、内部で毎回新しい`DateFormat`オブジェクトを作成するため、パフォーマンスコストが発生します。

`Date` または `DateTime` は、コンストラクタを介してだけでなく、文字列からも構築できます。これは、[`parse`](@ref) および [`tryparse`](@ref) 関数を使用して行うことができ、オプションの第3引数として `DateFormat` 型のフォーマットを指定できます。例えば、`parse(Date, "06.23.2013", dateformat"m.d.y")` や、デフォルトフォーマットを使用する `tryparse(DateTime, "1999-12-31T23:59:59")` があります。これらの関数の顕著な違いは、`4d61726b646f776e2e436f64652822222c202274727970617273652229_40726566` を使用する場合、文字列が空であるか無効なフォーマットであってもエラーがスローされず、代わりに `nothing` が返されることです。

!!! compat "Julia 1.9"
    Julia 1.9以前は、空の文字列をコンストラクタや`parse`に渡してもエラーが発生せず、適切に`DateTime(1)`、`Date(1)`、または`Time(0)`が返されていました。同様に、`tryparse`は`nothing`を返しませんでした。


完全なパースおよびフォーマットのテストと例のスイートは、[`stdlib/Dates/test/io.jl`](https://github.com/JuliaLang/julia/blob/master/stdlib/Dates/test/io.jl)で利用可能です。

## Durations/Comparisons

Finding the length of time between two [`Date`](@ref) or [`DateTime`](@ref) is straightforward given their underlying representation as `UTInstant{Day}` and `UTInstant{Millisecond}`, respectively. The difference between [`Date`](@ref) is returned in the number of [`Day`](@ref), and [`DateTime`](@ref) in the number of [`Millisecond`](@ref). Similarly, comparing [`TimeType`](@ref) is a simple matter of comparing the underlying machine instants (which in turn compares the internal [`Int64`](@ref) values).

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

[`Date`](@ref) および [`DateTime`](@ref) タイプは、単一の [`Int64`](@ref) 値として保存されているため、日付の部分やフィールドはアクセサ関数を通じて取得できます。小文字のアクセサはフィールドを整数として返します：

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

While propercase return the same value in the corresponding [`Period`](@ref) type:

```jldoctest tdate
julia> Dates.Year(t)
2014 years

julia> Dates.Day(t)
31 days
```

複合メソッドは、個別にアクセスするよりも複数のフィールドに同時にアクセスする方が効率的であるため提供されています：

```jldoctest tdate
julia> Dates.yearmonth(t)
(2014, 1)

julia> Dates.monthday(t)
(1, 31)

julia> Dates.yearmonthday(t)
(2014, 1, 31)
```

基礎となる `UTInstant` または整数値にもアクセスできます:

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

クエリ関数は、[`TimeType`](@ref)に関するカレンダー情報を提供します。これには、曜日に関する情報が含まれています：

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

年の月:

```jldoctest tdate2
julia> Dates.monthname(t)
"January"

julia> Dates.daysinmonth(t)
31
```

[`TimeType`](@ref)の年と四半期に関する情報:

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

[`dayname`](@ref) および [`monthname`](@ref) メソッドは、他の言語/ロケールのために曜日や月の名前を返すために使用できるオプションの `locale` キーワードを取ることもできます。これらの関数には、省略形の名前を返すバージョンもあり、具体的には [`dayabbr`](@ref) および [`monthabbr`](@ref) です。最初に、マッピングが `LOCALES` 変数にロードされます：

```jldoctest tdate2
julia> french_months = ["janvier", "février", "mars", "avril", "mai", "juin",
                        "juillet", "août", "septembre", "octobre", "novembre", "décembre"];

julia> french_months_abbrev = ["janv","févr","mars","avril","mai","juin",
                              "juil","août","sept","oct","nov","déc"];

julia> french_days = ["lundi","mardi","mercredi","jeudi","vendredi","samedi","dimanche"];

julia> Dates.LOCALES["french"] = Dates.DateLocale(french_months, french_months_abbrev, french_days, [""]);
```

上記の関数を使用して、クエリを実行できます：

```jldoctest tdate2
julia> Dates.dayname(t;locale="french")
"vendredi"

julia> Dates.monthname(t;locale="french")
"janvier"

julia> Dates.monthabbr(t;locale="french")
"janv"
```

省略形の曜日が読み込まれていないため、関数 `dayabbr` を使用しようとするとエラーが発生します。

```jldoctest tdate2
julia> Dates.dayabbr(t;locale="french")
ERROR: BoundsError: attempt to access 1-element Vector{String} at index [5]
Stacktrace:
[...]
```

## TimeType-Period Arithmetic

日付/時間フレームワークを使用する際には、日付期間の算術がどのように処理されるかに精通しておくことが良い習慣です。なぜなら、扱うべき [tricky issues](https://codeblog.jonskeet.uk/2010/12/01/the-joys-of-date-time-arithmetic/) があるからです（ただし、日単位の精度のタイプについてはそれほどではありません）。

`Dates` モジュールのアプローチは、[`Period`](@ref) 算術を行う際に、できるだけ少ない変更を加えるというシンプルな原則に従おうとします。このアプローチは、*カレンダー* 算術としても知られており、誰かが会話の中で同じ計算を尋ねた場合にあなたが推測するであろうことです。なぜこれほど騒がれているのでしょうか？クラシックな例を見てみましょう：2014年1月31日に1か月を加えます。答えは何でしょうか？Javascriptは [March 3](https://markhneedham.com/blog/2009/01/07/javascript-add-a-month-to-a-date/) （31日を仮定）と言います。PHPは [March 2](https://stackoverflow.com/questions/5760262/php-adding-months-to-a-date-while-not-exceeding-the-last-day-of-the-month) （30日を仮定）と言います。実際のところ、正しい答えはありません。`Dates` モジュールでは、結果として2月28日を返します。どのようにそれを計算するのでしょうか？カジノのクラシックな7-7-7ギャンブルゲームを考えてみてください。

今、7-7-7の代わりにスロットが年-月-日になっていると想像してみてください。つまり、私たちの例では2014-01-31です。この日付に1か月を追加するように頼むと、月のスロットが増加し、2014-02-31になります。次に、日付が新しい月の最終有効日よりも大きいかどうかがチェックされます。もしそうであれば（上記のケースのように）、日付は最終有効日（28）に調整されます。このアプローチの影響は何でしょうか？では、私たちの日付にもう1か月を追加してみましょう。`2014-02-28 + Month(1) == 2014-03-28`。え？3月の最終日を期待していましたか？いいえ、申し訳ありませんが、7-7-7のスロットを思い出してください。できるだけ少ないスロットが変更されるので、まず月のスロットを1増やして2014-03-28になり、これで完了です。これは有効な日付です。一方、元の日時2014-01-31に2か月を追加すると、予想通り2014-03-31になります。このアプローチのもう一つの影響は、特定の順序が強制されるときに結合性が失われることです（つまり、異なる順序で追加すると異なる結果が得られます）。例えば：

```jldoctest
julia> (Date(2014,1,29)+Dates.Day(1)) + Dates.Month(1)
2014-02-28

julia> (Date(2014,1,29)+Dates.Month(1)) + Dates.Day(1)
2014-03-01
```

何が起こっているのでしょうか？最初の行では、1日を1月29日に加えています。これにより2014-01-30になります。その後、1か月を加えると2014-02-30になり、これが2014-02-28に調整されます。2番目の例では、最初に1か月を加えます。これにより2014-02-29になり、これが2014-02-28に調整され、その後1日を加えると2014-03-01になります。この場合に役立つ設計原則の1つは、複数の期間が存在する場合、操作は期間の*タイプ*によって順序付けられるということです。これは、`Year`が常に最初に加えられ、その後`Month`、`Week`などが続くことを意味します。したがって、以下の*は*結合性を持ち、うまく機能します：

```jldoctest
julia> Date(2014,1,29) + Dates.Day(1) + Dates.Month(1)
2014-03-01

julia> Date(2014,1,29) + Dates.Month(1) + Dates.Day(1)
2014-03-01
```

トリッキー？おそらく。無邪気な `Dates` ユーザーは何をすべきでしょうか？要するに、月を扱う際に特定の結合性を明示的に強制することは、予期しない結果を招く可能性があることを認識しておくべきですが、それ以外はすべてが期待通りに機能するはずです。幸いなことに、UTでの時間を扱う際の日付期間の算術における奇妙なケースはこれがほとんど全てです（夏時間、うるう秒などの「喜び」を避けることを考慮して）。

ボーナスとして、すべての期間算術オブジェクトは範囲と直接連携します：

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

日付の期間算術が便利である一方で、日付に必要な計算の多くは、固定された期間の数ではなく、*カレンダー的*または*時間的*な性質を持つことがよくあります。祝日はその完璧な例です。ほとんどは「メモリアルデー = 5月の最後の月曜日」や「感謝祭 = 11月の第4木曜日」といったルールに従います。このような時間的表現は、月の最初または最後、次の火曜日、または第1および第3の水曜日など、カレンダーに対するルールに関連しています。

`Dates` モジュールは、時間的ルールを簡潔に表現するのに役立つ便利なメソッドを通じて *adjuster* API を提供します。最初のグループの adjuster メソッドは、週、月、四半期、年の最初と最後に関するものです。それぞれは単一の [`TimeType`](@ref) を入力として受け取り、入力に対して希望する期間の最初または最後に *調整* します。

```jldoctest
julia> Dates.firstdayofweek(Date(2014,7,16)) # Adjusts the input to the Monday of the input's week
2014-07-14

julia> Dates.lastdayofmonth(Date(2014,7,16)) # Adjusts to the last day of the input's month
2014-07-31

julia> Dates.lastdayofquarter(Date(2014,7,16)) # Adjusts to the last day of the input's quarter
2014-09-30
```

次の2つの高次のメソッド、[`tonext`](@ref) と [`toprev`](@ref) は、`DateFunction` を最初の引数として受け取り、開始点として [`TimeType`](@ref) を使用することで、時間的表現の操作を一般化します。`DateFunction` は、通常は匿名の関数で、単一の `4d61726b646f776e2e436f64652822222c202254696d65547970652229_40726566` を入力として受け取り、[`Bool`](@ref) を返し、調整基準が満たされていることを示す `true` を返します。例えば：

```jldoctest
julia> istuesday = x->Dates.dayofweek(x) == Dates.Tuesday; # Returns true if the day of the week of x is Tuesday

julia> Dates.tonext(istuesday, Date(2014,7,13)) # 2014-07-13 is a Sunday
2014-07-15

julia> Dates.tonext(Date(2014,7,13), Dates.Tuesday) # Convenience method provided for day of the week adjustments
2014-07-15
```

これは、より複雑な時間表現のためのdoブロック構文で役立ちます：

```jldoctest
julia> Dates.tonext(Date(2014,7,13)) do x
           # Return true on the 4th Thursday of November (Thanksgiving)
           Dates.dayofweek(x) == Dates.Thursday &&
           Dates.dayofweekofmonth(x) == 4 &&
           Dates.month(x) == Dates.November
       end
2014-11-27
```

[`Base.filter`](@ref) メソッドを使用すると、指定された範囲内のすべての有効な日付/瞬間を取得できます：

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

追加の例とテストは [`stdlib/Dates/test/adjusters.jl`](https://github.com/JuliaLang/julia/blob/master/stdlib/Dates/test/adjusters.jl) にあります。

## Period Types

期間は、人間が捉える離散的で時には不規則な時間の長さです。1か月を考えてみてください。それは、年や月の文脈によって、28、29、30、または31日の値を表すことがあります。また、1年は、うるう年の場合、365日または366日を表すことがあります。 [`Period`](@ref) タイプは単純な [`Int64`](@ref) ラッパーであり、任意の `Int64` 変換可能なタイプをラップすることによって構築されます。つまり、`Year(1)` や `Month(3.0)` のように。 同じタイプの `4d61726b646f776e2e436f64652822222c2022506572696f642229_40726566` 同士の算術演算は整数のように振る舞い、制限された `Period-Real` 算術演算が利用可能です。 基本となる整数は、[`Dates.value`](@ref) を使って抽出できます。

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

整数倍ではない期間や持続時間を表現するには、[`Dates.CompoundPeriod`](@ref) 型を使用できます。複合期間は、単純な [`Period`](@ref) 型から手動で構築することができます。さらに、[`canonicalize`](@ref) 関数を使用して、期間を `4d61726b646f776e2e436f64652822222c202244617465732e436f6d706f756e64506572696f642229_40726566` に分解することができます。これは、2つの `DateTime` の差などの持続時間を、より便利な表現に変換するのに特に役立ちます。

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

[`Date`](@ref) と [`DateTime`](@ref) の値は、[`floor`](@ref)、[`ceil`](@ref)、または [`round`](@ref) を使用して指定された解像度（例：1か月または15分）に丸めることができます。

```jldoctest
julia> floor(Date(1985, 8, 16), Dates.Month)
1985-08-01

julia> ceil(DateTime(2013, 2, 13, 0, 31, 20), Dates.Minute(15))
2013-02-13T00:45:00

julia> round(DateTime(2016, 8, 6, 20, 15), Dates.Day)
2016-08-07T00:00:00
```

数値 [`round`](@ref) メソッドとは異なり、デフォルトで偶数に向かって引き分けを行うのではなく、[`TimeType`](@ref)`4d61726b646f776e2e436f64652822222c2022726f756e642229_40726566` メソッドは `RoundNearestTiesUp` 丸めモードを使用します。引き分けを最も近い「偶数」にする `4d61726b646f776e2e436f64652822222c202254696d65547970652229_40726566` が何を意味するのかを推測するのは難しいです。利用可能な `RoundingMode` についての詳細は [API reference](@ref stdlib-dates-api) で確認できます。

丸めは一般的に期待通りに動作するべきですが、期待される動作が明らかでないいくつかのケースがあります。

### Rounding Epoch

多くの場合、丸めのために指定された解像度（例：`Dates.Second(30)`）は、次に大きな期間（この場合は`Dates.Minute(1)`）に均等に分割されます。しかし、これが当てはまらない場合の丸めの挙動は混乱を招く可能性があります。[`DateTime`](@ref)を最も近い10時間に丸めた場合の期待される結果は何ですか？

```jldoctest
julia> round(DateTime(2016, 7, 17, 11, 55), Dates.Hour(10))
2016-07-17T12:00:00
```

それは混乱を招くかもしれませんが、時間（12）は10で割り切れません。`2016-07-17T12:00:00`が選ばれた理由は、`0000-01-01T00:00:00`から17,676,660時間後であり、17,676,660は10で割り切れるからです。

ジュリア [`Date`](@ref) と [`DateTime`](@ref) の値は ISO 8601 標準に従って表現されており、日数（およびミリ秒）の計算に使用される丸め計算の基準（または「丸めエポック」）として `0000-01-01T00:00:00` が選ばれました。（これは、ジュリアの内部表現 `4d61726b646f776e2e436f64652822222c2022446174652229_40726566` が [Rata Die notation](https://en.wikipedia.org/wiki/Rata_Die) を使用しているのとは若干異なりますが、ISO 8601 標準がエンドユーザーに最も見えやすいため、混乱を最小限に抑えるために内部で使用される `0000-12-31T00:00:00` の代わりに `0000-01-01T00:00:00` が丸めエポックとして選ばれました。）

`0000-01-01T00:00:00`を丸めの基準点として使用する唯一の例外は、週に丸める場合です。最も近い週に丸めると、常に月曜日（ISO 8601で指定された週の最初の日）が返されます。このため、週数に丸める際の基準として、`0000-01-03T00:00:00`（ISO 8601で定義された年0000の最初の週の最初の日）を使用します。

ここに、期待される動作が必ずしも明白ではない関連するケースがあります：`P(2)` に最も近い値に丸めるとどうなりますか？ここで `P` は [`Period`](@ref) タイプです。いくつかのケース（具体的には、`P <: Dates.TimePeriod` の場合）では、答えは明確です：

```jldoctest
julia> round(DateTime(2016, 7, 17, 8, 55, 30), Dates.Hour(2))
2016-07-17T08:00:00

julia> round(DateTime(2016, 7, 17, 8, 55, 30), Dates.Minute(2))
2016-07-17T08:56:00
```

これは明らかに思えます。なぜなら、これらの期間のそれぞれの2つは次の大きな順序の期間に均等に分割されるからです。しかし、2か月の場合（これはまだ1年に均等に分割されますが）、答えは驚くべきものかもしれません：

```jldoctest
julia> round(DateTime(2016, 7, 17, 8, 55, 30), Dates.Month(2))
2016-07-01T00:00:00
```

なぜ7月の最初の日に丸めるのか、それは月が奇数であるにもかかわらず？ 重要なのは、月は1から始まる（最初の月は1が割り当てられる）のに対し、時間、分、秒、ミリ秒は0から始まるということです。

これは、[`DateTime`](@ref)を秒、分、時間、または年の偶数倍に丸めると、そのフィールドに偶数の値を持つ`4d61726b646f776e2e436f64652822222c20224461746554696d652229_40726566`が得られることを意味します（ISO 8601仕様には年ゼロが含まれているため）。一方、`4d61726b646f776e2e436f64652822222c20224461746554696d652229_40726566`を月の偶数倍に丸めると、月のフィールドには奇数の値が得られます。月と年の両方が不規則な日数を含む可能性があるため、偶数の日数に丸めると日数フィールドに偶数の値が得られるかどうかは不確かです。

`Dates`モジュールからエクスポートされたメソッドに関する追加情報は、[API reference](@ref stdlib-dates-api)を参照してください。

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

`Date` と `DateTime` の値は、`floor`、`ceil`、または `round` を使用して指定された解像度（例：1か月または15分）に丸めることができます。

```@docs
Base.floor(::Dates.TimeType, ::Dates.Period)
Base.ceil(::Dates.TimeType, ::Dates.Period)
Base.round(::Dates.TimeType, ::Dates.Period, ::RoundingMode{:NearestTiesUp})
```

ほとんどの `Period` 値は、指定された解像度に丸めることもできます：

```@docs
Base.floor(::Dates.ConvertiblePeriod, ::T) where T <: Dates.ConvertiblePeriod
Base.ceil(::Dates.ConvertiblePeriod, ::Dates.ConvertiblePeriod)
Base.round(::Dates.ConvertiblePeriod, ::Dates.ConvertiblePeriod, ::RoundingMode{:NearestTiesUp})
```

次の関数はエクスポートされていません：

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

曜日:

| Variable    | Abbr. | Value (Int) |
|:----------- |:----- |:----------- |
| `Monday`    | `Mon` | 1           |
| `Tuesday`   | `Tue` | 2           |
| `Wednesday` | `Wed` | 3           |
| `Thursday`  | `Thu` | 4           |
| `Friday`    | `Fri` | 5           |
| `Saturday`  | `Sat` | 6           |
| `Sunday`    | `Sun` | 7           |

年の月:

| Variable    | Abbr. | Value (Int) |
|:----------- |:----- |:----------- |
| `January`   | `Jan` | 1           |
| `February`  | `Feb` | 2           |
| `March`     | `Mar` | 3           |
| `April`     | `Apr` | 4           |
| `May`       | `May` | 5           |
| `June`      | `Jun` | 6           |
| `July`      | `Jul` | 7           |
| `August`    | `Aug` | 8           |
| `September` | `Sep` | 9           |
| `October`   | `Oct` | 10          |
| `November`  | `Nov` | 11          |
| `December`  | `Dec` | 12          |

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
