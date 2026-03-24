# ZapClipper — Attachment Reminder for Apple Mail

**Ne partez plus jamais sans votre piece jointe. / Never forget an attachment again.**

ZapClipper est une extension Apple Mail pour macOS (Sequoia, Sonoma) qui detecte quand vous mentionnez une piece jointe dans un email sans en avoir attache une — et vous previent avant l'envoi.

ZapClipper is a native macOS Mail extension that detects when you mention an attachment in your email without actually attaching a file — and warns you before sending.

> *Fini les "Oups, j'ai oublie la piece jointe" / No more "Sorry, I forgot the attachment"*

## Video explicative

[![ZapClipper](https://img.youtube.com/vi/lYJZObf1oHg/0.jpg)](https://www.youtube.com/shorts/lYJZObf1oHg)

## Screenshots

| Accueil | Mots-cles | Alerte |
|---------|-----------|--------|
| ![Accueil](screenshots/accueil.png) | ![Mots-cles](screenshots/mots-cles.png) | ![Alerte](screenshots/alerte-piece-jointe.png) |

## Fonctionnalites / Features

- Detection bilingue (francais & anglais) des mots-cles d'attachement / Bilingual keyword detection (French & English)
- Mots-cles personnalisables depuis l'app / Customizable keywords
- Export/Import de votre configuration de mots-cles / Export/Import your keyword config
- Ignore les messages cites dans les fils de reponse / Ignores quoted text in replies (no false positives)
- Mises a jour automatiques via Sparkle / Auto-updates via Sparkle
- Compatible macOS Sequoia (15) et Sonoma (14) / Works with macOS Sequoia & Sonoma
- 100% natif Swift/SwiftUI — aucune dependance externe sauf Sparkle / Fully native, no telemetry

## Installation

1. Telecharger la derniere version depuis les [Releases](https://github.com/Lenouw/ZapClipper/releases)
2. Dezipper et copier `ZapClipper.app` dans `/Applications`
3. Lancer l'app une fois
4. Ouvrir **Mail > Reglages > Extensions** et cocher **ZapClipperExtension**
5. C'est tout !

## Build from source

```bash
# Prerequis : Xcode 16+, XcodeGen
xcodegen generate
open ZapClipper.xcodeproj
# Build & Run (scheme ZapClipper)
```

## Keywords / Mots-cles de recherche

`oubli piece jointe mail` · `forgot attachment mail mac` · `attachment reminder macos` · `mail extension macos` · `apple mail plugin` · `piece jointe oubliee` · `ci-joint sans piece jointe` · `mail attachment checker` · `MailKit extension` · `rappel piece jointe`

## Licence

MIT
