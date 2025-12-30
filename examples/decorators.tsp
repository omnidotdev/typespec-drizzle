import "@omnidotdev/typespec-drizzle";

using Drizzle;

/**
 * Decorators Demo Example
 *
 * This example demonstrates how to use Drizzle-specific decorators
 * to define database tables, relationships, and constraints in TypeSpec.
 *
 * To generate Drizzle schema:
 * npx tsp compile main.tsp --emit @omnidotdev/typespec-drizzle
 */
namespace Decorators;

/** User status enumeration */
enum UserStatus {
  Active: "active",
  Inactive: "inactive",
  Suspended: "suspended",
}

/** User role enumeration */
enum UserRole {
  Admin: "admin",
  User: "user",
  Moderator: "moderator",
}

/** User model with comprehensive decorator usage */
@table(#{ name: "users", schema: "public" })
model User {
  @id
  @uuid
  @column(#{ name: "user_id" })
  id: string = Defaults.uuidv4;

  @unique
  @index(#{ name: "idx_username" })
  username: string;

  @unique
  @index(#{ name: "idx_email" })
  email: string;

  @column(#{ name: "password_hash" })
  passwordHash: string;

  displayName: string = "User";
  firstName?: string;
  lastName?: string;
  bio?: string;
  status: UserStatus = UserStatus.Active;
  role: UserRole = UserRole.User;
  emailVerified: boolean = false;

  @index(#{ name: "idx_created_at" })
  createdAt: utcDateTime = Defaults.currentTimestamp;

  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

/** Profile model with one-to-one relationship */
@table(#{ name: "user_profiles" })
model UserProfile {
  @id
  @uuid
  id: string = Defaults.uuidv4;

  @oneToOne(#{ fields: "userId", references: "id" })
  @unique
  userId: string;

  avatarUrl?: string;
  bio?: string;
  website?: string;
  location?: string;
  createdAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

/** Category model */
@table(#{ name: "categories" })
model Category {
  @id
  @uuid
  id: string = Defaults.uuidv4;

  @unique
  name: string;

  @unique
  @index(#{ name: "idx_category_slug" })
  slug: string;

  description?: string;
  color: string = "#000000";

  @manyToOne(#{ fields: "parentId", references: "id" })
  parentId?: string;

  sortOrder: int32 = 0;
  isActive: boolean = true;
  createdAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

/** Tag model for many-to-many relationships */
@table(#{ name: "tags" })
model Tag {
  @id
  @uuid
  id: string = Defaults.uuidv4;

  @unique
  name: string;

  @unique
  slug: string;

  description?: string;
  color: string = "#007acc";
  usageCount: int32 = 0;
  createdAt: utcDateTime = Defaults.currentTimestamp;
}

/** Post model with various relationships */
@table(#{ name: "posts" })
model Post {
  @id
  @uuid
  id: string = Defaults.uuidv4;

  title: string;

  @unique
  @index(#{ name: "idx_post_slug" })
  slug: string;

  excerpt?: string;
  content: string;

  @manyToOne(#{ fields: "authorId", references: "id" })
  authorId: string;

  @manyToOne(#{ fields: "categoryId", references: "id" })
  categoryId?: string;

  status: string = "draft";
  allowComments: boolean = true;
  isFeatured: boolean = false;
  viewCount: int32 = 0;
  likeCount: int32 = 0;
  publishedAt?: utcDateTime;
  createdAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

/** Junction table for post-tag many-to-many relationship */
@junction
@table(#{ name: "post_tags" })
model PostTag {
  @id
  @uuid
  id: string = Defaults.uuidv4;

  @manyToOne(#{ fields: "postId", references: "id" })
  postId: string;

  @manyToOne(#{ fields: "tagId", references: "id" })
  tagId: string;

  createdAt: utcDateTime = Defaults.currentTimestamp;
}

/** Comment model with self-referencing relationship */
@table(#{ name: "comments" })
model Comment {
  @id
  @uuid
  id: string = Defaults.uuidv4;

  content: string;

  @manyToOne(#{ fields: "postId", references: "id" })
  postId: string;

  @manyToOne(#{ fields: "authorId", references: "id" })
  authorId: string;

  @manyToOne(#{ fields: "parentCommentId", references: "id" })
  parentCommentId?: string;

  isApproved: boolean = false;
  isSpam: boolean = false;
  likeCount: int32 = 0;
  createdAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

/** Settings model with unique constraints */
@table(#{ name: "site_settings" })
model SiteSetting {
  @id
  @unique
  key: string;

  value: string;
  valueType: string = "string";
  description?: string;
  isPublic: boolean = false;
  settingsGroup: string = "general";
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

/** Analytics model with indexes */
@table(#{ name: "page_views" })
model PageView {
  @id
  @autoIncrement
  id: int64;

  @index(#{ name: "idx_page_path" })
  path: string;

  @manyToOne(#{ fields: "postId", references: "id" })
  postId?: string;

  @manyToOne(#{ fields: "userId", references: "id" })
  userId?: string;

  sessionId: string;

  @index(#{ name: "idx_ip_address" })
  ipAddress: string;

  userAgent?: string;
  referrer?: string;
  countryCode?: string;
  deviceType?: string;

  @index(#{ name: "idx_viewed_at" })
  viewedAt: utcDateTime = Defaults.currentTimestamp;
}
