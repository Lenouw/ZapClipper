# ZapClipper - Contexte projet

## Etat actuel (v1.2, build 3)

L'app est fonctionnelle et distribuee. Extension Mail macOS qui detecte les oublis de pieces jointes avant l'envoi.

- **Repo** : https://github.com/Lenouw/ZapClipper (public)
- **Release** : v1.2 sur GitHub avec zip signe (EdDSA)
- **Sparkle** : feed appcast.xml accessible publiquement, signature en place
- **README** : video YouTube explicative + 3 screenshots (accueil, mots-cles, alerte)

## Ce qui a ete fait (session du 24 mars 2026)

### Nettoyage des donnees personnelles
- Repo passe de prive a public
- Historique git reecrit : "Florian BONIN" remplace par "Linydv" sur tous les commits
- Bundle IDs changes : `com.florianbonin.*` → `com.zapclipper.*`
- App Group mis a jour : `TQVHUV8MZY.com.zapclipper.app`
- Entitlements (app + extension) mis a jour en coherence

### Corrections et ameliorations
- Release GitHub renommee "Anti-Oups v1.1" → "ZapClipper v1.1"
- Fix du toggle "Verifier automatiquement les mises a jour" (checkbox qui ne repondait pas au clic) — utilisation d'un @State local synchronise avec Sparkle
- Version bumpee a 1.2 (build 3)
- Archive buildee, exportee, signee (EdDSA), installee dans /Applications
- Release GitHub v1.2 creee avec le zip

### README et vitrine
- README cree avec description, instructions d'installation, build from source
- Video YouTube explicative integree (thumbnail cliquable)
- 3 screenshots ajoutes dans `screenshots/` : accueil, mots-cles, alerte-piece-jointe
- Video mp4 uploadee sur la release v1.2

## A faire ensuite

- Tester la mise a jour Sparkle de bout en bout (v1.2 installee → verifier que "Verifier maintenant" dit "a jour")
- Verifier que l'extension Mail fonctionne bien avec les nouveaux bundle IDs (Mail > Reglages > Extensions > cocher ZapClipperExtension)
- Supprimer les fichiers temporaires (captures d'ecran originales a la racine, dossier build/)
- Ajouter un fichier LICENSE (MIT) si on veut formaliser la licence mentionnee dans le README
- Eventuellement : ajouter le .mp4 et les captures originales au .gitignore
