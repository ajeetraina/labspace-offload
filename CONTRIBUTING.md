# Contributing to Docker Offload Labspace

Thank you for your interest in contributing to the Docker Offload Labspace! This document provides guidelines for contributing improvements, fixes, and new content.

## How to Contribute

### Reporting Issues

If you find errors, broken links, or have suggestions for improvement:

1. Check existing issues to avoid duplicates
2. Open a new issue with:
   - Clear description of the problem
   - Steps to reproduce (if applicable)
   - Suggested solution (optional)
   - Screenshots or code snippets (if helpful)

### Suggesting Enhancements

We welcome suggestions for:
- New examples or tutorials
- Additional use cases
- Improved explanations
- Better code samples
- Updated diagrams or visualizations

### Contributing Content

#### Small Changes

For typos, broken links, or minor corrections:
1. Fork the repository
2. Make your changes
3. Submit a pull request

#### Large Changes

For substantial additions or modifications:
1. Open an issue first to discuss your proposal
2. Wait for feedback from maintainers
3. Fork and create a feature branch
4. Make your changes following our guidelines
5. Submit a pull request

## Content Guidelines

### Writing Style

- **Clear and Concise**: Use simple language
- **Action-Oriented**: Focus on what users should do
- **Examples-First**: Show code before explaining
- **Progressive Complexity**: Start simple, build up
- **Inclusive Language**: Write for all skill levels

### Code Examples

**Good Example**:
```bash
# Start Docker Offload with GPU support
docker offload start --gpu

# Verify GPU is available
docker run --rm --gpus all nvidia/cuda:12.4.0-runtime-ubuntu22.04 nvidia-smi
```

**What Makes It Good**:
- ✅ Includes comments
- ✅ Shows complete commands
- ✅ Demonstrates verification step
- ✅ Uses real, working code

### Markdown Formatting

#### Headers
```markdown
# Top Level (H1) - Section Title
## Second Level (H2) - Major Topics
### Third Level (H3) - Subtopics
#### Fourth Level (H4) - Details
```

#### Code Blocks

**Shell Commands**:
```markdown
```bash
docker offload start
```
```

**Python Code**:
```markdown
```python
import torch
print(torch.cuda.is_available())
```
```

**YAML Configuration**:
```markdown
```yaml
services:
  app:
    image: myapp:latest
```
```

#### Lists

**Unordered Lists**:
```markdown
- First item
- Second item
  - Nested item
  - Another nested item
- Third item
```

**Ordered Lists**:
```markdown
1. First step
2. Second step
3. Third step
```

#### Links

**External Links**:
```markdown
[Docker Documentation](https://docs.docker.com)
```

**Internal Links**:
```markdown
See [Getting Started](.labspace/02-getting-started.md) for details.
```

#### Emphasis

```markdown
**Bold text** for important terms
*Italic text* for emphasis
`inline code` for commands or variables
```

#### Emojis for Visual Cues

```markdown
✅ Success or completed items
⚠️  Warnings
ℹ️  Information
🚀 Getting started or launch
💡 Tips or ideas
🐛 Bugs or issues
✨ New features
🔒 Security
📚 Documentation
```

### Technical Accuracy

- **Test All Code**: Verify examples work before submitting
- **Use Current Versions**: Reference latest stable versions
- **Cite Sources**: Link to official documentation
- **Accurate Commands**: Double-check syntax and flags
- **Platform Compatibility**: Note OS-specific differences

### Structure Requirements

Each tutorial section should include:

1. **Introduction**
   - What you'll learn
   - Prerequisites
   - Estimated time

2. **Prerequisites**
   - Required software versions
   - Necessary credentials
   - Background knowledge

3. **Step-by-Step Instructions**
   - Numbered steps
   - Code examples
   - Expected output

4. **Verification**
   - How to confirm success
   - Common issues
   - Troubleshooting

5. **Summary**
   - Key takeaways
   - Next steps
   - Related resources

## Example Contributions

### Adding a New Example

1. Create file in `examples/` directory
2. Follow naming convention: `descriptive-name.yaml` or `descriptive-name.sh`
3. Include comprehensive comments
4. Add to `examples/README.md`
5. Test thoroughly

**Template for Script**:
```bash
#!/bin/bash
# Description: What this script does
# Requirements: List any prerequisites
# Usage: ./script-name.sh

set -e  # Exit on error

echo "Starting..."

# Main logic here

echo "Complete!"
```

**Template for Compose File**:
```yaml
# Description: What this compose file demonstrates
# Usage: docker compose -f filename.yaml up

services:
  app:
    image: myapp:latest
    ports:
      - "8080:8080"
    # Add comments explaining each section
```

### Updating Documentation

1. Identify the section to update
2. Make changes following style guidelines
3. Update any related sections
4. Test all commands and code
5. Submit pull request with clear description

### Improving Examples

1. Test existing examples
2. Identify improvements:
   - Better error handling
   - More efficient code
   - Clearer comments
   - Additional features
3. Make changes
4. Document improvements in PR

## Pull Request Process

### Before Submitting

- [ ] Code examples tested and working
- [ ] Markdown properly formatted
- [ ] Links verified
- [ ] Spelling and grammar checked
- [ ] Changes follow style guidelines
- [ ] Related documentation updated

### PR Description

Include in your PR:

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature/example
- [ ] Documentation update
- [ ] Code improvement

## Testing
How you tested the changes

## Related Issues
Fixes #123 (if applicable)

## Screenshots
(if applicable)
```

### Review Process

1. Maintainer reviews within 1-2 weeks
2. Address any requested changes
3. Maintainer merges when approved
4. Your contribution is live!

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive experience for everyone.

### Expected Behavior

- ✅ Be respectful and inclusive
- ✅ Accept constructive criticism
- ✅ Focus on what's best for the community
- ✅ Show empathy towards others

### Unacceptable Behavior

- ❌ Harassment or discrimination
- ❌ Trolling or insulting comments
- ❌ Personal attacks
- ❌ Publishing others' private information

## Recognition

Contributors will be:
- Listed in project acknowledgments
- Credited in relevant documentation
- Mentioned in release notes (for significant contributions)

## Getting Help

Need assistance?

- **Questions**: Open a GitHub issue
- **Discussion**: Join Collabnix Slack
- **Chat**: Docker Community forums
- **Email**: community@docker.com

## Resources

### Documentation
- [Docker Offload Docs](https://docs.docker.com)
- [Markdown Guide](https://www.markdownguide.org/)
- [GitHub Docs](https://docs.github.com)

### Tools
- [Markdown Linter](https://github.com/DavidAnson/markdownlint)
- [ShellCheck](https://www.shellcheck.net/) for bash scripts
- [YAML Validator](https://www.yamllint.com/)

## License

By contributing, you agree that your contributions will be licensed under the Apache License 2.0.

## Questions?

Don't hesitate to ask! Open an issue or reach out on Slack.

---

**Thank you for contributing to Docker Offload Labspace!** 🚀

Your contributions help the entire Docker community learn and grow.
