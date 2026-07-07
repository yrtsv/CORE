# Architecture

*This document describes the architectural principles underlying the design of CORE and explains how methodological objectives are translated into a modular software framework.*

---

## Purpose

The architecture of CORE has been designed to support the methodological principles described in *The Philosophy Behind CORE*. Rather than optimising solely for computational performance, the framework has been structured to make entity resolution transparent, modular, reproducible, and open to scientific review.

Architectural decisions within CORE are therefore driven by research methodology rather than software engineering alone. Each component performs a clearly defined responsibility, intermediate outputs remain available for inspection, and uncertainty is preserved whenever expert judgement is required. This organisation enables researchers to understand not only the final matching results, but also the sequence of decisions through which those results were produced.

The architecture is intended to support long-term scientific use. Individual modules may evolve, algorithms may be replaced, and domain-specific resources may expand over time without requiring fundamental changes to the overall structure of the framework. In this way, methodological continuity is maintained while allowing technical implementation to improve.

---

## Architectural Principles

The design of CORE is guided by five architectural principles that ensure the framework remains transparent, extensible, and suitable for empirical research.

### Single Responsibility

Each module performs one clearly defined task within the entity resolution workflow. Data cleaning, candidate generation, similarity assessment, expert review, and knowledge preservation remain independent responsibilities rather than being combined within a single procedure. This separation simplifies development, testing, maintenance, and scientific interpretation.

### Transparency

Intermediate outputs are intentionally preserved throughout the workflow. Researchers are able to inspect the outcome of each processing stage, making the reasoning behind final matching decisions visible rather than implicit. Transparency therefore applies not only to the final dataset, but to the complete entity resolution process.

### Composability

Modules are designed to operate as independent building blocks. Individual components can be combined, omitted, replaced, or extended without requiring changes to the overall workflow. This allows the framework to adapt to different research requirements while preserving methodological consistency.

### Extensibility

Domain-specific resources, including normalisation rules, reference dictionaries, alias dictionaries, and validation knowledge, are maintained independently from the core architecture. New resources can therefore be incorporated without modifying the underlying workflow or altering the responsibilities assigned to individual modules.

### Testability

Because each module performs a single responsibility and produces explicit outputs, every component can be tested independently. This improves software reliability while allowing methodological assumptions to be evaluated at each stage of the entity resolution process.

---

## Layered Architecture

CORE adopts a layered architecture in which each stage of the entity resolution process addresses a distinct methodological objective. Rather than concentrating multiple responsibilities within a single procedure, the framework separates data preparation, entity resolution, expert validation, knowledge preservation, and output generation into independent architectural layers.

This organisation improves both scientific transparency and software maintainability. Intermediate results remain available throughout the workflow, allowing researchers to inspect, validate, or replace individual stages without affecting the remainder of the framework.

The current architecture is organised into six conceptual layers.

### Input Layer

The Input Layer is responsible for importing heterogeneous datasets into a consistent working environment. Reference data, target datasets, configuration files, and project resources are loaded without introducing methodological transformations.

### Preparation Layer

The Preparation Layer standardises raw observations before entity resolution begins. Tasks such as text normalisation, tokenisation, and reference preparation reduce avoidable variation while preserving the original information required for later validation.

### Resolution Layer

The Resolution Layer performs the computational stages of entity resolution. Exact matching, suffix normalisation, alias resolution, candidate generation, and similarity assessment are implemented as independent operations, allowing each methodological step to remain transparent and individually testable.

### Validation Layer

The Validation Layer manages observations whose interpretation cannot be established confidently through computational procedures alone. Rather than forcing automatic decisions, uncertain cases remain available for scientific review through the Review Queue, ensuring that ambiguity is resolved through documented expert judgement.

### Knowledge Layer

The Knowledge Layer preserves validated scientific judgement independently from the computational workflow. Previously reviewed decisions become reusable research knowledge through the Learning Layer, allowing future investigations to benefit from earlier scientific evaluation while remaining open to refinement and correction.

### Output Layer

The Output Layer produces analysis-ready datasets together with the intermediate information required to understand how those datasets were generated. Entity resolution therefore produces both analytical outputs and a transparent record of the decisions supporting them.

---

## Modular Design

Although CORE operates as a single research framework, its implementation consists of independent modules organised according to their methodological responsibilities rather than their computational complexity.

Each module performs one clearly defined function and communicates with the remainder of the framework through explicit inputs and outputs. Modules therefore remain loosely coupled while contributing to a coherent end-to-end workflow.

This modular organisation provides several practical advantages. Individual components can be developed, tested, replaced, or extended independently. New functionality can be introduced without modifying unrelated parts of the framework, while methodological assumptions remain isolated within the modules responsible for implementing them.

Importantly, modularity within CORE is not simply a software engineering decision. It reflects the methodological principle that entity resolution consists of multiple independent scientific activities rather than a single matching algorithm. Separating these activities improves transparency, facilitates validation, and allows each stage of the workflow to evolve without compromising the integrity of the overall framework.

---

## Separation of Responsibilities

A fundamental design objective of CORE is the explicit separation of methodological responsibilities. Entity resolution is not implemented as a single procedure that performs multiple operations simultaneously. Instead, each stage of the workflow is responsible for one well-defined scientific task.

Data preparation remains distinct from entity resolution. Computational matching remains distinct from expert validation. Knowledge preservation remains distinct from both computational inference and analytical output generation. This separation ensures that each methodological decision can be understood, evaluated, and improved independently.

The resulting architecture provides more than software modularity. It preserves the scientific meaning of each stage within the workflow. Researchers are therefore able to identify where observations have been transformed, where correspondences have been established, where expert judgement has been applied, and where validated knowledge has been preserved.

Maintaining these boundaries also reduces unintended interactions between independent components. Improvements introduced within one stage can therefore be implemented without altering the scientific responsibilities assigned to the remainder of the framework.

---

## Extensibility

CORE has been designed to evolve without requiring changes to its underlying architecture.

The framework distinguishes between methodological components and domain-specific resources. Dictionaries, normalisation rules, reference datasets, validation knowledge, and other supporting resources may expand or be replaced as new research domains are considered. These changes extend the capabilities of the framework without modifying its architectural principles.

Similarly, individual computational modules may be improved or replaced as more suitable methods become available. Because each module operates within clearly defined responsibilities, methodological consistency is preserved even as technical implementation evolves.

This separation allows CORE to remain stable as a research framework while continuously adapting to new empirical requirements, alternative entity types, and future methodological developments.

---

## Why This Architecture?

The architecture of CORE has not been designed around algorithms. It has been designed around scientific methodology.

Every architectural decision reflects a corresponding methodological objective: transparency requires visible intermediate outputs; expert review requires explicit validation stages; knowledge preservation requires an independent Learning Layer; reproducibility requires modular and testable components.

Consequently, the architecture follows the methodology rather than defining it. Software implementation serves the scientific process, not the reverse.

The purpose of the architecture is therefore not only to organise code, but also to preserve the integrity, transparency, and continuity of entity resolution as a scientific activity.