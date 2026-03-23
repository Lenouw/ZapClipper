import SwiftUI
import Sparkle

struct ContentView: View {

    let updater: SPUUpdater

    @State private var keywords: KeywordData = KeywordStore.shared.load()
    @State private var newFrenchWord = ""
    @State private var newEnglishWord = ""
    @State private var showingResetAlert = false

    var body: some View {
        TabView {
            infoTab
                .tabItem { Label("Accueil", systemImage: "house") }

            keywordsTab
                .tabItem { Label("Mots-cles", systemImage: "text.magnifyingglass") }

            preferencesTab
                .tabItem { Label("Preferences", systemImage: "gearshape.2") }
        }
        .frame(width: 560, height: 700)
    }

    // MARK: - Info Tab

    private var infoTab: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Image(systemName: "paperclip.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.blue)

                Text("Anti-Oups")
                    .font(.largeTitle.bold())

                Text("Ne partez plus jamais sans votre piece jointe")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            Divider()

            VStack(alignment: .leading, spacing: 16) {
                Label("Comment activer", systemImage: "gearshape")
                    .font(.title3.bold())

                VStack(alignment: .leading, spacing: 10) {
                    instructionRow(number: 1, text: "Ouvrez l'app Mail")
                    instructionRow(number: 2, text: "Allez dans Mail > Reglages > Extensions")
                    instructionRow(number: 3, text: "Cochez \"AntiOupsExtension\"")
                    instructionRow(number: 4, text: "C'est tout ! L'extension surveille vos mails automatiquement")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Divider()

            VStack(alignment: .leading, spacing: 16) {
                Label("Comment ca marche", systemImage: "questionmark.circle")
                    .font(.title3.bold())

                Text("Quand vous cliquez \"Envoyer\" dans Mail, Anti-Oups verifie si votre message mentionne une piece jointe (en francais ou en anglais) sans qu'un fichier soit effectivement attache. Si c'est le cas, un message vous previent.")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            Text("Créée par Florian BONIN avec l'aide de Claude")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(32)
    }

    // MARK: - Keywords Tab

    private var keywordsTab: some View {
        VStack(spacing: 16) {
            Text("Mots-cles surveilles")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Ajoutez ou supprimez des mots-cles. L'extension detectera ces mots dans vos mails et vous alertera si aucune piece jointe n'est attachee.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(alignment: .top, spacing: 16) {
                // French keywords
                VStack(alignment: .leading, spacing: 8) {
                    Text("Francais (\(keywords.french.count))")
                        .font(.headline)

                    HStack {
                        TextField("Nouveau mot-cle...", text: $newFrenchWord)
                            .textFieldStyle(.roundedBorder)
                            .onSubmit { addFrenchWord() }

                        Button(action: addFrenchWord) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(.blue)
                        }
                        .buttonStyle(.plain)
                        .disabled(newFrenchWord.trimmingCharacters(in: .whitespaces).isEmpty)
                    }

                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 4) {
                            ForEach(keywords.french, id: \.self) { word in
                                HStack {
                                    Text(word)
                                        .font(.system(.body, design: .monospaced))

                                    Spacer()

                                    Button(action: { removeFrench(word) }) {
                                        Image(systemName: "xmark.circle")
                                            .foregroundStyle(.red.opacity(0.7))
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                            }
                        }
                    }
                }

                Divider()

                // English keywords
                VStack(alignment: .leading, spacing: 8) {
                    Text("English (\(keywords.english.count))")
                        .font(.headline)

                    HStack {
                        TextField("New keyword...", text: $newEnglishWord)
                            .textFieldStyle(.roundedBorder)
                            .onSubmit { addEnglishWord() }

                        Button(action: addEnglishWord) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(.blue)
                        }
                        .buttonStyle(.plain)
                        .disabled(newEnglishWord.trimmingCharacters(in: .whitespaces).isEmpty)
                    }

                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 4) {
                            ForEach(keywords.english, id: \.self) { word in
                                HStack {
                                    Text(word)
                                        .font(.system(.body, design: .monospaced))

                                    Spacer()

                                    Button(action: { removeEnglish(word) }) {
                                        Image(systemName: "xmark.circle")
                                            .foregroundStyle(.red.opacity(0.7))
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                            }
                        }
                    }
                }
            }

            HStack {
                Button("Reinitialiser") {
                    showingResetAlert = true
                }
                .alert("Reinitialiser les mots-cles ?", isPresented: $showingResetAlert) {
                    Button("Annuler", role: .cancel) { }
                    Button("Reinitialiser", role: .destructive) {
                        KeywordStore.shared.resetToDefaults()
                        keywords = KeywordStore.shared.load()
                    }
                } message: {
                    Text("Les mots-cles seront remplaces par la liste par defaut.")
                }

                Spacer()

                Text("\(keywords.french.count + keywords.english.count) mots-cles au total")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(24)
    }

    // MARK: - Preferences Tab

    private var preferencesTab: some View {
        VStack(spacing: 24) {
            Text("Preferences")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)

            GroupBox {
                VStack(alignment: .leading, spacing: 16) {
                    Label("Mises a jour", systemImage: "arrow.triangle.2.circlepath")
                        .font(.headline)

                    Toggle("Verifier automatiquement les mises a jour", isOn: Binding(
                        get: { updater.automaticallyChecksForUpdates },
                        set: { updater.automaticallyChecksForUpdates = $0 }
                    ))

                    HStack {
                        Button("Verifier maintenant") {
                            updater.checkForUpdates()
                        }

                        Spacer()

                        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
                           let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
                            Text("Version \(version) (\(build))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(8)
            }

            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    Label("A propos", systemImage: "info.circle")
                        .font(.headline)

                    Text("Anti-Oups detecte les oublis de pieces jointes dans Apple Mail. Quand vous mentionnez une piece jointe sans en attacher une, l'extension vous previent avant l'envoi.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .padding(8)
            }

            Spacer()

            Text("Creee par Florian BONIN avec l'aide de Claude")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(32)
    }

    // MARK: - Actions

    private func addFrenchWord() {
        let word = newFrenchWord.trimmingCharacters(in: .whitespaces)
        guard !word.isEmpty, !keywords.french.contains(word) else { return }
        keywords.french.append(word)
        KeywordStore.shared.save(keywords)
        newFrenchWord = ""
    }

    private func addEnglishWord() {
        let word = newEnglishWord.trimmingCharacters(in: .whitespaces)
        guard !word.isEmpty, !keywords.english.contains(word) else { return }
        keywords.english.append(word)
        KeywordStore.shared.save(keywords)
        newEnglishWord = ""
    }

    private func removeFrench(_ word: String) {
        keywords.french.removeAll { $0 == word }
        KeywordStore.shared.save(keywords)
    }

    private func removeEnglish(_ word: String) {
        keywords.english.removeAll { $0 == word }
        KeywordStore.shared.save(keywords)
    }

    private func instructionRow(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.caption.bold())
                .foregroundStyle(.white)
                .frame(width: 22, height: 22)
                .background(Circle().fill(.blue))

            Text(text)
                .font(.body)
        }
    }
}

// Preview disabled - requires SPUUpdater instance
