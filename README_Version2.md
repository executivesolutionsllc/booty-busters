# Booty Busters – Therapeutic Prostate Massage Management System

> **Busting Bad Habits, One Booty at a Time™**

Booty Busters is a real-time platform for managing clients, sessions, payments, and wellness for therapeutic prostate massage providers. The monorepo includes web and mobile apps, cloud functions, and deployment workflows.

---

## Features

- Admin Mobile App (React Native/Expo)
- Client Web Portal (Next.js)
- Stripe Payments Integration
- Real-time Scheduling (Firebase)
- PDF Intake Forms (add your forms in web/mobile)
- Push & SMS Notifications (Firebase Messaging, Twilio)
- Secure Authentication (Firebase Auth)
- Real-time Dashboard (Firestore)
- Multi-platform support

---

## Quickstart

```sh
git clone https://github.com/executivesolutionsllc/booty-busters.git
cd booty-busters
yarn install
yarn bootstrap
# Set up .env files in each app/service
yarn deploy-functions
yarn deploy-hosting
```

- Configure Firebase, Stripe, and Twilio credentials in the respective `.env` files.
- Deployments are automated via GitHub Actions.

MIT License