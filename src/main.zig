const std = @import("std");
const debug_print = std.debug.print;
const log = std.log;

// Define a generic Stack data structure parameterized by type T.
fn Stack(comptime T: type) type {
    return struct {
        const Self = @This();

        // Size and capacity of the stack.
        size: usize = 0,
        capacity: usize,
        // Data storage for the stack.
        data: []T,

        // Constructor for creating a new stack with a given capacity.
        fn new(capacity: usize) Self {
            const allocator = std.heap.page_allocator;

            // Allocate memory for the stack data.
            const data = allocator.alloc(T, capacity) catch unreachable;

            return Self{
                .capacity = capacity,
                .data = data,
            };
        }

        // Push an element onto the stack.
        fn push(self: *Self, data: T) !void {
            // Check if the stack is full.
            if (self.size >= self.capacity) {
                log.info("Stack full!", .{});
            } else {
                // Push the data onto the stack and update size.
                self.data[self.size] = data;
                self.size += 1;

                log.info("Pushed data to Stack!", .{});
            }
        }

        // Pop an element from the stack.
        fn pop(self: *Self) !void {
            // Set the top element to undefined and update size.
            self.data[self.size - 1] = undefined;
            self.size -= 1;

            log.info("Popped data from Stack!", .{});
        }

        // Peek at the top element of the stack.
        fn peek(self: *Self) T {
            return self.data[self.size - 1];
        }

        // Clear all elements from the stack.
        fn clear(self: *Self) void {
            while (self.size > 0) {
                self.data[self.size - 1] = undefined;
                self.size -= 1;
            }
        }

        // Print the contents of the stack.
        fn print(self: *Self) void {
            // Use a switch statement to handle different types.
            switch (T) {
                usize => {
                    log.info("usize: {usize}", .{self.data});
                },
                u8 => {
                    log.info("{any}: {any}", .{ T, self.data });
                },

                // Add more cases for other types if needed.

                else => {},
            }
        }

        // Resize the stack to a new capacity.
        fn resize(self: *Self, new_capacity: usize) !void {
            const allocator = std.heap.page_allocator;
            const new_data = allocator.alloc(T, new_capacity) catch unreachable;

            // Copy existing data to the new memory.
            std.mem.copyForwards(T, new_data, self.data);

            // Update stack with new data and capacity.
            self.data = new_data;
            self.capacity = new_capacity;
        }
    };
}

// Entry point of the program.
pub fn main() !void {
    // Create a stack of u8 with an initial capacity of 2.
    var stack = Stack(u8).new(2);
    // Ensure stack is cleared when main exits.
    defer stack.clear();

    // Push a character onto the stack.
    try stack.push('d');
    log.info("{any}", .{stack});

    // Pop an element from the stack.
    try stack.pop();
    log.info("{any}", .{stack});

    // Push a character onto the stack.
    try stack.push('s');
    log.info("{any}", .{stack});

    // Peek at the top element of the stack.
    var data_ontop = stack.peek();
    log.info("{any}", .{data_ontop});

    // Clear all elements from the stack.
    stack.clear();
    log.info("{}", .{stack});

    // Resize the stack to a capacity of 4.
    try stack.resize(4);
    log.info("{}", .{stack});
}
