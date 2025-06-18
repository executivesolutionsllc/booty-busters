#!/bin/bash

# Create directory structure
mkdir -p apps/admin-mobile apps/client-web \
  packages/shared-ui packages/core packages/notifications \
  services/functions services/api \
  config scripts

# Initialize root package.json
cat <<EOT > package.json
{
  "name": "booty-busters",
  "private": true,
  "version": "1.0.0",
  "workspaces": ["apps/*", "packages/*", "services/*"],
  "scripts": {
    "bootstrap": "echo 'Bootstrap dependencies'",
    "deploy-functions": "cd services/functions && firebase deploy --only functions",
    "deploy-hosting": "cd apps/client-web && firebase deploy --only hosting"
  },
  "description": "Therapeutic prostate massage management system",
  "keywords": ["massage", "prostate", "wellness", "client-management", "stripe", "firebase"],
  "author": "Executive Solutions LLC",
  "license": "MIT"
}
EOT

# Create .gitignore
cat <<EOT > .gitignore
node_modules/
*.log
npm-debug.log*
.yarn-integrity
.firebase
.firebaserc

# IDE
.idea/
.vscode/
.env.local
.env.development.local
.env.test.local
.env.production.local
.env
.DS_Store
*.swp
*~
*.bak
*.tmp

dist/
build/

.expo/
web-build/
.eas/
EOT

# Create README.md
cat <<EOT > README.md
# Booty Busters – Therapeutic Prostate Massage Management System

> **Busting Bad Habits, One Booty at a Time™**

A professional system for managing clients, sessions, payments, and wellness data for therapeutic prostate massage providers.

---

## 🧩 Features

| Feature | Description |
|--------|-------------|
| 👨‍⚕️ Admin Mobile App | Manage clients, schedule appointments, track income |
| 👥 Client Web Portal | Book sessions, pay online, fill out intake forms |
| 💵 Payment Integration | Stripe for credit cards, crypto, subscriptions |
| 📅 Calendar | Real-time scheduling |
| 📄 PDF Forms | Auto-generate client intake forms |
| 📢 Notifications | Push & SMS reminders |
| 🔐 Authentication | Firebase Auth |
| 📊 Real-Time Dashboard | Firestore sync |
| 📱 iOS/Android Support | Built with React Native |

---

## 🧱 Tech Stack

| Layer | Tool |
|------|------|
| Admin App | React Native + Expo |
| Client Portal | Next.js + Tailwind CSS |
| Backend | Firebase |
| Payments | Stripe |
| Messaging | Firebase Cloud Messaging + Twilio |
| Hosting | Firebase Hosting |
| CI/CD | GitHub Actions |

---

## 📁 Folder Structure

