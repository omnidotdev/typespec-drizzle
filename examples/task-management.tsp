/**
 * Task Management Application Example
 *
 * This example demonstrates a comprehensive team task management system using TypeSpec
 * that will be converted to Drizzle ORM tables for PostgreSQL.
 *
 * Features demonstrated:
 * - Team and organization management
 * - Project organization with workspaces
 * - Task creation with dependencies and subtasks
 * - Time tracking and reporting
 * - Team collaboration features
 * - File attachments and comments
 * - Activity logging and notifications
 *
 * To generate Drizzle schema:
 * npx tsp compile main.tsp --emit @omnidotdev/typespec-drizzle
 */
namespace TaskManagement;

/** User role enumeration for permissions */
enum UserRole {
  /** Organization owner with full access */
  Owner: "owner",

  /** Administrator with management access */
  Admin: "admin",

  /** Project manager with project oversight */
  Manager: "manager",

  /** Team member with standard access */
  Member: "member",

  /** Guest with limited read access */
  Guest: "guest",
}

/** Task priority levels */
enum TaskPriority {
  /** Low priority task */
  Low: "low",

  /** Normal priority task */
  Normal: "normal",

  /** High priority task */
  High: "high",

  /** Critical priority task */
  Critical: "critical",
}

/** Task status enumeration */
enum TaskStatus {
  /** Task has not been started */
  NotStarted: "not_started",

  /** Task is currently in progress */
  InProgress: "in_progress",

  /** Task is blocked by dependencies */
  Blocked: "blocked",

  /** Task is under review */
  InReview: "in_review",

  /** Task has been completed */
  Complete: "complete",

  /** Task has been cancelled */
  Cancelled: "cancelled",
}

/** Project status enumeration */
enum ProjectStatus {
  /** Project is in planning phase */
  Planning: "planning",

  /** Project is active */
  Active: "active",

  /** Project is on hold */
  OnHold: "on_hold",

  /** Project has been completed */
  Completed: "completed",

  /** Project has been cancelled */
  Cancelled: "cancelled",
}

/** Time entry type enumeration */
enum TimeEntryType {
  /** Regular work time */
  Work: "work",

  /** Meeting time */
  Meeting: "meeting",

  /** Research and learning time */
  Research: "research",

  /** Bug fixing time */
  BugFix: "bug_fix",

  /** Code review time */
  Review: "review",
}

/** Organization model for multi-tenancy */
model Organization {
  /** Unique organization identifier */
  id: string;

  /** Organization name */
  name: string;

  /** Organization slug for URLs */
  slug: string;

  /** Organization description */
  description?: string;

  /** Organization logo URL */
  logoUrl?: string;

  /** Organization website URL */
  websiteUrl?: string;

  /** Billing email address */
  billingEmail?: string;

  /** Organization timezone */
  timezone: string;

  /** Organization creation timestamp */
  createdAt: utcDateTime;

  /** Organization last updated timestamp */
  updatedAt: utcDateTime;
}

/** User model with authentication and profile */
model User {
  /** Unique user identifier */
  id: string;

  /** User email address (unique) */
  email: string;

  /** Hashed password for authentication */
  passwordHash: string;

  /** User's first name */
  firstName: string;

  /** User's last name */
  lastName: string;

  /** User's avatar image URL */
  avatarUrl?: string;

  /** User's job title */
  jobTitle?: string;

  /** User's timezone */
  timezone?: string;

  /** User's preferred language */
  language?: string;

  /** Email verification status */
  emailVerified: boolean;

  /** User's last login timestamp */
  lastLoginAt?: utcDateTime;

  /** User registration timestamp */
  createdAt: utcDateTime;

  /** User profile last updated timestamp */
  updatedAt: utcDateTime;
}

/** Organization membership model */
model OrganizationMember {
  /** Unique membership identifier */
  id: string;

  /** Reference to organization */
  organizationId: string;

  /** Reference to user */
  userId: string;

  /** User's role in the organization */
  role: UserRole;

  /** Whether the user has accepted the invitation */
  isActive: boolean;

  /** Invitation email (if different from user email) */
  invitationEmail?: string;

  /** When the user joined the organization */
  joinedAt: utcDateTime;

  /** Membership creation timestamp */
  createdAt: utcDateTime;

  /** Membership last updated timestamp */
  updatedAt: utcDateTime;
}

/** Team model for grouping users within an organization */
model Team {
  /** Unique team identifier */
  id: string;

  /** Reference to organization */
  organizationId: string;

  /** Team name */
  name: string;

  /** Team description */
  description?: string;

  /** Team color for UI (hex code) */
  color?: string;

  /** Reference to team lead */
  leadId?: string;

  /** Whether the team is active */
  isActive: boolean;

  /** Team creation timestamp */
  createdAt: utcDateTime;

  /** Team last updated timestamp */
  updatedAt: utcDateTime;
}

