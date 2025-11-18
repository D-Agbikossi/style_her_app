# Admin Registration Guide

There are **three ways** to register an admin user for the StyleHer admin portal:

## Method 1: Using the Admin Setup Screen (Recommended)

1. **Run the admin app** - The app will automatically show the setup screen if no admin exists
2. **Fill in the form** with:
   - Full Name
   - Email Address
   - Password (minimum 6 characters)
   - Confirm Password
3. **Click "Create Admin Account"**
4. The system will:
   - Create a Firebase Auth user
   - Create a Firestore document in `users` collection with `role: 'admin'`
5. **You'll be redirected to login** - Use your credentials to sign in

## Method 2: Using Firebase Console (Manual)

### Step 1: Create User in Firebase Authentication
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `herstyleproject`
3. Navigate to **Authentication** → **Users**
4. Click **Add user**
5. Enter email and password
6. Click **Add user**

### Step 2: Add Admin Role in Firestore
1. In Firebase Console, go to **Firestore Database**
2. Navigate to `users` collection
3. Find the user document (use the UID from Authentication)
4. If document doesn't exist, create it with:
   ```json
   {
     "email": "admin@example.com",
     "displayName": "Admin User",
     "role": "admin",
     "createdAt": [timestamp],
     "updatedAt": [timestamp]
   }
   ```
5. If document exists, add/update the `role` field to `"admin"`

## Method 3: Using Code (Programmatic)

You can also use the `AdminSetupService` programmatically:

```dart
import 'package:admin/services/admin_setup_service.dart';

final adminSetup = AdminSetupService();

// Register new admin
await adminSetup.registerAdmin(
  email: 'admin@example.com',
  password: 'securepassword123',
  displayName: 'Admin User',
);

// Or promote existing user to admin
await adminSetup.promoteToAdmin('user-uid-here');
```

## Important Notes

- **Admin role is checked** in Firestore `users` collection with field `role: 'admin'`
- **Only users with admin role** can access the admin interface
- **The setup screen** is accessible at `/admin/setup` route
- **After creating first admin**, you can still access setup screen from login page

## Troubleshooting

### "Access denied. Admin privileges required."
- Make sure the user document in Firestore has `role: 'admin'`
- Check that you're using the correct user UID

### "User already exists"
- The email is already registered in Firebase Auth
- Use Method 2 to add the admin role to existing user
- Or use `promoteToAdmin()` method

### Can't access admin interface
- Verify the user is logged in
- Check Firestore `users/{uid}` document has `role: 'admin'`
- Try signing out and signing back in

