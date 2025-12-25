// Advanced features fixture - Testing advanced Drizzle features like constraints, indexes, and special field types
namespace AdvancedFeatures;

/** User model with various constraints and indexes */
model User {
  /** Primary key with UUID type */
  id: string;

  /** Unique email field */
  email: string;

  /** Username with unique constraint */
  username: string;

  /** Password hash (should not be nullable) */
  passwordHash: string;

  /** First name */
  firstName: string;

  /** Last name */
  lastName: string;

  /** Phone number (unique, optional) */
  phoneNumber?: string;

  /** Date of birth */
  dateOfBirth?: utcDateTime;

  /** Account verification status */
  isEmailVerified: boolean;

  /** Account active status */
  isActive: boolean;

  /** Failed login attempts counter */
  failedLoginAttempts: int32;

  /** Last login timestamp */
  lastLoginAt?: utcDateTime;

  /** Account created timestamp */
  createdAt: utcDateTime;

  /** Account updated timestamp */
  updatedAt: utcDateTime;

  /** Soft delete timestamp */
  deletedAt?: utcDateTime;
}

/** Product model with decimal pricing and inventory */
model Product {
  /** Product ID */
  id: string;

  /** Product SKU (unique identifier) */
  sku: string;

  /** Product name */
  name: string;

  /** Product description */
  description?: string;

  /** Product price with decimal precision */
  price: float64;

  /** Cost price */
  costPrice?: float64;

  /** Product weight in grams */
  weight?: int32;

  /** Inventory count */
  stockQuantity: int32;

  /** Minimum stock level for alerts */
  minStockLevel?: int32;

  /** Product category ID */
  categoryId: string;

  /** Vendor/supplier ID */
  vendorId?: string;

  /** Product barcode */
  barcode?: string;

  /** Product is active/published */
  isActive: boolean;

  /** Featured product flag */
  isFeatured: boolean;

  /** Product created timestamp */
  createdAt: utcDateTime;

  /** Product updated timestamp */
  updatedAt: utcDateTime;
}

/** Order model with complex relationships */
model Order {
  /** Order ID */
  id: string;

  /** Order number (human-readable, unique) */
  orderNumber: string;

  /** Customer user ID */
  customerId: string;

  /** Order status */
  status: string;

  /** Subtotal amount */
  subtotal: float64;

  /** Tax amount */
  taxAmount: float64;

  /** Shipping cost */
  shippingCost: float64;

  /** Discount amount */
  discountAmount?: float64;

  /** Total amount */
  totalAmount: float64;

  /** Payment method */
  paymentMethod: string;

  /** Payment status */
  paymentStatus: string;

  /** Shipping address (JSON) */
  shippingAddress: string;

  /** Billing address (JSON) */
  billingAddress: string;

  /** Order notes */
  notes?: string;

  /** Tracking number */
  trackingNumber?: string;

  /** Order placed timestamp */
  placedAt: utcDateTime;

  /** Order shipped timestamp */
  shippedAt?: utcDateTime;

  /** Order delivered timestamp */
  deliveredAt?: utcDateTime;

  /** Order cancelled timestamp */
  cancelledAt?: utcDateTime;

  /** Order created timestamp */
  createdAt: utcDateTime;

  /** Order updated timestamp */
  updatedAt: utcDateTime;
}

/** Order item model with quantity and pricing */
model OrderItem {
  /** Order item ID */
  id: string;

  /** Reference to order */
  orderId: string;

  /** Reference to product */
  productId: string;

  /** Product name at time of order (for historical accuracy) */
  productName: string;

  /** Product SKU at time of order */
  productSku: string;

  /** Unit price at time of order */
  unitPrice: float64;

  /** Quantity ordered */
  quantity: int32;

  /** Line total (unitPrice * quantity) */
  lineTotal: float64;

  /** Item created timestamp */
  createdAt: utcDateTime;
}

