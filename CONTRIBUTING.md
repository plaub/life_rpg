# Contributing to Life RPG

First off, thanks for taking the time to contribute! ❤️

All types of contributions are welcome, from bug reports to new features.

## How Can I Contribute?

### Reporting Bugs
- Use the **GitHub Issues** tab.
- Describe the bug and provide steps to reproduce it.
- Include screenshots if possible.

### Suggesting Enhancements
- Open a GitHub Issue with the "enhancement" label.
- Describe the feature you'd like to see and why it would be useful.

### Pull Requests
1. Fork the repository.
2. Create a new branch (`git checkout -b feature/awesome-feature`).
3. Make your changes.
4. Run tests (`flutter test`).
5. Commit your changes (`git commit -m 'Add awesome feature'`).
6. Push to your branch (`git push origin feature/awesome-feature`).
7. Open a Pull Request.

## Coding Standards
- Follow the official [Dart Style Guide](https://dart.dev/guides/language/evolutionary-style-guide).
- Use `flutter format .` before committing.
- Ensure all logic is covered by unit tests in the `test/` directory.

## Clean Architecture
This project follows **Clean Architecture**. Please ensure:
- The **Domain** layer remains independent of any external packages.
- All dependencies are injected via **Riverpod**.
- Feature code is contained within its respective `lib/features/` subdirectory.

Thank you for helping make Life RPG better!
