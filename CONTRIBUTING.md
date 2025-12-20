# Contributing to CharGen

First off, thank you for considering contributing to CharGen! It's people like you that make CharGen such a great tool.

## Code of Conduct

This project and everyone participating in it is governed by a code of conduct of respect and professionalism. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When creating a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples**
- **Describe the behavior you observed and what you expected**
- **Include your environment details** (OS, version, etc.)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- **Use a clear and descriptive title**
- **Provide a detailed description of the suggested enhancement**
- **Explain why this enhancement would be useful**
- **List any similar features in other tools**

### Pull Requests

1. Fork the repo and create your branch from `main`
2. If you've added code, add tests
3. Ensure the test suite passes
4. Make sure your code follows the existing style
5. Write a clear commit message

## Development Setup

```bash
git clone https://github.com/vct-mrt/CharGen.git
cd CharGen
make
./test.sh
```

## Coding Standards

- Follow the existing code style
- Comment your code where necessary
- Keep functions small and focused
- Use meaningful variable names
- Handle errors appropriately

### C Style Guidelines

- Use 4 spaces for indentation (not tabs)
- Opening braces on the same line for functions
- Use `snake_case` for function names
- Use `UPPER_CASE` for constants
- Always check return values
- Free allocated memory

Example:
```c
int my_function(char *input)
{
    if (input == NULL) {
        return -1;
    }
    
    // Function logic here
    return 0;
}
```

## Testing

Run the test suite before submitting:

```bash
./test.sh
```

Add tests for new features:
1. Add test cases to `test.sh`
2. Ensure all tests pass
3. Test on multiple platforms if possible

## Documentation

- Update README.md if you change functionality
- Update man page (chargen.1) for new options
- Add comments for complex logic
- Update PACKAGING.md for packaging changes

## Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters
- Reference issues and pull requests

Example:
```
Add support for hexadecimal character generation

- Add -x flag for hex output
- Update help message
- Add tests for hex generation

Fixes #42
```

## Release Process

1. Update version in:
   - `include/random_char.h` (VERSION constant)
   - `Makefile`
   - `packaging/debian/changelog`
   - `packaging/chargen.spec`
   - `packaging/PKGBUILD`

2. Update CHANGELOG.md

3. Create and push tag:
   ```bash
   git tag -a v1.0.0 -m "Release v1.0.0"
   git push origin v1.0.0
   ```

4. Build packages:
   ```bash
   cd packaging
   ./build-package.sh all
   ```

5. Create GitHub release with packages

## Questions?

Feel free to open an issue with the label `question`.

## License

By contributing, you agree that your contributions will be licensed under the GPL-3.0 License.
