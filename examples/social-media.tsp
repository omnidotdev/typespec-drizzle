/**
 * Social Media Platform Example
 *
 * This example demonstrates a comprehensive social media platform schema using TypeSpec
 * that will be converted to Drizzle ORM tables for PostgreSQL.
 *
 * Features demonstrated:
 * - User profiles and authentication
 * - Posts with rich media support
 * - Social interactions (likes, shares, comments)
 * - Following/follower relationships
 * - Direct messaging system
 * - Content moderation
 * - Hashtags and mentions
 * - Stories and highlights
 *
 * To generate Drizzle schema:
 * npx tsp compile main.tsp --emit @omnidotdev/typespec-drizzle
 */
namespace SocialMedia;

/** User account status enumeration */
enum UserStatus {
  /** Active user account */
  Active: "active",

  /** Temporarily suspended account */
  Suspended: "suspended",

  /** Account pending verification */
  Pending: "pending",

  /** Deactivated account */
  Deactivated: "deactivated",

  /** Banned account */
  Banned: "banned",
}

/** User account visibility settings */
enum AccountVisibility {
  /** Public profile visible to all */
  Public: "public",

  /** Private profile, requires approval to follow */
  Private: "private",
}

/** Post type enumeration */
enum PostType {
  /** Regular text/image post */
  Regular: "regular",

  /** Story post (24h expiry) */
  Story: "story",

  /** Repost/share of another post */
  Repost: "repost",

  /** Poll post */
  Poll: "poll",
}

/** Post visibility enumeration */
enum PostVisibility {
  /** Public post visible to all */
  Public: "public",

  /** Post visible to followers only */
  FollowersOnly: "followers_only",

  /** Post visible to close friends only */
  CloseFriends: "close_friends",

  /** Private post visible to author only */
  Private: "private",
}

/** Media type enumeration */
enum MediaType {
  /** Image media */
  Image: "image",

  /** Video media */
  Video: "video",

  /** Audio media */
  Audio: "audio",

  /** GIF media */
  Gif: "gif",
}

/** Notification type enumeration */
enum NotificationType {
  /** Someone liked your post */
  Like: "like",

  /** Someone commented on your post */
  Comment: "comment",

  /** Someone shared your post */
  Share: "share",

  /** Someone started following you */
  Follow: "follow",

  /** Someone mentioned you */
  Mention: "mention",

  /** Someone sent you a direct message */
  DirectMessage: "direct_message",

  /** System notification */
  System: "system",
}

/** Report reason enumeration */
enum ReportReason {
  /** Spam content */
  Spam: "spam",

  /** Inappropriate content */
  Inappropriate: "inappropriate",

  /** Harassment or bullying */
  Harassment: "harassment",

  /** Hate speech */
  HateSpeech: "hate_speech",

  /** Violence or threats */
  Violence: "violence",

  /** Copyright violation */
  Copyright: "copyright",

  /** Misinformation */
  Misinformation: "misinformation",

  /** Other reason */
  Other: "other",
}

/** User model with profile and authentication */
model User {
  /** Unique user identifier */
  id: string;

  /** Unique username */
  username: string;

  /** User email address (unique) */
  email: string;

  /** Hashed password for authentication */
  passwordHash: string;

  /** User's display name */
  displayName: string;

  /** User biography */
  bio?: string;

  /** Profile picture URL */
  profilePictureUrl?: string;

  /** Cover photo URL */
  coverPhotoUrl?: string;

  /** User's website URL */
  websiteUrl?: string;

  /** User's location */
  location?: string;

  /** User's birth date */
  birthDate?: utcDateTime;

  /** User's phone number */
  phoneNumber?: string;

  /** Account status */
  status: UserStatus;

  /** Account visibility setting */
  visibility: AccountVisibility;

  /** Whether user is verified (blue checkmark) */
  isVerified: boolean;

  /** Whether user is a business account */
  isBusiness: boolean;

  /** Email verification status */
  emailVerified: boolean;

  /** Phone verification status */
  phoneVerified: boolean;

  /** Two-factor authentication enabled */
  twoFactorEnabled: boolean;

  /** Follower count */
  followerCount: int32;

  /** Following count */
  followingCount: int32;

  /** Post count */
  postCount: int32;

  /** User's timezone */
  timezone?: string;

  /** User's preferred language */
  language?: string;

  /** Last login timestamp */
  lastLoginAt?: utcDateTime;

  /** Last active timestamp */
  lastActiveAt?: utcDateTime;

  /** Account creation timestamp */
  createdAt: utcDateTime;

  /** Profile last updated timestamp */
  updatedAt: utcDateTime;
}

