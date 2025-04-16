# 📚 Study Helper – Your Smart Study Companion

Study Helper is a Flutter mobile app designed to make studying more efficient and organized. It combines task management with smart image analysis to help students stay on top of their academic goals.

---

## 🚀 Features

- 📸 **Topic Extractor from Images**  
  Take a picture of your notes or textbook page — Study Helper uses an AI API to extract the top 3 main topics automatically.

- ✅ **To-Do List for Study Tasks**  
  Easily create, manage, and complete your study tasks with a clean to-do list interface.

- 🔐 **Authentication System**  
  Secure login and registration with Firebase Auth.

- ☁️ **Firestore Integration**  
  All data, including tasks and captured images, are stored and synced using Firebase Cloud Firestore.

---

## 🧠 How It Works

1. Click the camera button to take a photo of your notes.
2. The app sends the image to a backend API that analyzes it and returns three key topics.
3. You can save the image and its topics to your account.
4. Use the to-do list to plan your study sessions based on extracted topics.

---

## 🛠️ Tech Stack

- **Flutter** – Frontend development
- **Firebase** – Auth + Firestore backend
- **Dart** – App logic
- **REST API** – For analyzing study images
- **OpenAI / Hugging Face** – (Optional) AI services for topic extraction

---

## 🧪 Installation

1. Clone the repo:
   ```bash
   git clone https://github.com/AbdElkader-moh/Study-Helper-Mobile-app.git
   cd Study-Helper-Mobile-app
