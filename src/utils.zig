const std = @import("std");

const Contact = struct {
    name: []const u8,
    email: []const u8,
    id: i32,

    pub fn init(id: i32, name: []const u8, email: []const u8) Contact {
        return .{
            .id = id,
            .name = name,
            .email = email,
        };
    }
};

const Contacts = struct {
    contacts: []Contact,

    pub fn init(allocator: std.mem.Allocator) !*Contacts {
        const contacts = try allocator.create(Contacts);
        errdefer allocator.destroy(contacts); // Cleanup if we fail

        contacts.* = .{
            .contacts = try allocator.alloc(Contact, 2),
        };
        errdefer allocator.free(contacts.contacts);

        contacts.contacts[0] = Contact.init(1, "John Doe", "john.doe@gmail.com");
        contacts.contacts[1] = Contact.init(2, "Jane Doe", "jane.doe@gmail.com");

        return contacts;
    }

    pub fn deinit(self: *Contacts, allocator: std.mem.Allocator) void {
        allocator.free(self.contacts);
        allocator.destroy(self);
    }
};

const FormData = struct {
    errors: std.StringHashMap([]const u8),
    values: std.StringHashMap([]const u8),

    pub fn init(allocator: std.mem.Allocator) FormData {
        return .{
            .errors = std.StringHashMap([]const u8).init(allocator),
            .values = std.StringHashMap([]const u8).init(allocator),
        };
    }
    pub fn deinit(self: *FormData) void {
        self.errors.deinit();
        self.values.deinit();
    }
};

const PageData = struct {
    data: Contacts,
    form: FormData,

    pub fn init(data: Contacts, form: FormData) PageData {
        return .{
            .data = data,
            .form = form,
        };
    }
};

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    // Initialize Data
    const data = try Contacts.init(allocator);
    defer data.deinit(allocator);

    // Initialize FormData
    var form = FormData.init(allocator);
    defer form.deinit();

    // Create PageData
    const page_data = PageData.init(data.*, form);

    // Use the data
    std.debug.print("First contact: {s}\n", .{page_data.data.contacts[0].name});
}
