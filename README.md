# 🛡️ PhishGuard — AI-Powered Phishing Email Detection

<p align="center">
  <img src="assets/icon/app_icon.png" width="120" alt="PhishGuard Logo">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Python-3.10+-3776AB?logo=python&logoColor=white" alt="Python">
  <img src="https://img.shields.io/badge/FastAPI-0.100+-009688?logo=fastapi&logoColor=white" alt="FastAPI">
  <img src="https://img.shields.io/badge/scikit--learn-ML-F7931E?logo=scikit-learn&logoColor=white" alt="scikit-learn">
  <img src="https://img.shields.io/badge/Gmail_API-integrated-EA4335?logo=gmail&logoColor=white" alt="Gmail API">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-blueviolet" alt="Platforms">
</p>

---

## 📖 Overview

Phishing attacks are among the most prevalent and dangerous forms of cybercrime, accounting for over **36% of all data breaches** worldwide. They exploit human psychology — urgency, fear, and impersonation — to trick users into revealing sensitive information or clicking malicious links, often through seemingly legitimate emails. Despite spam filters and basic rule-based detection, sophisticated phishing emails continue to reach inboxes every day.

**PhishGuard** is a cross-platform mobile application designed to close that gap. It connects directly to a user's Gmail inbox and applies a trained **Machine Learning pipeline** to analyse every email in real-time — classifying it as **safe** or **phishing**, explaining *why*, and offering direct actions to neutralise the threat without leaving the app.

Unlike static blocklists or keyword filters, PhishGuard learns from the linguistic and structural patterns that define phishing attempts: the combination of suspicious sender domains, urgency-driven language, embedded URLs, requests for sensitive information, and formatting anomalies like excessive capitalisation or punctuation. This multi-dimensional approach makes it significantly harder to evade than traditional rule-based systems.

---

## 🎯 Problem Statement

Standard email clients offer limited protection against phishing:

- **Spam filters** are reactive — they rely on known patterns and can be bypassed by novel attacks.
- **User judgement** is unreliable under pressure — phishing emails are crafted to create urgency and panic.
- **No explainability** — even when an email is flagged, users rarely understand *why*, making it hard to learn from the experience.
- **No in-app remediation** — acting on a flagged email (labelling, reporting, removing) requires navigating multiple Gmail menus.

PhishGuard addresses all four gaps in a single, intuitive application.

---

## 🔍 How It Works

The app is composed of two tightly integrated layers: a **Flutter frontend** handling the user experience and Gmail connectivity, and a **Python backend microservice** responsible for all ML inference.

### 1 — Authentication & Inbox Access
The user signs in with their Google account via OAuth 2.0. PhishGuard requests only the `gmail.modify` scope, which allows reading emails and applying labels — nothing more. Once authenticated, the Gmail API fetches real messages from the user's **Inbox**, **Promotions**, and **Social** tabs, parsed into structured `EmailModel` objects complete with sender, subject, body, date, and category.

### 2 — Email Analysis Pipeline
When the user selects an email for scanning, the app sends a `POST` request to the FastAPI backend containing the sender address, subject line, and full body text. The backend then:

**Step 1 — Text Cleaning**
The raw text is normalised: HTML tags are stripped, URLs are replaced with a placeholder token (`url`), punctuation and digits are removed, and the result is lowercased. This produces a clean, consistent representation for the vectoriser.

**Step 2 — TF-IDF Vectorisation**
The cleaned text is transformed into a sparse numerical vector using a **pre-fitted TF-IDF (Term Frequency–Inverse Document Frequency) vectoriser**. TF-IDF assigns higher weights to terms that are rare across the training corpus but frequent in this specific email — precisely the kind of vocabulary (e.g. *"verify your account"*, *"suspend"*, *"wire transfer"*) that distinguishes phishing content from legitimate communication.

**Step 3 — Numerical Feature Extraction**
In parallel, 9 hand-crafted numerical features are computed from the raw email:

| Feature | Rationale |
|---|---|
| URL presence | Phishing emails almost always contain links |
| Subject character length | Very long or very short subjects are anomalous |
| Body character length | Extremely terse or verbose bodies signal manipulation |
| Subject word count | Structural pattern indicator |
| Body word count | Structural pattern indicator |
| Exclamation mark count | Urgency signalling |
| Dollar sign count | Financial lure indicator |
| Uppercase character ratio | Shouting / pressure tactics |
| Trusted sender domain | gmail.com, outlook.com, yahoo.com, etc. are considered common |

