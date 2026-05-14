# Workshop dataset

The CSVs used in this workshop (`issues_train.csv`, `issues_test.csv`) come from
the NLBSE'24 issue-report classification dataset:

  https://github.com/nlbse2024/issue-report-classification

They are **not redistributed** in this repository — the upstream repo carries
no license, so we don't have the right to re-host the files. To get them, run
the fetch script once after `uv sync`:

```bash
./scripts/fetch_data.sh
```

The script shallow-clones the upstream repo into a temp directory, moves the
two CSVs into this `data/` folder, and cleans up.

## Citation

If you use the dataset beyond this workshop, please cite the original authors.
The full BibTeX entries are in the upstream repository's README under
**Citing related work**.
