# 📦 localize

A simple, powerful, and lazy-loading i18n package for Flutter apps, inspired by Angular's internationalization.  
Supports **dynamic language switching**, **nested keys**, **pluralization**, and **parameter interpolation**.

---

## ✨ Features

✅ Nested JSON keys  
✅ Pluralization support  
✅ Interpolation (e.g., `{name}`)  
✅ Lazy loading from asset files  
✅ Caching to avoid redundant loads  
✅ Persistence of the selected locale  
✅ Per-call control over persistence (`changeLocaleWithPreference`)  
✅ Simple `tr()` helper function

---

## 🚀 Getting Started

### 1️⃣ Install

Add to your `pubspec.yaml`:

```yaml
dependencies:
  localize:
    git:
      url: https://github.com/your-repo/localize.git
```

Or once published to pub.dev:
```yaml
dependencies:
  localize: ^1.0.0
```

### 2️⃣ Create Translation Files

Inside your assets/i18n folder, create JSON files:

```en.json```:
```json
{
  "auth": {
    "login": "Login"
  },
  "greeting": "Hello {name}!",
  "items": {
    "zero": "No items",
    "one": "One item",
    "other": "{count} items"
  }
}
```

```fr.json```:
```json
{
   "auth": {
    "login": "Connexion"
  },
  "greeting": "Bonjour {name}!",
  "items": {
    "zero": "Aucun élément",
    "one": "Un élément",
    "other": "{count} éléments"
  }
}
```

### 3️⃣ Configure pubspec.yaml assets

```yaml
flutter:
  assets:
    - assets/i18n/
```

---

## 🛠️ Usage Example

### Initialize

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalizeConfig.init(
    const Locale('en'),
    persistLanguage: true,
    fileLoader: LocalizeFileLoader('assets/i18n'),
  );

  runApp(MyApp());
}
```

### Provide Delegates and Reactive Locale

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: LocalizeConfig.currentLocale,
      builder: (context, locale, _) {
        return ValueListenableBuilder(
          valueListenable: LocalizeConfig.translationsNotifier,
          builder: (context, _, __) {
            return MaterialApp(
              locale: locale,
              supportedLocales: [
                Locale('en'),
                Locale('fr'),
              ],
              localizationsDelegates: [
                LocalizeConfig.delegate(),
              ],
              home: HomePage(),
            );
          },
        );
      },
    );
  }
}
```

### Translating Text

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(tr(context, 'auth.login')),
        Text(tr(context, 'greeting', params: {'name': 'Alice'})),
        Text(tr(context, 'items', plural: 3)),
        ElevatedButton(
          onPressed: () {
            LocalizeConfig.changeLocale(const Locale('fr'));
          },
          child: Text('Switch to French'),
        ),
      ],
    );
  }
}
```

---

## 🔄 Per-Call Persistence Control

Sometimes you may want user A to persist language selection but user B to not.

Use ```changeLocaleWithPreference```:

```dart
// Switch to French and persist this choice
await LocalizeConfig.changeLocaleWithPreference(
  const Locale('fr'),
  persist: true,
);

// Switch to English only for this session
await LocalizeConfig.changeLocaleWithPreference(
  const Locale('en'),
  persist: false,
);
```

---

## 🧩 API Reference

```LocalizeConfig.init```

Initializes localization:

```dart
await LocalizeConfig.init(
  Locale('en'),
  persistLanguage: true,
  fileLoader: LocalizeFileLoader('assets/i18n'),
);
```
- persistLanguage: true — automatically remembers the user’s last selected language.

- If persistLanguage is false, it always starts with your defaultLocale.

```LocalizeConfig.changeLocale```

Switches language (respecting ```persistLanguage```):

```dart
await LocalizeConfig.changeLocale(Locale('fr'));
```

```LocalizeConfig.changeLocaleWithPreference```

Switches language and specifies whether to persist this change:

```dart
await LocalizeConfig.changeLocaleWithPreference(
  Locale('fr'),
  persist: true,
);
```

```tr()```

Helper for translating:

```dart
tr(context, 'auth.login')
tr(context, 'greeting', params: {'name': 'Alice'})
tr(context, 'items', plural: 2)
```
---

## 🆚 Comparison With Other Packages

Here’s a quick look at how `localize` compares to popular Flutter i18n solutions:

| Feature                           | **localize**        | [intl](https://pub.dev/packages/intl)        | [easy_localization](https://pub.dev/packages/easy_localization) | [get](https://pub.dev/packages/get) |
|-----------------------------------|---------------------|---------------------------------------------|------------------------------------------------|-------------------------------------|
| **Format**                        | JSON nested keys    | ARB files                                  | JSON / CSV                                    | JSON                                |
| **Code generation required**      | ❌ None             | ✅ Yes                                      | ❌ No                                         | ❌ No                               |
| **Lazy loading**                  | ✅ Yes              | ❌ No                                       | ⚠️ Partial                                   | ❌ No                               |
| **Caching**                       | ✅ In-memory        | ❌ No                                       | ⚠️ Limited                                   | ⚠️ Limited                          |
| **Pluralization**                 | ✅ Supported        | ✅ Supported                                | ✅ Supported                                  | ⚠️ Limited                          |
| **Interpolation**                 | ✅ `{name}` syntax  | ✅ `{name}` syntax                          | ✅ `{name}` syntax                            | ✅ `{name}` syntax                  |
| **Dynamic locale switching**      | ✅ Yes              | ⚠️ Manual rebuild                          | ✅ Yes                                       | ✅ Yes                              |
| **Per-call persistence control**  | ✅ Yes              | ❌ No                                       | ❌ No                                        | ❌ No                               |
| **Dependencies**                  | Minimal             | Medium                                      | Medium                                       | Medium                              |
| **Learning curve**                | Super low          | Medium                                      | Medium                                       | Low                                 |

---

## 🎯 When Should You Use `localize`?

**Choose `localize` if:**
- You want **Angular-style simplicity** without build steps.
- You need **lazy loading** and **caching** to save memory.
- You prefer **full control over persistence** for each user.
- You like small, clean, auditable codebases.
- You want to ship multilingual apps fast with minimal boilerplate.

---

## ⚠️ Known Limitations

- No right-to-left (RTL) helpers (yet).
- No ICU plural rules (advanced pluralization logic).
- Currently loads from asset bundles (not remote URLs).

If you’d like to contribute or request features, please open an issue or pull request!

---

## 🙏 Contributing

Contributions are welcome!  
Feel free to:
- Submit pull requests
- Report bugs
- Suggest improvements

---

## 💡 Example Apps

We recommend you create a small demo app to see `localize` in action before integrating into production.

---

## 📫 Support

Questions or need help?  
Open an issue or contact the maintainer.

---

## 📝 License

MIT License

---