/**
 * Ecommerce Application Example
 *
 * This example demonstrates a comprehensive ecommerce platform schema using TypeSpec
 * that will be converted to Drizzle ORM tables for PostgreSQL.
 *
 * Features demonstrated:
 * - Customer management with authentication
 * - Product catalog with categories and variants
 * - Shopping cart and order processing
 * - Inventory management
 * - Payment processing
 * - Shipping and fulfillment
 * - Reviews and ratings
 *
 * To generate Drizzle schema:
 * npx tsp compile main.tsp --emit @omnidotdev/typespec-drizzle
 */
namespace ECommerce;

/** Customer account status enumeration */
enum CustomerStatus {
  /** Active customer account */
  Active: "active",

  /** Inactive customer account */
  Inactive: "inactive",

  /** Suspended customer account */
  Suspended: "suspended",

  /** Account pending verification */
  Pending: "pending",
}

/** Order status enumeration */
enum OrderStatus {
  /** Order has been placed but not yet processed */
  Pending: "pending",

  /** Order is being processed */
  Processing: "processing",

  /** Order has been shipped */
  Shipped: "shipped",

  /** Order has been delivered */
  Delivered: "delivered",

  /** Order has been cancelled */
  Cancelled: "cancelled",

  /** Order has been returned */
  Returned: "returned",

  /** Order has been refunded */
  Refunded: "refunded",
}

/** Payment status enumeration */
enum PaymentStatus {
  /** Payment is pending */
  Pending: "pending",

  /** Payment has been completed */
  Completed: "completed",

  /** Payment has failed */
  Failed: "failed",

  /** Payment has been refunded */
  Refunded: "refunded",

  /** Payment has been partially refunded */
  PartiallyRefunded: "partially_refunded",
}

/** Product status enumeration */
enum ProductStatus {
  /** Product is active and available */
  Active: "active",

  /** Product is inactive/disabled */
  Inactive: "inactive",

  /** Product is out of stock */
  OutOfStock: "out_of_stock",

  /** Product is discontinued */
  Discontinued: "discontinued",
}

/** Shipping status enumeration */
enum ShippingStatus {
  /** Shipment is pending */
  Pending: "pending",

  /** Shipment has been picked up */
  PickedUp: "picked_up",

  /** Shipment is in transit */
  InTransit: "in_transit",

  /** Shipment is out for delivery */
  OutForDelivery: "out_for_delivery",

  /** Shipment has been delivered */
  Delivered: "delivered",

  /** Shipment delivery failed */
  DeliveryFailed: "delivery_failed",

  /** Shipment has been returned */
  Returned: "returned",
}

/** Customer model with profile and authentication */
model Customer {
  /** Unique customer identifier */
  id: string;

  /** Customer email address (unique) */
  email: string;

  /** Hashed password for authentication */
  passwordHash: string;

  /** Customer's first name */
  firstName: string;

  /** Customer's last name */
  lastName: string;

  /** Customer's phone number */
  phoneNumber?: string;

  /** Customer's date of birth */
  dateOfBirth?: utcDateTime;

  /** Customer account status */
  status: CustomerStatus;

  /** Email verification status */
  emailVerified: boolean;

  /** Newsletter subscription status */
  subscribedToNewsletter: boolean;

  /** Customer's preferred language */
  preferredLanguage?: string;

  /** Customer's preferred currency */
  preferredCurrency?: string;

  /** Customer last login timestamp */
  lastLoginAt?: utcDateTime;

  /** Customer registration timestamp */
  registeredAt: utcDateTime;

  /** Customer profile last updated timestamp */
  updatedAt: utcDateTime;
}

