# Supabase Schema Analysis - SalonManager

**Generated:** February 13, 2026  
**Source:** `backup.sql` (Supabase Database Dump)  
**Purpose:** Complete inventory of tables, columns, and features for Flutter integration

---

## 1. Core Tables Summary

### 1.1 Authentication & Users
- **profiles** (user_id, role, display_name, etc.)
  - Extends Supabase auth with custom fields
  - Role field determines access level
  
### 1.2 Salon & Organization
- **salons** (id, name, address, city, coordinates, phone, etc.)
  - Main salon entity
  - Stores location data, contact info, working hours
  - Images and URLs for branding
  
- **employees** (id, salon_id, user_id, role, etc.)
  - Links users to salons as staff members
  - Tracks availability, services offered
  
- **employee_services** (employee_id, service_id)
  - Junction table: employees can offer multiple services
  
- **employee_invitations** (salon_id, email, role, status)
  - Invite new employees to join salon
  
- **employee_time_codes** (employee_id, code)
  - Check-in/check-out codes for time tracking

### 1.3 Customers & Appointments
- **customer_profiles** (salon_id, user_id, first_name, last_name, phone, email, etc.)
  - Guest and registered customer data
  - Stores preferences, allergies, customer_number
  - Note: Can exist without user_id (guest bookings)
  
- **appointments** (salon_id, customer_id, employee_id, service_id, guest_name/email/phone, etc.)
  - Bookings with full appointment details
  - Status: pending, confirmed, completed, cancelled
  - Supports both registered customers and guests
  - Images array for reference photos
  
### 1.4 Services & Pricing
- **services** (salon_id, name, description, duration, price, etc.)
  - Salon services (haircut, coloring, etc.)
  - Duration in minutes, price in currency
  
- **service_categories** (salon_id, name, description, order)
  - Organize services by category

### 1.5 Time & Scheduling
- **work_schedules** (salon_id, employee_id, day_of_week, start_time, end_time)
  - Employee working hours per day
  
- **leave_requests** (salon_id, employee_id, start_date, end_date, status, reason)
  - Employee time-off requests
  - Status: pending, approved, rejected
  
- **shift_swap_requests** (salon_id, initiator_id, requested_by_id, shift_date, status)
  - Employees can request shift swaps
  
- **time_entries** (salon_id, employee_id, entry_type, timestamp, duration_minutes)
  - Tracks when employees clock in/out
  - admin_confirmed flag for manager validation

### 1.6 Payments & Transactions
- **transactions** (salon_id, customer_profile_id, employee_id, amount, status, type)
  - Payment records for appointments/services
  - Types: appointment, service, product, charge
  - Status: pending, completed, failed
  
- **transaction_items** (transaction_id, service_id, description, price, quantity)
  - Line items in a transaction
  
- **invoices** (salon_id, transaction_id, customer_profile_id, invoice_number, total_amount, tax, discount)
  - Formal invoice records
  - Tracks tax and discount applied

### 1.7 Inventory
- **inventory** (salon_id, supplier_id, product_name, quantity, unit_price, reorder_level)
  - Stock management
  - Tracks low-stock threshold
  
- **inventory_transactions** (inventory_id, transaction_type, quantity, reason, user_id)
  - Log of inventory movements (in/out/adjustment)
  - Tracks who made changes and why
  
- **suppliers** (salon_id, name, contact_person, phone, email, address)
  - Vendor information for restocking

### 1.8 Gallery & Media
- **gallery_images** (salon_id, image_url, description, tags, created_by, etc.)
  - Portfolio photos of work
  - Can be tagged with services/styles
  
- **gallery_image_tags** (gallery_image_id, tag)
  - Tags for filtering images (e.g., "bob", "blonde", "long hair")
  
- **gallery_likes** (gallery_image_id, user_id)
  - Users can like portfolio images
  
- **gallery_saved** (gallery_image_id, user_id)
  - Users can save images for later reference
  
- **gallery_image_vectors** (gallery_image_id, embedding)
  - Similarity vectors for AI-powered search

### 1.9 Loyalty & Rewards
- **loyalty_accounts** (salon_id, customer_profile_id, points_balance, tier_level)
  - Customer loyalty points program
  - Tier levels for VIP benefits
  
- **loyalty_settings** (salon_id, points_per_currency, tier_thresholds, benefits)
  - Configure loyalty program behavior per salon
  
- **coupons** (salon_id, code, title, discount_type, discount_value, start_date, end_date)
  - Promotional codes/coupons
  - Types: percentage or fixed amount
  
