# Assumptions

This document records the decisions and assumptions made during development where the assessment brief or the VoucherHub API documentation left room for interpretation.

---

## API & Backend

**1. Authentication uses a Bearer JWT.**
The login endpoint returns a JWT access token. All subsequent requests include `Authorization: Bearer <token>` via a Dio interceptor. No refresh-token flow was implemented; if the token expires the user is redirected to the login screen.

**2. Response envelope follows `{ success: bool, data: ..., message: string }`.**
The API client unwraps the `data` field automatically. If the response does not contain a `success` key it is treated as successful (to handle endpoints that return plain arrays or objects at the top level).

**3. The cart is server-side.**
There is no local cart state. Every add, update, and remove operation calls the API and the resulting `CartModel` from the server is used as the source of truth. This avoids sync issues if the same account is used on multiple devices.

**4. `POST /checkout/calculate-total` uses the current server-side cart.**
No cart items are sent in the request body; the backend calculates the total from the authenticated user's cart. The "Place Order" button is disabled until a successful calculate-total response is received.

**5. Payment is fully simulated.**
No payment gateway integration was implemented, consistent with the assessment note: *"Payment is simulated by the backend."*

**6. Product `code` field is used as the product identifier.**
The product list returns a `code` field which is used as both the display ID and the value sent when adding to cart (`productCode`). If the API uses a different field as the cart key this mapping would need updating.

**7. `GET /vouchers/{id}/operations` failures are non-fatal.**
On the voucher detail screen, operations are fetched in parallel with the voucher itself. If the operations call fails, an empty list is shown and the rest of the detail screen renders normally, rather than blocking the entire screen.

**7. `GET /orders` 
The order endpoint does not seem to exist at all as I was getting 404 response. Although i planned ahead and designed and implemented it.

---

## Data Model

**8. `termsAndConditions` may arrive as a `List<String>` or a plain `String`.**
Both shapes are handled in `ProductModel.fromJson` — lists are joined with newlines.

**9. `redemptionDetails` is a `List<String>`.**
Observed in the VoucherHub API docs; the list is joined with newlines and stored as `redemptionInstructions`.

**10. Voucher `status` and `redemptionUrl` key names may vary.**
`fromJson` tries multiple camelCase and snake_case variants for both fields to be resilient to API inconsistencies.

**11. `voucherCount` on an order may come as `voucher_count` or `vouchers_count`.**
Both key names are tried in `OrderModel.fromJson`.

---

## UX & Behaviour

**12. The bottom navigation bar persists across the main screens.**
A `StatefulShellRoute` (GoRouter) keeps each tab's navigation stack alive when switching tabs, so scroll position and loaded data are preserved.

**13. The cart badge shows the number of distinct line items, not total quantity.**
This is a common e-commerce pattern and avoids a large number cluttering the icon when quantities are high.

**14. The "Place Order" button is disabled until total is calculated.**
This prevents placing an order without confirming the price breakdown, which also serves as a user confirmation step.

**15. Voucher operations are loaded together with voucher detail in a single screen visit.**
`Future.wait` fetches both concurrently to minimise latency. If operations are unavailable the detail screen still renders fully.

**16. Product catalogue is cached locally after first load.**
On subsequent launches the cached data is shown immediately while a background refresh is not triggered automatically — the user can pull-to-refresh to fetch the latest data.

**17. Screen orientation is locked to portrait.**
`SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])` is set at startup. Gift card apps are primarily portrait-use; landscape layout was not designed.

---

## Security

**18. The JWT is stored in `flutter_secure_storage`.**
On iOS this uses the Keychain; on Android it uses `EncryptedSharedPreferences`. Plain `SharedPreferences` is only used for non-sensitive data (user display name, product cache, token expiry timestamp).

**19. Network logging is disabled in release builds.**
`PrettyDioLogger` is guarded by `kDebugMode` so tokens, voucher codes, and PINs are never logged outside of development.