/** Customer address model */
model Address {
  /** Unique address identifier */
  id: string;

  /** Reference to customer */
  customerId: string;

  /** Address type (billing, shipping, etc.) */
  type: string;

  /** First name for this address */
  firstName: string;

  /** Last name for this address */
  lastName: string;

  /** Company name (optional) */
  company?: string;

  /** Street address line 1 */
  streetAddress1: string;

  /** Street address line 2 (optional) */
  streetAddress2?: string;

  /** City */
  city: string;

  /** State/Province */
  state: string;

  /** Postal/ZIP code */
  postalCode: string;

  /** Country code (ISO 3166-1 alpha-2) */
  countryCode: string;

  /** Phone number for this address */
  phoneNumber?: string;

  /** Whether this is the default address */
  isDefault: boolean;

  /** Address creation timestamp */
  createdAt: utcDateTime;

  /** Address last updated timestamp */
  updatedAt: utcDateTime;
}

/** Product category model */
model Category {
  /** Unique category identifier */
  id: string;

  /** Category name */
  name: string;

  /** URL-friendly category slug */
  slug: string;

  /** Category description */
  description?: string;

  /** Category image URL */
  imageUrl?: string;

  /** Parent category for hierarchical structure */
  parentId?: string;

  /** Display order for sorting */
  sortOrder: int32;

  /** Whether category is active */
  isActive: boolean;

  /** SEO meta title */
  metaTitle?: string;

  /** SEO meta description */
  metaDescription?: string;

  /** Category creation timestamp */
  createdAt: utcDateTime;

  /** Category last updated timestamp */
  updatedAt: utcDateTime;
}

/** Product model */
model Product {
  /** Unique product identifier */
  id: string;

  /** Product name */
  name: string;

  /** URL-friendly product slug */
  slug: string;

  /** Product description */
  description?: string;

  /** Short product description */
  shortDescription?: string;

  /** Product SKU (Stock Keeping Unit) */
  sku: string;

  /** Product barcode/UPC */
  barcode?: string;

  /** Product price */
  price: float64;

  /** Product cost (for profit calculation) */
  cost?: float64;

  /** Compare at price (original/MSRP) */
  compareAtPrice?: float64;

  /** Reference to product category */
  categoryId?: string;

  /** Product brand */
  brand?: string;

  /** Product weight in grams */
  weight?: int32;

  /** Product dimensions - length in mm */
  length?: int32;

  /** Product dimensions - width in mm */
  width?: int32;

  /** Product dimensions - height in mm */
  height?: int32;

  /** Product status */
  status: ProductStatus;

  /** Whether product is featured */
  isFeatured: boolean;

  /** Whether product requires shipping */
  requiresShipping: boolean;

  /** Whether product is taxable */
  isTaxable: boolean;

  /** Product tags (JSON array) */
  tags?: string;

  /** SEO meta title */
  metaTitle?: string;

  /** SEO meta description */
  metaDescription?: string;

  /** Product creation timestamp */
  createdAt: utcDateTime;

  /** Product last updated timestamp */
  updatedAt: utcDateTime;
}

/** Product variant model for size, color, etc. */
model ProductVariant {
  /** Unique variant identifier */
  id: string;

  /** Reference to parent product */
  productId: string;

  /** Variant title (e.g., "Red / Large") */
  title: string;

  /** Variant SKU */
  sku: string;

  /** Variant barcode */
  barcode?: string;

  /** Variant price (overrides product price if set) */
  price?: float64;

  /** Variant compare at price */
  compareAtPrice?: float64;

  /** Variant weight */
  weight?: int32;

  /** Current inventory quantity */
  inventoryQuantity: int32;

  /** Whether inventory is tracked */
  trackInventory: boolean;

  /** Minimum inventory level for alerts */
  inventoryAlert?: int32;

  /** Whether variant allows backorders when out of stock */
  allowBackorder: boolean;

  /** Variant position for sorting */
  position: int32;

  /** Variant creation timestamp */
  createdAt: utcDateTime;

  /** Variant last updated timestamp */
  updatedAt: utcDateTime;
}

/** Product option (like Color, Size) */
model ProductOption {
  /** Unique option identifier */
  id: string;

  /** Reference to product */
  productId: string;

  /** Option name (e.g., "Color", "Size") */
  name: string;

  /** Display position */
  position: int32;

  /** Option creation timestamp */
  createdAt: utcDateTime;
}

