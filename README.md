[![Swift](https://github.com/janodevorg/Report/actions/workflows/swift.yml/badge.svg)](https://github.com/janodevorg/Report/actions/workflows/swift.yml)

[Report network requests for logging purposes](https://janodevorg.github.io/Report/documentation/report/).

Example output:
```
2022-02-01 14:34:35.968778+0100 MyApp[459:15451531] [network] 200 GET https://www.somedomain.com/api/v2/feed
Request
 ├─ Query String
 │ fields[blogs] = name,title,url,avatar,can_be_followed,?followed,theme
 │ limit = 8
 ├─ Headers
 │ Accept = application/json
 │ Authorization = Bearer cafebabe
 │ Cookie = sid=magiccookie
 └

Response
 ├─ Headers
 │ Content-Encoding = br
 │ Content-Type = application/json; charset=utf-8
 │ Date = Tue, 01 Feb 2022 13:34:35 GMT
 ├─ Body
 │ {"meta":{"status":200,"msg":"OK"},"response":{"blogs":[{"name":"milk-pudding-pos… (continues up to 343681 bytes)
 └
```
