# Corella Term Planning — Master Prompt Toolkit

A reusable prompt system for the Queensland Department of Education AI (Corella) to
generate detailed year / term / weekly / lesson plans for composite Technologies
classes.

## How to use it

1. Pick the **Value Block** for the subject you're planning (Woodwork, Metalwork, or
   Digital Technologies) from the section below.
2. Change `{{term}}` (and `{{part_number}}`, and `{{project_name}}` if the term's
   project changes) to the term you're planning.
3. Paste the chosen Value Block **followed by** the Master Prompt into Corella.
4. To reuse next term: edit only `{{term}}`, `{{part_number}}`, and `{{project_name}}`.
5. To reuse for a different subject: swap in that subject's Value Block — the prompt
   body adapts itself.

> Tip: Build the year one term at a time. Corella (like most AI) produces richer,
> more coherent plans when focused on a single term. The prompt is written to enforce
> this.

---

## Four-Term Project Sequence (fixed projects for a coherent year)

Deciding the four major projects up front keeps skills building progressively and stops
later terms repeating or skipping competencies. Suggested spiral sequence:

### Woodwork (Timber Technologies)

| Term | Project | New/primary skills introduced | Spiral focus (Y7 → Y10) |
|------|---------|-------------------------------|--------------------------|
| Term 1 | **Toolbox** | Measuring, marking out, sawing, drilling, basic joinery, sanding, fastening, finishing | Y7: simple butt joints & nails · Y10: rebated/housed joints, refined finish, own dimensions |
| Term 2 | **Serving / cutting board** | Timber selection, gluing up, edge jointing, food-safe finishing, shaping | Y7: single-species board · Y10: laminated multi-species, contoured handle, oil finish |
| Term 3 | **Stool** | Frame construction, mortise & tenon or dowelled joints, squaring, assembly, structural design | Y7: dowel-jointed stool · Y10: mortise & tenon, angled legs, load testing |
| Term 4 | **Student-designed major project** | Design folio, planning, independent tool selection, project management | Y7: guided design from templates · Y10: fully self-directed design & build |

### Metalwork (Metal Technologies)

| Term | Project | New/primary skills introduced |
|------|---------|-------------------------------|
| Term 1 | **Sheet metal toolbox / tray** | Marking out on metal, shearing, bending/folding, drilling, riveting, deburring, finishing |
| Term 2 | **Scriber / centre punch (turning)** | Filing, lathe turning, knurling, hardening & tempering |
| Term 3 | **Welded frame project (e.g. plant stand / bracket)** | MIG/arc welding, grinding, jigs, joint prep, safe fabrication |
| Term 4 | **Student-designed fabrication project** | Design folio, CAD/drawing, independent process selection, project management |

### Digital Technologies (Programming & Computational Thinking)

| Term | Project | New/primary skills introduced |
|------|---------|-------------------------------|
| Term 1 | **Interactive quiz (Python / Scratch)** | Sequencing, variables, input/output, selection, basic debugging |
| Term 2 | **Data visualisation / dashboard** | Lists/arrays, iteration, working with data, simple charts |
| Term 3 | **Physical computing (micro:bit / robotics)** | Sensors, events, conditionals, hardware/software integration |
| Term 4 | **Student-designed digital solution** | Design thinking, user needs, project management, testing & evaluation |

---

## Value Blocks

### Woodwork

```text
{{subject_name}} = Woodwork
{{curriculum_area}} = Design and Technologies
{{specialisation}} = Timber Technologies
{{year_levels}} = Years 7–10
{{term}} = Term 1
{{part_number}} = Part 1
{{weeks_per_term}} = 10
{{lessons_per_term}} = 20
{{lessons_per_week}} = 2
{{lesson_duration}} = 70 minutes
{{project_type}} = woodworking project
{{project_name}} = Toolbox
{{learning_environment}} = workshop
{{tools_and_equipment}} = hand tools, portable power tools and fixed woodworking machinery
{{safety_requirements}} = workshop PPE and Queensland WHS machinery requirements
{{software}} = N/A
{{assessment_type}} = practical project and design folio
{{school_context}} = regional/remote Queensland school, composite class
```

### Metalwork

```text
{{subject_name}} = Metalwork
{{curriculum_area}} = Design and Technologies
{{specialisation}} = Metal Technologies
{{year_levels}} = Years 7–10
{{term}} = Term 1
{{part_number}} = Part 1
{{weeks_per_term}} = 10
{{lessons_per_term}} = 20
{{lessons_per_week}} = 2
{{lesson_duration}} = 70 minutes
{{project_type}} = metal fabrication project
{{project_name}} = Sheet Metal Toolbox
{{learning_environment}} = workshop
{{tools_and_equipment}} = hand tools, welders, grinders, folders/shears and fixed metalworking machinery
{{safety_requirements}} = welding PPE, hot work procedures and Queensland WHS machinery requirements
{{software}} = CAD software (where available)
{{assessment_type}} = practical fabrication project and design folio
{{school_context}} = regional/remote Queensland school, composite class
```

