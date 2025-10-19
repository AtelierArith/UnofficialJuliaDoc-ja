```julia
DateFormat(format::AbstractString, locale="english") -> DateFormat
```

Construct a date formatting object that can be used for parsing date strings or formatting a date object as a string. The following character codes can be used to construct the `format` string:

| Code       | Matches   | Comment                                                       |
|:---------- |:--------- |:------------------------------------------------------------- |
| `Y`        | 1996, 96  | Returns year of 1996, 0096                                    |
| `y`        | 1996, 96  | Same as `Y` on `parse` but discards excess digits on `format` |
| `m`        | 1, 01     | Matches 1 or 2-digit months                                   |
| `u`        | Jan       | Matches abbreviated months according to the `locale` keyword  |
| `U`        | January   | Matches full month names according to the `locale` keyword    |
| `d`        | 1, 01     | Matches 1 or 2-digit days                                     |
| `H`        | 00        | Matches hours (24-hour clock)                                 |
| `I`        | 00        | For outputting hours with 12-hour clock                       |
| `M`        | 00        | Matches minutes                                               |
| `S`        | 00        | Matches seconds                                               |
| `s`        | .500      | Matches milliseconds                                          |
| `e`        | Mon, Tues | Matches abbreviated days of the week                          |
| `E`        | Monday    | Matches full name days of the week                            |
| `p`        | AM        | Matches AM/PM (case-insensitive)                              |
| `yyyymmdd` | 19960101  | Matches fixed-width year, month, and day                      |

Characters not listed above are normally treated as delimiters between date and time slots. For example a `dt` string of "1996-01-15T00:00:00.0" would have a `format` string like "y-m-dTH:M:S.s". If you need to use a code character as a delimiter you can escape it using backslash. The date "1995y01m" would have the format "y\ym\m".

Note that 12:00AM corresponds 00:00 (midnight), and 12:00PM corresponds to 12:00 (noon). When parsing a time with a `p` specifier, any hour (either `H` or `I`) is interpreted as as a 12-hour clock, so the `I` code is mainly useful for output.

Creating a DateFormat object is expensive. Whenever possible, create it once and use it many times or try the [`dateformat""`](@ref @dateformat_str) string macro. Using this macro creates the DateFormat object once at macro expansion time and reuses it later. There are also several [pre-defined formatters](@ref Common-Date-Formatters), listed later.

See [`DateTime`](@ref) and [`format`](@ref) for how to use a DateFormat object to parse and write Date strings respectively.
