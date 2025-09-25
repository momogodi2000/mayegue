# Mayegue - Cameroonian Language Learning App

Application d'apprentissage des langues traditionnelles camerounaises (Ewondo, Bafang, etc.) avec intelligence artificielle et paiements intégrés.

## 🚀 Fonctionnalités

- **Apprentissage des langues** : Ewondo, Bafang et autres langues camerounaises
- **IA intégrée** : Assistance contextuelle avec Gemini AI
- **Système de paiement** : Intégration CamPay et NouPai
- **Authentification** : Firebase Auth avec Google, Facebook, Apple
- **Contenu multimédia** : Audio, vidéo et exercices interactifs
- **Tableaux de bord** : Pour apprenants, enseignants et administrateurs
- **Communauté** : Forums et interactions sociales
- **Gamification** : Système de récompenses et progression

## 🛠️ Installation

### Prérequis

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Firebase CLI (pour le déploiement)

### Configuration

1. **Cloner le projet**
   ```bash
   git clone <repository-url>
   cd mayegue-app
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Configuration des variables d'environnement**

   Copiez le fichier d'exemple et configurez vos clés API :

   ```bash
   cp .env.example .env
   ```

   Éditez `.env` avec vos vraies clés API :

   ```env
   # Firebase (obligatoire)
   FIREBASE_API_KEY=votre_clé_api_firebase
   FIREBASE_PROJECT_ID=votre_id_projet

   # Gemini AI (obligatoire pour l'IA)
   GEMINI_API_KEY=votre_clé_gemini

   # Paiements (au moins un requis pour la monétisation)
   CAMPAY_API_KEY=votre_clé_campay
   CAMPAY_SECRET=votre_secret_campay
   # OU/ET
   NOUPAI_API_KEY=votre_clé_noupai
   ```

4. **Configuration Firebase**

   - Créez un projet Firebase
   - Activez Authentication, Firestore, Storage, Messaging
   - Téléchargez `google-services.json` dans `android/app/`
   - Configurez les règles de sécurité

5. **Générer les icônes et localisations**
   ```bash
   flutter pub run flutter_launcher_icons:main
   flutter gen-l10n
   ```

## 🔧 Configuration des API

### Firebase
1. Créez un projet sur [Firebase Console](https://console.firebase.google.com/)
2. Activez les services requis
3. Copiez les clés dans `.env`

### Gemini AI
1. Accédez à [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Créez une clé API
3. Ajoutez-la dans `.env`

### Paiements
- **CamPay** : Inscrivez-vous sur [campay.net](https://campay.net/)
- **NouPai** : Inscrivez-vous sur [noupai.com](https://noupai.com/)

## 🚀 Lancement

```bash
# Développement
flutter run

# Build production
flutter build apk --release
flutter build ios --release
```

## 📱 Architecture

- **MVVM Pattern** avec Clean Architecture
- **Provider** pour la gestion d'état
- **Go Router** pour la navigation
- **Dio** pour les appels HTTP
- **Hive** pour le stockage local
- **Firebase** pour le backend

## 🧪 Tests

```bash
flutter test
```

## 📦 Build et déploiement

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contribution

1. Fork le projet
2. Créez une branche feature (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Pushez vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## 📄 Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👥 Équipe

- **Développement** : Équipe Mayegue
- **Design** : UI/UX Camerounais
- **IA** : Intégration Gemini
- **Paiements** : CamPay & NouPai

## 🌍 Impact

Application éducative pour préserver et promouvoir les langues traditionnelles camerounaises, rendant l'apprentissage accessible à tous grâce à l'IA et aux paiements mobiles.
