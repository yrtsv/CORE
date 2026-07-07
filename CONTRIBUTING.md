# Contributing to CORE

Thank you for your interest in contributing to the Corporate Entity Resolution Engine (CORE).

CORE is an academic research software project developed to provide a transparent, reproducible, and modular framework for company name matching and corporate entity resolution. Contributions are welcome from researchers, students, developers, and domain experts.

---

## Development Philosophy

When contributing to CORE, please follow these principles:

- Keep the software modular.
- Prioritize reproducibility over convenience.
- Avoid unnecessary dependencies.
- Prefer readable code over clever code.
- Document any change that affects the matching logic.
- Preserve backward compatibility whenever possible.
- Avoid architectural redesign unless addressing a demonstrated limitation or bug.

---

## Coding Standards

Please ensure that:

- Functions perform a single well-defined task.
- Function names remain descriptive and consistent.
- Existing module structure is preserved whenever possible.
- New features should be implemented in new modules whenever practical, rather than by rewriting stable components.
- Comments explain *why* a decision was made, not only *what* the code does.

---

## Testing

Every functional change should be validated before submission.

At minimum, contributors should run:

```r
run_core_integration_test()
run_core_testthat()
run_core_code_audit()
```

New functionality should not break existing tests.

Pull requests that fail the integration tests or the project code audit will not be accepted.

---

## Pull Requests

When submitting a pull request:

- Clearly describe the purpose of the change.
- Explain why the modification is needed.
- Include tests whenever appropriate.
- Update documentation if user-facing behaviour changes.

Changes that affect the software architecture should be proposed and discussed before implementation.

---

## Reporting Issues

If you discover a bug, please include:

- R version
- Operating system
- CORE version
- Reproducible example
- Complete error message (if available)

---

## Feature Requests

Suggestions for new functionality are welcome.

When proposing a feature, please explain:

- the research problem it solves,
- why it belongs in CORE,
- whether it affects existing workflows,
- and how it improves reproducibility, transparency, or usability.

---

## Scope of Contributions

CORE welcomes contributions including, but not limited to:

- Bug fixes
- Documentation improvements
- Performance optimizations
- Dictionary enhancements
- Additional unit tests
- Example datasets
- User interface improvements
- Shiny application features

Major changes to the matching methodology or software architecture should be discussed with the project maintainer before implementation.

---

## Code of Conduct

Please be respectful and constructive when interacting with other contributors.

The goal of CORE is to support open, transparent, reproducible, and collaborative research.