# TaskSwap - Social Task Exchange Mobile App

A beautiful Flutter mobile application that allows users to connect with others and exchange tasks in a social, Instagram-like interface.

## Features

### 🔐 Authentication
- Email/password login with demo credentials
- Beautiful gradient login screen with smooth animations

### 🔍 User Discovery
- Search for users by username or name
- View user profiles with photos and bios
- Send connection requests to other users

### 🤝 Social Connections
- Accept or decline connection requests
- Manage your network of connected users
- View pending requests with user details

### ✅ Task Management
- Assign structured tasks to connected users
- Set task priorities (Low, Medium, High)
- Add due dates and descriptions
- Track task status (Pending, Completed)
- View received and sent tasks separately

### 🔔 Notifications
- Real-time notifications for:
  - New task assignments
  - Connection requests
  - Accepted connections
  - Task completions
- Unread notification badges
- Auto-mark as read when viewing

## Tech Stack

- **Framework**: Flutter 3.10+
- **State Management**: Provider
- **UI Components**: Material Design 3
- **Image Caching**: cached_network_image
- **Date Formatting**: intl
- **Unique IDs**: uuid

## Getting Started

### Prerequisites
- Flutter SDK 3.10.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd taskswap
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Demo Credentials
- Email: `sara@example.com`
- Password: `password`

## App Architecture

### Models
- `User`: User profile information
- `Task`: Task details with priority and status
- `ConnectionRequest`: Connection between users
- `AppNotification`: In-app notifications

### Providers
- `AppProvider`: Main state management for the entire app

### Screens
- `LoginScreen`: Authentication interface
- `MainScreen`: Bottom navigation container
- `SearchScreen`: User discovery and search
- `ConnectionsScreen`: Manage connections and requests
- `TasksScreen`: View and manage tasks
- `NotificationsScreen`: View all notifications

### Widgets
- `UserCard`: Reusable user display component
- `TaskCard`: Task display with status controls
- `NotificationCard`: Notification item display
- `CreateTaskModal`: Task creation interface
- Custom UI components (Button, TextField, Avatar)

## Design Features

- **Modern UI**: Clean, card-based design with subtle shadows
- **Gradient Backgrounds**: Beautiful color gradients throughout
- **Smooth Animations**: Micro-interactions and transitions
- **Responsive Layout**: Optimized for various screen sizes
- **Consistent Theming**: Unified color scheme and typography
- **Accessibility**: Proper contrast ratios and touch targets

## Future Enhancements

- Push notifications
- Task comments and attachments
- Recurring tasks
- Task categories and tags
- User profiles editing
- Dark mode support
- Offline functionality
- Task reminders
- Analytics and insights

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.