- **coupon_redemptions** (coupon_id, customer_profile_id, salon_id, redeemed_at, transaction_id)
  - Track which customers used which coupons

### 1.10 Communication
- **conversations** (salon_id, type, appointment_id, title, last_message_at)
  - Chat threads (support, appointment-related, etc.)
  - Types: support, appointment_discussion, broadcast
  
- **conversation_participants** (conversation_id, user_id, role, is_active, last_read_message_id)
  - Users in a conversation (customer, stylist, admin)
  
- **messages** (conversation_id, sender_id, content, created_at, read_at)
  - Message content with timestamps
  - Tracks when user read the message

### 1.11 Media Assets
- **media_assets** (appointment_id, media_url, media_type, uploaded_by, created_at)
  - Unstructured media storage
  - Can be booking images, receipt photos, etc.

### 1.12 Settings & Audit
- **admin_dashboard_config** (salon_id, enabled_modules, settings_json)
  - Customize which modules show in admin dashboard
  
- **admin_module_activity_logs** (salon_id, action, changed_at, old_value, new_value)
  - Audit trail for admin actions
  
- **audit_logs** (user_id, action, entity_type, entity_id, metadata, ip_address)
  - General audit logging
  
- **extra_charge_reasons** (salon_id, reason, description)
  - Predefined reasons for surcharges on appointments
  
- **dashboard_activity_log** (salon_id, user_id, action, details)
  - Activity log for dashboard operations
  
- **dashboard_time_entries** (salon_id, employee_id, entry_type, timestamp)
  - Dashboard-specific time tracking

---

## 2. Key Features to Implement

### Feature: Authentication
**Tables:** profiles (from auth schema), user_roles  
**Models needed:**
- `UserProfile` (extends Supabase Auth)
- `UserRole` (maps roleKey: "customer", "stylist", "salon_owner", "admin")

**Riverpod Providers:**
- `authControllerProvider` (login/signup/logout state)
- `userProvider` (current user profile)
- `roleProvider` (current user role as string)

---

### Feature: Salon Search & Discovery
**Tables:** salons, employees, services, work_schedules  
**RPC Functions (from React):**
- `salons_within_radius(lat, lon, radius)` 
- `salons_within_radius_filtered(lat, lon, radius, filters)`
- `has_free_slot(salon_id, start, end)`

**Models needed:**
- `Salon` (name, address, coordinates, phone, rating)
- `SalonDetail` (+ hours, services, employees)

---

### Feature: Booking (Guest + Customer)
**Tables:** appointments, customer_profiles, services, gallery_images, media_assets  
**Flow:**
1. Select salon → services → stylist (optional)
2. Date/time selection (check availability via RPC)
3. Enter contact info (guest) or use profile
4. Upload reference images → Storage bucket `booking-images`
5. Accept terms
6. Create appointment record

**Models needed:**
- `Service` (id, name, duration, price)
- `Appointment` (with guest fields: guest_name, guest_email, guest_phone)
- `AppointmentImage` (from media_assets)

---

### Feature: Customer Dashboard
**Tables:** appointments, customer_profiles, gallery_images, gallery_likes, gallery_saved, conversations  
**Screens:**
- Upcoming appointments (query appointments by customer)
- Past appointments (completed/cancelled)
- Saved gallery images (gallery_saved)
- Favorites (gallery_likes)
- Messages (conversations + messages by participant)

---

### Feature: Employee Dashboard (Stylist)
**Tables:** appointments, time_entries, leave_requests, shift_swap_requests, employee_services, work_schedules  
**Screens:**
- My appointments (query by employee_id)
- Status updates (accept/decline/complete)
- Time tracking (checkin/out via time_entries)
- Leave requests (create/list leave_requests)
- Work schedule (display work_schedules)
- Shift swaps (manage shift_swap_requests)

---

### Feature: Admin Dashboard
**Tables:** All salary-related, appointment, inventory, loyalty, transaction, coupon  
**Tabs:**
1. **Appointments** - view/manage all salon appointments
2. **Employees** - manage staff, invitations, services, schedules
3. **Services** - CRUD services and categories
4. **Customers** - view customer profiles, notes, preferences
5. **Inventory** - stock levels, transactions, suppliers
6. **POS** - transactions, invoices, payments
7. **Gallery** - manage portfolio images, tags
8. **Loyalty** - loyalty accounts, coupons, redemptions
9. **Reports** - analytics (appointments/revenue/inventory)
10. **Settings** - salon info, dashboard modules, working hours

---