/** Product option value (like "Red", "Large") */
model ProductOptionValue {
  /** Unique option value identifier */
  id: string;

  /** Reference to product option */
  optionId: string;

  /** Reference to product variant */
  variantId: string;

  /** Option value (e.g., "Red", "Large") */
  value: string;

  /** Option value creation timestamp */
  createdAt: utcDateTime;
}

/** Product image model */
model ProductImage {
  /** Unique image identifier */
  id: string;

  /** Reference to product */
  productId: string;

  /** Reference to product variant (optional) */
  variantId?: string;

  /** Image URL */
  url: string;

  /** Image alt text for accessibility */
  altText?: string;

  /** Image width in pixels */
  width?: int32;

  /** Image height in pixels */
  height?: int32;

  /** Display position */
  position: int32;

  /** Image creation timestamp */
  createdAt: utcDateTime;
}

/** Shopping cart model */
model Cart {
  /** Unique cart identifier */
  id: string;

  /** Reference to customer (null for guest carts) */
  customerId?: string;

  /** Session ID for guest carts */
  sessionId?: string;

  /** Cart creation timestamp */
  createdAt: utcDateTime;

  /** Cart last updated timestamp */
  updatedAt: utcDateTime;
}

/** Shopping cart item model */
model CartItem {
  /** Unique cart item identifier */
  id: string;

  /** Reference to cart */
  cartId: string;

  /** Reference to product */
  productId: string;

  /** Reference to product variant */
  variantId: string;

  /** Item quantity */
  quantity: int32;

  /** Unit price at time of adding to cart */
  unitPrice: float64;

  /** Cart item creation timestamp */
  createdAt: utcDateTime;

  /** Cart item last updated timestamp */
  updatedAt: utcDateTime;
}

/** Order model */
model Order {
  /** Unique order identifier */
  id: string;

  /** Human-readable order number */
  orderNumber: string;

  /** Reference to customer */
  customerId: string;

  /** Order status */
  status: OrderStatus;

  /** Order currency code */
  currency: string;

  /** Order subtotal (before tax and shipping) */
  subtotal: float64;

  /** Tax amount */
  taxAmount: float64;

  /** Shipping cost */
  shippingCost: float64;

  /** Discount amount */
  discountAmount?: float64;

  /** Order total amount */
  totalAmount: float64;

  /** Payment status */
  paymentStatus: PaymentStatus;

  /** Billing address (JSON) */
  billingAddress: string;

  /** Shipping address (JSON) */
  shippingAddress: string;

  /** Customer notes/instructions */
  notes?: string;

  /** Order placed timestamp */
  placedAt: utcDateTime;

  /** Order creation timestamp */
  createdAt: utcDateTime;

  /** Order last updated timestamp */
  updatedAt: utcDateTime;
}

/** Order line item model */
model OrderItem {
  /** Unique order item identifier */
  id: string;

  /** Reference to order */
  orderId: string;

  /** Reference to product */
  productId: string;

  /** Reference to product variant */
  variantId: string;

  /** Product name at time of order */
  productName: string;

  /** Variant title at time of order */
  variantTitle?: string;

  /** Product SKU at time of order */
  sku: string;

  /** Unit price at time of order */
  unitPrice: float64;

  /** Item quantity */
  quantity: int32;

  /** Line total (unitPrice * quantity) */
  lineTotal: float64;

  /** Order item creation timestamp */
  createdAt: utcDateTime;
}

/** Payment model */
model Payment {
  /** Unique payment identifier */
  id: string;

  /** Reference to order */
  orderId: string;

  /** Payment method (card, paypal, etc.) */
  paymentMethod: string;

  /** Payment gateway (stripe, paypal, etc.) */
  gateway: string;

  /** Gateway transaction ID */
  gatewayTransactionId?: string;

  /** Payment amount */
  amount: float64;

  /** Payment currency */
  currency: string;

  /** Payment status */
  status: PaymentStatus;

  /** Gateway response data (JSON) */
  gatewayResponse?: string;

  /** Payment processed timestamp */
  processedAt?: utcDateTime;

  /** Payment creation timestamp */
  createdAt: utcDateTime;

  /** Payment last updated timestamp */
  updatedAt: utcDateTime;
}

