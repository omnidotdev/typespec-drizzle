// Basic models fixture - Simple table structures
namespace BasicModels;

/** A basic user model with common fields */
model User {
  /** Unique identifier for the user */
  id: string;

  /** User's email address */
  email: string;

  /** User's display name */
  name: string;

  /** When the user was created */
  createdAt: utcDateTime;

  /** When the user was last updated */
  updatedAt?: utcDateTime;
}

/** A simple blog post model */
model Post {
  /** Unique identifier for the post */
  id: string;

  /** Post title */
  title: string;

  /** Post content */
  content: string;

  /** Reference to the author */
  authorId: string;

  /** When the post was created */
  createdAt: utcDateTime;

  /** When the post was published (optional) */
  publishedAt?: utcDateTime;
}

/** A category model for organizing posts */
model Category {
  /** Unique identifier for the category */
  id: string;

  /** Category name */
  name: string;

  /** Category description */
  description?: string;
}
