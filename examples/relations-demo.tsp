/**
 * Relations Demo Example
 *
 * This example demonstrates Drizzle relations generation from TypeSpec models.
 * It showcases one-to-many, many-to-many, and self-referential relationships.
 *
 * To generate Drizzle schema with relations:
 * npx tsp compile main.tsp --emit @omnidotdev/typespec-drizzle
 */
namespace RelationsDemo;

/** User model - the main entity */
model User {
  /** Unique user identifier */
  id: string;

  /** User's username */
  username: string;

  /** User's email address */
  email: string;

  /** User creation timestamp */
  createdAt: utcDateTime;
}

/** Blog post model - one-to-many with User */
model Post {
  /** Unique post identifier */
  id: string;

  /** Post title */
  title: string;

  /** Post content */
  content: string;

  /** Reference to post author (one-to-many: User -> Posts) */
  authorId: string;

  /** Post creation timestamp */
  createdAt: utcDateTime;
}

/** Comment model - one-to-many with Post and self-referential */
model Comment {
  /** Unique comment identifier */
  id: string;

  /** Comment content */
  content: string;

  /** Reference to the post (one-to-many: Post -> Comments) */
  postId: string;

  /** Reference to comment author (one-to-many: User -> Comments) */
  authorId: string;

  /** Reference to parent comment for threading (self-referential) */
  parentId?: string;

  /** Comment creation timestamp */
  createdAt: utcDateTime;
}

/** Tag model for categorizing posts */
model Tag {
  /** Unique tag identifier */
  id: string;

  /** Tag name */
  name: string;

  /** Tag description */
  description?: string;
}

/** Junction table for many-to-many relationship between Posts and Tags */
model PostTag {
  /** Unique identifier */
  id: string;

  /** Reference to post (many-to-many: Posts <-> Tags) */
  postId: string;

  /** Reference to tag (many-to-many: Posts <-> Tags) */
  tagId: string;

  /** When tag was added to post */
  createdAt: utcDateTime;
}

/** Category model with hierarchical structure */
model Category {
  /** Unique category identifier */
  id: string;

  /** Category name */
  name: string;

  /** Category description */
  description?: string;

  /** Parent category for hierarchy (self-referential) */
  parentId?: string;

  /** Category creation timestamp */
  createdAt: utcDateTime;
}

/** Post-Category relationship (one-to-many: Category -> Posts) */
model PostCategory {
  /** Unique identifier */
  id: string;

  /** Reference to post */
  postId: string;

  /** Reference to category */
  categoryId: string;

  /** When post was categorized */
  createdAt: utcDateTime;
}

/** Like model - multiple one-to-many relationships */
model Like {
  /** Unique like identifier */
  id: string;

  /** Reference to user who liked */
  userId: string;

  /** Reference to liked post */
  postId: string;

  /** When like was created */
  createdAt: utcDateTime;
}

/** User profile model - one-to-one relationship */
model UserProfile {
  /** Unique profile identifier */
  id: string;

  /** Reference to user (one-to-one: User -> UserProfile) */
  userId: string;

  /** User's bio */
  bio?: string;

  /** Profile picture URL */
  avatarUrl?: string;

  /** User's website */
  website?: string;

  /** Profile last updated */
  updatedAt: utcDateTime;
}
