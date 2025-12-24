import "@omnidotdev/typespec-drizzle";

using Drizzle;

namespace EnumTest;

enum Status {
  Active: "active",
  Inactive: "inactive",
  Pending: "pending",
}

enum Priority {
  Low,
  Medium,
  High,
  Critical,
}

@table(#{ name: "tasks" })
model Task {
  @id
  id: string;

  title: string;
  status: Status;
  priority: Priority;

  @defaultValue("now()")
  createdAt: utcDateTime;
}
