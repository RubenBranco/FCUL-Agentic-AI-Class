#!/usr/bin/env bash
set -euo pipefail

UPSTREAM_URL="https://github.com/nlbse2024/issue-report-classification.git"
FILES=("issues_train.csv" "issues_test.csv")

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATA_DIR="${REPO_ROOT}/data"

mkdir -p "${DATA_DIR}"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

echo "Cloning ${UPSTREAM_URL} (shallow)..."
git clone --depth 1 --quiet "${UPSTREAM_URL}" "${TMP_DIR}/repo"

for f in "${FILES[@]}"; do
  src="${TMP_DIR}/repo/data/${f}"
  dst="${DATA_DIR}/${f}"
  if [[ ! -f "${src}" ]]; then
    echo "Error: ${f} not found in upstream data/ — has the upstream layout changed?" >&2
    exit 1
  fi
  mv "${src}" "${dst}"
  echo "Wrote ${dst}"
done

echo "Done. Dataset is in ${DATA_DIR}/."
