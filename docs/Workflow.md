# Workflow

*This document describes how information moves through CORE, from raw data to analysis-ready outputs. The workflow reflects the methodological architecture of the framework and explains how each processing stage contributes to transparent and reproducible entity resolution.*

---

## Purpose

The workflow of CORE has been designed to transform heterogeneous raw data into transparent, reviewable, and analysis-ready outputs through a sequence of explicit methodological stages. Rather than combining multiple operations within a single procedure, each stage performs a distinct scientific function while preserving the intermediate information required to understand how final matching decisions have been obtained.

The workflow therefore represents more than a computational pipeline. It provides a structured research process in which data preparation, entity resolution, expert validation, knowledge preservation, and output generation remain clearly separated yet collectively contribute to a coherent and reproducible methodology.

---

## Workflow Overview

The overall workflow consists of six consecutive stages.

```text
Raw Data
    │
    ▼
Data Acquisition
    │
    ▼
Data Preparation
    │
    ▼
Entity Resolution
    │
    ▼
Expert Validation
    │
    ▼
Knowledge Preservation
    │
    ▼
Analysis-Ready Outputs
```

Each stage produces explicit outputs that become the inputs of the following stage. Intermediate results remain available throughout the workflow, allowing researchers to inspect, validate, and reproduce every important decision rather than observing only the final analytical dataset.

Unlike conventional data-processing pipelines, the workflow deliberately preserves uncertainty whenever computational procedures alone cannot establish reliable correspondences. Scientific judgement therefore remains an integral component of the workflow rather than an external correction applied after automated matching has been completed.

---

## Stage 1 — Data Acquisition

The workflow begins by importing all data sources required for entity resolution. These may include reference datasets, target datasets, project-specific resources, and supporting configuration files. At this stage, the objective is not to modify the data, but to establish a consistent and reproducible starting point for the remainder of the workflow.

Maintaining the original observations is an important methodological principle. Raw data remain unchanged throughout the workflow, allowing every subsequent transformation to be interpreted relative to the original source information.

---

## Stage 2 — Data Preparation

Before entity resolution can begin, observations are standardised to reduce avoidable variation while preserving their scientific meaning. Preparation includes operations such as text normalisation, tokenisation, and reference preparation, ensuring that subsequent matching procedures compare observations within a consistent representation.

Importantly, this stage does not attempt to establish correspondences between entities. Its purpose is solely to improve the quality and consistency of the information entering the resolution process. Data preparation therefore reduces technical variation without introducing methodological assumptions regarding entity identity.

---

## Stage 3 — Entity Resolution

Entity resolution forms the computational core of the workflow. Rather than relying upon a single matching algorithm, CORE performs entity resolution through a sequence of independent methodological operations. Exact matching, suffix normalisation, alias resolution, candidate generation, and similarity assessment each contribute distinct evidence regarding potential correspondences.

This sequential organisation provides two important advantages. First, individual stages remain transparent and independently testable. Second, multiple forms of evidence can be considered before a correspondence is accepted or rejected, reducing dependence upon any single computational criterion.

The purpose of this stage is not to maximise automation. Instead, it aims to resolve observations that can be established confidently while explicitly identifying those requiring further scientific evaluation.

---

## Stage 4 — Expert Validation

Not every potential correspondence can be established through computational procedures alone. Observations whose interpretation remains uncertain proceed to the expert validation stage, where scientific judgement complements computational evidence.

Within CORE, uncertainty is deliberately preserved rather than concealed. Candidate correspondences requiring additional evaluation are collected within the Review Queue, allowing researchers to inspect the supporting evidence before accepting, rejecting, or refining individual decisions. Expert validation therefore remains an explicit and transparent stage of the workflow rather than an undocumented activity performed outside the software.

The purpose of this stage is not to maximise manual intervention, but to ensure that scientific judgement is applied only where computational evidence alone is insufficient.

---

## Stage 5 — Knowledge Preservation

Validated decisions generated during expert review represent scientific knowledge that extends beyond the immediate objectives of an individual project. Rather than allowing this knowledge to disappear once entity resolution has been completed, CORE preserves validated decisions within the Learning Layer.

Knowledge preservation should not be interpreted as autonomous learning. The framework does not infer new scientific knowledge independently. Instead, it maintains a transparent record of validated expert decisions so that future investigations may benefit from previous scientific evaluation while remaining free to review, refine, or revise earlier conclusions.

Knowledge therefore accumulates through continued scientific review rather than through automated prediction.

---

## Stage 6 — Analysis-Ready Outputs

The final stage produces datasets suitable for subsequent empirical analysis together with the information required to understand how those datasets were constructed.

Rather than returning only matched observations, the workflow preserves intermediate information describing how entity resolution decisions were reached. Researchers therefore obtain not only analysis-ready data, but also a transparent and reproducible record of the methodological process supporting those data.

The workflow concludes with outputs that remain suitable for statistical analysis while preserving the scientific accountability of every major stage contributing to their construction.

---

## Workflow Characteristics

The workflow of CORE has been designed around four methodological characteristics.

### Sequential

Each processing stage builds explicitly upon the outputs of the previous stage, producing a coherent end-to-end research workflow.

### Transparent

Intermediate outputs remain available throughout the workflow, allowing every important transformation and decision to be inspected independently.

### Reviewable

Scientific judgement remains an explicit component of the workflow through the Review Queue, ensuring that uncertainty is resolved through documented evaluation rather than concealed within automated procedures.

### Reproducible

Every stage contributes to a workflow that can be repeated, inspected, and independently verified, supporting transparent empirical research across different datasets and application domains.
