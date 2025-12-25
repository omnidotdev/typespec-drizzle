// Enums and unions fixture - Testing enum and union types for Drizzle generation
namespace EnumsUnions;

/** Status enum for user accounts */
enum UserStatus {
  /** User account is active */
  Active: "active",

  /** User account is inactive */
  Inactive: "inactive",

  /** User account is suspended */
  Suspended: "suspended",

  /** User account is pending verification */
  Pending: "pending",
}

/** Priority levels for tasks */
enum Priority {
  Low: "low",
  Medium: "medium",
  High: "high",
  Critical: "critical",
}

/** Content types for posts */
enum ContentType {
  Text: "text",
  Markdown: "markdown",
  Html: "html",
  Json: "json",
}

/** Model using enum fields */
model UserAccount {
  /** Primary key */
  id: string;

  /** User's email */
  email: string;

  /** User's display name */
  name: string;

  /** Account status */
  status: UserStatus;

  /** Account type (optional enum) */
  accountType?: UserStatus;

  /** When the account was created */
  createdAt: utcDateTime;
}

/** Model with multiple enum fields */
model Task {
  /** Primary key */
  id: string;

  /** Task title */
  title: string;

  /** Task description */
  description?: string;

  /** Task priority */
  priority: Priority;

  /** Task status */
  status: UserStatus;

  /** Assignee user ID */
  assigneeId?: string;

  /** When the task was created */
  createdAt: utcDateTime;

  /** Task due date */
  dueDate?: utcDateTime;
}

/** Content model using content type enum */
model Content {
  /** Primary key */
  id: string;

  /** Content title */
  title: string;

  /** Content body */
  body: string;

  /** Content type */
  type: ContentType;

  /** Author ID */
  authorId: string;

  /** When the content was created */
  createdAt: utcDateTime;
}

/** Union type for different ID formats */
union IdType {
  string,
  int32,
}

/** Union type for different content formats */
union ContentFormat {
  TextContent,
  MediaContent,
}

/** Text content variant */
model TextContent {
  type: "text";
  content: string;
}

/** Media content variant */
model MediaContent {
  type: "media";
  url: string;
  mimeType: string;
}

/** Model using union types */
model Article {
  /** Primary key (union type) */
  id: IdType;

  /** Article title */
  title: string;

  /** Article content (union type) */
  content: ContentFormat;

  /** Author ID */
  authorId: string;

  /** Publication status */
  status: UserStatus;

  /** When the article was created */
  createdAt: utcDateTime;
}

/** String literal union for roles */
union Role {
  "admin",
  "editor",
  "viewer",
  "guest",
}

/** Model with string literal union */
model Permission {
  /** Primary key */
  id: string;

  /** User ID */
  userId: string;

  /** Resource ID */
  resourceId: string;

  /** User role */
  role: Role;

  /** When the permission was granted */
  grantedAt: utcDateTime;
}

/** Numeric union for different numeric types */
union NumericValue {
  int32,
  float64,
}

/** Model with numeric union */
model Metric {
  /** Primary key */
  id: string;

  /** Metric name */
  name: string;

  /** Metric value (can be int or float) */
  value: NumericValue;

  /** When the metric was recorded */
  recordedAt: utcDateTime;
}