/** Team membership model */
model TeamMember {
  /** Unique team membership identifier */
  id: string;

  /** Reference to team */
  teamId: string;

  /** Reference to user */
  userId: string;

  /** When the user joined the team */
  joinedAt: utcDateTime;

  /** Team membership creation timestamp */
  createdAt: utcDateTime;
}

/** Project model */
model Project {
  /** Unique project identifier */
  id: string;

  /** Reference to organization */
  organizationId: string;

  /** Reference to team (optional) */
  teamId?: string;

  /** Project name */
  name: string;

  /** Project description */
  description?: string;

  /** Project color for UI (hex code) */
  color?: string;

  /** Reference to project manager */
  managerId?: string;

  /** Project status */
  status: ProjectStatus;

  /** Project start date */
  startDate?: utcDateTime;

  /** Project due date */
  dueDate?: utcDateTime;

  /** Project completion date */
  completedAt?: utcDateTime;

  /** Whether the project is archived */
  isArchived: boolean;

  /** Project creation timestamp */
  createdAt: utcDateTime;

  /** Project last updated timestamp */
  updatedAt: utcDateTime;
}

/** Task list/section within a project */
model TaskList {
  /** Unique task list identifier */
  id: string;

  /** Reference to project */
  projectId: string;

  /** Task list name */
  name: string;

  /** Task list description */
  description?: string;

  /** Display order within project */
  sortOrder: int32;

  /** Whether the task list is archived */
  isArchived: boolean;

  /** Task list creation timestamp */
  createdAt: utcDateTime;

  /** Task list last updated timestamp */
  updatedAt: utcDateTime;
}

/** Main task model */
model Task {
  /** Unique task identifier */
  id: string;

  /** Reference to project */
  projectId: string;

  /** Reference to task list */
  taskListId: string;

  /** Reference to parent task (for subtasks) */
  parentTaskId?: string;

  /** Task title */
  title: string;

  /** Task description */
  description?: string;

  /** Task priority */
  priority: TaskPriority;

  /** Task status */
  status: TaskStatus;

  /** Reference to assigned user */
  assigneeId?: string;

  /** Reference to task creator */
  creatorId: string;

  /** Task due date */
  dueDate?: utcDateTime;

  /** Estimated hours to complete */
  estimatedHours?: float64;

  /** Actual hours spent */
  actualHours?: float64;

  /** Display order within task list */
  sortOrder: int32;

  /** Whether the task is archived */
  isArchived: boolean;

  /** Task start date */
  startedAt?: utcDateTime;

  /** Task completion date */
  completedAt?: utcDateTime;

  /** Task creation timestamp */
  createdAt: utcDateTime;

  /** Task last updated timestamp */
  updatedAt: utcDateTime;
}

/** Task dependency model for task relationships */
model TaskDependency {
  /** Unique dependency identifier */
  id: string;

  /** Task that depends on another */
  dependentTaskId: string;

  /** Task that must be completed first */
  prerequisiteTaskId: string;

  /** Dependency creation timestamp */
  createdAt: utcDateTime;
}

/** Task label/tag model */
model TaskLabel {
  /** Unique label identifier */
  id: string;

  /** Reference to organization */
  organizationId: string;

  /** Label name */
  name: string;

  /** Label color (hex code) */
  color: string;

  /** Label description */
  description?: string;

  /** Label creation timestamp */
  createdAt: utcDateTime;
}

/** Junction table for task-label relationship */
model TaskLabelAssignment {
  /** Unique assignment identifier */
  id: string;

  /** Reference to task */
  taskId: string;

  /** Reference to label */
  labelId: string;

  /** Assignment creation timestamp */
  createdAt: utcDateTime;
}

/** Task comment model */
model TaskComment {
  /** Unique comment identifier */
  id: string;

  /** Reference to task */
  taskId: string;

  /** Reference to comment author */
  authorId: string;

  /** Comment content */
  content: string;

  /** Reference to parent comment (for replies) */
  parentCommentId?: string;

  /** Whether the comment has been edited */
  isEdited: boolean;

  /** Comment creation timestamp */
  createdAt: utcDateTime;

  /** Comment last updated timestamp */
  updatedAt: utcDateTime;
}

/** File attachment model */
model Attachment {
  /** Unique attachment identifier */
  id: string;

  /** Reference to task */
  taskId: string;

  /** Reference to uploader */
  uploadedById: string;

  /** Original filename */
  originalFilename: string;

  /** Stored filename */
  storedFilename: string;

  /** File MIME type */
  mimeType: string;

  /** File size in bytes */
  fileSize: int32;

  /** File URL or storage path */
  fileUrl: string;

  /** File upload timestamp */
  uploadedAt: utcDateTime;
}

