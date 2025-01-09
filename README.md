# ⚽ Teams & Players CRUD App with Flutter

This project is a **CRUD application** (Create, Read, Update, Delete) for managing **teams and players**, developed using **Flutter** and integrated with **Firebase NoSQL**. The app features a minimalistic and user-friendly interface, making it easy to perform operations on teams and players.

## 📱 Features

- ✅ **Complete CRUD for Teams**
  - Create, view, edit, and delete teams
- ✅ **Complete CRUD for Players**
  - Create, view, edit, and delete players
- ✅ **Player-to-Team Linking**
  - Players can be linked to a team (one-to-many relationship)
- ✅ **Minimalistic and Intuitive UI**
  - Clean layout focused on providing a great user experience

## 🛠️ Technologies Used

- **Dart**: Programming language
- **Flutter**: UI development framework
- **Firebase Firestore**: NoSQL database
- **Provider**: State management

## 📂 Project Structure

```bash
/lib
  ├── main.dart             
  ├── pages/
  │   ├── home.dart         
  │   └── add_player.dart   
  │   └── add_team.dart 
  │   └── show_players.dart 
  │   └── show_teams.dart 
  │   └── update_player.dart 
  │   └── update_team.dart     
  ├── services/
  │   └── database.dart       
```

## 🚀 How to Run the Project

Follow the steps below to set up and run the project on your local machine:

### 📝 **Prerequisites**

Make sure you have the following tools installed:

- [Flutter](https://flutter.dev/docs/get-started/install) (latest stable version)
- [Firebase Console](https://console.firebase.google.com/) account
- Project configured in the Firebase Console

### 📥 **Step 1: Clone the Repository**

Clone this repository to your local machine using the following command:

```bash
git clone https://github.com/LuccaMenegatti/flutter-crud.git
cd flutter-crud
```

### 📦 **Step 2: Install Dependencies**

Run the following command to install all the required dependencies:

```bash
flutter pub get
```

### 🔧 **Step 3: Configure Firebase**

- Go to the Firebase Console and create a new project.
- Enable Firestore Database in the Firebase project.

### ▶️ **Step 4: Run the App**

Start the app on an emulator or connected device by running:

```bash
flutter run
```

### 🎉 **You are all set! The app should now be running on your device.**
