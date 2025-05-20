`EASY_HOOK` is a modifable global hook to used as the default `easy_hook` on new `Downloader` objects. This supplies a mechanism to set options for the `Downloader` via `Curl.setopt`

It is expected to be function taking two arguments: an `Easy` struct and an `info` NamedTuple with names `url`, `method` and `headers`.
