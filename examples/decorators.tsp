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
namespace DecoratorsDemo;

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
  @column(#{ name: "user_id" })
  id: string;

  @unique
  @index(#{ name: "idx_username" })
  username: string;

  @unique
  @index(#{ name: "idx_email" })
  email: string;

  @column(#{ name: "password_hash" })
  passwordHash: string;

  @defaultValue("'User'")
  displayName: string;

  firstName?: string;
  lastName?: string;
  bio?: string;

  @defaultValue("'active'")
  status: UserStatus;

  @defaultValue("'user'")
  role: UserRole;

  @defaultValue("false")
  emailVerified: boolean;

  @defaultValue("now()")
  @index(#{ name: "idx_created_at" })
  createdAt: utcDateTime;

  @defaultValue("now()")
  updatedAt: utcDateTime;
}

/** Profile model with one-to-one relationship */
@table(#{ name: "user_profiles" })
model UserProfile {
  @id
  id: string;

  @oneToOne(#{ fields: "userId", references: "id" })
  @unique
  userId: string;

  avatarUrl?: string;
  bio?: string;
  website?: string;
  location?: string;

  @defaultValue("now()")
  createdAt: utcDateTime;

  @defaultValue("now()")
  updatedAt: utcDateTime;
}

/** Category model */
@table(#{ name: "categories" })
model Category {
  @id
  id: string;

  @unique
  name: string;

  @unique
  @index(#{ name: "idx_category_slug" })
  slug: string;

  description?: string;

  @defaultValue("'#000000'")
  color: string;

  @manyToOne(#{ fields: "parentId", references: "id" })
  parentId?: string;

  @defaultValue("0")
  sortOrder: int32;

  @defaultValue("true")
  isActive: boolean;

  @defaultValue("now()")
  createdAt: utcDateTime;

  @defaultValue("now()")
  updatedAt: utcDateTime;
}

/** Tag model for many-to-many relationships */
@table(#{ name: "tags" })
model Tag {
  @id
  id: string;

  @unique
  name: string;

  @unique
  slug: string;

  description?: string;

  @defaultValue("'#007acc'")
  color: string;

  @defaultValue("0")
  usageCount: int32;

  @defaultValue("now()")
  createdAt: utcDateTime;
}

/** Post model with various relationships */
@table(#{ name: "posts" })
model Post {
  @id
  id: string;

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

  @defaultValue("'draft'")
  status: string;

  @defaultValue("true")
  allowComments: boolean;

  @defaultValue("false")
  isFeatured: boolean;

  @defaultValue("0")
  viewCount: int32;

  @defaultValue("0")
  likeCount: int32;

  publishedAt?: utcDateTime;

  @defaultValue("now()")
  createdAt: utcDateTime;

  @defaultValue("now()")
  updatedAt: utcDateTime;
}

/** Junction table for post-tag many-to-many relationship */
@junction
@table(#{ name: "post_tags" })
model PostTag {
  @id
  id: string;

  @manyToOne(#{ fields: "postId", references: "id" })
  postId: string;

  @manyToOne(#{ fields: "tagId", references: "id" })
  tagId: string;

  @defaultValue("now()")
  createdAt: utcDateTime;
}

/** Comment model with self-referencing relationship */
@table(#{ name: "comments" })
model Comment {
  @id
  id: string;

  content: string;

  @manyToOne(#{ fields: "postId", references: "id" })
  postId: string;

  @manyToOne(#{ fields: "authorId", references: "id" })
  authorId: string;

  @manyToOne(#{ fields: "parentCommentId", references: "id" })
  parentCommentId?: string;

  @defaultValue("false")
  isApproved: boolean;

  @defaultValue("false")
  isSpam: boolean;

  @defaultValue("0")
  likeCount: int32;

  @defaultValue("now()")
  createdAt: utcDateTime;

  @defaultValue("now()")
  updatedAt: utcDateTime;
}

/** Settings model with unique constraints */
@table(#{ name: "site_settings" })
model SiteSetting {
  @id
  @unique
  key: string;

  value: string;

  @defaultValue("'string'")
  valueType: string;

  description?: string;

  @defaultValue("false")
  isPublic: boolean;

  @defaultValue("'general'")
  settingsGroup: string;

  @defaultValue("now()")
  updatedAt: utcDateTime;
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

  @defaultValue("now()")
  @index(#{ name: "idx_viewed_at" })
  viewedAt: utcDateTime;
}
