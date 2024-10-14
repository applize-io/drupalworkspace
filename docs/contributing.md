# Contributing to the drupalWorkSpace Project

Thank you for your interest in contributing to **drupalWorkSpace**! This guide outlines how to participate in the project and the best practices for ensuring high-quality contributions.

## Table of Contents

1. [How to Get Started](#how-to-get-started)
2. [How to Contribute](#how-to-contribute)
3. [Coding Standards](#coding-standards)
4. [Pull Request Process and Testing](#pull-request-process-and-testing)
5. [Project Branches](#project-branches)
6. [Conventional Commits](#conventional-commits)

---

## How to Get Started

1. **Fork the repository**: Start by forking this repository into your GitHub account and then clone it locally:

   ```bash
   git clone https://github.com/your-username/drupalworkspace.git
   cd drupalworkspace
   ```

2. **Create a new branch**: For your contribution, create a new branch:
   ```bash
   git checkout -b feature/contribution
   ```

3. **Set up the environment**: Ensure that Docker and Docker Compose are installed on your machine. You can then start the environment:
   ```bash
   make up
   ```

4. **Create the Drupal folder**:
   ```bash
   make project
   ```

5. **Make your changes**: Whether you're adding a feature, fixing a bug, or improving documentation, make changes within your feature branch.

---

## How to Contribute

### Proposing a New Feature

- **Open an issue**: Describe the feature you want to add by creating an issue. Be as detailed as possible.
- **Wait for approval**: A discussion will take place in the issue to validate the relevance of the feature before you start developing it.
- **Implement the feature**: Once approved, you can start implementing it.

### Reporting a Problem

- **Check existing issues**: Before creating a new issue, check if the problem has already been reported.
- **Create a new issue**: If the problem hasn’t been reported, create an issue with a clear description of:
  - What you expected.
  - What actually happened.
  - Steps to reproduce the issue.
  - Screenshots or Docker logs (if applicable).

---

## Coding Standards

### Contribution Guidelines

To keep the project organized and consistent, follow these rules:

1. **Respect the project structure**: Do not move or rename files unless necessary.
2. **Follow the coding style**: Stick to the coding conventions already in place. Maintain the same logic and structure if you're modifying code.
3. **Document changes**: If you add a new feature or modify existing behavior, update the relevant documentation (e.g., `README.md`).

---

## Pull Request Process and Testing

1. **Create a Pull Request (PR)**: Once your changes are complete, submit a PR from your fork by clicking the "New Pull Request" button.

2. **Provide a description**: Include a detailed description of the PR and explain why it’s useful.

3. **Ensure tests pass**: Before submitting the PR, make sure your changes pass all automated tests.

4. **Review and feedback**: Your PR will be reviewed, and feedback may be given. Address any comments or make changes as needed.

5. **Merging**: Once approved, your PR will be merged into the main repository.

### Running Tests

The project uses automated testing to ensure stability. Please ensure that all tests pass before submitting a PR. You can run tests locally using the test files provided.

---

## Project Branches

We follow a **Git Flow** approach for branch management:

- **`main`**: This is the stable branch containing production-ready code. No direct commits should be made to `main`.
  
- **`develop`**: The main development branch. All new features and bug fixes should be based on `develop`. After testing and validation, they will be merged into `main` when preparing a new release.
  
- **`feature/[feature-name]`**: Each new feature or improvement should be developed in a dedicated branch created from `develop`. The branch name should be descriptive (e.g., `feature/add-ssl-support`).

- **`bugfix/[bug-name]`**: If you're working on fixing a bug, create a branch from `develop` with the prefix `bugfix/`.

- **hotfix/[hotfix-name]**: Hotfix branches are created from `main` to quickly address critical bugs in production (e.g., `hotfix/fix-critical-issue`). After resolving the issue, the hotfix must be merged into both `main` and `develop` to ensure continuity.

When your contribution is ready, submit a **Pull Request (PR)** to the `develop` branch. Once tested and approved, it will be merged into `main` during the release process.

---

## Conventional Commits

To ensure clear and consistent commit messages, we follow the **Conventional Commits** specification. Each commit message should have a defined structure based on the type of change being made. Here are the main types and their use:

- **feat (Feature)**: Use when introducing a new feature.
  ```bash
  git commit -m "feat: Add advanced search functionality"
  ```

- **docs (Documentation)**: Use for changes related to documentation.
  ```bash
  git commit -m "docs: Update README with installation instructions"
  ```

- **style (Style)**: Use for changes that don’t affect the code’s logic, like formatting, whitespace, or indentation adjustments.
  ```bash
  git commit -m "style: Fix spacing in function definitions"
  ```

- **perf (Performance)**: Use for changes that improve code performance.
  ```bash
  git commit -m "perf: Optimize query handling"
  ```

- **test (Tests)**: Use for adding or modifying tests.
  ```bash
  git commit -m "test: Add tests for form validation"
  ```

---

Thank you again for your participation and contribution to the **drupalWorkSpace** project. Together, we can make this tool even more powerful and accessible to the community.
