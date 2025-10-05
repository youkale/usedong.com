---
title: "Params"
date: 2024-10-07
tags: ["Go", "HTTP", "Library", "Web"]
image: "https://opengraph.githubassets.com/1/youkale/params"
github: "https://github.com/youkale/params"
summary: "Go 库，用于将 url.Values 转换为结构体，支持 HTTP 请求的查询参数和表单参数"
---

# Params

Params is a Go library for converting `url.Values` to struct, supporting HTTP request query-parameters and form-parameters.

{{< linkcard
  url="https://github.com/youkale/params"
  title="Params - GitHub"
  description="Go library for convert url.Values to struct"
  image="https://opengraph.githubassets.com/1/youkale/params"
  site="github.com"
>}}

## Features

- **简单易用**: 通过结构体标签轻松定义参数映射
- **自动转换**: 自动将 URL 参数转换为对应的 Go 类型
- **默认值支持**: 支持为参数设置默认值
- **类型安全**: 编译时类型检查，减少运行时错误
- **高性能**: 零内存分配，性能优异

## Installation

```bash
go get github.com/youkale/params
```

## Usage

### 1. Define a struct

Define a struct with tags that match the query parameter names:

```go
type User struct {
    UserId  int64   `param:"user_id,100"`
    StoreId int     `param:"store_id"`
    Page    float32 `param:"page"`
    Name    string  `param:"name"`
    Age     uint8   `param:"age,18"`
    Enable  bool    `param:"enable,false"`
}
```

### 2. Parse in HTTP handler

In your HTTP handler, parse the query parameters into an instance of the struct:

```go
import "github.com/youkale/params"

func MyHandler(w http.ResponseWriter, r *http.Request) {
    // Convert request.URL.Query() or request.Form
    var user User
    if err := params.Convert(r.URL.Query(), &user); err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
        return
    }
    // Do something with the user struct...
}
```

Params will automatically parse the query parameters and set the values in the struct fields.

## Tag Options

The `param` tag supports the following format:

```go
`param:"field_name,default_value"`
```

- **field_name**: The key to get the content from query parameters
- **default_value**: (Optional) Default value if the parameter is not present

### Examples

```go
type Query struct {
    // Required parameter, no default
    ID int `param:"id"`

    // Optional parameter with default value
    Page int `param:"page,1"`

    // String with default
    Sort string `param:"sort,created_at"`

    // Boolean with default
    Active bool `param:"active,true"`
}
```

## Performance

```
goos: linux
goarch: amd64
pkg: github.com/youkale/params
2000000000	         0.00 ns/op
PASS
```

**零内存分配，性能极致！**

## Supported Types

Params 支持以下 Go 基础类型：

- `string`
- `bool`
- `int`, `int8`, `int16`, `int32`, `int64`
- `uint`, `uint8`, `uint16`, `uint32`, `uint64`
- `float32`, `float64`

## Use Cases

Params 非常适合以下场景：

- RESTful API 参数解析
- HTTP 表单数据处理
- URL 查询参数验证
- 微服务参数传递

## License

This project is available under an open source license.

## Contributing

Contributions are welcome! Feel free to submit issues and pull requests.