/** User session model for authentication */
model UserSession {
  /** Unique session identifier */
  id: string;

  /** Reference to user */
  userId: string;

  /** Session token */
  token: string;

  /** Device information */
  deviceInfo?: string;

  /** IP address */
  ipAddress?: string;

  /** User agent string */
  userAgent?: string;

  /** Session expiry timestamp */
  expiresAt: utcDateTime;

  /** Session creation timestamp */
  createdAt: utcDateTime;
}

/** Follow relationship model */
model Follow {
  /** Unique follow identifier */
  id: string;

  /** User who is following */
  followerId: string;

  /** User being followed */
  followingId: string;

  /** Whether follow request is approved (for private accounts) */
  isApproved: boolean;

  /** Whether follower is in close friends list */
  isCloseFriend: boolean;

  /** When the follow relationship was created */
  createdAt: utcDateTime;

  /** When the follow was approved */
  approvedAt?: utcDateTime;
}

/** Main post model */
model Post {
  /** Unique post identifier */
  id: string;

  /** Reference to post author */
  authorId: string;

  /** Post type */
  type: PostType;

  /** Post content/caption */
  content?: string;

  /** Post visibility setting */
  visibility: PostVisibility;

  /** Reference to original post (for reposts) */
  originalPostId?: string;

  /** Location tag */
  location?: string;

  /** Whether comments are disabled */
  commentsDisabled: boolean;

  /** Whether post is pinned to profile */
  isPinned: boolean;

  /** Whether post is archived */
  isArchived: boolean;

  /** Like count */
  likeCount: int32;

  /** Comment count */
  commentCount: int32;

  /** Share count */
  shareCount: int32;

  /** View count */
  viewCount: int32;

  /** Post expiry timestamp (for stories) */
  expiresAt?: utcDateTime;

  /** Post creation timestamp */
  createdAt: utcDateTime;

  /** Post last updated timestamp */
  updatedAt: utcDateTime;
}

/** Post media attachment model */
model PostMedia {
  /** Unique media identifier */
  id: string;

  /** Reference to post */
  postId: string;

  /** Media type */
  type: MediaType;

  /** Media file URL */
  url: string;

  /** Thumbnail URL (for videos) */
  thumbnailUrl?: string;

  /** Media width in pixels */
  width?: int32;

  /** Media height in pixels */
  height?: int32;

  /** Media duration in seconds (for videos/audio) */
  duration?: int32;

  /** File size in bytes */
  fileSize?: int32;

  /** Alt text for accessibility */
  altText?: string;

  /** Display order in post */
  sortOrder: int32;

  /** Media upload timestamp */
  createdAt: utcDateTime;
}

/** Hashtag model */
model Hashtag {
  /** Unique hashtag identifier */
  id: string;

  /** Hashtag name (without #) */
  name: string;

  /** Usage count */
  usageCount: int32;

  /** Whether hashtag is trending */
  isTrending: boolean;

  /** Hashtag creation timestamp */
  createdAt: utcDateTime;

  /** Last used timestamp */
  lastUsedAt: utcDateTime;
}

/** Junction table for post-hashtag relationship */
model PostHashtag {
  /** Unique identifier */
  id: string;

  /** Reference to post */
  postId: string;

  /** Reference to hashtag */
  hashtagId: string;

  /** When hashtag was added to post */
  createdAt: utcDateTime;
}

