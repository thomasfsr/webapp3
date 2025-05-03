const std = @import("std");
const jetzig = @import("jetzig");

pub fn get(id: []const u8, request: *jetzig.Request) !jetzig.View {
    var root = try request.data(.object);
    try root.put("id", id);
    return request.render(.ok);
}

pub fn index(request: *jetzig.Request) !jetzig.View {
    var root = try request.data(.object);
    try root.put("welcome_message", "Welcome to Jetzig!");
    const params = try request.params();
    try root.put("message_param", params.get("message"));
    try request.response.headers.append("x-example-header", "example header value");
    return request.render(.ok);
}
// test "get" {
//     var app = try jetzig.testing.app(std.testing.allocator, @import("routes"));
//     defer app.deinit();
//     const response = try app.request(.GET, "/fuba/example-id", .{});
//     try response.expectStatus(.ok);
// }
