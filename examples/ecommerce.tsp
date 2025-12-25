/**
 * Ecommerce Application Example
 *
 * Demonstrates a comprehensive ecommerce platform schema using TypeSpec
 * converted to Drizzle ORM tables for PostgreSQL.
 */
import "@omnidotdev/typespec-drizzle";

using Drizzle;

namespace ECommerce;

enum CustomerStatus {
  Active: "active",
  Inactive: "inactive",
  Suspended: "suspended",
  Pending: "pending",
}

enum OrderStatus {
  Pending: "pending",
  Processing: "processing",
  Shipped: "shipped",
  Delivered: "delivered",
  Cancelled: "cancelled",
  Returned: "returned",
  Refunded: "refunded",
}

enum PaymentStatus {
  Pending: "pending",
  Completed: "completed",
  Failed: "failed",
  Refunded: "refunded",
  PartiallyRefunded: "partially_refunded",
}

enum ProductStatus {
  Active: "active",
  Inactive: "inactive",
  OutOfStock: "out_of_stock",
  Discontinued: "discontinued",
}

enum ShippingStatus {
  Pending: "pending",
  PickedUp: "picked_up",
  InTransit: "in_transit",
  OutForDelivery: "out_for_delivery",
  Delivered: "delivered",
  DeliveryFailed: "delivery_failed",
  Returned: "returned",
}

@table
model Customer {
  @id id: string;
  @unique email: string;
  passwordHash: string;
  firstName: string;
  lastName: string;
  phoneNumber?: string;
  dateOfBirth?: utcDateTime;
  status: CustomerStatus;
  emailVerified: boolean;
  subscribedToNewsletter: boolean;
  preferredLanguage?: string;
  preferredCurrency?: string;
  lastLoginAt?: utcDateTime;
  @defaultValue("now()") registeredAt: utcDateTime;
  @defaultValue("now()") updatedAt: utcDateTime;
}

@table
model Address {
  @id id: string;
  customerId: string;
  type: string;
  firstName: string;
  lastName: string;
  company?: string;
  streetAddress1: string;
  streetAddress2?: string;
  city: string;
  state: string;
  postalCode: string;
  countryCode: string;
  phoneNumber?: string;
  isDefault: boolean;
  @defaultValue("now()") createdAt: utcDateTime;
  @defaultValue("now()") updatedAt: utcDateTime;
}

@table
model Category {
  @id id: string;
  name: string;
  @unique slug: string;
  description?: string;
  imageUrl?: string;
  parentId?: string;
  sortOrder: int32;
  isActive: boolean;
  metaTitle?: string;
  metaDescription?: string;
  @defaultValue("now()") createdAt: utcDateTime;
  @defaultValue("now()") updatedAt: utcDateTime;
}

@table
model Product {
  @id id: string;
  name: string;
  @unique slug: string;
  description?: string;
  shortDescription?: string;
  @unique sku: string;
  barcode?: string;
  price: float64;
  cost?: float64;
  compareAtPrice?: float64;
  categoryId?: string;
  brand?: string;
  weight?: int32;
  length?: int32;
  width?: int32;
  height?: int32;
  status: ProductStatus;
  isFeatured: boolean;
  requiresShipping: boolean;
  isTaxable: boolean;
  tags?: string;
  metaTitle?: string;
  metaDescription?: string;
  @defaultValue("now()") createdAt: utcDateTime;
  @defaultValue("now()") updatedAt: utcDateTime;
}

@table
model ProductVariant {
  @id id: string;
  productId: string;
  title: string;
  @unique sku: string;
  barcode?: string;
  price?: float64;
  compareAtPrice?: float64;
  weight?: int32;
  inventoryQuantity: int32;
  trackInventory: boolean;
  inventoryAlert?: int32;
  allowBackorder: boolean;
  position: int32;
  @defaultValue("now()") createdAt: utcDateTime;
  @defaultValue("now()") updatedAt: utcDateTime;
}

@table
model ProductOption {
  @id id: string;
  productId: string;
  name: string;
  position: int32;
  @defaultValue("now()") createdAt: utcDateTime;
}

@table
model ProductOptionValue {
  @id id: string;
  optionId: string;
  variantId: string;
  value: string;
  @defaultValue("now()") createdAt: utcDateTime;
}