**Step 4 — Feature Fusion & Classification**
The TF-IDF sparse vector and the numerical feature array are **horizontally stacked** into a single combined feature matrix using `scipy.sparse.hstack`. This unified representation is passed to the **Naive Bayes classifier**, which outputs a binary prediction (`phishing` / `safe`) alongside a probability score for each class.

**Step 5 — Risk Scoring & Explanation**
The raw probability is translated into a human-friendly **confidence percentage** and a **risk level** (`low`, `medium`, or `high`). A rule-based explanation engine then inspects the email against each phishing signal and produces a set of plain-English **reason statements** — e.g. *"Suspicious sender domain"*, *"Contains urgent or threatening language"*, *"Asks for personal information"* — which are surfaced directly in the app alongside the verdict.

### 3 — Result Display & Gmail Actions
The scan result screen presents:
- A clear **Phishing Detected / Safe Email** verdict with a colour-coded icon
- A **risk level badge** and an animated **confidence bar**
- A list of **reasons** explaining the classification
- Contextual **security advice** (what to do / what to avoid)
- An **"Already Clicked?"** screen with step-by-step recovery guidance for users who interacted with a suspicious email before scanning it
- A **"Mark as Phishing"** button that programmatically applies a `Phishing` Gmail label to the email and removes it from the inbox in one tap — no manual navigation required

### 4 — Scan History
Every completed scan is persisted to a local **SQLite database** using `sqflite`. The History screen lets users review all past results, giving them an audit trail of their inbox security over time without requiring any cloud storage or additional account.

---

## ✨ Key Features

| Feature | Description |
|---|---|
| 🔐 **Google OAuth 2.0** | Secure sign-in with minimal permission scope |
| 📥 **Live Inbox Fetch** | Reads from Inbox, Promotions, and Social in real time |
| 🤖 **ML Classification** | Naive Bayes + TF-IDF + 9 numerical features |
| 📊 **Confidence Scoring** | Percentage confidence with Low / Medium / High risk |
| 🧠 **Explainable AI** | Plain-English reasons for every verdict |
| 🏷️ **Gmail Labelling** | One-tap "Mark as Phishing" — labels + removes from inbox |
| 🕒 **Scan History** | Persistent local history via SQLite |
| 💡 **Recovery Tips** | Step-by-step guidance for post-click victims |
| 🌙 **Dark UI** | Polished dark theme with Material Design 3 |

---

## 🏗️ Architecture

PhishGuard is built on a clean **MVC (Model-View-Controller)** pattern on the Flutter side, with Provider as the state management layer, and a decoupled **Python microservice** handling all inference workloads.

```
┌──────────────────────────────────────────────────────┐
│                  Flutter Application                 │
│                                                      │
│  Views ──────► Controllers ──────► Services          │
│  (UI screens)   (business logic)   (API, Gmail, DB)  │
│                      │                               │
│                   Models                             │
│              (data structures)                       │
└───────────────────────┬──────────────────────────────┘
                        │ HTTP POST
                        ▼
          ┌─────────────────────────┐
          │   Python FastAPI        │
          │   phishguard_backend.py │
          │                         │
          │  TF-IDF + Naive Bayes   │
          │  Numerical Features     │
          │  Explanation Engine     │
          └─────────────────────────┘
```

This separation keeps the Flutter app lightweight and platform-agnostic, while allowing the ML backend to be updated, retrained, or swapped independently.

---

## 🛠️ Tech Stack

### Flutter Application
| Package | Version | Purpose |
|---|---|---|
| `google_sign_in` | ^6.2.1 | OAuth 2.0 Google authentication |
| `googleapis` | ^13.2.0 | Gmail REST API client |
| `googleapis_auth` | ^1.6.0 | Authenticated HTTP client |
| `provider` | ^6.1.2 | State management (MVC) |
| `sqflite` | ^2.3.3 | Local scan history (SQLite) |
| `fl_chart` | ^0.68.0 | Confidence score visualisation |
| `lottie` | ^3.1.2 | Animated loading states |
| `shimmer` | ^3.0.0 | Skeleton loading UI |
| `url_launcher` | ^6.2.6 | Safe external link handling |

