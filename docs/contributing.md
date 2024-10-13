# Contributing to the drupalWorkSpace Project

Thank you for your interest in contributing to drupalWorkSpace! This guide explains how you can participate in the project and the best practices to follow.

## Table of Contents

- How to Get Started
- How to Contribute
- Coding Standards
- Pull Request Process and Testing
- Project Branches

## How to Get Started

1. **Clone the project**: Start by forking this repository to your GitHub account, then clone it locally:

   ```bash
   git clone https://github.com/your-username/drupalworkspace.git
   cd drupalworkspace

2. Create a new branch for your contribution:
   ```bash
   git checkout -b feature/contribution

3. Install the necessary dependencies: Make sure Docker and Docker Compose are installed on your machine. You can then start the environment:
   ```bash
   make up 
4. Then create the Drupal folder:
   ```bash
   make project 
Make your changes: Whether it's adding a feature, fixing a bug, or improving the documentation.

### How to Contribute
If you want to propose a new feature, please follow these steps:
- Open an issue: Create an issue describing the feature you want to add. Be as detailed as possible.
- Wait for approval: A discussion will take place in the issue to validate the relevance of the feature before you start developing it.
- Implement the feature once approval is received.

Reporting a Problem
If you find a bug or an issue in the project, please follow these steps:
- Check existing issues to see if the problem has already been reported.
- Create a new issue with a clear description of the problem:
    What you expected
    What actually happened
    Steps to reproduce the issue
    Screenshot or Docker logs if necessary
#### Contribution Rules
To keep the project organized and clean, we ask you to follow these rules:
Coding Standards
- Respect the project structure: Do not move or rename files without a valid reason.
- Respect the coding style: Follow the coding conventions already in place in the project. If you modify code, try to maintain the same logic and structure.
- Document changes: If you introduce a new feature or modify a behavior, update the documentation accordingly (e.g., README.md).
##### Pull Request Process and Testing
- Create a pull request (PR) once you have completed your changes: Go to the page of your fork, click on the "New Pull Request" button.
- Description: Provide a detailed description of what the PR does and why it's useful.
- Testing: Make sure your changes pass automated tests.
- Review: Your PR will be reviewed, and comments may be made. Be sure to respond to these comments or make changes as necessary.
- Merge: Once approved, your PR will be merged into the main repository.
- Running Tests
We use a testing system to ensure the stability of the project. Make sure all tests pass before submitting a pull request. To run the tests, use the test files.

###### Project Branches
We follow a simplified Git Flow approach for branch management.

main: The main development branch. All new features and bug fixes should be based on this branch. Once tested and validated, they will be merged.

feature/[feature-name]: Each new feature or improvement should be developed in a dedicated branch created from main. The branch name should be descriptive (e.g., feature/add-ssl-support).

bugfix/[bug-name]: If you are working on fixing a bug, create a branch from main with the prefix bugfix/.

When your contribution is ready, submit a Pull Request (PR) to the main branch.


Thank you again for your involvement and contribution to the Docker drupalWorkSpace. Together, we can make this project an even more powerful and accessible tool for the community.

###### Conventional Commits
To ensure clear and uniform commit messages, we follow the Conventional Commits convention.Each commit message should follow a clear structure based on the type of change made. Here are the main types and their uses:
- feat (Feature): Used to introduce a new feature.
  ```bash
  git commit -m "feat: Add advanced search functionality"
- docs (Documentation): Used for changes related to documentation, such as adding or modifying comments in the code.
  ```bash
  git commit -m "docs: Update documentation"

- style (Style): Used for changes that don't affect the logic of the code, like formatting, spaces, or indentation adjustments.
  ```bash
  git commit -m "style: Reorganize spaces and indentation"

- perf (Performance): Used for changes that improve code performance.
  ```bash
  git commit -m "perf: Add cache mecanism"

- test (Tests): Used for adding or modifying tests.
  ```bash
  git commit -m "test: Add form validation tests"