/** Shipment model */
model Shipment {
  /** Unique shipment identifier */
  id: string;

  /** Reference to order */
  orderId: string;

  /** Shipping carrier (UPS, FedEx, etc.) */
  carrier?: string;

  /** Tracking number */
  trackingNumber?: string;

  /** Tracking URL */
  trackingUrl?: string;

  /** Shipping service (ground, overnight, etc.) */
  service?: string;

  /** Shipping status */
  status: ShippingStatus;

  /** Shipping address (JSON) */
  shippingAddress: string;

  /** Shipment weight in grams */
  weight?: int32;

  /** Shipment shipped timestamp */
  shippedAt?: utcDateTime;

  /** Estimated delivery date */
  estimatedDeliveryAt?: utcDateTime;

  /** Actual delivery timestamp */
  deliveredAt?: utcDateTime;

  /** Shipment creation timestamp */
  createdAt: utcDateTime;

  /** Shipment last updated timestamp */
  updatedAt: utcDateTime;
}

/** Product review model */
model Review {
  /** Unique review identifier */
  id: string;

  /** Reference to product */
  productId: string;

  /** Reference to customer */
  customerId: string;

  /** Review title */
  title: string;

  /** Review content */
  content: string;

  /** Review rating (1-5 stars) */
  rating: int32;

  /** Whether review is verified purchase */
  isVerifiedPurchase: boolean;

  /** Whether review is approved */
  isApproved: boolean;

  /** Number of helpful votes */
  helpfulVotes: int32;

  /** Review creation timestamp */
  createdAt: utcDateTime;

  /** Review last updated timestamp */
  updatedAt: utcDateTime;
}

/** Wishlist model */
model Wishlist {
  /** Unique wishlist identifier */
  id: string;

  /** Reference to customer */
  customerId: string;

  /** Wishlist name */
  name: string;

  /** Whether wishlist is public */
  isPublic: boolean;

  /** Wishlist creation timestamp */
  createdAt: utcDateTime;

  /** Wishlist last updated timestamp */
  updatedAt: utcDateTime;
}

/** Wishlist item model */
model WishlistItem {
  /** Unique wishlist item identifier */
  id: string;

  /** Reference to wishlist */
  wishlistId: string;

  /** Reference to product */
  productId: string;

  /** Reference to product variant */
  variantId?: string;

  /** Item added to wishlist timestamp */
  addedAt: utcDateTime;
}

/** Coupon/discount code model */
model Coupon {
  /** Unique coupon identifier */
  id: string;

  /** Coupon code */
  code: string;

  /** Coupon description */
  description?: string;

  /** Discount type (percentage, fixed_amount) */
  discountType: string;

  /** Discount value */
  discountValue: float64;

  /** Minimum order amount for coupon to apply */
  minimumAmount?: float64;

  /** Maximum discount amount (for percentage coupons) */
  maximumAmount?: float64;

  /** Maximum number of uses */
  usageLimit?: int32;

  /** Current number of uses */
  usageCount: int32;

  /** Maximum uses per customer */
  usageLimitPerCustomer?: int32;

  /** Whether coupon is active */
  isActive: boolean;

  /** Coupon valid from timestamp */
  validFrom: utcDateTime;

  /** Coupon valid until timestamp */
  validUntil?: utcDateTime;

  /** Coupon creation timestamp */
  createdAt: utcDateTime;

  /** Coupon last updated timestamp */
  updatedAt: utcDateTime;
}

/** Inventory transaction model for tracking stock changes */
model InventoryTransaction {
  /** Unique transaction identifier */
  id: string;

  /** Reference to product variant */
  variantId: string;

  /** Transaction type (sale, restock, adjustment, etc.) */
  type: string;

  /** Quantity change (positive for additions, negative for subtractions) */
  quantityChange: int32;

  /** Quantity after transaction */
  quantityAfter: int32;

  /** Reference to order item (if applicable) */
  orderItemId?: string;

  /** Transaction notes */
  notes?: string;

  /** Transaction timestamp */
  createdAt: utcDateTime;
}
