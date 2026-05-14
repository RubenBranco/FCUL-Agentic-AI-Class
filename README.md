# FCUL Agentic AI Class

Materials for a 45–60 minute workshop-style class delivered as part of **Introdução à Inteligência Artificial** (Intro to AI) at FCUL. The workshop walks students through using agentic coding tools (Claude Code, Cursor, Copilot, etc.) to build a small classifier that labels GitHub issues as **bug**, **feature**, or **question**.

The point isn't the classifier, it's the loop: **plan, prompt, verify, review**. Additionally, it stands to showcase students the bleeding edge of AI, and how it is being applied to Software Engineering.

## Contents

- [`WORKSHOP.md`](WORKSHOP.md) — the workshop script: prompts to give the agent, things to push back on, what to watch for.
- [`scripts/fetch_data.sh`](scripts/fetch_data.sh) — pulls the NLBSE'24 dataset at setup time (see [`data/README.md`](data/README.md) for why it isn't redistributed).

## Setup

```bash
git clone git@github.com:RubenBranco/FCUL-Agentic-AI-Class.git
cd FCUL-Agentic-AI-Class
uv sync
./scripts/fetch_data.sh
```

Requires Python 3.10+ and [uv](https://docs.astral.sh/uv/). Windows: use WSL.

## License

Code in this repository is released under the [Apache 2.0 License](LICENSE). The dataset is *not* included and is governed by its upstream source.
