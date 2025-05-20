```
struct Response
    proto   :: String
    url     :: String
    status  :: Int
    message :: String
    headers :: Vector{Pair{String,String}}
end
```

`Response` is a type capturing the properties of a successful response to a request as an object. It has the following fields:

  * `proto`: the protocol that was used to get the response
  * `url`: the URL that was ultimately requested after following redirects
  * `status`: the status code of the response, indicating success, failure, etc.
  * `message`: a textual message describing the nature of the response
  * `headers`: any headers that were returned with the response

The meaning and availability of some of these responses depends on the protocol used for the request. For many protocols, including HTTP/S and S/FTP, a 2xx status code indicates a successful response. For responses in protocols that do not support headers, the headers vector will be empty. HTTP/2 does not include a status message, only a status code, so the message will be empty.
