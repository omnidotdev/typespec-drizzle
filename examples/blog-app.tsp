/**
 * Blog Application Example
 *
 * This example demonstrates a complete blog application schema using TypeSpec
 * that will be converted to Drizzle ORM tables for PostgreSQL.
 *
 * Features demonstrated:
 * - User management with authentication
 * - Blog posts with categories and tags
 * - Comments with threading support
 * - Media attachments
 * - Content moderation
 *
 * To generate Drizzle schema:
 * npx tsp compile main.tsp --emit @omnidotdev/typespec-drizzle
 */
namespace BlogApp;

/** User account status enumeration */
enum UserStatus {
  /** User account is active and can login */
  Active: "active",

  /** User account is temporarily suspended */
  Suspended: "suspended",

  /** User account is pending email verification */
  Pending: "pending",

  /** User account has been deactivated */
  Deactivated: "deactivated",
}

/** User role enumeration for permissions */
enum UserRole {
  /** Administrator with full access */
  Admin: "admin",

  /** Editor who can manage content */
  Editor: "editor",

  /** Author who can create and edit their own content */
  Author: "author",

  /** Reader with basic access */
  Reader: "reader",
}

/** Post publication status */
enum PostStatus {
  /** Draft post, not published */
  Draft: "draft",

  /** Published and visible to readers */
  Published: "published",

  /** Scheduled for future publication */
  Scheduled: "scheduled",

  /** Archived post */
  Archived: "archived",
}

/** Content visibility settings */
enum PostVisibility {
  /** Public post visible to all */
  Public: "public",

  /** Private post only visible to author */
  Private: "private",

  /** Password protected post */
  Protected: "protected",
}

/** User model with authentication and profile information */
model User {
  /** Unique user identifier */
  id: string;

  /** Unique username for login */
  username: string;

  /** User's email address (unique) */
  email: string;

  /** Hashed password for authentication */
  passwordHash: string;

  /** User's display name */
  displayName: string;

  /** User's first name */
  firstName?: string;

  /** User's last name */
  lastName?: string;

  /** Short bio or description */
  bio?: string;

  /** Avatar image URL */
  avatarUrl?: string;

  /** User's website URL */
  websiteUrl?: string;

  /** User's location */
  location?: string;

  /** User's role in the system */
  role: UserRole;

  /** Current account status */
  status: UserStatus;

  /** Email verification status */
  emailVerified: boolean;

  /** Count of failed login attempts */
  failedLoginAttempts: int32;

  /** Timestamp of last login */
  lastLoginAt?: utcDateTime;

  /** Account creation timestamp */
  createdAt: utcDateTime;

  /** Profile last updated timestamp */
  updatedAt: utcDateTime;
}

/** Blog post category for organization */
model Category {
  /** Unique category identifier */
  id: string;

  /** Category name */
  name: string;

  /** URL-friendly category slug */
  slug: string;

  /** Category description */
  description?: string;

  /** Category color for UI (hex code) */
  color?: string;

  /** Parent category for hierarchical organization */
  parentId?: string;

  /** Display order for sorting */
  sortOrder: int32;

  /** Whether category is active */
  isActive: boolean;

  /** Category creation timestamp */
  createdAt: utcDateTime;

  /** Category last updated timestamp */
  updatedAt: utcDateTime;
}

/** Blog post tag for flexible categorization */
model Tag {
  /** Unique tag identifier */
  id: string;

  /** Tag name */
  name: string;

  /** URL-friendly tag slug */
  slug: string;

  /** Tag description */
  description?: string;

  /** Tag color for UI (hex code) */
  color?: string;

  /** Number of times this tag has been used */
  usageCount: int32;

  /** Tag creation timestamp */
  createdAt: utcDateTime;
}

/** Main blog post model */
model Post {
  /** Unique post identifier */
  id: string;

  /** Post title */
  title: string;

  /** URL-friendly post slug */
  slug: string;

  /** Post excerpt/summary */
  excerpt?: string;

  /** Full post content (Markdown) */
  content: string;

  /** Featured image URL */
  featuredImageUrl?: string;

  /** Featured image alt text */
  featuredImageAlt?: string;

  /** Post author */
  authorId: string;

  /** Post category */
  categoryId?: string;

  /** Post publication status */
  status: PostStatus;

  /** Post visibility setting */
  visibility: PostVisibility;

  /** Password for protected posts */
  password?: string;

  /** Whether post allows comments */
  allowComments: boolean;

  /** Whether post is featured */
  isFeatured: boolean;

  /** Whether post is sticky/pinned */
  isSticky: boolean;

  /** Post view count */
  viewCount: int32;

  /** Post like count */
  likeCount: int32;

  /** Post comment count */
  commentCount: int32;

  /** SEO meta title */
  metaTitle?: string;

  /** SEO meta description */
  metaDescription?: string;

  /** Reading time estimate in minutes */
  readingTime?: int32;

  /** Post scheduled publication time */
  scheduledAt?: utcDateTime;

  /** Post published timestamp */
  publishedAt?: utcDateTime;

  /** Post creation timestamp */
  createdAt: utcDateTime;

  /** Post last updated timestamp */
  updatedAt: utcDateTime;
}

