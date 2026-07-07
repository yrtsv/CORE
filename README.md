# Corporate Entity Resolution Engine (CORE)

> **An open-source research software framework for transparent, reviewable, reproducible, and cumulative entity resolution.**

<p align="center">

![Version](https://img.shields.io/badge/version-v1.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![R](https://img.shields.io/badge/language-R-276DC3)
![Status](https://img.shields.io/badge/status-Stable-success)
![Research Software](https://img.shields.io/badge/type-Research%20Software-purple)

</p>

<p align="center">
  <img src="assets/core_hero_figure.svg"
       alt="CORE Framework Overview"
       width="900">
</p>

---

## Overview

The **Corporate Entity Resolution Engine (CORE)** is an open-source research software framework designed to support transparent, reviewable, and reproducible entity resolution in empirical research.

Rather than treating entity resolution as a disposable data-cleaning task, CORE treats it as a scientific process in which computational methods, expert judgement, and validated knowledge work together to produce trustworthy analytical datasets.

Originally developed for corporate entity resolution, the framework has been intentionally designed as a general methodology that can support transparent entity resolution across a broad range of empirical research domains.

---

## Why CORE?

Traditional entity resolution workflows typically conclude once a matched dataset has been produced. Intermediate decisions, reviewer knowledge, and methodological reasoning often disappear with the project, forcing future researchers to reconstruct work that has already been completed.

CORE adopts a different philosophy.

> **Validated entity resolution decisions are scientific knowledge and should be preserved rather than discarded at the end of individual research projects.**

This philosophy is reflected throughout the framework.

Instead of relying exclusively on automated matching, CORE combines:

- transparent computational workflows;
- documented expert review through the Review Queue;
- preservation of validated scientific judgement through the Learning Layer;
- reusable knowledge that supports future empirical research.

The result is a research software framework that treats entity resolution as a documented and reproducible scientific methodology rather than a project-specific preprocessing task.

---

## Key Features

CORE has been designed as a modular research software framework rather than a collection of matching scripts.

### Research methodology

- Transparent and reproducible entity resolution workflows
- Explicit integration of computational methods and scientific judgement
- Preservation of validated knowledge through the Learning Layer
- Reviewable decision-making through the Review Queue
- Methodological continuity across independent research projects

### Software architecture

- Modular architecture with clearly separated responsibilities
- Independent matching engines and reusable workflow components
- Extensible dictionary management system
- Transparent intermediate outputs throughout the workflow
- Comprehensive testing and software quality checks

### Research outputs

- Analysis-ready matched datasets
- Reproducible entity resolution workflows
- Reusable domain-specific dictionaries
- Preserved expert knowledge for future investigations
- Transparent documentation supporting scientific reproducibility

---

## Installation

Clone the repository.

```bash
git clone https://github.com/YurtsevUymaz/CORE.git
```

Move into the project directory.

```bash
cd CORE
```

Install the required R packages.

```r
source("R/01_install_packages.R")
```

Load the CORE environment.

```r
source("R/02_load_packages.R")
```

CORE is now ready for use.

---

## Quick Start

A typical CORE workflow consists of six methodological stages.

```text
1. Read reference data
2. Read target data
3. Prepare data
4. Run entity resolution
5. Review uncertain matches
6. Export analysis-ready outputs
```

The workflow can be initiated by sourcing the project modules.

```r
# Project configuration
source("R/03_project_config.R")

# Data import
source("R/05_read_reference.R")
source("R/06_read_employer.R")

# Data preparation
source("R/07_clean_names.R")
source("R/08_tokenizer.R")
source("R/09_prepare_reference.R")

# Run CORE
source("R/workflow/18_run_core.R")
```

CORE automatically generates transparent intermediate outputs together with reproducible analysis-ready datasets.

---

## Repository Structure

The repository has been organised to separate methodological components, software infrastructure, documentation, visual assets, and supporting resources.

```text
CORE/
│
├── assets/
│   ├── core_hero_figure.svg
│   └── core_hero_figure.png
│
├── R/
│   ├── engines/
│   ├── managers/
│   ├── utilities/
│   ├── workflow/
│   └── tests/
│
├── docs/
│
├── inst/
│   └── dictionaries/
│
├── config/
│
├── diagnostics/
│
├── LICENSE
├── DESCRIPTION
├── CITATION.cff
├── NEWS.md
└── CONTRIBUTING.md
```

This modular organisation reflects the methodological architecture of CORE and allows individual components to evolve independently while preserving a stable overall framework.

---

## Documentation

CORE is supported by a collection of complementary design documents.

| Document | Purpose |
|----------|---------|
| **[The Philosophy Behind CORE](docs/The_Philosophy_Behind_CORE.md)** | Explains the scientific motivation and conceptual foundations of CORE. |
| **[Architecture](docs/Architecture.md)** | Describes the software architecture and design principles. |
| **[Workflow](docs/Workflow.md)** | Explains how information moves through the complete entity resolution process. |
| **[Methodology](docs/Methodology.md)** | Describes the methodological framework implemented throughout CORE. |
| **[Review Queue](docs/Review_Queue.md)** | Explains how uncertain matches are evaluated through expert review. |
| **[Learning Layer](docs/Learning_Layer.md)** | Describes how validated scientific judgement is preserved and reused. |

Although each document focuses on a different aspect of the framework, together they describe the complete methodological and architectural design of CORE.

---

## Documentation Roadmap

Researchers may find the following reading order helpful.

```text
The Philosophy Behind CORE
            │
            ▼
      Architecture
            │
            ▼
        Workflow
            │
            ▼
      Review Queue
            │
            ▼
     Learning Layer
            │
            ▼
       Methodology
```

Developers who wish to understand the software implementation may alternatively begin with **Architecture** before exploring the remaining documentation.

---

## Citation

If CORE contributes to your research, please cite the software using the citation metadata provided in the repository.

Citation information is available in:

- **CITATION.cff** (GitHub citation support)

A DOI and additional citation formats will be added following the first archived software release.

---

## Project Status

**Current Release:** **CORE v1.0.0**

CORE v1.0.0 represents the first stable public release of the Corporate Entity Resolution Engine.

The core entity resolution framework is considered stable and future development will focus on expanding the surrounding research software platform rather than redesigning the underlying architecture.

Current development priorities include:

- GitHub repository development
- Documentation website
- Interactive Shiny interface
- Community dictionary ecosystem
- Large-scale benchmarking
- Research software infrastructure

---

## Development Roadmap

The long-term vision of CORE extends beyond entity resolution algorithms.

The project aims to become a complete open research software platform supporting transparent, reviewable, and reproducible entity resolution.

### CORE v1.0

- Stable entity resolution engine
- Modular architecture
- Review Queue
- Learning Layer
- Dictionary management
- Integration tests
- Software quality audit

### CORE v1.1

- Professional GitHub repository
- Community documentation
- Improved user experience

### CORE v1.2

- Documentation website

### CORE v1.3

- Interactive Shiny application

### CORE v1.4

- Large-scale benchmarking
- Performance optimisation

### Long-Term Vision

- Community-maintained dictionaries
- Collaborative review workflows
- Research software platform
- Cross-domain entity resolution
- Open scientific ecosystem

---

## Contributing

Contributions are welcome from researchers, students, developers, and domain experts.

Examples include:

- Bug reports
- Documentation improvements
- Performance optimisation
- Dictionary contributions
- Feature proposals
- User interface improvements
- Pull requests

Please read **[CONTRIBUTING.md](CONTRIBUTING.md)** before contributing.

---

## License

CORE is released under the **MIT License**.

See **[LICENSE](LICENSE)** for details.

---

## Acknowledgements

CORE was developed from the recognition that entity resolution is not merely a technical preprocessing task, but a scientific activity whose validated decisions constitute valuable research knowledge.

The framework reflects a commitment to transparent methodology, reproducible empirical research, explicit scientific judgement, and long-term knowledge preservation.

Its long-term objective is to contribute to an open research ecosystem in which validated entity resolution knowledge remains available for future scientific investigation rather than disappearing at the conclusion of individual research projects.