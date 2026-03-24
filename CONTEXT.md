# ZapClipper - Contexte projet

## Etat actuel (v1.2.2, build 5)

L'app est fonctionnelle et distribuee. Extension Mail macOS qui detecte les oublis de pieces jointes avant l'envoi.

- **Repo** : https://github.com/Lenouw/ZapClipper (public, propre)
- **Release actuelle** : v1.2.2 sur GitHub avec zip signe (EdDSA)
- **Sparkle** : feed appcast.xml accessible, mises a jour automatiques fonctionnelles (teste de bout en bout)
- **README** : video YouTube v2 explicative + 3 screenshots (accueil, mots-cles, alerte)
- **Logo** : nouveau logo ZapClipper (trombone + eclair bleu), remplace l'ancien "Anti Oups"
- **Sandbox** : desactive sur l'app hote (requis pour que Sparkle puisse installer les mises a jour)
- **Licence** : MIT
- **Extension Mail** : verifiee fonctionnelle apres desactivation du sandbox (v1.2.2 active dans Mail)

## Versioning

- Format : `MAJOR.MINOR.PATCH` (ex: 1.2.2)
- Chaque nouvelle fonctionnalite = +0.0.1 (ex: 1.2.1 -> 1.2.2)
- Grosse modification = +0.1.0 (ex: 1.2.x -> 1.3)
- Le build number est incremente a chaque release (actuellement: 5)

## Releases publiees

| Version | Build | Date       | Contenu |
|---------|-------|------------|---------|
| v1.1    | 2     | 23/03/2026 | Mots-cles personnalisables, filtrage citations, Sparkle, preferences |
| v1.2    | 3     | 24/03/2026 | Nettoyage donnees perso, bundle IDs changes, repo public |
| v1.2.1  | 4     | 24/03/2026 | Export/Import mots-cles, sandbox desactive |
| v1.2.2  | 5     | 24/03/2026 | Nouveau logo ZapClipper |

## Ce qui a ete fait

### Session 1 (23 mars 2026)
- Creation de l'app et de l'extension Mail depuis zero
- Detection mots-cles FR/EN, filtrage citations, mots-cles editables
- Integration Sparkle pour mises a jour automatiques
- Onglets Accueil, Mots-cles, Preferences

### Session 2 (24 mars 2026, matin)
- Nettoyage donnees personnelles (historique git, bundle IDs)
- Repo passe en public
- Fix toggle Sparkle (checkbox non reactive)
- README avec video YouTube + screenshots
- Release v1.2

### Session 3 (24 mars 2026, apres-midi)
- Video YouTube mise a jour vers v2
- Export/Import des mots-cles (KeywordStore + boutons UI)
- Decouverte que le sandbox bloquait l'installeur Sparkle -> desactive
- Nouveau logo ZapClipper (trombone + eclair bleu, remplace "Anti Oups")
- Test complet du flux Sparkle : v1.2.1 -> v1.2.2 installe avec succes
- Releases v1.2.1 et v1.2.2 publiees sur GitHub
- Appcast.xml mis a jour avec toutes les versions
- Suppression ancien DerivedData qui causait une extension fantome dans Mail
- SEO : 15 topics GitHub, description bilingue FR/EN, README enrichi avec mots-cles de recherche

### Session 4 (24 mars 2026, soir)
- Deplacement des fichiers temporaires (captures, video, logos) dans `Files Flo/` (local uniquement)
- Mise a jour `.gitignore` : ajout `Files Flo/` et `*.mp4`
- Ajout licence MIT (`LICENSE`)
- Suppression du tracking git des fichiers temporaires (plus sur GitHub)
- Verification extension Mail : v1.2.2 active et fonctionnelle dans Mail apres desactivation sandbox
- Verification coherence repo GitHub : 4 releases OK, 15 topics, description bilingue

## Structure du repo (apres nettoyage)

```
ZapClipper/
  .gitignore
  LICENSE
  README.md
  CONTEXT.md
  appcast.xml
  project.yml
  exportOptions.plist
  Shared/KeywordStore.swift
  ZapClipper/              (app hote SwiftUI)
  ZapClipperExtension/     (extension Mail)
  ZapClipper.xcodeproj/
  screenshots/             (3 screenshots pour le README)
  Files Flo/               (local uniquement, ignore par git)
```

## Processus de release (a suivre pour chaque mise a jour)

1. Modifier le code
2. Bumper MARKETING_VERSION et CURRENT_PROJECT_VERSION dans `project.yml` (les DEUX targets)
3. `xcodegen generate`
4. `xcodebuild archive` (Release)
5. Copier .app depuis l'archive, zipper avec `ditto`
6. Signer avec `generate_appcast` (dans DerivedData/SourcePackages/artifacts/sparkle/Sparkle/bin/)
7. Mettre a jour `appcast.xml` avec la nouvelle entree (signature, taille, URL)
8. Creer GitHub Release avec le zip
9. Commiter + pousser (appcast.xml doit etre sur main pour que Sparkle le lise)
10. **Installer dans /Applications** pour verifier que tout fonctionne

## Points techniques critiques (pieges resolus)

1. **Point d'extension** : `com.apple.email.extension` (PAS `com.apple.mail.extension`)
2. **Format NSExtension** classique avec `MEExtensionCapabilities` (PAS ExtensionKit)
3. **Extension dans `PlugIns/`** (pas `Extensions/`)
4. **Sandbox desactive** sur l'app hote — sinon Sparkle ne peut pas installer les mises a jour (pas de certificat Developer ID)
5. **Bundle IDs** : `com.zapclipper.app` et `com.zapclipper.app.ZapClipperExtension`
6. **App Group** : `TQVHUV8MZY.com.zapclipper.app`
7. **Filtrage citations** : coupe au premier `<blockquote>` (HTML) ou "Le ... a ecrit :" (texte brut)
8. **Appcast URL** : `https://raw.githubusercontent.com/Lenouw/ZapClipper/main/appcast.xml`
9. **Compiler != Installer** : apres un build, toujours copier dans /Applications avant de dire "c'est fait"

## SEO et referencement

- **GitHub Topics** (15) : macos, apple-mail, mail-extension, mailkit, attachment-reminder, swift, swiftui, sparkle, macos-app, productivity, email, forgotten-attachment, piece-jointe, oubli-piece-jointe, mail-plugin
- **Description repo** : bilingue FR/EN
- **README** : titre SEO, description EN, features bilingues, section mots-cles de recherche

## A faire ensuite

- Eventuellement : republier la v1.2 sans sandbox pour les utilisateurs qui l'auraient deja installee
- Envisager la signature Developer ID pour pouvoir reactiver le sandbox
- Ajouter des tests unitaires pour KeywordDetector
- Localisation complete (actuellement mots-cles FR/EN, mais UI en anglais)
- Page web / landing page pour le projet
