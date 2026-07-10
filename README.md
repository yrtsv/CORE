# Corporate Entity Resolution Engine (CORE)

> **An open-source research software framework for transparent, reviewable, reproducible, and cumulative entity resolution.**

> **Entity resolution does not merely produce analytical datasets.**
>
> **It produces scientific knowledge.**

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

The **Corporate Entity Resolution Engine (CORE)** is an open-source research software framework designed to support transparent, reviewable, reproducible, and cumulative entity resolution in empirical research.

Rather than treating entity resolution as a disposable data-cleaning task, CORE treats it as a scientific process in which computational methods, expert judgement, and validated knowledge work together to produce trustworthy analytical datasets.

Originally developed for corporate entity resolution, the framework has been intentionally designed as a general methodology capable of supporting transparent entity resolution across a broad range of empirical research domains.

---

## Why CORE?

Traditional entity resolution workflows typically conclude once a matched dataset has been produced. Intermediate decisions, reviewer knowledge, and methodological reasoning often disappear with the project, forcing future researchers to reconstruct work that has already been completed.

CORE adopts a different philosophy.

> **Validated entity resolution decisions are scientific knowledge and should be preserved rather than discarded at the end of individual research projects.**

Instead of relying exclusively on automated matching, CORE combines:

- transparent computational workflows;
- documented expert review through the Review Queue;
- preservation of validated scientific judgement through the Learning Layer;
- reusable knowledge that supports future empirical research;
- explicit separation between computational evidence and scientific judgement.

The result is a research software framework that treats entity resolution as a documented and reproducible scientific methodology rather than a project-specific preprocessing task.

---

## Key Features

CORE has been designed as a modular research software framework rather than a collection of matching scripts.

### Research Methodology

- Transparent and reproducible entity resolution workflows
- Explicit integration of computational methods and scientific judgement
- Preservation of validated knowledge through the Learning Layer
- Reviewable decision-making through the Review Queue
- Methodological continuity across independent research projects
- Cumulative knowledge preservation

### Software Architecture

- Modular architecture with clearly separated responsibilities
- Independent matching engines and reusable workflow components
- Extensible dictionary management system
- Transparent intermediate outputs throughout the workflow
- Comprehensive testing and software quality checks

### Research Outputs

- Analysis-ready matched datasets
- Reproducible entity resolution workflows
- Reusable domain-specific dictionaries
- Preserved expert knowledge for future investigations
- Transparent documentation supporting scientific reproducibility

---

## Installation

Clone the repository:

```bash
git clone https://github.com/yrtsv/CORE.git
```

Move into the project directory:

```bash
cd CORE
```

Install required packages:

```r
source("R/01_install_packages.R")
```

Load the CORE environment:

```r
source("R/02_load_packages.R")
```

CORE is now ready for use.

---

## Quick Start

A typical CORE workflow consists of seven methodological stages:

```text
1. Read reference data
2. Read target data
3. Prepare data
4. Run entity resolution
5. Review uncertain matches
6. Preserve validated knowledge
7. Export analysis-ready outputs
```

Typical execution:

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

```text
CORE/
│
├── assets/
│
├── app/
│
├── website/
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
| **The Philosophy Behind CORE** | Scientific motivation and conceptual foundations |
| **Architecture** | Software architecture and design principles |
| **Workflow** | Complete entity resolution process |
| **Methodology** | Methodological framework |
| **Review Queue** | Expert review and uncertainty management |
| **Learning Layer** | Preservation and reuse of scientific judgement |

Together, these documents describe the complete methodological and architectural design of CORE.

---

## Documentation Roadmap

Suggested reading order:

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
      Methodology
            │
            ▼
      Review Queue
            │
            ▼
     Learning Layer
```

---

## Demonstrator

CORE includes an interactive Shiny demonstrator that executes the real CORE pipeline through a graphical interface.

Current capabilities include:

- End-to-end execution of the CORE workflow
- Interactive Review Queue
- Match diagnostics and explainability
- Human review decisions
- Learning Layer integration
- Exportable review decisions

The demonstrator is intended as a research interface rather than a simplified matching application.

---

## Documentation Website

CORE includes a dedicated documentation website built with Quarto.

The website provides:

- installation instructions;
- methodological documentation;
- architectural overview;
- tutorials and examples;
- release notes and project news.

---

## Project Status

**Current Release:** **CORE v1.0.0**

CORE v1.0.0 represents the first stable public release of the Corporate Entity Resolution Engine.

Completed milestones include:

- Stable entity resolution engine
- Review Queue
- Learning Layer infrastructure
- Dictionary management system
- Documentation website
- Interactive Shiny demonstrator
- Software quality audit
- GitHub repository infrastructure

---

## Learning Philosophy

Knowledge preserved through the Learning Layer does not automatically influence future entity resolution decisions.

CORE currently distinguishes three stages of knowledge integration.

### Passive Learning

Validated decisions are preserved but do not influence computational procedures.

### Consensus Learning

Knowledge becomes eligible for methodological influence only after sufficient independent scientific validation has accumulated.

### Soft Learning

Validated knowledge influences future workflows through transparent score adjustments and review prioritisation rather than automatic acceptance or rejection.

This approach protects future investigations from isolated reviewer errors while preserving the cumulative development of scientific knowledge.

---

## Development Roadmap

### CORE v1.0

- Stable entity resolution engine
- Review Queue
- Learning Layer
- Documentation website
- Interactive Shiny demonstrator

### CORE v1.1

- Public demonstrator deployment
- Improved user experience
- Community documentation

### CORE v1.2

- Consensus learning infrastructure
- Collaborative review workflows

### CORE v1.3

- Soft learning integration
- Knowledge-aware scoring

### Long-Term Vision

- Community-maintained dictionaries
- Cross-domain entity resolution
- Open scientific ecosystem
- Collaborative scientific review
- Research software platform

---

## Citation

If CORE contributes to your research, please cite the software using the citation metadata provided in the repository.

Citation information is available in:

- `CITATION.cff`

A DOI and additional citation formats will be added following the first archived software release.

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

Please read `CONTRIBUTING.md` before contributing.

---

## License

CORE is released under the MIT License.

See `LICENSE` for details.

---

## Acknowledgements

CORE was developed from the recognition that entity resolution is not merely a technical preprocessing task, but a scientific activity whose validated decisions constitute valuable research knowledge.

The framework reflects a commitment to transparent methodology, reproducible empirical research, explicit scientific judgement, and long-term knowledge preservation.

Its long-term objective is to contribute to an open research ecosystem in which validated entity resolution knowledge remains available for future scientific investigation rather than disappearing at the conclusion of individual research projects.