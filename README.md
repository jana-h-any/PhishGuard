# 🛡️ PhishGuard — AI-Powered Phishing Email Detection

<p align="center">
  <img src="assets/icon/app_icon.png" width="120" alt="PhishGuard Logo">
</p>

<p align="center">
  <strong>A Flutter mobile application that detects phishing emails using Machine Learning</strong><br>
  Built with MVC architecture • Gmail API integration • Real-time AI analysis
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/Python-3.11-3776AB?logo=python" alt="Python">
  <img src="https://img.shields.io/badge/FastAPI-0.115-009688?logo=fastapi" alt="FastAPI">
  <img src="https://img.shields.io/badge/ML-scikit--learn-F7931E?logo=scikit-learn" alt="scikit-learn">
</p>

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [ML Pipeline](#ml-pipeline)
- [Screenshots](#screenshots)
- [Setup & Installation](#setup--installation)
- [Configuration](#configuration)
- [API Reference](#api-reference)
- [Tech Stack](#tech-stack)
- [Future Improvements](#future-improvements)

---

## Overview

**PhishGuard** is a mobile application that connects to a user's Gmail account and analyzes incoming emails for phishing indicators using a trained machine learning model. The app provides real-time classification (phishing vs. safe), confidence scores, risk levels, detailed reasons, and actionable advice.

### Problem Statement
Phishing emails remain one of the most common cybersecurity threats, targeting users through deceptive messages that impersonate trusted entities. Traditional spam filters miss sophisticated phishing attempts, leaving users vulnerable to credential theft, financial fraud, and data breaches.

### Solution
PhishGuard combines **Natural Language Processing (NLP)** with **machine learning** to analyze email content, sender reputation, and structural patterns — providing users with an intelligent, real-time phishing detection system directly on their mobile device.

---

## Features

| Feature | Description |
|---------|-------------|
| 🔐 **Google OAuth** | Secure Gmail sign-in with read-only access |
| 📬 **Email Fetching** | Real-time inbox, promotions, and social tabs |
| 🧠 **AI Analysis** | ML-powered phishing detection with confidence scores |
| 📊 **Risk Assessment** | High / Medium / Low risk level classification |
| 🔍 **Detailed Reasons** | Human-readable explanations for each verdict |
| 💡 **Safety Advice** | Actionable recommendations based on results |
| 📈 **Scan History** | Local SQLite storage with weekly statistics |
| 🔗 **URL Detection** | Automatic detection of suspicious links |
| 🌙 **Dark Theme** | Modern dark purple UI design |
| 📱 **Android Support** | Optimized for Android devices |

---

## Architecture

### System Architecture

```
┌─────────────────┐     ┌──────────────┐     ┌─────────────────┐
│   Flutter App    │────▶│  Gmail API   │     │  Python Backend  │
│   (MVC Pattern)  │     │  (OAuth 2.0) │     │   (FastAPI)      │
│                  │     └──────────────┘     │                  │
│  ┌────────────┐  │                          │  ┌────────────┐  │
│  │   Models   │  │    HTTP POST /           │  │  ML Model  │  │
│  ├────────────┤  │◀────────────────────────▶│  │  (sklearn)  │  │
│  │   Views    │  │    JSON Request/Response  │  ├────────────┤  │
│  ├────────────┤  │                          │  │  TF-IDF    │  │
│  │Controllers │  │                          │  │ Vectorizer │  │
│  ├────────────┤  │                          │  └────────────┘  │
│  │  Services  │  │                          │                  │
│  └────────────┘  │                          │  Feature Engine  │
│                  │                          │  + Reasons Gen   │
│  SQLite (Local)  │                          │                  │
└─────────────────┘                          └─────────────────┘
```

### MVC Pattern

- **Models** — Data classes for emails, scan results, users, and history
- **Views** — UI screens (8 screens matching the app design)
- **Controllers** — Business logic for auth, email, scanning, and history
- **Services** — API client, Gmail integration, and database operations

---

## Project Structure

```
PhishGuard/
├── backend/                          # Python ML Backend
│   ├── phishguard_backend.py         # FastAPI server
│   ├── naive_bayes_model.joblib      # Naive Bayes model
│   ├── lr_model.joblib               # Logistic Regression model
│   ├── Random_Forest_model.joblib    # Random Forest model (best)
│   ├── tfidf_vectorizer.joblib       # TF-IDF vectorizer (8000 features)
│   └── requirements.txt             # Python dependencies
│
├── lib/                              # Flutter Application
│   ├── main.dart                     # App entry point
│   │
│   ├── models/                       # Data Models
│   │   ├── email_model.dart          # Gmail email data class
│   │   ├── scan_result_model.dart    # ML prediction result
│   │   ├── user_model.dart           # Google user info
│   │   └── history_model.dart        # Scan history entry
│   │
│   ├── views/                        # UI Screens
│   │   ├── onboarding_view.dart      # Welcome screen
│   │   ├── connect_gmail_view.dart   # Google OAuth screen
│   │   ├── home_shell.dart           # Bottom navigation shell
│   │   ├── inbox_view.dart           # Email list with tabs
│   │   ├── email_detail_view.dart    # Full email view
│   │   ├── analyzing_view.dart       # Analysis animation
│   │   ├── scan_result_view.dart     # Phishing/Safe result + advice
│   │   ├── history_view.dart         # Scan history & statistics
│   │   └── profile_view.dart         # User profile & settings
│   │
│   ├── controllers/                  # Business Logic
│   │   ├── auth_controller.dart      # Google Sign-In + Gmail auth
│   │   ├── email_controller.dart     # Fetch & manage emails
│   │   ├── scan_controller.dart      # ML analysis orchestration
│   │   └── history_controller.dart   # Local database operations
│   │
│   ├── services/                     # External Integrations
│   │   ├── api_service.dart          # HTTP client to Python backend
│   │   ├── gmail_service.dart        # Gmail API wrapper
│   │   └── database_service.dart     # SQLite local storage
│   │
│   └── utils/                        # Shared Utilities
│       ├── constants.dart            # Colors, API URLs
│       ├── theme.dart                # Dark theme configuration
│       └── routes.dart               # Navigation routes
│
├── assets/icon/                      # App icon
├── pubspec.yaml                      # Flutter dependencies
└── README.md                         # This file
```

---

## ML Pipeline

### Dataset
- **CEAS_08**: 39,126 emails (55.8% phishing, 44.2% ham)
- Source: [Phishing Email Dataset](https://github.com/rokibulroni/Phishing-Email-Dataset)

### Feature Engineering

**Text Features (TF-IDF):**
- 8,000 features using unigrams + bigrams
- Sublinear TF scaling
- English stop words removed
- Text preprocessing: lowercase, HTML removal, URL normalization

**Numerical Features (9):**

| # | Feature | Description |
|---|---------|-------------|
| 1 | `urls` | Whether email contains URLs (auto-detected) |
| 2 | `subject_len` | Character length of subject |
| 3 | `body_len` | Character length of body |
| 4 | `subject_word_count` | Word count in subject |
| 5 | `body_word_count` | Word count in body |
| 6 | `exclamation_count` | Number of `!` in body |
| 7 | `dollar_count` | Number of `$` in body |
| 8 | `caps_ratio` | Ratio of uppercase characters |
| 9 | `is_common_domain` | Whether sender is from gmail, yahoo, etc. |

### Model Comparison

| Model | Accuracy | Precision | Recall | F1-Score | ROC AUC |
|-------|----------|-----------|--------|----------|---------|
| Logistic Regression | 57.40% | 83.01% | 19.70% | 31.84% | 0.8588 |
| Naive Bayes | 85.02% | 78.08% | 97.80% | 86.83% | 0.9362 |
| **Random Forest** | **99.42%** | **99.45%** | **99.40%** | **99.43%** | **0.9996** |

### Best Model: Random Forest
- **Accuracy**: 99.42%
- **ROC AUC**: 0.9996
- **Precision**: 99.45% (very few false positives)
- **Recall**: 99.40% (catches almost all phishing)

### Prediction Pipeline

```
Raw Email → Clean Text → TF-IDF Vectorization → Combine with
                                                  9 Numerical Features → ML Model → Label + Confidence
```

---

## Setup & Installation

### Prerequisites
- Flutter SDK (≥ 3.0)
- Python 3.11+
- Android Studio (for Android development)
- Google Cloud Console project with Gmail API enabled

### 1. Clone the Repository

```bash
git clone https://github.com/jana-h-any/PhishGuard.git
cd PhishGuard
```

### 2. Backend Setup

```bash
cd backend
pip install -r requirements.txt
python phishguard_backend.py
```

The server starts at `http://0.0.0.0:8000`. You should see:
```
✅ ML model loaded: MultinomialNB
✅ TF-IDF vectorizer loaded: 8000 features
🛡️ PhishGuard Backend API
Server: http://0.0.0.0:8000
```

### 3. Flutter App Setup

```bash
cd ..  # Back to project root
flutter pub get
```

### 4. Google OAuth Configuration

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a project → Enable **Gmail API**
3. Configure **OAuth consent screen** (External)
4. Create an **Android OAuth client** with your SHA-1 fingerprint:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -storepass android
   ```
5. Create a **Web OAuth client** → Copy the Client ID
6. Add your email as a **test user** in the OAuth consent screen

### 5. Configure the App

**`lib/controllers/auth_controller.dart`** — Update the `serverClientId`:
```dart
serverClientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
```

**`lib/services/api_service.dart`** — Update the backend URL:
```dart
static const String _baseUrl = 'http://YOUR_PC_IP:8000/';
```

Find your PC's IP with `ipconfig` (Windows) or `ifconfig` (Mac/Linux).

### 6. Run

```bash
flutter run
```

### 7. Firewall (Windows)

Allow the backend port through Windows Firewall:
```powershell
netsh advfirewall firewall add rule name="PhishGuard API" dir=in action=allow protocol=TCP localport=8000
```

---

## Configuration

### Switching ML Models

The backend supports multiple models. Edit `backend/phishguard_backend.py`:

```python
# Choose your model:
MODEL_PATH = "naive_bayes_model.joblib"        # Naive Bayes (85% accuracy)
# MODEL_PATH = "lr_model.joblib"               # Logistic Regression
# MODEL_PATH = "Random_Forest_model.joblib"    # Random Forest (99.4% accuracy)
```

---

## API Reference

### `POST /`

Analyze an email for phishing detection.

**Request Body:**
```json
{
  "sender": "security@amaz0n-support.com",
  "subject": "Important: Verify your account",
  "body": "Dear Customer, We detected unusual activity..."
}
```

**Response:**
```json
{
  "label": "phishing",
  "confidence": 0.92,
  "risk_level": "high",
  "has_url": true,
  "reasons": [
    "Suspicious sender domain",
    "Contains urgent or threatening language",
    "Contains a suspicious link",
    "Asks for personal information"
  ],
  "model_used": "naive_bayes_ml"
}
```

**Fields:**

| Field | Type | Description |
|-------|------|-------------|
| `label` | string | `"phishing"` or `"safe"` |
| `confidence` | float | 0.0 – 1.0 confidence score |
| `risk_level` | string | `"high"`, `"medium"`, or `"low"` |
| `has_url` | boolean | Whether URLs were detected |
| `reasons` | string[] | Human-readable explanations |
| `model_used` | string | Model identifier used |

---

## Tech Stack

### Frontend (Mobile App)
| Technology | Purpose |
|-----------|---------|
| Flutter 3.0+ | Cross-platform mobile framework |
| Dart | Programming language |
| Provider | State management |
| Google Sign-In | OAuth 2.0 authentication |
| googleapis | Gmail API client |
| sqflite | Local SQLite database |
| http | HTTP client for API calls |

### Backend (ML Server)
| Technology | Purpose |
|-----------|---------|
| Python 3.11 | Runtime |
| FastAPI | REST API framework |
| scikit-learn | Machine learning models |
| TF-IDF Vectorizer | Text feature extraction |
| NumPy / SciPy | Numerical computations |
| joblib | Model serialization |
| Uvicorn | ASGI server |

---

## Future Improvements

- [ ] Add support for email attachment scanning
- [ ] Implement push notifications for new phishing detections
- [ ] Add automatic background email scanning
- [ ] User feedback loop to improve model over time
- [ ] Multi-language phishing detection
- [ ] Integration with email providers beyond Gmail

---

## Author

**Jana Hany** — [LinkedIn](https://www.linkedin.com/in/jana-hany)

---
