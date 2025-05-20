```
DateLocale(["January", "February",...], ["Jan", "Feb",...],
           ["Monday", "Tuesday",...], ["Mon", "Tue",...])
```

Create a locale for parsing or printing textual month names.

Arguments:

  * `months::Vector`: 12 month names
  * `months_abbr::Vector`: 12 abbreviated month names
  * `days_of_week::Vector`: 7 days of week
  * `days_of_week_abbr::Vector`: 7 days of week abbreviated

This object is passed as the last argument to `tryparsenext` and `format` methods defined for each `AbstractDateToken` type.
