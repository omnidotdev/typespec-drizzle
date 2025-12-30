/**
 * Ecommerce Application Example
 *
 * Demonstrates a comprehensive ecommerce platform schema using TypeSpec
 * converted to Drizzle ORM tables for PostgreSQL.
 */
import "@omnidotdev/typespec-drizzle";

using Drizzle;

namespace Ecommerce;

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
  @id @uuid id: string = Defaults.uuidv4;
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
  registeredAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model Address {
  @id @uuid id: string = Defaults.uuidv4;
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
  createdAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model Category {
  @id @uuid id: string = Defaults.uuidv4;
  name: string;
  @unique slug: string;
  description?: string;
  imageUrl?: string;
  parentId?: string;
  sortOrder: int32;
  isActive: boolean;
  metaTitle?: string;
  metaDescription?: string;
  createdAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model Product {
  @id @uuid id: string = Defaults.uuidv4;
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
  createdAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model ProductVariant {
  @id @uuid id: string = Defaults.uuidv4;
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
  createdAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model ProductOption {
  @id @uuid id: string = Defaults.uuidv4;
  productId: string;
  name: string;
  position: int32;
  createdAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model ProductOptionValue {
  @id @uuid id: string = Defaults.uuidv4;
  optionId: string;
  variantId: string;
  value: string;
  createdAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model ProductImage {
  @id @uuid id: string = Defaults.uuidv4;
  productId: string;
  variantId?: string;
  url: string;
  altText?: string;
  width?: int32;
  height?: int32;
  position: int32;
  createdAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model Cart {
  @id @uuid id: string = Defaults.uuidv4;
  customerId?: string;
  sessionId?: string;
  createdAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model CartItem {
  @id @uuid id: string = Defaults.uuidv4;
  cartId: string;
  productId: string;
  variantId: string;
  quantity: int32;
  unitPrice: float64;
  createdAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model Order {
  @id @uuid id: string = Defaults.uuidv4;
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
  createdAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model OrderItem {
  @id @uuid id: string = Defaults.uuidv4;
  orderId: string;
  productId: string;
  variantId: string;
  productName: string;
  variantTitle?: string;
  sku: string;
  unitPrice: float64;
  quantity: int32;
  lineTotal: float64;
  createdAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model Payment {
  @id @uuid id: string = Defaults.uuidv4;
  orderId: string;
  paymentMethod: string;
  gateway: string;
  gatewayTransactionId?: string;
  amount: float64;
  currency: string;
  status: PaymentStatus;
  gatewayResponse?: string;
  processedAt?: utcDateTime;
  createdAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model Shipment {
  @id @uuid id: string = Defaults.uuidv4;
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
  createdAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model Review {
  @id @uuid id: string = Defaults.uuidv4;
  productId: string;
  customerId: string;
  title: string;
  content: string;
  rating: int32;
  isVerifiedPurchase: boolean;
  isApproved: boolean;
  helpfulVotes: int32;
  createdAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model Wishlist {
  @id @uuid id: string = Defaults.uuidv4;
  customerId: string;
  name: string;
  isPublic: boolean;
  createdAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model WishlistItem {
  @id @uuid id: string = Defaults.uuidv4;
  wishlistId: string;
  productId: string;
  variantId?: string;
  addedAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model Coupon {
  @id @uuid id: string = Defaults.uuidv4;
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
  createdAt: utcDateTime = Defaults.currentTimestamp;
  updatedAt: utcDateTime = Defaults.currentTimestamp;
}

@table
model InventoryTransaction {
  @id @uuid id: string = Defaults.uuidv4;
  variantId: string;
  type: string;
  quantityChange: int32;
  quantityAfter: int32;
  orderItemId?: string;
  notes?: string;
  createdAt: utcDateTime = Defaults.currentTimestamp;
}
