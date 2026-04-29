import os
import re
import numpy as np
import scipy
from scipy.sparse import hstack, csr_matrix
import joblib
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List

# Load ML Model

MODEL_PATH = "naive_bayes_model.joblib"        
VECTORIZER_PATH = "tfidf_vectorizer.joblib" 

model = None
vectorizer = None
model_loaded = False

try:
    model = joblib.load(MODEL_PATH)
    vectorizer = joblib.load(VECTORIZER_PATH)
    model_loaded = True
    print(f"✅ ML model loaded: {type(model).__name__}")
    print(f"✅ TF-IDF vectorizer loaded: {vectorizer.max_features} features")
except Exception as e:
    print(f"⚠️ Could not load model: {e}")
    print("❌ Machine learning model is missing. The server cannot start.")  

# Constants
COMMON_DOMAINS = {'gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com', 'aol.com', 'live.com'}
URL_PATTERN = re.compile(r'https?://\S+|www\.\S+', re.IGNORECASE)

# Helper Functions

def clean_text(text: str) -> str:
    text = str(text).lower()
    text = re.sub(r'<[^>]+>', ' ', text)
    text = re.sub(r'http\S+|www\.\S+', ' url ', text)
    text = re.sub(r'[^a-z\s]', ' ', text)
    text = re.sub(r'\s+', ' ', text).strip()
    return text

def detect_urls(text: str) -> bool:
    return bool(URL_PATTERN.search(text))

def extract_sender_domain(sender: str) -> str:
    match = re.search(r'@([\w.\-]+)', sender)
    return match.group(1).lower() if match else ''

def build_numerical_features(subject, body, sender, has_url):
    domain = extract_sender_domain(sender)
    is_common = int(domain in COMMON_DOMAINS)
    return np.array([[
        int(has_url),
        len(subject),
        len(body),
        len(subject.split()),
        len(body.split()),
        body.count('!'),
        body.count('$'),
        sum(1 for c in body if c.isupper()) / max(len(body), 1),
        is_common,
    ]])

def generate_reasons(subject, body, sender, has_url, is_phishing):
    reasons = []
    domain = extract_sender_domain(sender)
    if is_phishing:
        if domain and domain not in COMMON_DOMAINS:
            reasons.append("Suspicious sender domain")
        if any(w in body.lower() for w in ['urgent', 'immediately', 'suspend', 'verify now', 'act now']):
            reasons.append("Contains urgent or threatening language")
        if has_url:
            reasons.append("Contains a suspicious link")
        if any(w in body.lower() for w in ['password', 'credit card', 'ssn', 'bank account', 'social security', 'verify your']):
            reasons.append("Asks for personal information")
        if body.count('!') > 2:
            reasons.append("Excessive use of exclamation marks")
        if body.count('$') > 0:
            reasons.append("Contains monetary references")
        if not reasons:
            reasons.append("Pattern matches known phishing indicators")
    else:
        if domain in COMMON_DOMAINS:
            reasons.append("Sender is trusted")
        if not has_url:
            reasons.append("No suspicious links found")
        if not any(w in body.lower() for w in ['urgent', 'immediately', 'suspend', 'verify now']):
            reasons.append("No urgent or threatening language")
        if not any(w in body.lower() for w in ['password', 'credit card', 'ssn', 'bank account']):
            reasons.append("No request for sensitive information")
    return reasons

def predict_with_model(sender, subject, body, has_url):
    text = clean_text(subject + ' ' + body)
    X_text = vectorizer.transform([text])
    X_num = csr_matrix(build_numerical_features(subject, body, sender, has_url))
    X = hstack([X_text, X_num])
    pred = model.predict(X)[0]
    proba = model.predict_proba(X)[0]
    phishing_prob = float(proba[1])
    is_phishing = int(pred) == 1
    return {
        'is_phishing': is_phishing,
        'confidence': phishing_prob if is_phishing else float(proba[0]),
    }


# FastAPI App
app = FastAPI(title="PhishGuard API", version="1.0.0")

# Allow Flutter app to connect
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

class AnalyzeRequest(BaseModel):
    sender: str
    subject: str
    body: str

class AnalyzeResponse(BaseModel):
    label: str
    confidence: float
    risk_level: str
    has_url: bool
    reasons: List[str]
    model_used: str

@app.post("/")
async def analyze_email(request: AnalyzeRequest):
    has_url = detect_urls(request.body) or detect_urls(request.subject)

    if model_loaded:
        result = predict_with_model(request.sender, request.subject, request.body, has_url)
        model_used = "naive_bayes_model.joblib"
    else:
        label="error",
        confidence=0.0,
        risk_level="unknown",
        has_url=False,
        reasons=["ML model is not loaded"],
        model_used="none",


    is_phishing = result['is_phishing']
    confidence = round(result['confidence'], 4)
    risk_level = "high" if is_phishing and confidence >= 0.8 else ("medium" if is_phishing else "low")
    reasons = generate_reasons(request.subject, request.body, request.sender, has_url, is_phishing)
    label = "phishing" if is_phishing else "safe"

    print(f"📧 {request.sender} → {label} ({confidence:.0%}) [{model_used}]")

    return AnalyzeResponse(
        label=label,
        confidence=confidence,
        risk_level=risk_level,
        has_url=has_url,
        reasons=reasons,
        model_used=model_used,
    )

if __name__ == "__main__":
    import uvicorn
    print("\n🛡️ PhishGuard Backend API")
    print("=" * 40)
    print(f"Model: {'ML (' + type(model).__name__ + ')' if model_loaded else'Not Loaded'}")
    print(f"Server: http://0.0.0.0:8000")
    print(f"Docs:   http://localhost:8000/docs")
    print("=" * 40)
    uvicorn.run(app, host="0.0.0.0", port=8000)