/** Junction table for post-tag many-to-many relationship */
model PostTag {
  /** Unique identifier */
  id: string;

  /** Reference to post */
  postId: string;

  /** Reference to tag */
  tagId: string;

  /** When tag was added to post */
  createdAt: utcDateTime;
}

/** Blog post comment model with threading support */
model Comment {
  /** Unique comment identifier */
  id: string;

  /** Comment content */
  content: string;

  /** Reference to the post */
  postId: string;

  /** Reference to the comment author */
  authorId: string;

  /** Reference to parent comment (for replies) */
  parentCommentId?: string;

  /** Comment author's name (for guests) */
  authorName?: string;

  /** Comment author's email (for guests) */
  authorEmail?: string;

  /** Comment author's website (for guests) */
  authorWebsite?: string;

  /** Comment author's IP address */
  authorIpAddress: string;

  /** Comment approval status */
  isApproved: boolean;

  /** Whether comment is marked as spam */
  isSpam: boolean;

  /** Whether comment has been edited */
  isEdited: boolean;

  /** Comment like count */
  likeCount: int32;

  /** User agent string of commenter */
  userAgent?: string;

  /** Comment creation timestamp */
  createdAt: utcDateTime;

  /** Comment last updated timestamp */
  updatedAt: utcDateTime;
}

/** Media file model for attachments */
model Media {
  /** Unique media identifier */
  id: string;

  /** Original filename */
  originalFilename: string;

  /** Stored filename (usually UUID-based) */
  storedFilename: string;

  /** File MIME type */
  mimeType: string;

  /** File size in bytes */
  fileSize: int32;

  /** Image width (for images) */
  width?: int32;

  /** Image height (for images) */
  height?: int32;

  /** Alt text for accessibility */
  altText?: string;

  /** Media caption */
  caption?: string;

  /** Media description */
  description?: string;

  /** File storage path or URL */
  url: string;

  /** Thumbnail URL (for images/videos) */
  thumbnailUrl?: string;

  /** Reference to uploader */
  uploadedById: string;

  /** Whether media is used in content */
  isUsed: boolean;

  /** Media upload timestamp */
  uploadedAt: utcDateTime;

  /** Media last updated timestamp */
  updatedAt: utcDateTime;
}

/** Junction table for post-media relationships */
model PostMedia {
  /** Unique identifier */
  id: string;

  /** Reference to post */
  postId: string;

  /** Reference to media */
  mediaId: string;

  /** Display order in post */
  sortOrder: int32;

  /** When media was attached to post */
  createdAt: utcDateTime;
}

/** Newsletter subscriber model */
model Subscriber {
  /** Unique subscriber identifier */
  id: string;

  /** Subscriber email address */
  email: string;

  /** Subscriber's name */
  name?: string;

  /** Subscription status */
  isActive: boolean;

  /** Email verification status */
  isVerified: boolean;

  /** Verification token */
  verificationToken?: string;

  /** Unsubscribe token */
  unsubscribeToken: string;

  /** Subscriber preferences (JSON) */
  preferences?: string;

  /** Subscription timestamp */
  subscribedAt: utcDateTime;

  /** Email verified timestamp */
  verifiedAt?: utcDateTime;

  /** Last updated timestamp */
  updatedAt: utcDateTime;
}

/** Site configuration model */
model SiteConfig {
  /** Configuration key */
  key: string;

  /** Configuration value */
  value: string;

  /** Value data type for parsing */
  valueType: string;

  /** Configuration description */
  description?: string;

  /** Whether config is public (visible to frontend) */
  isPublic: boolean;

  /** Configuration group/category */
  group?: string;

  /** Configuration last updated timestamp */
  updatedAt: utcDateTime;
}

/** Analytics page view tracking */
model PageView {
  /** Unique view identifier */
  id: string;

  /** Page path that was viewed */
  path: string;

  /** Reference to post (if applicable) */
  postId?: string;

  /** Reference to user (if logged in) */
  userId?: string;

  /** Session identifier */
  sessionId: string;

  /** Visitor's IP address */
  ipAddress: string;

  /** User agent string */
  userAgent?: string;

  /** Referrer URL */
  referrer?: string;

  /** Country code from IP */
  countryCode?: string;

  /** Device type (mobile, desktop, tablet) */
  deviceType?: string;

  /** Page view timestamp */
  viewedAt: utcDateTime;
}
