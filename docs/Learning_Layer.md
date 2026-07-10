# Learning Layer

*This document describes the purpose, design, and methodological role of the Learning Layer within CORE. The Learning Layer preserves validated scientific judgement so that knowledge generated during entity resolution remains available for future empirical research.*

---

## Purpose

The Learning Layer has been designed to preserve validated scientific judgement beyond the lifetime of individual research projects. Rather than allowing carefully reviewed entity resolution decisions to disappear once an analytical dataset has been produced, CORE maintains those decisions as reusable research knowledge that can support future investigations.

The Learning Layer therefore represents more than a repository of previously reviewed correspondences. It provides a structured mechanism through which validated scientific judgement remains available for inspection, refinement, and reuse. Knowledge generated during entity resolution becomes part of a continuing scientific record rather than a temporary project artefact.

By preserving validated decisions independently from the computational workflow, the Learning Layer strengthens methodological continuity across successive empirical studies. Scientific knowledge accumulated through careful review is therefore able to contribute to future research rather than being repeatedly reconstructed.

---

## Why a Learning Layer?

Every expert review produces knowledge that extends beyond the immediate correspondence being evaluated. The reasoning supporting a validated decision may prove relevant whenever future investigations encounter comparable observations, naming conventions, organisational structures, or historical relationships.

Without an explicit mechanism for preserving this knowledge, each new project begins with limited awareness of previous scientific evaluation. Researchers may therefore repeat investigations whose conclusions have already been established, not because earlier knowledge was incorrect, but because it was never retained in a reusable form.

CORE addresses this problem by separating knowledge preservation from both computational matching and expert review. The Review Queue is responsible for scientific evaluation; the Learning Layer is responsible for ensuring that validated scientific judgement remains available after that evaluation has been completed.

The Learning Layer therefore exists not to replace future scientific reasoning, but to ensure that previous scientific reasoning continues to contribute to future empirical research.

---

## What Does the Learning Layer Preserve?

The Learning Layer preserves validated scientific judgement rather than computational predictions. Every decision entering the Learning Layer has previously undergone expert evaluation through the Review Queue and therefore represents documented scientific reasoning rather than automatically inferred knowledge.

Preserved knowledge may include validated correspondences, documented review outcomes, supporting evidence, and the scientific rationale through which those decisions were established. The objective is not simply to retain conclusions, but to preserve the context required to understand, evaluate, and, where appropriate, refine those conclusions in future investigations.

Importantly, the Learning Layer stores knowledge independently from the computational methods that originally generated candidate correspondences. Improvements to matching algorithms therefore do not invalidate previously documented scientific judgement, while new evidence remains capable of refining earlier decisions.

---

## Scientific Learning versus Machine Learning

The term "Learning Layer" does not refer to machine learning, artificial intelligence, or autonomous decision-making.

Within CORE, learning is understood in its scientific sense: the preservation and accumulation of validated knowledge generated through empirical investigation. Knowledge grows because researchers evaluate uncertain observations, document their reasoning, and preserve validated conclusions. The framework itself does not generate new knowledge independently.

This distinction is fundamental to the design of CORE. Machine learning systems typically improve by identifying statistical patterns within data. The Learning Layer, by contrast, improves the usefulness of the framework by preserving scientific judgement that has already been critically evaluated by researchers.

Consequently, the Learning Layer should be understood as a mechanism for scientific continuity rather than computational adaptation. Its purpose is not to automate expert reasoning, but to ensure that validated reasoning remains available to future empirical research.

---

## Knowledge Evolution

Scientific knowledge is never regarded as complete or immutable. As new evidence becomes available, previously validated decisions may require refinement, reinterpretation, or correction. The Learning Layer has therefore been designed to preserve scientific continuity without preventing scientific revision.

Knowledge preserved within the Learning Layer remains open to future evaluation. Previously validated decisions provide an informed starting point for subsequent investigations, yet they do not constrain future scientific judgement. Researchers remain free to confirm, refine, challenge, or replace earlier conclusions whenever additional evidence justifies doing so.

This approach allows knowledge to evolve through continued scientific scrutiny rather than through automatic replacement. The Learning Layer therefore preserves the history of scientific judgement while supporting the ongoing development of empirical understanding.

---

## Learning Activation

Knowledge preserved within the Learning Layer does not automatically influence future entity resolution decisions.

A single expert decision may contain errors, reflect project-specific assumptions, or represent an interpretation that later evidence may challenge. Preserved knowledge therefore enters the Learning Layer as documented scientific evidence rather than as immediately actionable rules.

CORE currently distinguishes three stages of knowledge integration.

### Passive Learning

Validated decisions are preserved for future reference but do not influence computational procedures.

The objective of Passive Learning is scientific continuity rather than methodological adaptation. Preserved knowledge remains available for inspection, discussion, and future evaluation while computational workflows continue to operate independently from previously reviewed decisions.

This stage establishes the scientific memory of the framework without introducing the risk that isolated errors or project-specific interpretations influence future investigations.

### Consensus Learning

Preserved decisions become eligible for methodological influence only after sufficient independent scientific validation has accumulated.

The purpose of Consensus Learning is to distinguish broadly supported scientific judgement from isolated observations or individual reviewer errors. Knowledge enters this stage only after multiple independent evaluations produce consistent conclusions regarding a correspondence.

Consensus thresholds may vary across projects and research domains, but the underlying principle remains constant: scientific knowledge should influence future workflows only after adequate validation has emerged.

### Soft Learning

Validated knowledge influences future workflows through transparent adjustments to similarity assessment or review prioritisation rather than through automatic acceptance or rejection of correspondences.

Examples may include increasing confidence scores for repeatedly validated correspondences, reducing confidence scores for repeatedly rejected candidates, or modifying review priorities to focus expert attention on genuinely uncertain observations.

Importantly, Soft Learning does not replace scientific judgement. Final decisions remain subject to expert review and remain open to future refinement whenever new evidence becomes available.

This staged approach ensures that scientific knowledge remains cumulative while protecting future investigations from isolated errors, accidental reviewer decisions, or premature methodological conclusions.

Knowledge preserved within the Learning Layer therefore evolves gradually through continued scientific scrutiny rather than immediate algorithmic adoption.

---

## Design Principles

The Learning Layer has been designed around four methodological principles.

### Evidence-Based

Only decisions supported by documented scientific evaluation become part of the Learning Layer.

### Transparent

Preserved knowledge remains available for inspection, allowing future researchers to understand the evidence and reasoning supporting previous decisions.

### Cumulative

Scientific knowledge grows through the continued preservation and refinement of validated expert judgement rather than through repeated reconstruction.

### Revisable

Previously validated decisions remain open to future review whenever new evidence or improved scientific understanding becomes available.

---

## Relationship with the Review Queue

The Review Queue and the Learning Layer together form the methodological bridge between uncertainty and accumulated scientific knowledge.

The Review Queue is responsible for resolving uncertainty through documented expert evaluation. It represents the stage at which scientific judgement is actively produced.

The Learning Layer begins only after that evaluation has been completed. Its responsibility is not to generate new knowledge, but to preserve validated scientific judgement so that it remains available for future empirical investigations.

Together, these two components establish a continuous knowledge cycle within CORE. Scientific judgement generated through expert review becomes preserved knowledge, while preserved knowledge provides future researchers with an informed foundation for subsequent scientific evaluation.

The Learning Layer therefore does not replace scientific expertise. It ensures that validated expertise continues to contribute to empirical research beyond the boundaries of the project in which it was originally produced.