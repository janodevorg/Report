# ``Report``

Report network requests for logging purposes.

## Overview

![Report](Report)

### Usage

```swift
// let request = URLRequest...
// let response = HTTPURLResponse...
let report = Report(request: request, response: response, data: data).description
```

Logging to Xcode:
```swift
import os
Logger(subsystem: "dev.jano", category: "network").debug("\(report)")
```

Resulting text:
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

To save this request to a file run:
  curl -v -X GET "https://www.somedomain.com/api/v2/feed" \
    -b "sid=magiccookie" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer alAfqIYLyFcsjIf7lBTEYgV4EL2QI5V8mYpqjHcdsnJ4uc9o5u" | python -mjson.tool > file.json
```
