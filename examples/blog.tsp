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
  @id @uuid id: string = Defaults.uuidv4;
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
  createdAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model Category {
  @id @uuid id: string = Defaults.uuidv4;
  name: string;
  @unique slug: string;
  description?: string;
  color?: string;
  parentId?: string;
  sortOrder: int32;
  isActive: boolean;
  createdAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model Tag {
  @id @uuid id: string = Defaults.uuidv4;
  name: string;
  @unique slug: string;
  description?: string;
  color?: string;
  usageCount: int32;
  createdAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model Post {
  @id @uuid id: string = Defaults.uuidv4;
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
  createdAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

@table
@junction
model PostTag {
  @id @uuid id: string = Defaults.uuidv4;
  postId: string;
  tagId: string;
  createdAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model Comment {
  @id @uuid id: string = Defaults.uuidv4;
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
  createdAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model Media {
  @id @uuid id: string = Defaults.uuidv4;
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
  uploadedAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

@table
@junction
model PostMedia {
  @id @uuid id: string = Defaults.uuidv4;
  postId: string;
  mediaId: string;
  sortOrder: int32;
  createdAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model Subscriber {
  @id @uuid id: string = Defaults.uuidv4;
  @unique email: string;
  name?: string;
  isActive: boolean;
  isVerified: boolean;
  verificationToken?: string;
  unsubscribeToken: string;
  preferences?: string;
  subscribedAt: utcDateTime = Defaults.currentTimestamp;
  verifiedAt?: utcDateTime;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model SiteConfig {
  @id key: string;
  value: string;
  valueType: string;
  description?: string;
  isPublic: boolean;
  group?: string;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model PageView {
  @id @uuid id: string = Defaults.uuidv4;
  path: string;
  postId?: string;
  userId?: string;
  sessionId: string;
  ipAddress: string;
  userAgent?: string;
  referrer?: string;
  countryCode?: string;
  deviceType?: string;
  viewedAt: utcDateTime = Defaults.currentTimestamp;
}