### Digital Technologies

```text
{{subject_name}} = Digital Technologies
{{curriculum_area}} = Digital Technologies
{{specialisation}} = Programming and Computational Thinking
{{year_levels}} = Years 7–10
{{term}} = Term 1
{{part_number}} = Part 1
{{weeks_per_term}} = 10
{{lessons_per_term}} = 20
{{lessons_per_week}} = 2
{{lesson_duration}} = 70 minutes
{{project_type}} = digital solution
{{project_name}} = Interactive Quiz
{{learning_environment}} = computer lab
{{tools_and_equipment}} = laptops, micro:bit and robotics kits
{{safety_requirements}} = cyber safety, responsible technology use and ergonomics
{{software}} = Python, Scratch and micro:bit
{{assessment_type}} = digital solution and design folio
{{school_context}} = regional/remote Queensland school, composite class
```

---

## Master Prompt (paste after a Value Block)

```text
Role

You are an expert Queensland Department of Education curriculum writer, experienced Head of Department for {{curriculum_area}}, Master Teacher, and specialist in secondary {{subject_name}} ({{specialisation}}).

Your task is to develop {{term}} only of a comprehensive annual teaching program for a composite {{year_levels}} {{subject_name}} class, where all year levels are taught together in the same {{learning_environment}}.

This is {{part_number}} of a four-part annual program. Do not attempt to plan the entire year. Focus exclusively on creating the highest quality, most detailed, and practical {{term}} program possible. The completed program should be suitable for immediate implementation by a Queensland secondary teacher in a {{school_context}}.

⸻

Teaching Context

Design the program around the following teaching context:

Composite {{year_levels}} {{subject_name}} class taught together in one {{learning_environment}}.
Students attend {{lessons_per_week}} lessons each week, each {{lesson_duration}} in duration.
Assume a standard Queensland school term of approximately {{weeks_per_term}} teaching weeks.
Plan for approximately {{lessons_per_term}} lessons per term.
Allow flexibility for interruptions such as public holidays, school events, assessment weeks and student absences.
Every lesson must include sufficient time for: lesson introduction, attendance, safety briefing, teacher demonstration, guided practice, independent practical work, cleanup, equipment return, and student reflection.
Reserve approximately 10–15 minutes at the end of every lesson for cleaning the {{learning_environment}}, equipment return and pack-up.
Lessons must be realistically achievable within {{lesson_duration}} without rushing students.
Embed theory naturally throughout practical lessons wherever possible rather than teaching theory separately, except where explicit safety or design instruction is required.
Sequence activities so that students can successfully complete the major project within the available teaching time, while allowing flexibility for students working at different rates.
Include strategies to help absent students catch up without disrupting the flow of the class.

⸻

Curriculum Requirements

Align the program with:

Australian Curriculum Version 9.0
Queensland Department of Education requirements
{{curriculum_area}} curriculum
Queensland Work Health and Safety legislation where applicable
Safe operation of {{tools_and_equipment}}
Industry best practice for {{subject_name}}
Universal Design for Learning (UDL)
Explicit Teaching
High Impact Teaching Strategies
Positive Behaviour for Learning (PBL)
Differentiated instruction
Inclusive education practices
Aboriginal and Torres Strait Islander Histories and Cultures where authentic and appropriate
Sustainability where appropriate
Ethical use of technology where applicable

⸻

Teaching Philosophy

Design the entire term around a spiral curriculum.

All students should generally work on the same project and skills simultaneously, with differentiation achieved through increasing levels of complexity rather than completely different projects.

Differentiate through:
project complexity, design expectations, accuracy, independence, craftsmanship, tool competency, machine competency, documentation, problem-solving, and assessment expectations.

The aim is to maximise {{learning_environment}} efficiency while ensuring every student is appropriately challenged.

⸻

Program Requirements

1. Term Overview

Produce a detailed overview including: Unit title, Unit rationale, Duration, Big Ideas, Essential Questions, Learning Intentions, Success Criteria, Achievement Standards, Australian Curriculum Version 9 Content Descriptors (cited by code), General Capabilities, Cross-Curriculum Priorities, Required resources, Materials list, Equipment/machinery required, Safety requirements, Risk management considerations, and Assessment schedule.
Explain the educational reasoning behind the unit design.

2. Skills Progression

Develop a logical progression of {{specialisation}} knowledge and practical skills appropriate for {{subject_name}}, including {{learning_environment}} expectations, PPE, and the safe use of {{tools_and_equipment}}.
Identify the specific competencies students should achieve during {{term}}.

3. Major Project

Recommend one major {{project_type}} — the {{project_name}} — suitable for all {{year_levels}}.
Explain: why the project is suitable, what skills it develops, estimated completion timeline, assessment opportunities, how it is differentiated for each year level, extension opportunities, common misconceptions, and likely student challenges.

4. Weekly Teaching Program

Develop a complete week-by-week teaching program for the entire term.
For every teaching week, divide the week into the two actual lessons taught.

Lesson 1 ({{lesson_duration}})
Include: Learning Intention; Success Criteria; Lesson timings (e.g. Welcome – 5 min, Safety briefing – 5 min, Demonstration – 10 min, Guided practice – 15 min, Independent practical work – 25 min, Reflection – 5 min, Cleanup – 5 min); Starter activity; Review of prior learning; Explicit instruction; Teacher modelling; Guided practice; Independent practice; Practical {{subject_name}} learning activities; Literacy focus; Numeracy focus; Digital Technologies integration (where appropriate); Aboriginal and Torres Strait Islander perspectives (where authentic); Safety focus; Required resources; Teacher preparation; Formative assessment; Reflection; Exit ticket; and {{learning_environment}} cleanup routine.
Cite the specific Australian Curriculum Version 9 content descriptor codes and achievement standard elements addressed in this lesson.

Lesson 2 ({{lesson_duration}})
Include the same level of detail as Lesson 1, including cited curriculum codes.

5. Lesson Design

Each lesson should follow an Explicit Teaching model with realistic timings and be achievable within {{lesson_duration}}.

6. Differentiation

For every week's learning, explain practical, classroom-ready adjustments for: Year 7, Year 8, Year 9, Year 10, high-achieving students, students requiring additional learning support, students with literacy difficulties, EAL/D learners, and students requiring reasonable adjustments. Provide concrete strategies rather than general statements.

7. Assessment

Include: Diagnostic assessment; Formative assessment; Summative assessment opportunities ({{assessment_type}}); Teacher observation checklists; Practical competency checklists; Student self-assessment; Peer assessment; Evidence collection suggestions; Rubric recommendations; and Moderation notes.

8. Behaviour and {{learning_environment}} Management

Develop consistent routines for: entering the {{learning_environment}}, attendance, PPE, equipment and resource distribution, teacher demonstrations, safe movement around {{tools_and_equipment}}, safe operation of {{tools_and_equipment}}, safe behaviour, emergency procedures, expectations, cleanup, equipment return and storage, and end-of-lesson pack-up.

9. Supporting Resources

Recommend: printable worksheets, theory notes, safety posters, practical demonstrations, instructional videos, extension activities, intervention activities, homework (where appropriate), revision resources, and teacher checklists. Where relevant, reference {{software}}.

⸻

Output Requirements

Present the response using professional headings, tables and clearly organised sections suitable for immediate classroom use.
Where possible, explain the educational reasoning behind recommendations rather than simply listing information.
Provide sufficient detail so that another Queensland teacher could confidently teach the entire term using this document.
Do not abbreviate sections or provide summaries.
Produce a comprehensive planning document suitable for direct implementation in a {{school_context}}.

Focus exclusively on {{term}}. Do not begin planning the other terms.

At the conclusion of the document, provide recommendations for improvements to the following term based on the intended progression of student knowledge, skills and competencies — but do not develop that term's program itself.
```

---

## Optional follow-up prompts (for the staged build)

After Corella produces the term program, you can go deeper with these short prompts
(they reuse the same Value Block variables):

**Expand a single week into full lessons**
```text
Using the {{term}} program you just produced for the composite {{year_levels}} {{subject_name}} class, expand Week {{week_number}} into two fully detailed {{lesson_duration}} lessons with minute-by-minute timings, teacher scripts for the explicit instruction, and cited Australian Curriculum Version 9 content descriptor codes.
```

**Generate assessment tools**
```text
For the {{project_name}} project in {{subject_name}}, produce a marking rubric differentiated across {{year_levels}}, a practical competency checklist, and a student self-assessment sheet, aligned to Australian Curriculum Version 9 achievement standards.
```

**Generate student-facing resources**
```text
Create student-facing resources for {{term}} {{subject_name}}: a one-page project brief for the {{project_name}}, a step-by-step build guide with safety reminders, and a literacy support glossary of key {{specialisation}} terms.
```