### Feature: Chat & Messaging
**Tables:** conversations, conversation_participants, messages  
**Models needed:**
- `Conversation` (id, type, appointment_id, title)
- `ConversationParticipant` (role: customer, stylist, admin)
- `Message` (sender_id, content, created_at, read_at)

**Real-time:** Subscribe to messages using Supabase Realtime

---

### Feature: Gallery & Portfolio
**Tables:** gallery_images, gallery_image_tags, gallery_likes, gallery_saved  
**Models needed:**
- `GalleryImage` (image_url, description, tags)
- `GalleryTag` (tag name)

---

### Feature: Inventory & POS
**Tables:** inventory, inventory_transactions, suppliers, transactions, transaction_items, invoices  
**Models needed:**
- `InventoryItem` (product_name, quantity, unit_price)
- `Transaction` (amount, status, type)
- `Invoice` (invoice_number, total_amount, tax)

---

### Feature: Loyalty & Coupons
**Tables:** loyalty_accounts, loyalty_settings, coupons, coupon_redemptions  
**Models needed:**
- `LoyaltyAccount` (points_balance, tier_level)
- `Coupon` (code, discount_type, discount_value)

---

## 3. Rollout Priority

**Phase 1 (MUST DO FIRST):**
1. Supabase init + config
2. Auth (login/signup/session)
3. User profile + role loading
4. Router guards & redirects

**Phase 2 (DATA FOUNDATION):**
1. Salon repository (search, location)
2. Service repository
3. Customer profile repository

**Phase 3 (PRIMARY FEATURE):**
1. Booking wizard (guest + customer)
2. Appointment repository

**Phase 4 (DASHBOARDS):**
1. Customer dashboard
2. Employee dashboard
3. Admin dashboard (core tabs)

**Phase 5 (ADVANCED):**
1. Chat & messaging
2. Gallery & likes
3. Inventory & POS
4. Loyalty & coupons
5. Reporting

---

## 4. Models to Create (Freezed + JsonSerializable)

Key models to start with:

```
lib/models/
  ├── auth/
  │   ├── user_profile.dart
  │   ├── user_role.dart
  ├── salon/
  │   ├── salon.dart
  │   ├── employee.dart
  │   ├── service.dart
  ├── appointment/
  │   ├── appointment.dart
  │   └── customer_profile.dart
  ├── time/
  │   ├── work_schedule.dart
  │   ├── time_entry.dart
  │   ├── leave_request.dart
  ├── transaction/
  │   ├── transaction.dart
  │   ├── invoice.dart
  ├── inventory/
  │   ├── inventory_item.dart
  │   └── inventory_transaction.dart
  ├── loyalty/
  │   ├── loyalty_account.dart
  │   └── coupon.dart
  ├── communication/
  │   ├── conversation.dart
  │   └── message.dart
  └── gallery/
      └── gallery_image.dart
```

---

## 5. Repositories to Create

```
lib/features/
  ├── auth/
  │   └── data/auth_repository.dart
  ├── salons/
  │   └── data/salon_repository.dart
  ├── services/
  │   └── data/service_repository.dart
  ├── bookings/
  │   └── data/booking_repository.dart
  ├── customers/
  │   └── data/customer_repository.dart
  ├── time_tracking/
  │   └── data/time_entry_repository.dart
  ├── inventory/
  │   └── data/inventory_repository.dart
  ├── transactions/
  │   └── data/transaction_repository.dart
  ├── loyalty/
  │   └── data/loyalty_repository.dart
  ├── messaging/
  │   └── data/messaging_repository.dart
  └── gallery/
      └── data/gallery_repository.dart
```

---

## 6. RPC Functions (from React App)

Functions to implement as Dart wrappers:

```dart
lib/core/supabase/supabase_rpc.dart

- salons_within_radius(lat, lon, radius) → List<Salon>
- salons_within_radius_filtered(lat, lon, radius, filters) → List<Salon>
- has_free_slot(salon_id, service_id, start, end) → bool
```

---

## 7. Storage Buckets

Used buckets:
- `booking-images` - appointment reference photos
- `salon-images` - salon portfolio/branding
- `gallery-images` - portfolio showcase
- (Others TBD based on implementation)

---

## Notes

- All timestamps in Supabase are UTC with timezone
- User roles are stored in `profiles.role` as strings
- Guest bookings use `guest_name`, `guest_email`, `guest_phone` on appointments table
- RLS policies must be checked when querying (some tables have row-level security)
- Many tables use UUIDs as primary keys
- Images stored as arrays of URLs in some tables, separate media_assets table for others
-Firebase/Cloud URLs for storage: `https://tshbudjnxgufagnvgqtl.supabase.co/storage/v1/object/public/...`