/** Blog post model with full-text search capabilities */
model BlogPost {
  /** Post ID */
  id: string;

  /** Post title */
  title: string;

  /** URL slug (unique) */
  slug: string;

  /** Post excerpt/summary */
  excerpt?: string;

  /** Post content (markdown/html) */
  content: string;

  /** Author user ID */
  authorId: string;

  /** Category ID */
  categoryId?: string;

  /** Featured image URL */
  featuredImage?: string;

  /** SEO meta title */
  metaTitle?: string;

  /** SEO meta description */
  metaDescription?: string;

  /** Post tags (JSON array) */
  tags?: string;

  /** View count */
  viewCount: int32;

  /** Like count */
  likeCount: int32;

  /** Comment count */
  commentCount: int32;

  /** Post status */
  status: string;

  /** Post visibility */
  visibility: string;

  /** Is post featured */
  isFeatured: boolean;

  /** Allow comments */
  allowComments: boolean;

  /** Post published timestamp */
  publishedAt?: utcDateTime;

  /** Post created timestamp */
  createdAt: utcDateTime;

  /** Post updated timestamp */
  updatedAt: utcDateTime;
}

/** Analytics event model for tracking */
model AnalyticsEvent {
  /** Event ID */
  id: string;

  /** Session ID */
  sessionId: string;

  /** User ID (optional for anonymous users) */
  userId?: string;

  /** Event name/type */
  eventName: string;

  /** Event properties (JSON) */
  properties?: string;

  /** Page/screen where event occurred */
  page?: string;

  /** Referrer URL */
  referrer?: string;

  /** User agent string */
  userAgent?: string;

  /** IP address */
  ipAddress?: string;

  /** Country code */
  countryCode?: string;

  /** City name */
  city?: string;

  /** Device type */
  deviceType?: string;

  /** Operating system */
  operatingSystem?: string;

  /** Browser name */
  browser?: string;

  /** Event timestamp */
  timestamp: utcDateTime;

  /** Event created timestamp */
  createdAt: utcDateTime;
}

/** File storage model with metadata */
model FileStorage {
  /** File ID */
  id: string;

  /** Original filename */
  originalName: string;

  /** Stored filename (UUID-based) */
  storedName: string;

  /** File path in storage */
  filePath: string;

  /** MIME type */
  mimeType: string;

  /** File size in bytes */
  fileSize: int32;

  /** File hash (for deduplication) */
  fileHash: string;

  /** Storage bucket/container */
  bucket?: string;

  /** CDN URL */
  cdnUrl?: string;

  /** File is public/private */
  isPublic: boolean;

  /** Uploader user ID */
  uploadedById: string;

  /** File metadata (JSON) */
  metadata?: string;

  /** Image width (for images) */
  width?: int32;

  /** Image height (for images) */
  height?: int32;

  /** File uploaded timestamp */
  uploadedAt: utcDateTime;

  /** Last accessed timestamp */
  lastAccessedAt?: utcDateTime;

  /** File expires at timestamp */
  expiresAt?: utcDateTime;
}

/** Configuration model with key-value pairs */
model Configuration {
  /** Config ID */
  id: string;

  /** Configuration key (unique) */
  key: string;

  /** Configuration value */
  value: string;

  /** Value data type hint */
  valueType: string;

  /** Configuration description */
  description?: string;

  /** Is configuration public */
  isPublic: boolean;

  /** Is configuration encrypted */
  isEncrypted: boolean;

  /** Configuration group/namespace */
  group?: string;

  /** Configuration created timestamp */
  createdAt: utcDateTime;

  /** Configuration updated timestamp */
  updatedAt: utcDateTime;
}

/** Rate limiting model for API usage */
model RateLimit {
  /** Rate limit ID */
  id: string;

  /** Identifier (user ID, IP, API key) */
  identifier: string;

  /** Rate limit type */
  limitType: string;

  /** Current request count */
  requestCount: int32;

  /** Rate limit window start */
  windowStart: utcDateTime;

  /** Rate limit window duration in seconds */
  windowDuration: int32;

  /** Maximum requests allowed */
  maxRequests: int32;

  /** Last request timestamp */
  lastRequestAt: utcDateTime;

  /** Rate limit created timestamp */
  createdAt: utcDateTime;

  /** Rate limit updated timestamp */
  updatedAt: utcDateTime;
}
