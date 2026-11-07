`Base.parse(Union{Float64,Float32}, str)`と同様ですが、浮動小数点数のアンダーフローを許容します。

Float64を解析します。str[firstind:lastind]は有効な浮動小数点リテラル文字列でなければなりません。値がFloat64の範囲外の場合。
