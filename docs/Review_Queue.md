# Review Queue

*This document describes the purpose, design, and methodological role of the Review Queue within CORE. The Review Queue provides a structured environment in which uncertain entity resolution decisions remain available for transparent scientific evaluation rather than being resolved through automated procedures alone.*

---

## Purpose

The Review Queue has been designed to manage uncertainty within the entity resolution workflow. Rather than forcing every candidate correspondence into an automatic decision, CORE deliberately preserves observations whose interpretation cannot be established confidently through computational procedures alone.

The Review Queue therefore represents more than a collection of unresolved cases. It provides a dedicated stage of scientific evaluation in which computational evidence and expert judgement are considered together before a validated decision is reached. Uncertainty is treated as an explicit component of empirical research rather than as a limitation to be concealed or bypassed.

By separating uncertain observations from confidently resolved correspondences, the Review Queue protects both methodological transparency and scientific reliability. Researchers remain able to inspect the available evidence, document their reasoning, and distinguish validated knowledge from unresolved ambiguity.

---

## Why a Review Queue?

Entity resolution rarely consists entirely of obvious matches or obvious mismatches. Between these two extremes lies a spectrum of observations for which computational evidence alone is insufficient to support a reliable conclusion.

Many existing workflows resolve this uncertainty by adjusting similarity thresholds or applying increasingly complex matching algorithms. Although these approaches may improve automation, they do not eliminate uncertainty itself. Instead, they often transfer important scientific decisions from explicit human evaluation to implicit computational assumptions.

CORE adopts a different methodological position.

Rather than attempting to eliminate uncertainty, the framework preserves it until sufficient scientific judgement can be applied. The Review Queue therefore exists not because automated methods fail, but because some empirical questions are inherently interpretative and require documented expert evaluation before becoming validated scientific knowledge.

---

## What Enters the Review Queue?

Only observations for which computational evidence remains insufficient are forwarded to the Review Queue. Confidently resolved correspondences continue through the workflow without manual intervention, whereas uncertain observations are intentionally separated for scientific evaluation.

The decision to enter the Review Queue is therefore determined by methodological confidence rather than by computational completion. An observation may satisfy multiple computational criteria while still requiring expert review if conflicting evidence remains. Conversely, observations supported by consistent and reliable evidence need not undergo unnecessary manual evaluation.

Typical reasons for entering the Review Queue include conflicting evidence between independent matching procedures, ambiguous naming conventions, historical organisational changes, multiple plausible candidate correspondences, or situations in which domain-specific interpretation remains necessary. The precise criteria may evolve as the framework develops, but the underlying principle remains unchanged: uncertainty is preserved whenever computational evidence alone cannot support a scientifically reliable conclusion.

---

## The Review Process

The Review Queue provides a structured environment in which researchers evaluate uncertain observations using all available supporting evidence. Rather than reconsidering isolated similarity scores, reviewers assess the broader empirical context in which candidate correspondences have been generated.

Review therefore represents a process of scientific reasoning rather than simple verification. Computational evidence, historical information, domain knowledge, and methodological judgement are considered together before a correspondence is accepted, rejected, or left unresolved pending additional evidence.

Equally important, the reasoning supporting each validated decision remains explicit. The Review Queue is designed not merely to record outcomes, but to preserve the scientific evaluation through which those outcomes were obtained. This distinction allows subsequent researchers to understand why a decision was reached rather than observing only the decision itself.

By making expert evaluation an explicit stage of the workflow, CORE ensures that uncertainty is resolved through transparent scientific judgement instead of becoming hidden within increasingly complex computational procedures.

---

## Outcomes of Review

Every observation leaving the Review Queue follows one of three possible paths.

A correspondence may be accepted when the available evidence supports a reliable scientific conclusion. It may be rejected when the accumulated evidence demonstrates that the observations represent different entities. Alternatively, the observation may remain unresolved when the available evidence is insufficient to support either conclusion with confidence.

Preserving unresolved observations is an intentional methodological decision. Within CORE, the absence of a definitive conclusion is considered preferable to introducing unsupported certainty. Unresolved cases therefore remain available for future investigation as additional evidence, domain knowledge, or contextual information becomes available.

The Review Queue therefore distinguishes between validated knowledge and continuing uncertainty, ensuring that confidence is earned through scientific evaluation rather than assumed through computational necessity.

---

## Design Principles

The Review Queue has been designed around four methodological principles.

### Evidence-Based

Review decisions are supported by documented evidence rather than isolated similarity scores or subjective impressions.

### Transparent

Both the available evidence and the resulting scientific judgement remain open to inspection and future review.

### Conservative

When uncertainty cannot be resolved confidently, CORE prefers preserving ambiguity over introducing potentially incorrect correspondences.

### Reproducible

Review decisions remain documented and available for future verification, allowing subsequent researchers to understand, reproduce, or challenge previous scientific evaluations.

---

## Relationship with the Learning Layer

The Review Queue and the Learning Layer perform complementary methodological roles.

The Review Queue is responsible for scientific evaluation. It provides the environment in which uncertain observations are examined and validated through expert judgement.

The Learning Layer is responsible for scientific preservation. Once a decision has been validated through review, the resulting scientific judgement becomes available for future investigations through the Learning Layer.

The relationship between these two components reflects the broader philosophy of CORE. Scientific judgement produces validated knowledge, while the Learning Layer preserves that knowledge so it may contribute to future empirical research.

The Review Queue therefore represents the point at which uncertainty becomes scientific knowledge. The Learning Layer ensures that this knowledge remains part of the continuing scientific record rather than disappearing at the conclusion of an individual project.