/** User mention in post model */
model PostMention {
  /** Unique mention identifier */
  id: string;

  /** Reference to post */
  postId: string;

  /** Reference to mentioned user */
  mentionedUserId: string;

  /** Character position in post content */
  position: int32;

  /** Length of mention in characters */
  length: int32;

  /** Mention creation timestamp */
  createdAt: utcDateTime;
}

/** Post like model */
model PostLike {
  /** Unique like identifier */
  id: string;

  /** Reference to post */
  postId: string;

  /** Reference to user who liked */
  userId: string;

  /** Like creation timestamp */
  createdAt: utcDateTime;
}

/** Post comment model */
model Comment {
  /** Unique comment identifier */
  id: string;

  /** Reference to post */
  postId: string;

  /** Reference to comment author */
  authorId: string;

  /** Reference to parent comment (for replies) */
  parentCommentId?: string;

  /** Comment content */
  content: string;

  /** Like count */
  likeCount: int32;

  /** Reply count */
  replyCount: int32;

  /** Whether comment is pinned by post author */
  isPinned: boolean;

  /** Whether comment is hidden */
  isHidden: boolean;

  /** Comment creation timestamp */
  createdAt: utcDateTime;

  /** Comment last updated timestamp */
  updatedAt: utcDateTime;
}

/** Comment like model */
model CommentLike {
  /** Unique like identifier */
  id: string;

  /** Reference to comment */
  commentId: string;

  /** Reference to user who liked */
  userId: string;

  /** Like creation timestamp */
  createdAt: utcDateTime;
}

/** Direct message conversation model */
model Conversation {
  /** Unique conversation identifier */
  id: string;

  /** Conversation title (for group chats) */
  title?: string;

  /** Whether conversation is a group chat */
  isGroup: boolean;

  /** Conversation creation timestamp */
  createdAt: utcDateTime;

  /** Last message timestamp */
  lastMessageAt?: utcDateTime;
}

/** Conversation participant model */
model ConversationParticipant {
  /** Unique participant identifier */
  id: string;

  /** Reference to conversation */
  conversationId: string;

  /** Reference to participant user */
  userId: string;

  /** Whether participant is admin (for group chats) */
  isAdmin: boolean;

  /** Whether participant has muted the conversation */
  isMuted: boolean;

  /** When participant joined conversation */
  joinedAt: utcDateTime;

  /** When participant last read messages */
  lastReadAt?: utcDateTime;
}

/** Direct message model */
model DirectMessage {
  /** Unique message identifier */
  id: string;

  /** Reference to conversation */
  conversationId: string;

  /** Reference to message sender */
  senderId: string;

  /** Message content */
  content?: string;

  /** Reference to media attachment */
  mediaId?: string;

  /** Reference to shared post */
  sharedPostId?: string;

  /** Whether message is deleted */
  isDeleted: boolean;

  /** Whether message is edited */
  isEdited: boolean;

  /** Message creation timestamp */
  createdAt: utcDateTime;

  /** Message last updated timestamp */
  updatedAt: utcDateTime;
}

/** Story model (24h expiring posts) */
model Story {
  /** Unique story identifier */
  id: string;

  /** Reference to story author */
  authorId: string;

  /** Story content */
  content?: string;

  /** Reference to media */
  mediaId?: string;

  /** Story background color (if no media) */
  backgroundColor?: string;

  /** View count */
  viewCount: int32;

  /** Story creation timestamp */
  createdAt: utcDateTime;

  /** Story expiry timestamp */
  expiresAt: utcDateTime;
}

/** Story view model */
model StoryView {
  /** Unique view identifier */
  id: string;

  /** Reference to story */
  storyId: string;

  /** Reference to viewer */
  viewerId: string;

  /** View timestamp */
  viewedAt: utcDateTime;
}

