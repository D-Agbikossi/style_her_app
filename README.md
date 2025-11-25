# StyleHer - Beauty & Style Learning Platform

A comprehensive Flutter-based learning platform for beauty and style education, featuring separate admin and user applications with Firebase backend integration.

## 📱 Overview

StyleHer is a dual-application platform consisting of:
- **Admin App**: Complete content management system for administrators
- **Frontend App**: User-facing mobile application for learners

The platform enables beauty and style education through courses, mentors, and interactive learning experiences.

## ✨ Features

### Admin Application
- **Dashboard**: Real-time statistics (users, courses, mentors)
- **Course Management**: Create, edit, delete courses with:
  - Direct file uploads (thumbnails, videos, pictures)
  - Progress indicators for large file uploads
  - Multiple video and picture support
  - Category and difficulty management
- **User Management**: 
  - Separate management for learners and mentors
  - User status management (active/inactive)
  - Bulk operations (delete, update status)
- **Mentor Management**: Create and manage mentor profiles
- **Bulk Operations**: Select and perform actions on multiple items
- **Enhanced Validation**: Comprehensive form validation
- **Real-time Updates**: Live data synchronization with Firestore

### Frontend Application
- **Onboarding**: Welcome screens and interest selection
- **Authentication**: 
  - Email/password signup and login
  - Google Sign-In
  - Email verification
  - Password recovery
- **Home Screen**: 
  - Banner carousel with special offers
  - Advanced course search (title, description, category, instructor)
  - Category filtering
  - Popular courses display
  - Top mentors showcase
- **Course Enrollment**: 
  - Enroll in free and paid courses
  - Track enrollment status
  - Progress tracking for videos
- **Course Details**: 
  - Comprehensive course information
  - **Video Player**: Full-featured video playback with controls
  - **Image Gallery**: Grid view with full-screen zoom capability
  - Course curriculum with video selection
  - Instructor information
- **My Courses**: Course enrollment and progress tracking
- **Mentor Profiles**: View mentor information and their courses
- **Marketplace**: E-commerce functionality
- **Inbox**: Communication features
- **Profile Management**: Edit user profile

## 🛠️ Tech Stack

### Core Technologies
- **Flutter** (SDK 3.9.2+)
- **Dart** (3.9.2+)
- **Firebase**:
  - Firebase Authentication
  - Cloud Firestore
  - Firebase Storage

### Key Packages

#### Admin App
- `provider: ^6.1.5+1` - State management
- `firebase_core: ^4.2.1` - Firebase initialization
- `firebase_auth: ^6.1.2` - Authentication
- `cloud_firestore: ^6.1.0` - Database
- `firebase_storage: ^13.0.4` - File storage
- `image_picker: ^1.1.2` - Image selection
- `file_picker: ^8.1.4` - File selection

#### Frontend App
- `provider: ^6.1.5+1` - State management
- `google_sign_in: ^6.1.5` - Google authentication
- `smooth_page_indicator: ^1.1.0` - Page indicators
- `firebase_core: ^4.2.1` - Firebase initialization
- `firebase_auth: ^6.1.2` - Authentication
- `cloud_firestore: ^6.1.0` - Database
- `video_player: ^2.8.2` - Video playback
- `photo_view: ^0.14.0` - Image gallery with zoom
- `cached_network_image: ^3.3.1` - Image caching

## 📁 Project Structure

```
style_her_app-1/
├── admin/                    # Admin application
│   ├── lib/
│   │   ├── models/          # Data models
│   │   ├── screens/         # UI screens
│   │   ├── services/        # Business logic
│   │   ├── providers/       # State management
│   │   ├── utils/           # Utilities (validators)
│   │   └── widgets/         # Reusable widgets
│   ├── test/                # Test files
│   │   ├── models/
│   │   ├── services/
│   │   ├── utils/
│   │   └── widgets/
│   └── pubspec.yaml
│
├── frontend/                 # User application
│   ├── lib/
│   │   ├── models/          # Data models
│   │   ├── screens/         # UI screens
│   │   ├── services/        # Business logic
│   │   ├── providers/       # State management
│   │   ├── widgets/         # Reusable widgets
│   │   └── theme.dart       # App theme
│   └── pubspec.yaml
│
└── README.md
```

## 🗄️ Database Structure

### Firestore Collections

#### `users` Collection
Main user collection with subcollections:
- `users/{userId}` - User document
- `users/_roles/mentors/{mentorId}` - Mentor subcollection
- `users/_roles/learners/{learnerId}` - Learner subcollection
- `users/_roles/admin/{adminId}` - Admin subcollection

**User Document Structure:**
```json
{
  "email": "user@example.com",
  "displayName": "User Name",
  "role": "learner" | "mentor" | "admin",
  "status": "active" | "inactive",
  "createdAt": timestamp,
  "updatedAt": timestamp
}
```

#### `courses` Collection
Course documents with media support:
```json
{
  "title": "Course Title",
  "description": "Course Description",
  "category": "Make Up" | "Hair Styling" | "Hair Making" | "Nail Care" | "Arts",
  "difficulty": "Beginner" | "Intermediate" | "Advanced",
  "instructor": "Instructor Name",
  "thumbnailUrl": "https://...",
  "videoUrls": ["https://...", "https://..."],
  "pictureUrls": ["https://...", "https://..."],
  "duration": 60,
  "lessonCount": 5,
  "rating": 4.5,
  "enrolledCount": 100,
  "isFree": false,
  "price": 29.99,
  "createdAt": timestamp,
  "updatedAt": timestamp
}
```

