/**
 * Blog Application Example
 *
 * Demonstrates a complete blog application schema using TypeSpec
 * converted to Drizzle ORM tables for PostgreSQL.
 */
import "@omnidotdev/typespec-drizzle";

using Drizzle;

namespace BlogApp;

enum UserStatus {
  Active: "active",
  Suspended: "suspended",
  Pending: "pending",
  Deactivated: "deactivated",
}

enum UserRole {
  Admin: "admin",
  Editor: "editor",
  Author: "author",
  Reader: "reader",
}

enum PostStatus {
  Draft: "draft",
  Published: "published",
  Scheduled: "scheduled",
  Archived: "archived",
}

enum PostVisibility {
  Public: "public",
  Private: "private",
  Protected: "protected",
}

@table
model User {
  @id id: string;
  @unique username: string;
  @unique email: string;
  passwordHash: string;
  displayName: string;
  firstName?: string;
  lastName?: string;
  bio?: string;
  avatarUrl?: string;
  websiteUrl?: string;
  location?: string;
  role: UserRole;
  status: UserStatus;
  emailVerified: boolean;
  failedLoginAttempts: int32;
  lastLoginAt?: utcDateTime;
  @defaultValue("now()") createdAt: utcDateTime;
  @defaultValue("now()") updatedAt: utcDateTime;
}

@table
model Category {
  @id id: string;
  name: string;
  @unique slug: string;
  description?: string;
  color?: string;
  parentId?: string;
  sortOrder: int32;
  isActive: boolean;
  @defaultValue("now()") createdAt: utcDateTime;
  @defaultValue("now()") updatedAt: utcDateTime;
}

@table
model Tag {
  @id id: string;
  name: string;
  @unique slug: string;
  description?: string;
  color?: string;
  usageCount: int32;
  @defaultValue("now()") createdAt: utcDateTime;
}

@table
model Post {
  @id id: string;
  title: string;
  @unique slug: string;
  excerpt?: string;
  content: string;
  featuredImageUrl?: string;
  featuredImageAlt?: string;
  authorId: string;
  categoryId?: string;
  status: PostStatus;
  visibility: PostVisibility;
  password?: string;
  allowComments: boolean;
  isFeatured: boolean;
  isSticky: boolean;
  viewCount: int32;
  likeCount: int32;
  commentCount: int32;
  metaTitle?: string;
  metaDescription?: string;
  readingTime?: int32;
  scheduledAt?: utcDateTime;
  publishedAt?: utcDateTime;
  @defaultValue("now()") createdAt: utcDateTime;
  @defaultValue("now()") updatedAt: utcDateTime;
}

@table
@junction
model PostTag {
  @id id: string;
  postId: string;
  tagId: string;
  @defaultValue("now()") createdAt: utcDateTime;
}

@table
model Comment {
  @id id: string;
  content: string;
  postId: string;
  authorId: string;
  parentCommentId?: string;
  authorName?: string;
  authorEmail?: string;
  authorWebsite?: string;
  authorIpAddress: string;
  isApproved: boolean;
  isSpam: boolean;
  isEdited: boolean;
  likeCount: int32;
  userAgent?: string;
  @defaultValue("now()") createdAt: utcDateTime;
  @defaultValue("now()") updatedAt: utcDateTime;
}

@table
model Media {
  @id id: string;
  originalFilename: string;
  storedFilename: string;
  mimeType: string;
  fileSize: int32;
  width?: int32;
  height?: int32;
  altText?: string;
  caption?: string;
  description?: string;
  url: string;
  thumbnailUrl?: string;
  uploadedById: string;
  isUsed: boolean;
  @defaultValue("now()") uploadedAt: utcDateTime;
  @defaultValue("now()") updatedAt: utcDateTime;
}

@table
@junction
model PostMedia {
  @id id: string;
  postId: string;
  mediaId: string;
  sortOrder: int32;
  @defaultValue("now()") createdAt: utcDateTime;
}

@table
model Subscriber {
  @id id: string;
  @unique email: string;
  name?: string;
  isActive: boolean;
  isVerified: boolean;
  verificationToken?: string;
  unsubscribeToken: string;
  preferences?: string;
  @defaultValue("now()") subscribedAt: utcDateTime;
  verifiedAt?: utcDateTime;
  @defaultValue("now()") updatedAt: utcDateTime;
}

@table
model SiteConfig {
  @id key: string;
  value: string;
  valueType: string;
  description?: string;
  isPublic: boolean;
  group?: string;
  @defaultValue("now()") updatedAt: utcDateTime;
}

@table
model PageView {
  @id id: string;
  path: string;
  postId?: string;
  userId?: string;
  sessionId: string;
  ipAddress: string;
  userAgent?: string;
  referrer?: string;
  countryCode?: string;
  deviceType?: string;
  @defaultValue("now()") viewedAt: utcDateTime;
}