\`\`\`bash
/booty-busters/
├── apps/
│   ├── admin-mobile/       # React Native Trainer App
│   └── client-web/         # Next.js Client Portal
├── packages/
│   ├── shared-ui/          # Shared components
│   ├── core/               # Business logic
│   └── notifications/      # Push/SMS logic
├── services/
│   ├── functions/          # Firebase Cloud Functions
│   └── api/               # Optional REST API layer
├── config/
│   ├── firebase.json
│   └── tailwind.config.js
└── package.json
\`\`\`

---

## 📲 Local Setup

\`\`bash
# Clone the repo
gh repo clone executivesolutionsllc/booty-busters
cd booty-busters

# Install dependencies
npm install

# Setup Firebase
cd services/functions
firebase init functions
\`\`

---

## 📤 Deployment

### Deploy Firebase Functions

\`\`bash
cd services/functions
firebase deploy --only functions
\`\`

### Deploy Web Portal

\`\`bash
cd ../..
cd apps/client-web
npm run build
firebase deploy --only hosting
\`\`

### Build Mobile App

\`\`bash
cd ../admin-mobile
eas build --platform all
\`\`

---

## 📞 Support

Contact us at [support@executivesolutionsllc.com](mailto:support@executivesolutionsllc.com)
EOT

# Create Tailwind Config
cat <<EOT > config/tailwind.config.js
module.exports = {
  content: [
    "./apps/**/*.{js,jsx,ts,tsx}",
    "./packages/**/*.{js,jsx,ts,tsx}",
    "./services/**/*.{js,jsx,ts,tsx}"
  ],
  theme: {
    extend: {
      colors: {
        primary: "#ec4899",
        secondary: "#fbcfe8",
        accent: "#a855f7",
        light: "#fff0f6"
      }
    },
  },
  plugins: [],
};
EOT

# Create Firebase JSON
cat <<EOT > config/firebase.json
{
  "functions": {
    "predeploy": ["npm --prefix \"\$RESOURCE_DIR\" run build"]
  },
  "emulators": {
    "functions": {
      "port": 5001
    },
    "firestore": {
      "port": 8080
    },
    "ui": {
      "enabled": true
    }
  }
}
EOT

# Create Button Component
mkdir -p packages/shared-ui
cat <<EOT > packages/shared-ui/Button.jsx
import React from "react";
import { TouchableOpacity, Text, StyleSheet } from "react-native";

export default function Button({ title, onPress }) {
  return (
    <TouchableOpacity style={styles.button} onPress={onPress}>
      <Text style={styles.text}>{title}</Text>
    </TouchableOpacity>
  );
}

const styles = {
  button: {
    backgroundColor: "#ec4899",
    padding: 15,
    borderRadius: 8,
    alignItems: "center",
  },
  text: {
    color: "white",
    fontWeight: "bold",
  },
};
EOT

# Create Core Utils
mkdir -p packages/core
cat <<EOT > packages/core/utils.js
export function formatCurrency(value) {
  return \$\${parseFloat(value).toFixed(2)};
}

export function formatDate(date) {
  return new Date(date).toLocaleDateString("en-US");
}
EOT

# Create Firebase Functions
mkdir -p services/functions
cat <<EOT > services/functions/index.js
const functions = require("firebase-functions");
const twilio = require("twilio");

// Example function
exports.helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello from Firebase!");
  response.send("Welcome to Booty Busters");
});

// Twilio example
const accountSid = functions.config().twilio.sid;
const authToken = functions.config().twilio.token;
const messagingServiceSid = functions.config().twilio.service;

const client = twilio(accountSid, authToken);

exports.sendAppointmentReminder = functions.firestore
  .document("appointments/{appointmentId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();
    await client.messages.create({
      body: Hi \${data.clientName}, your session is scheduled for \${data.date}.,
      from: "+1234567890",
      to: data.clientPhone,
      messagingServiceSid,
    });
  });
EOT

cat <<EOT > services/functions/package.json
{
  "name": "functions",
  "description": "Firebase Functions for Booty Busters",
  "scripts": {
    "serve": "firebase emulators:start --only functions",
    "shell": "firebase functions:shell",
    "start": "node index.js",
    "deploy": "firebase deploy --only functions"
  },
  "engines": {
    "node": "18"
  },
  "main": "index.js"
}
EOT

# Create App.jsx
mkdir -p apps/admin-mobile
cat <<EOT > apps/admin-mobile/App.jsx
import React from "react";
import MainStack from "../navigation/MainStack";

export default function App() {
  return <MainStack />;
}
EOT

# Create MainStack
mkdir -p apps/admin-mobile/navigation
cat <<EOT > apps/admin-mobile/navigation/MainStack.js
import React from "react";
import { createStackNavigator } from "@react-navigation/stack";
import LoginScreen from "../screens/LoginScreen";
import DashboardScreen from "../screens/DashboardScreen";

const Stack = createStackNavigator();

export default function MainStack() {
  return (
    <Stack.Navigator initialRouteName="Login">
      <Stack.Screen name="Login" component={LoginScreen} options={{ headerShown: false }} />
      <Stack.Screen name="Dashboard" component={DashboardScreen} />
    </Stack.Navigator>
  );
}
EOT

# Create Firebase Setup Instructions
cat <<EOT > SETUP.md
# Booty Busters – Setup Guide

## Prerequisites

- Node.js v18+
- Yarn or npm
- Firebase Project
- Stripe Account
- Twilio Account
- GitHub CLI (\`gh\`)

---

## 🛠️ Local Setup

1. Clone the repo:
   \`\`\`bash
   gh repo clone executivesolutionsllc/booty-busters
   cd booty-busters
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Setup Firebase:
   \`\`\`bash
   cd services/functions
   firebase init functions
   \`\`\`

---

## 📤 Deployment

### Deploy Firebase Functions

\`\`bash
cd services/functions
firebase deploy --only functions
\`\`

### Deploy Web Portal

\`\`bash
cd ../..
cd apps/client-web
npm run build
firebase deploy --only hosting
\`\`

### Build Mobile App

\`\`bash
cd ../admin-mobile
eas build --platform all
\`\`

---

## 📞 Support

Contact us at [support@executivesolutionsllc.com](mailto:support@executivesolutionsllc.com)
EOT

# Make it executable
chmod +x setup.sh