/** Story highlight collection model */
model StoryHighlight {
  /** Unique highlight identifier */
  id: string;

  /** Reference to user */
  userId: string;

  /** Highlight title */
  title: string;

  /** Highlight cover image URL */
  coverImageUrl?: string;

  /** Display order */
  sortOrder: int32;

  /** Highlight creation timestamp */
  createdAt: utcDateTime;

  /** Highlight last updated timestamp */
  updatedAt: utcDateTime;
}

/** Junction table for highlight-story relationship */
model HighlightStory {
  /** Unique identifier */
  id: string;

  /** Reference to highlight */
  highlightId: string;

  /** Reference to story */
  storyId: string;

  /** Display order in highlight */
  sortOrder: int32;

  /** When story was added to highlight */
  addedAt: utcDateTime;
}

/** Notification model */
model Notification {
  /** Unique notification identifier */
  id: string;

  /** Reference to recipient user */
  userId: string;

  /** Reference to user who triggered notification */
  triggeredById?: string;

  /** Notification type */
  type: NotificationType;

  /** Notification title */
  title: string;

  /** Notification message */
  message: string;

  /** Reference to related entity */
  entityType?: string;

  /** ID of related entity */
  entityId?: string;

  /** Whether notification has been read */
  isRead: boolean;

  /** Notification creation timestamp */
  createdAt: utcDateTime;

  /** When notification was read */
  readAt?: utcDateTime;
}

/** Content report model */
model Report {
  /** Unique report identifier */
  id: string;

  /** Reference to reporting user */
  reporterId: string;

  /** Reference to reported user */
  reportedUserId?: string;

  /** Reference to reported post */
  reportedPostId?: string;

  /** Reference to reported comment */
  reportedCommentId?: string;

  /** Report reason */
  reason: ReportReason;

  /** Additional details */
  details?: string;

  /** Report status */
  status: string;

  /** Reference to moderator who handled report */
  moderatorId?: string;

  /** Moderator notes */
  moderatorNotes?: string;

  /** Report creation timestamp */
  createdAt: utcDateTime;

  /** Report resolution timestamp */
  resolvedAt?: utcDateTime;
}

/** User block relationship model */
model Block {
  /** Unique block identifier */
  id: string;

  /** User who blocked */
  blockerId: string;

  /** User who was blocked */
  blockedId: string;

  /** Block creation timestamp */
  createdAt: utcDateTime;
}

/** Trending topic model */
model TrendingTopic {
  /** Unique trending topic identifier */
  id: string;

  /** Topic name */
  name: string;

  /** Topic category */
  category?: string;

  /** Number of posts/mentions */
  postCount: int32;

  /** Trend score */
  score: float64;

  /** Location where trending (if regional) */
  location?: string;

  /** Trend start timestamp */
  startedAt: utcDateTime;

  /** When trend data was last updated */
  updatedAt: utcDateTime;
}

/** User preference/settings model */
model UserSettings {
  /** Reference to user */
  userId: string;

  /** Privacy settings (JSON) */
  privacySettings?: string;

  /** Notification preferences (JSON) */
  notificationSettings?: string;

  /** Content preferences (JSON) */
  contentPreferences?: string;

  /** Theme preference */
  theme?: string;

  /** Language preference */
  language?: string;

  /** Whether to show activity status */
  showActivityStatus: boolean;

  /** Whether to allow message requests */
  allowMessageRequests: boolean;

  /** Settings last updated timestamp */
  updatedAt: utcDateTime;
}

/** Analytics model for tracking user engagement */
model Analytics {
  /** Unique analytics entry identifier */
  id: string;

  /** Reference to user (optional for anonymous events) */
  userId?: string;

  /** Event type */
  eventType: string;

  /** Reference to related entity */
  entityType?: string;

  /** ID of related entity */
  entityId?: string;

  /** Additional event data (JSON) */
  eventData?: string;

  /** Session ID */
  sessionId?: string;

  /** IP address */
  ipAddress?: string;

  /** User agent string */
  userAgent?: string;

  /** Event timestamp */
  createdAt: utcDateTime;
}
