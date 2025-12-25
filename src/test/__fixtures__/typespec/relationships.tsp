// Relationships fixture - Testing foreign key relationships and table associations
namespace Relationships;

/** Organization model - parent entity */
model Organization {
  /** Unique identifier for the organization */
  id: string;

  /** Organization name */
  name: string;

  /** Organization slug for URLs */
  slug: string;

  /** Organization description */
  description?: string;

  /** When the organization was created */
  createdAt: utcDateTime;

  /** When the organization was last updated */
  updatedAt?: utcDateTime;
}

/** Department model - belongs to organization */
model Department {
  /** Unique identifier for the department */
  id: string;

  /** Department name */
  name: string;

  /** Reference to parent organization */
  organizationId: string;

  /** Department budget */
  budget?: float64;

  /** Department head user ID */
  headId?: string;

  /** When the department was created */
  createdAt: utcDateTime;
}

/** User model with organization relationship */
model User {
  /** Unique identifier for the user */
  id: string;

  /** User's email address */
  email: string;

  /** User's full name */
  firstName: string;

  lastName: string;

  /** Reference to user's organization */
  organizationId: string;

  /** Reference to user's department */
  departmentId?: string;

  /** User's manager (self-referential foreign key) */
  managerId?: string;

  /** User's job title */
  jobTitle?: string;

  /** When the user joined */
  joinedAt: utcDateTime;

  /** When the user was last active */
  lastActiveAt?: utcDateTime;
}

/** Project model - many-to-many with users */
model Project {
  /** Unique identifier for the project */
  id: string;

  /** Project name */
  name: string;

  /** Project description */
  description?: string;

  /** Reference to owning organization */
  organizationId: string;

  /** Reference to project lead */
  leadId: string;

  /** Project start date */
  startDate: utcDateTime;

  /** Project end date */
  endDate?: utcDateTime;

  /** Project budget */
  budget?: float64;

  /** Project status */
  status: string;

  /** When the project was created */
  createdAt: utcDateTime;
}

/** Project membership - junction table for many-to-many relationship */
model ProjectMembership {
  /** Unique identifier for the membership */
  id: string;

  /** Reference to project */
  projectId: string;

  /** Reference to user */
  userId: string;

  /** User's role in the project */
  role: string;

  /** When the user joined the project */
  joinedAt: utcDateTime;

  /** When the user left the project */
  leftAt?: utcDateTime;

  /** Whether the membership is active */
  isActive: boolean;
}

/** Task model - belongs to project and user */
model Task {
  /** Unique identifier for the task */
  id: string;

  /** Task title */
  title: string;

  /** Task description */
  description?: string;

  /** Reference to parent project */
  projectId: string;

  /** Reference to assigned user */
  assigneeId?: string;

  /** Reference to task creator */
  creatorId: string;

  /** Reference to parent task (for subtasks) */
  parentTaskId?: string;

  /** Task priority */
  priority: string;

  /** Task status */
  status: string;

  /** Task due date */
  dueDate?: utcDateTime;

  /** When the task was created */
  createdAt: utcDateTime;

  /** When the task was completed */
  completedAt?: utcDateTime;
}

/** Comment model - belongs to task and user */
model TaskComment {
  /** Unique identifier for the comment */
  id: string;

  /** Reference to parent task */
  taskId: string;

  /** Reference to comment author */
  authorId: string;

  /** Comment content */
  content: string;

  /** Reference to parent comment (for replies) */
  parentCommentId?: string;

  /** When the comment was created */
  createdAt: utcDateTime;

  /** When the comment was last edited */
  editedAt?: utcDateTime;

  /** Whether the comment is deleted */
  isDeleted: boolean;
}

/** File attachment model - can belong to task or project */
model Attachment {
  /** Unique identifier for the attachment */
  id: string;

  /** Original filename */
  filename: string;

  /** File size in bytes */
  fileSize: int32;

  /** MIME type */
  mimeType: string;

  /** Storage path or URL */
  storageUrl: string;

  /** Reference to uploader */
  uploadedById: string;

  /** Reference to parent task (optional) */
  taskId?: string;

  /** Reference to parent project (optional) */
  projectId?: string;

  /** When the file was uploaded */
  uploadedAt: utcDateTime;
}

/** Audit log model - tracks changes to other entities */
model AuditLog {
  /** Unique identifier for the log entry */
  id: string;

  /** Type of entity that was changed */
  entityType: string;

  /** ID of the entity that was changed */
  entityId: string;

  /** Type of action performed */
  action: string;

  /** Reference to user who performed the action */
  userId: string;

  /** JSON data of changes made */
  changes?: string;

  /** IP address of the user */
  ipAddress?: string;

  /** User agent string */
  userAgent?: string;

  /** When the action was performed */
  performedAt: utcDateTime;
}

/** Notification model - belongs to user */
model Notification {
  /** Unique identifier for the notification */
  id: string;

  /** Reference to recipient user */
  userId: string;

  /** Notification title */
  title: string;

  /** Notification message */
  message: string;

  /** Type of notification */
  type: string;

  /** Reference to related entity (optional) */
  relatedEntityType?: string;

  relatedEntityId?: string;

  /** Whether the notification has been read */
  isRead: boolean;

  /** When the notification was created */
  createdAt: utcDateTime;

  /** When the notification was read */
  readAt?: utcDateTime;
}
