# The Philosophy Behind CORE

*This document describes the conceptual foundations and methodological position underlying the design of CORE.*

---

## Introduction

Empirical research increasingly depends upon integrating evidence originating from multiple independent data sources. Individual datasets rarely provide a complete representation of the entities or phenomena under investigation. Instead, meaningful empirical analysis is built by connecting complementary observations collected by different organisations, under different reporting standards, and for different purposes. The reliability of these connections directly influences the quality of every subsequent stage of scientific analysis.

Establishing such connections, however, is rarely straightforward. Independent data sources frequently employ incompatible identifiers, heterogeneous naming conventions, historical name changes, abbreviations, legal suffixes, and inconsistent reporting practices. In many research settings, no universally reliable identifier exists, requiring researchers to determine whether separate records describe the same underlying real-world entity through a combination of computational procedures and informed scientific judgement.

Although this process forms a fundamental component of empirical research, it has traditionally been regarded as a temporary preprocessing activity. Once an analytical dataset has been produced, the validated decisions that enabled its construction often disappear together with project-specific scripts, intermediate files, and undocumented reasoning. Consequently, each new study frequently reconstructs knowledge that has already been generated elsewhere.

CORE has been developed from a different methodological perspective. Rather than viewing entity resolution as a disposable technical operation, the framework regards it as an explicit component of the scientific process in which validated decisions themselves constitute reusable research knowledge. Preserving these decisions allows empirical research to progress through continuity rather than repeated reconstruction.

---

## The Missing Continuity

Every empirical research project generates entity resolution decisions. Very few preserve them.

Resolving ambiguous entities is rarely a mechanical exercise. Researchers routinely compare independent data sources, examine historical records, inspect reporting conventions, and apply domain-specific expertise before accepting or rejecting a potential correspondence. Many of these decisions require careful scientific judgement and cannot be reduced to similarity scores or deterministic rules alone.

The effort invested in this process is substantial. Yet the knowledge produced through that effort is commonly treated as a temporary by-product of an individual project. Once the analytical dataset has been constructed, validated decisions frequently disappear together with intermediate scripts, personal notes, local dictionaries, and undocumented reasoning. The resulting dataset survives; the knowledge required to construct it does not.

This absence of continuity extends beyond duplicated effort. Scientific knowledge advances through the preservation, critical evaluation, and refinement of previous understanding. Entity resolution has historically followed a different trajectory. Researchers repeatedly confront ambiguities that have already been examined elsewhere, not because previous decisions were necessarily incorrect, but because they were never preserved in a form that could be inspected, questioned, and reused.

The consequence is a persistent loss of scientific memory. Each project begins with less knowledge than the research community collectively possesses, requiring substantial intellectual effort to reproduce decisions that may already have been carefully validated in previous investigations. As empirical datasets continue to increase in scale and complexity, this repeated reconstruction becomes progressively more difficult to justify.

CORE addresses this discontinuity by treating validated entity resolution decisions as durable scientific outputs rather than temporary preprocessing artefacts. Instead of disappearing at the conclusion of individual projects, validated decisions remain available for future review, refinement, and reuse. Entity resolution therefore becomes not only a process of connecting records, but also a process of preserving scientific knowledge generated through empirical investigation.

---

## The CORE Perspective

CORE is founded upon a simple methodological premise: entity resolution should be treated as an explicit component of empirical research rather than as a disposable preprocessing task.

Within many conventional workflows, the objective of entity resolution is to produce a dataset suitable for subsequent statistical analysis. Once this objective has been achieved, the intermediate decisions that produced the final dataset frequently lose both their visibility and their scientific value. CORE adopts a different perspective. The process itself is regarded as a research activity whose validated decisions constitute scientific outputs worthy of preservation.

This perspective fundamentally changes the role of entity resolution. Rather than serving solely as a preparatory operation preceding empirical analysis, entity resolution becomes part of the scientific methodology itself. Every validated correspondence represents documented evidence describing how independent observations have been interpreted, evaluated, and connected. The resulting dataset is therefore not the only research output; the reasoning that produced it also becomes part of the scientific record.

This methodological perspective shapes every component of the framework. Automation is employed where computational procedures can reliably reduce repetitive effort, while uncertainty remains visible whenever scientific judgement is required. Instead of concealing ambiguity behind a final similarity score, CORE explicitly preserves uncertain observations so that they remain available for review, discussion, and future validation.

Accordingly, the purpose of CORE is not simply to maximise matching performance. Its objective is to establish a transparent research workflow in which every important decision remains observable, reviewable, and scientifically accountable.

---

## Scientific Judgement

Entity resolution is frequently presented as a computational challenge. In practice, however, many of its most important decisions arise precisely where computation alone becomes insufficient. Ambiguous observations often require contextual interpretation, historical understanding, and domain-specific reasoning before they can be resolved with confidence.

