# Popeye action

This action runs [Popeye](https://github.com/derailed/popeye) report (standard) and validates that the score is over the given threshold.

## Environment Variables

### KUBECONFIG_DATA

**Required** Full kubeconfig data that Popeye will use to connect to the cluster.

### POPEYE_MIN_SCORE

Minimum score for the cluster to pass the Popeye Analysis.
*Default value: 50*

### POPEYE_FLAGS

Flags for Popeye to run the report and tests.
*Default value: -A*

## Outputs

* Comment to the Open PR (if any).
* Exit code 1 if score is under ther given threshold, 0 otherwise.

##  Example Usage

This example gets the kubeconfig from Github secrets and validates that the cluster score is more or equal than 80:
```yaml
on:
  pull_request:
    types: [opened, synchronize]

jobs:
  popeye_job:
    runs-on: ubuntu-latest
    name: Popeye Validation
    steps:
    - name: Popeye Score
      id: popeye-score
      uses: actions/popeye-github-actions@v8
      env:
        KUBECONFIG_DATA: ${{ secrets.KUBECONFIG_DATA }}
        POPEYE_MIN_SCORE: 80
```