/** Time tracking entry model */
model TimeEntry {
  /** Unique time entry identifier */
  id: string;

  /** Reference to task */
  taskId: string;

  /** Reference to user who logged time */
  userId: string;

  /** Time entry type */
  type: TimeEntryType;

  /** Time entry description */
  description?: string;

  /** Hours logged */
  hours: float64;

  /** Date of work */
  workDate: utcDateTime;

  /** Whether the entry is billable */
  isBillable: boolean;

  /** Hourly rate for billing */
  hourlyRate?: float64;

  /** Time entry creation timestamp */
  createdAt: utcDateTime;

  /** Time entry last updated timestamp */
  updatedAt: utcDateTime;
}

/** Activity log model for tracking changes */
model ActivityLog {
  /** Unique activity identifier */
  id: string;

  /** Reference to organization */
  organizationId: string;

  /** Reference to project (if applicable) */
  projectId?: string;

  /** Reference to task (if applicable) */
  taskId?: string;

  /** Reference to user who performed the action */
  userId: string;

  /** Type of action performed */
  action: string;

  /** Entity type that was affected */
  entityType: string;

  /** ID of the entity that was affected */
  entityId: string;

  /** Changes made (JSON) */
  changes?: string;

  /** Additional metadata (JSON) */
  metadata?: string;

  /** Activity timestamp */
  createdAt: utcDateTime;
}

/** Notification model */
model Notification {
  /** Unique notification identifier */
  id: string;

  /** Reference to recipient user */
  userId: string;

  /** Notification title */
  title: string;

  /** Notification message */
  message: string;

  /** Notification type */
  type: string;

  /** Reference to related entity */
  entityType?: string;

  /** ID of related entity */
  entityId?: string;

  /** Whether the notification has been read */
  isRead: boolean;

  /** Whether the notification was sent via email */
  emailSent: boolean;

  /** Notification creation timestamp */
  createdAt: utcDateTime;

  /** When the notification was read */
  readAt?: utcDateTime;
}

/** Project milestone model */
model Milestone {
  /** Unique milestone identifier */
  id: string;

  /** Reference to project */
  projectId: string;

  /** Milestone title */
  title: string;

  /** Milestone description */
  description?: string;

  /** Milestone due date */
  dueDate?: utcDateTime;

  /** Whether the milestone is completed */
  isCompleted: boolean;

  /** Display order within project */
  sortOrder: int32;

  /** Milestone completion timestamp */
  completedAt?: utcDateTime;

  /** Milestone creation timestamp */
  createdAt: utcDateTime;

  /** Milestone last updated timestamp */
  updatedAt: utcDateTime;
}

/** Custom field definition model */
model CustomField {
  /** Unique custom field identifier */
  id: string;

  /** Reference to organization */
  organizationId: string;

  /** Field name */
  name: string;

  /** Field type (text, number, date, select, etc.) */
  fieldType: string;

  /** Field options for select fields (JSON) */
  options?: string;

  /** Whether the field is required */
  isRequired: boolean;

  /** Entity type this field applies to */
  entityType: string;

  /** Display order */
  sortOrder: int32;

  /** Field creation timestamp */
  createdAt: utcDateTime;

  /** Field last updated timestamp */
  updatedAt: utcDateTime;
}

/** Custom field value model */
model CustomFieldValue {
  /** Unique value identifier */
  id: string;

  /** Reference to custom field */
  fieldId: string;

  /** ID of the entity this value belongs to */
  entityId: string;

  /** Field value */
  value?: string;

  /** Value creation timestamp */
  createdAt: utcDateTime;

  /** Value last updated timestamp */
  updatedAt: utcDateTime;
}

/** Recurring task template model */
model RecurringTemplate {
  /** Unique template identifier */
  id: string;

  /** Reference to project */
  projectId: string;

  /** Reference to task list */
  taskListId: string;

  /** Template title */
  title: string;

  /** Template description */
  description?: string;

  /** Task priority */
  priority: TaskPriority;

  /** Reference to default assignee */
  assigneeId?: string;

  /** Recurrence pattern (daily, weekly, monthly, etc.) */
  recurrencePattern: string;

  /** Recurrence interval (every N days/weeks/months) */
  recurrenceInterval: int32;

  /** Days of week for weekly recurrence (JSON array) */
  daysOfWeek?: string;

  /** Day of month for monthly recurrence */
  dayOfMonth?: int32;

  /** Whether the template is active */
  isActive: boolean;

  /** Next scheduled creation date */
  nextRunAt?: utcDateTime;

  /** Template creation timestamp */
  createdAt: utcDateTime;

  /** Template last updated timestamp */
  updatedAt: utcDateTime;
}
