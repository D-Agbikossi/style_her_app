# Firebase Security Rules Documentation

## Overview

This document explains the Firebase Security Rules implemented for the StyleHer application. These rules protect user data, ensure proper access control, and prevent unauthorized operations.

## Security Rules File Location

The security rules are defined in `firestore.rules` at the project root. To deploy these rules to Firebase, use:

```bash
firebase deploy --only firestore:rules
```

## Rule Structure

### Helper Functions

The rules use several helper functions to simplify access control:

1. **`isAuthenticated()`** - Checks if a user is logged in
2. **`isOwner(userId)`** - Checks if the current user owns the resource
3. **`getUserRole()`** - Retrieves the user's role from Firestore
4. **`isAdmin()`** - Checks if user has admin role
5. **`isMentor()`** - Checks if user has mentor role
6. **`isLearner()`** - Checks if user has learner role
7. **`isUserActive(userId)`** - Checks if user account is active

## Collection-Specific Rules

### 1. Users Collection (`/users/{userId}`)

**Purpose**: Stores user profile information

**Access Rules**:
- **Read**: Users can read their own profile; Admins can read all profiles
- **Create**: Users can create their own profile during registration
- **Update**: 
  - Users can update their own profile (except `role` and `status` fields)
  - Admins can update any user profile
- **Delete**: Only admins can delete users

**Security Rationale**:
- Prevents users from changing their role or status (prevents privilege escalation)
- Allows users to update their own profile information
- Admins have full control for user management

**Example**:
```javascript
// User can update their own displayName
allow update: if isOwner(userId) 
  && (!('role' in request.resource.data.diff(resource.data).affectedKeys()))
```

### 2. User Enrollments Subcollection (`/users/{userId}/enrollments/{enrollmentId}`)

**Purpose**: Tracks which courses a user is enrolled in

**Access Rules**:
- **Read/Write**: Users can only access their own enrollments
- **Read**: Admins can read all enrollments (for analytics)

**Security Rationale**:
- Users should only see their own course enrollments
- Prevents users from modifying other users' enrollment data
- Admins need read access for reporting

### 3. User Wardrobes Subcollection (`/users/{userId}/wardrobes/{wardrobeId}`)

**Purpose**: Stores user's wardrobe items (if implemented)

**Access Rules**:
- **Read/Write**: Users can only access their own wardrobe

**Security Rationale**:
- Personal data should be private to each user

### 4. Roles Subcollection (`/users/_roles/{roleType}/{roleUserId}`)

**Purpose**: Organized collection for mentors, learners, and admins

**Access Rules**:
- **Read/Write**: Admins have full access
- **Read**: 
  - Users can read their own role document
  - Mentors can read other mentors (for mentor list)
  - Learners can read mentors (for mentor list)

**Security Rationale**:
- Allows public mentor listing while protecting other role data
- Admins need full access for user management

### 5. Courses Collection (`/courses/{courseId}`)

**Purpose**: Stores course content and metadata

**Access Rules**:
- **Read**: All authenticated users can read courses
- **Create/Update/Delete**: Only admins can modify courses

**Security Rationale**:
- Course content should be publicly readable to all authenticated users
- Only admins should be able to create, modify, or delete courses
- Prevents unauthorized course modifications

### 6. Categories Collection (`/categories/{categoryId}`)

**Purpose**: Stores course categories

**Access Rules**:
- **Read**: All authenticated users can read categories
- **Create/Update/Delete**: Only admins can modify categories

**Security Rationale**:
- Categories are reference data that should be readable by all
- Only admins should manage categories

## Security Best Practices Implemented

### 1. Principle of Least Privilege
- Users can only access data they own or need
- Role-based access control limits permissions

### 2. Data Protection
- Users cannot modify their role or status (prevents privilege escalation)
- Personal data (enrollments, wardrobe) is private to each user

### 3. Admin Controls
- Admins have full access for management purposes
- Admin operations are clearly separated from user operations

### 4. Authentication Required
- All operations require authentication
- No anonymous access to sensitive data

### 5. Default Deny
- Any collection not explicitly allowed is denied by default
- Prevents accidental data exposure

## Testing Security Rules

### Test Scenarios

1. **User Profile Access**
   - ✅ User can read their own profile
   - ✅ User can update their own profile (except role/status)
   - ❌ User cannot read other users' profiles
   - ❌ User cannot change their role

2. **Course Enrollment**
   - ✅ User can create their own enrollment
   - ✅ User can read their own enrollments
   - ❌ User cannot read other users' enrollments
   - ❌ User cannot modify other users' enrollments

3. **Course Management**
   - ✅ All users can read courses
   - ✅ Admin can create/update/delete courses
   - ❌ Regular users cannot modify courses

4. **Mentor Access**
   - ✅ All authenticated users can read mentor list
   - ✅ Admins can manage mentors
   - ❌ Regular users cannot modify mentor data

## Deployment Instructions

1. **Local Testing**:
   ```bash
   firebase emulators:start --only firestore
   ```

2. **Deploy to Firebase**:
   ```bash
   firebase deploy --only firestore:rules
   ```

3. **Verify Rules**:
   - Test in Firebase Console > Firestore > Rules
   - Use Rules Playground to test scenarios

## Monitoring and Maintenance

- Review rules regularly for security updates
- Monitor Firebase Console for denied requests
- Update rules when adding new collections
- Test rules after any changes

## Known Limitations

1. **Role Lookup**: The `getUserRole()` function requires a Firestore read, which counts against quota
2. **Performance**: Multiple role checks may impact performance for high-traffic operations
3. **Future Collections**: New collections must be explicitly added to rules

## Future Enhancements

1. Add rules for course reviews/ratings
2. Implement rules for chat/messaging features
3. Add rules for payment/transaction data
4. Implement time-based access rules (e.g., course availability)