### Python Backend
| Package | Purpose |
|---|---|
| `FastAPI` | HTTP API framework |
| `uvicorn` | ASGI production server |
| `scikit-learn` | ML models & TF-IDF vectoriser |
| `numpy` / `scipy` | Numerical feature matrix & sparse ops |
| `joblib` | Model serialisation / loading |
| `pydantic` | Request/response validation |

---

## 📁 Project Structure

```
PhishGuard/
├── backend/                          # Python inference microservice
│   ├── phishguard_backend.py         # FastAPI app + full ML pipeline
│   ├── naive_bayes_model.joblib      # Primary classifier (active)
│   ├── lr_model.joblib               # Logistic Regression (available)
│   ├── Random_Forest_model.joblib    # Random Forest (available)
│   ├── tfidf_vectorizer.joblib       # Fitted TF-IDF vectorizer
│   └── requirements.txt
│
├── lib/                              # Flutter source code
│   ├── main.dart                     # App entry point & Provider setup
│   ├── controllers/
│   │   ├── auth_controller.dart      # Google Sign-In state
│   │   ├── email_controller.dart     # Inbox fetching state
│   │   ├── scan_controller.dart      # Scan request & result state
│   │   └── history_controller.dart   # Scan history state
│   ├── models/
│   │   ├── email_model.dart
│   │   ├── scan_result_model.dart
│   │   ├── history_model.dart
│   │   └── user_model.dart
│   ├── services/
│   │   ├── gmail_service.dart        # Gmail API: fetch, label, mark
│   │   ├── api_service.dart          # HTTP client → Python backend
│   │   └── database_service.dart     # SQLite persistence
│   ├── views/
│   │   ├── onboarding_view.dart
│   │   ├── connect_gmail_view.dart
│   │   ├── inbox_view.dart
│   │   ├── email_detail_view.dart
│   │   ├── analyzing_view.dart
│   │   ├── scan_result_view.dart
│   │   ├── history_view.dart
│   │   ├── profile_view.dart
│   │   ├── tips.dart
│   │   └── home_shell.dart
│   └── utils/
│       ├── constants.dart
│       ├── theme.dart
│       └── routes.dart
│
├── assets/icon/app_icon.png
└── pubspec.yaml
```

---

## 🤖 ML Models

Three classifiers were trained and shipped with the app. **Naive Bayes** is active by default.

| Model | File | Characteristics |
|---|---|---|
| **Naive Bayes** *(active)* | `naive_bayes_model.joblib` | Fast, low memory, strong baseline for text |
| Logistic Regression | `lr_model.joblib` | Linear boundary, good generalisation |
| Random Forest | `Random_Forest_model.joblib` | Ensemble, robust on edge cases |

All three share the same TF-IDF vectoriser (`tfidf_vectorizer.joblib`) and are drop-in interchangeable via a single config line in the backend.

---

## 📡 API Reference

### `POST /`

Analyse a single email for phishing indicators.

**Request Body**

```json
{
  "sender": "support@suspicious-domain.xyz",
  "subject": "URGENT: Verify your account now!",
  "body": "Click here immediately to avoid account suspension..."
}
```

**Response**

```json
{
  "label": "phishing",
  "confidence": 0.9432,
  "risk_level": "high",
  "has_url": true,
  "reasons": [
    "Suspicious sender domain",
    "Contains urgent or threatening language",
    "Contains a suspicious link"
  ],
  "model_used": "naive_bayes_model.joblib"
}
```

| Field | Type | Values |
|---|---|---|
| `label` | `string` | `"phishing"` or `"safe"` |
| `confidence` | `float` | 0.0 – 1.0 |
| `risk_level` | `string` | `"low"` · `"medium"` · `"high"` |
| `has_url` | `boolean` | URL detected in subject or body |
| `reasons` | `string[]` | Human-readable explanation |
| `model_used` | `string` | Active model filename |

---

## 📱 Supported Platforms

| Platform | Status |
|---|---|
| Android | ✅ |
| iOS | ✅ |
| Web | ✅ |
| macOS | ✅ |
| Windows | ✅ |
| Linux | ✅ |

---

## 📸 Screenshots

> *(Add screenshots of Onboarding, Inbox, Scan Result, and History screens here)*

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome.

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/your-feature`
3. Commit your changes using [Conventional Commits](https://www.conventionalcommits.org/)
4. Push and open a Pull Request

---

## 👩‍💻 Author

**Jana Hany**  
[GitHub](https://github.com/jana-h-any)

---

## 📄 License

This project is for educational purposes. All rights reserved © 2025 Jana Hany.