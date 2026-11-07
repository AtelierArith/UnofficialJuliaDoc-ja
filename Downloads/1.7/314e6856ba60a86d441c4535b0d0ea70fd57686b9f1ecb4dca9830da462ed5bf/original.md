```julia
struct RequestError <: ErrorException
    url      :: String
    code     :: Int
    message  :: String
    response :: Response
end
```

`RequestError` is a type capturing the properties of a failed response to a request as an exception object:

  * `url`: the original URL that was requested without any redirects
  * `code`: the libcurl error code; `0` if a protocol-only error occurred
  * `message`: the libcurl error message indicating what went wrong
  * `response`: response object capturing what response info is available

The same `RequestError` type is thrown by `download` if the request was successful but there was a protocol-level error indicated by a status code that is not in the 2xx range, in which case `code` will be zero and the `message` field will be the empty string. The `request` API only throws a `RequestError` if the libcurl error `code` is non-zero, in which case the included `response` object is likely to have a `status` of zero and an empty message. There are, however, situations where a curl-level error is thrown due to a protocol error, in which case both the inner and outer code and message may be of interest.