#### `categories` Collection
Course categories management

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK (3.9.2 or higher)
- Firebase project with:
  - Authentication enabled
  - Firestore Database
  - Storage configured
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio (IDE)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd style_her_app-1
   ```

2. **Setup Firebase**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication (Email/Password and Google)
   - Create Firestore Database
   - Configure Firebase Storage
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in respective platform folders

3. **Setup Admin App**
   ```bash
   cd admin
   flutter pub get
   flutter run
   ```

4. **Setup Frontend App**
   ```bash
   cd frontend
   flutter pub get
   flutter run
   ```

### Initial Admin Setup

After running the admin app for the first time:

1. The app will show an admin setup screen if no admin exists
2. Fill in the form:
   - Full Name
   - Email Address
   - Password (minimum 6 characters)
   - Confirm Password
3. Click "Create Admin Account"
4. You'll be redirected to login - use your credentials to sign in

For detailed admin setup instructions, see [ADMIN_SETUP.md](admin/ADMIN_SETUP.md)

## 🧪 Testing

### Running Tests

#### Admin App Tests
```bash
cd admin
flutter test
```

#### Run Specific Test Suites
```bash
# Validators tests
flutter test test/utils/validators_test.dart

# Model tests
flutter test test/models/course_test.dart

# Widget tests
flutter test test/widgets/bulk_operations_bar_test.dart
```

#### Test Coverage
```bash
flutter test --coverage
```

### Test Results
- ✅ **34 tests passing**
  - Validators: 23/23
  - Course Model: 4/4
  - Bulk Operations Bar: 6/6
  - Storage Service: Tests created
  - Admin Service: Tests created

For more information, see [test/README.md](admin/test/README.md)

## 📝 Key Features Implementation

### File Uploads with Progress
- Real-time upload progress tracking
- Individual file progress indicators
- Overall upload progress display
- Support for thumbnails, videos, and pictures
- Direct uploads to Firebase Storage

### Form Validation
- Email validation
- URL validation
- Number/Integer validation with constraints
- Price validation (0-10,000 range)
- Required field validation
- Length validation

### Bulk Operations
- Multi-select functionality
- Bulk delete for courses, mentors, and users
- Bulk status updates
- Visual selection feedback

## 🔐 Security

- Firebase Authentication for user management
- Role-based access control (admin, mentor, learner)
- Secure file uploads to Firebase Storage
- Firestore security rules (should be configured)

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🎨 Design

- Modern, clean UI design
- Consistent color scheme
- Material Design components
- Responsive layouts
- Smooth animations and transitions

## 📚 Documentation

- [Admin Setup Guide](admin/ADMIN_SETUP.md)
- [Features Implementation](admin/FEATURES_IMPLEMENTED.md)
- [Test Documentation](admin/test/README.md)
- [App Review](APP_REVIEW.md)
- [Code Review](CODE_REVIEW.md) - Comprehensive code quality analysis
- [Frontend Integration Summary](FRONTEND_INTEGRATION_SUMMARY.md)
- [Deployment Guide](DEPLOYMENT.md) - Complete deployment instructions

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is private and not licensed for public use.

## ✅ Recent Improvements

### High Priority Fixes (Completed)
- ✅ **Video Player**: Full integration with proper lifecycle management
- ✅ **Image Gallery**: Grid view with full-screen zoom capability
- ✅ **Firestore Integration**: Real-time data fetching in frontend
- ✅ **Enrollment System**: Complete course enrollment functionality
- ✅ **Enhanced Search**: Case-insensitive search across multiple fields
- ✅ **Error Handling**: User-friendly error messages throughout
- ✅ **Code Quality**: Fixed critical issues identified in code review
- ✅ **Constants Management**: Centralized app constants

### Code Quality Improvements
- ✅ Video player controller lifecycle properly managed
- ✅ Video URL validation before playback
- ✅ Firestore query optimization (no composite index required)
- ✅ Array bounds checking for video indices
- ✅ Improved error messages (user-friendly)
- ✅ Image gallery error handling (division by zero protection)

## 🐛 Known Issues

- Some tests require Firebase to be configured (will fail in CI/CD without mocking)

## 🔮 Future Enhancements

- [x] Video player integration in frontend ✅
- [x] Image gallery for course pictures ✅
- [x] Firestore integration in frontend ✅
- [x] Course enrollment system ✅
- [x] Enhanced search functionality ✅
- [ ] Push notifications
- [ ] Offline mode support
- [ ] Course completion certificates
- [ ] Payment integration
- [ ] Social features (comments, reviews)
- [ ] Analytics dashboard
- [ ] Video progress persistence
- [ ] Course recommendations
- [ ] Wishlist functionality

## 📞 Support

For issues and questions:
- Check the documentation files
- Review the code comments
- Check Firebase Console for configuration issues

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- All contributors to the open-source packages used

---

**Version**: 1.0.0  
**Last Updated**: 2025 
**Status**: Active Development