Computational methods remain indispensable. They efficiently identify candidate correspondences, eliminate obvious mismatches, and substantially reduce the scale of manual investigation. Their role, however, is to support scientific judgement rather than replace it. Efficiency and scientific validity are complementary objectives, not competing alternatives.

Within CORE, this principle is implemented through the Review Queue. Observations whose interpretation remains uncertain are deliberately retained for expert evaluation instead of being automatically accepted or rejected. Uncertainty is therefore treated as valuable scientific information rather than as a weakness of the computational workflow.

Every reviewed observation produces more than a corrected correspondence. It documents scientific reasoning applied to an empirical problem. Once preserved, that reasoning becomes reusable evidence capable of informing future investigations encountering comparable situations.

The Learning Layer extends this principle beyond individual projects. It does not attempt to generate knowledge autonomously, nor does it replace scientific expertise through predictive algorithms. Instead, it preserves validated expert decisions so that carefully established scientific judgement remains available to future researchers.

Within CORE, computational procedures improve efficiency, while scientific judgement produces knowledge. Both are essential. Neither substitutes for the other.

---

## Knowledge Accumulation

Scientific progress depends not only upon the generation of new evidence, but also upon the preservation, critical examination, and refinement of existing knowledge. Every empirical investigation contributes to a broader scientific record from which future research begins. Continuity is therefore one of the defining characteristics of cumulative science.

Entity resolution has rarely benefited from this continuity.

Although every empirical project generates validated entity resolution decisions, those decisions have traditionally remained confined to the project in which they were produced. The resulting analytical dataset is preserved, whereas the scientific reasoning required to construct it frequently disappears. Consequently, subsequent researchers often revisit ambiguities that have already been carefully investigated elsewhere.

CORE extends the principle of cumulative scientific knowledge to entity resolution itself.

Every validated entity resolution decision represents documented scientific judgement applied to a specific empirical problem. Once preserved, that judgement becomes available for future examination, confirmation, refinement, or revision. Knowledge therefore remains dynamic rather than static. Previously validated decisions are neither immutable nor automatically accepted; they remain open to continued scientific scrutiny as new evidence becomes available.

Over time, independently validated decisions contribute to an evolving scientific memory that extends beyond individual projects. This memory does not replace scientific judgement. Instead, it provides future researchers with an informed starting point from which new investigations may begin. Rather than reconstructing previous reasoning from the beginning, researchers inherit the current state of collectively validated understanding while remaining free to challenge, improve, or extend it.

Knowledge accumulation within CORE is therefore fundamentally different from algorithmic learning. The framework does not become more capable because it independently infers new relationships. It becomes more valuable because successive researchers preserve, examine, and refine validated scientific judgement over time. The continuity resides within the research community rather than within the software itself.

---

## Beyond Corporate Entities

CORE was initially developed within the context of corporate entity resolution because company-level datasets provided a demanding empirical environment in which heterogeneous identifiers, historical name changes, inconsistent reporting practices, and ambiguous naming conventions are frequently encountered.

The methodology itself, however, is intentionally independent of any particular application domain.

The architecture separates domain-specific knowledge from the entity resolution process. Resources such as normalisation rules, reference datasets, alias dictionaries, and validated decisions may evolve according to the requirements of individual disciplines without altering the underlying methodological framework.

This distinction allows the principles described throughout this document to remain applicable wherever independent datasets require transparent, reviewable, and reproducible entity resolution. The entities may differ, the domain knowledge may evolve, and the reference resources may change. The underlying scientific methodology remains the same.

CORE should therefore be understood not as a framework for company name matching, but as a general research framework for transparent entity resolution across empirical research.

---

## Towards Cumulative Entity Resolution

Entity resolution has traditionally remained one of the least visible stages of empirical research despite influencing every subsequent stage of scientific analysis. Considerable intellectual effort is invested in resolving ambiguous observations, yet the scientific knowledge generated throughout this process has rarely been preserved beyond the immediate objectives of individual projects.

CORE proposes a different methodological perspective.

Rather than viewing entity resolution solely as a technical operation that precedes statistical analysis, CORE regards it as an explicit component of scientific inquiry. The process of resolving entities generates knowledge through critical evaluation, documented reasoning, and validated scientific judgement. Preserving that knowledge is therefore as important as preserving the analytical dataset that ultimately emerges from it.

This perspective also changes the relationship between individual research projects and the broader scientific community. Instead of treating each investigation as an isolated exercise in data integration, validated decisions become part of an evolving scientific memory from which future studies may begin. Every contribution remains open to review, refinement, correction, and extension, allowing empirical knowledge to develop through continuity rather than repeated reconstruction.

The long-term vision of CORE is therefore not simply to improve entity resolution.

Its objective is to contribute to an empirical research culture in which validated entity resolution knowledge is preserved, scrutinised, shared, and continuously refined as part of the scientific record.

Entity resolution does not merely produce analytical datasets.

It produces scientific knowledge.

Preserving that knowledge is the central purpose of CORE.