@table
model ProductImage {
  @id id: string;
  productId: string;
  variantId?: string;
  url: string;
  altText?: string;
  width?: int32;
  height?: int32;
  position: int32;
  @defaultValue("now()") createdAt: utcDateTime;
}

@table
model Cart {
  @id id: string;
  customerId?: string;
  sessionId?: string;
  @defaultValue("now()") createdAt: utcDateTime;
  @defaultValue("now()") updatedAt: utcDateTime;
}

@table
model CartItem {
  @id id: string;
  cartId: string;
  productId: string;
  variantId: string;
  quantity: int32;
  unitPrice: float64;
  @defaultValue("now()") createdAt: utcDateTime;
  @defaultValue("now()") updatedAt: utcDateTime;
}

@table
model Order {
  @id id: string;
  @unique orderNumber: string;
  customerId: string;
  status: OrderStatus;
  currency: string;
  subtotal: float64;
  taxAmount: float64;
  shippingCost: float64;
  discountAmount?: float64;
  totalAmount: float64;
  paymentStatus: PaymentStatus;
  billingAddress: string;
  shippingAddress: string;
  notes?: string;
  placedAt: utcDateTime;
  @defaultValue("now()") createdAt: utcDateTime;
  @defaultValue("now()") updatedAt: utcDateTime;
}

@table
model OrderItem {
  @id id: string;
  orderId: string;
  productId: string;
  variantId: string;
  productName: string;
  variantTitle?: string;
  sku: string;
  unitPrice: float64;
  quantity: int32;
  lineTotal: float64;
  @defaultValue("now()") createdAt: utcDateTime;
}

@table
model Payment {
  @id id: string;
  orderId: string;
  paymentMethod: string;
  gateway: string;
  gatewayTransactionId?: string;
  amount: float64;
  currency: string;
  status: PaymentStatus;
  gatewayResponse?: string;
  processedAt?: utcDateTime;
  @defaultValue("now()") createdAt: utcDateTime;
  @defaultValue("now()") updatedAt: utcDateTime;
}

@table
model Shipment {
  @id id: string;
  orderId: string;
  carrier?: string;
  trackingNumber?: string;
  trackingUrl?: string;
  service?: string;
  status: ShippingStatus;
  shippingAddress: string;
  weight?: int32;
  shippedAt?: utcDateTime;
  estimatedDeliveryAt?: utcDateTime;
  deliveredAt?: utcDateTime;
  @defaultValue("now()") createdAt: utcDateTime;
  @defaultValue("now()") updatedAt: utcDateTime;
}

@table
model Review {
  @id id: string;
  productId: string;
  customerId: string;
  title: string;
  content: string;
  rating: int32;
  isVerifiedPurchase: boolean;
  isApproved: boolean;
  helpfulVotes: int32;
  @defaultValue("now()") createdAt: utcDateTime;
  @defaultValue("now()") updatedAt: utcDateTime;
}

@table
model Wishlist {
  @id id: string;
  customerId: string;
  name: string;
  isPublic: boolean;
  @defaultValue("now()") createdAt: utcDateTime;
  @defaultValue("now()") updatedAt: utcDateTime;
}

@table
model WishlistItem {
  @id id: string;
  wishlistId: string;
  productId: string;
  variantId?: string;
  @defaultValue("now()") addedAt: utcDateTime;
}

@table
model Coupon {
  @id id: string;
  @unique code: string;
  description?: string;
  discountType: string;
  discountValue: float64;
  minimumAmount?: float64;
  maximumAmount?: float64;
  usageLimit?: int32;
  usageCount: int32;
  usageLimitPerCustomer?: int32;
  isActive: boolean;
  validFrom: utcDateTime;
  validUntil?: utcDateTime;
  @defaultValue("now()") createdAt: utcDateTime;
  @defaultValue("now()") updatedAt: utcDateTime;
}

@table
model InventoryTransaction {
  @id id: string;
  variantId: string;
  type: string;
  quantityChange: int32;
  quantityAfter: int32;
  orderItemId?: string;
  notes?: string;
  @defaultValue("now()") createdAt: utcDateTime;
}
