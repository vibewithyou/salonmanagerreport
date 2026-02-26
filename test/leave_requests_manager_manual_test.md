// Manual Test Guide for Leave Requests Manager Approval Workflow
// Date: 2026-02-26

1. Log in as salon_manager or salon_owner.
2. Navigate to Dashboard > Leave Requests Tab.
3. Verify pending leave requests are listed (with gold badge).
4. Tap a request, approve or reject, add optional comment.
5. Confirm snackbar appears and request disappears from pending list.
6. Log in as staff, create leave request, refresh status.
7. Confirm status updates (badge color changes) after manager action.
8. Test error/loading/empty states by removing requests or simulating network issues.
9. Run flutter analyze and verify no new errors.

Expected: All flows work, no mock lists, status updates instantly, badges/colors correct, error/loading/empty states handled.
