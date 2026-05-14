# Workshop: Building an Issue Classifier with Agentic Coding Tools

This is a short, live demo of using agentic coding tools (e.g., Claude Code, Cursor, Copilot) to build a small machine learning classifier that labels GitHub issues as **bug**, **feature**, or **question**.

The goal is not to ship a finished classifier in 25 minutes. The goal is to show you how a professional uses these tools: planning before prompting, verifying every step, and catching the mistakes the agent will inevitably make.

If you want to keep going after the demo, the **Optional Extensions** at the end walk you through completing the project on your own.

## Prerequisites

- Python 3.10+ with [uv](https://docs.astral.sh/uv/) installed
- An agentic coding tool of your choice
- The [NLBSE'24 dataset](https://github.com/nlbse2024/issue-report-classification) (3,000 labeled issues from react, tensorflow, vscode, bitcoin, and opencv)
- Windows users: run inside WSL. But switch to Linux, seriously.

## Setup

```bash
git clone git@github.com:RubenBranco/FCUL-Agentic-AI-Class.git
cd FCUL-Agentic-AI-Class
uv sync
./scripts/fetch_data.sh
```

The fetch script shallow-clones the upstream [NLBSE'24 dataset](https://github.com/nlbse2024/issue-report-classification) into a temp folder and moves `issues_train.csv` and `issues_test.csv` into `data/`. We pull at setup time rather than re-hosting because the upstream repo carries no license. Each row has five columns: `repo`, `created_at`, `label`, `title`, `body`.

---

## Step 1: Understand the Repository and the Data

**Goal:** Get the agent to explore an unfamiliar codebase and dataset, and produce something concrete you can read.

**What to ask the agent:**

> "You are a software engineer joining this project. Look at the files and folders to understand what's here, then look at the dataset and tell me what's in it. Make me an HTML overview of the repository structure and a short summary of the data — class distribution, average text length, anything that looks unusual."

- **Role definition** — telling the agent it is "a software engineer joining this project" gives it a perspective and a task framing
- **Concrete output format** — asking for an HTML overview gives the agent a clear deliverable rather than a vague chat response
- **Two-part instruction** — explore the code *and* explore the data; agents often skip one if you don't ask explicitly

**Key questions to answer:**

- How many issues per class? Is the dataset balanced?
- How many issues per repository?
- How long are titles and bodies on average? Are there outliers?
- Are there any obvious problems with the text (HTML, code blocks, empty bodies, non-English content)?

**What to watch for:** The agent may give you a confident overview that misses something important — like empty rows, or that the body field contains HTML markup. Read its summary critically and spot-check by opening the CSV yourself.

---

## Step 2: Train a Baseline Classifier and Evaluate It

**Goal:** Build a simple classifier, train it, and report meaningful metrics — with the agent thinking through the design before writing code.

**What to ask the agent:**

> "Plan a baseline approach for classifying issues as bug / feature / question. Think about: what features to use, what model to start with, how to split the data, what metrics to report, and whether class balance matters here. Ask me clarifying questions before writing any code. Only build it after we agree on the plan."

- **"Plan ... ask me clarifying questions"** — prevents the agent from rushing into code; it should propose an approach and surface the choices
- **"Only build after we agree"** — separates thinking from doing; you review the plan before any code is written
- **Listing the dimensions to think about** — gives the agent a structure for its plan; without it, you often get a one-line "I'll use TF-IDF and logistic regression" that skips the interesting questions

**Things to push back on during planning:**

- The dataset already has a train/test split — make sure the agent uses it and doesn't re-split (a classic source of data leakage).
- What does the agent choose as the baseline? TF-IDF + logistic regression is a fine starting point; if the agent jumps straight to a transformer, ask why.
- What metrics? For three balanced classes, accuracy is fine, but per-class precision/recall/F1 is more informative.
- The published baseline on this dataset is around **0.83 F1**. If your classifier scores 0.99, something is wrong (probably leakage). If it scores 0.50, something is broken.

**Once it has built the classifier, ask it to review its own work:**

> "Now review what you built. Check for data leakage between train and test, whether the metrics are computed correctly, and whether the code does what we agreed it would do. Be skeptical of your own previous work."

- **"Be skeptical of your own previous work"** — agents tend to defend what they wrote; this prompt gives explicit permission to find mistakes
- This compresses the planning–build–review loop into one demo, which is the actual professional workflow

**What to watch for:** Confidently wrong code. The agent may train on the test set, fit the vectorizer on combined train+test data, or report metrics on the training set. Read the data flow carefully.

---

## Wrap-Up

In 20 minutes you have seen the loop that matters: **plan, prompt, verify, review**. The classifier itself is a side effect. The real lesson is that the agent is a fast collaborator that is confidently wrong on a regular basis — and the habits of planning and verification are what make it useful instead of dangerous.

---

## Optional Extensions

If you want to take this further on your own, here is what we skipped in the live demo. Each of these is a natural next step.

### Optional 1: Build a Tested Preprocessing Pipeline

Before training, real projects need a proper preprocessing module — not just inline cleanup in a notebook. Try this:

> "We need a preprocessing module that takes raw issue text and produces clean text ready for a classifier. Write the tests first — cover edge cases like empty bodies, HTML markup, code blocks, emojis, and very long text. Then write the implementation. Keep it as a small Python module, not a notebook."

The "tests first" instruction forces a TDD workflow: tests catch edge cases before they become bugs. Run the tests yourself before moving on. **Watch out for trivially-passing tests** — agents sometimes write assertions like `clean(x) == clean(x)` that test nothing. Read the assertions, not just the test names.

### Optional 2: Deep Review and Error Analysis

Take the classifier you built in Step 2 and dig into where it fails:

> "Look at a sample of misclassified examples on the test set. For each one, show me the issue text, the predicted label, and the true label. Group them by failure mode and tell me what patterns you see."

Then look at the confusion matrix yourself. Which classes get confused with each other? Does that make sense? Pick three or four misclassified examples and ask yourself: could *you* tell what the right label should be? If you can't, the model arguably can't either — which tells you something about the dataset, not the model.

### Optional 3: Compare Across Repositories

The dataset has issues from five different projects (react, tensorflow, vscode, bitcoin, opencv). Does your classifier work equally well on all of them?

> "Evaluate the classifier separately on each of the five repositories in the test set. Show me a per-repository breakdown of precision, recall, and F1. Do you notice any patterns?"

This is a great example of the kind of analysis you would never bother to do by hand but takes the agent two minutes — and the patterns it surfaces (e.g., bitcoin issues being harder to classify than react issues) often lead to genuinely interesting follow-up questions.

### Optional 4: Reflection

Whatever you build, end with these questions:

- At which step did the agent help you most? Where did it slow you down or mislead you?
- What did you have to verify or correct yourself?
- Could you reproduce this work in six months from your commit history alone?

That last question is the one most students don't think about. It's also the one your future self (and your future colleagues) will care about most.
