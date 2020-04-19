#!/bin/bash

# Colours
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

function write_kubeconfig {
    # If KUBECONFIG_DATA is set: dump to kubeconfig file
    if [ -n "${KUBECONFIG_DATA}" ]; then
        echo -e "${GREEN}>> kubeconfig data provided: Writing to ${POPEYE_HOME}/.kube/config${NC}"
        mkdir -p "${POPEYE_HOME}"/.kube
        echo "${KUBECONFIG_DATA}" > "${POPEYE_HOME}"/.kube/config
        export KUBECONFIG="${POPEYE_HOME}"/.kube/config
    else
        echo -e "${RED}>> ERROR: Please provide KUBECONFIG_DATA from secrets.${NC}"
        exit 1 
    fi
}

function report_to_pr {
    # Write report back to Pull Request
    PR_COMMENT=${1}
    if [ "$GITHUB_EVENT_NAME" == "pull_request" ]; then
        
        # shellcheck disable=SC2001
        PR_COMMENT_SANITIZED=$(echo "${PR_COMMENT}" | sed 's/\x1b\[[0-9;]*m//g')
        COMMENT_PAYLOAD=$(echo "${PR_COMMENT_SANITIZED}"| jq -R --slurp '{body: .}')
        # shellcheck disable=SC2002
        PR_PATH=$(cat "${GITHUB_EVENT_PATH}" | jq -r .pull_request.comments_url)
       echo ">> Send Report back to Pull Request... (Path: ${PR_PATH} ) "
        # Post back to Pull Request
        echo "${COMMENT_PAYLOAD}" | curl -s -S -H "Authorization: token ${GITHUB_TOKEN}" --header "Content-Type: application/json" --data @- "${PR_PATH}" > /dev/null
    fi
}

function run_popeye {
    # Run Popeye

    # Run popeye (standard) report and get score
    POPEYE_REPORT=$("${POPEYE_HOME}"/popeye "${POPEYE_FLAGS}")
    POPEYE_SCORE=$("${POPEYE_HOME}"/popeye "${POPEYE_FLAGS}" -o score)

    echo "${POPEYE_REPORT}"

    # Disabled for now
    # report_to_pr "${POPEYE_REPORT}"

    # Validate Score
    if [ "${POPEYE_SCORE}" -lt "${POPEYE_MIN_SCORE}" ]; then
        # Cluster score is under the threshold
        echo -e "${RED}>> ERROR: Cluster score (${POPEYE_SCORE}) is under the threshold (${POPEYE_MIN_SCORE}).${NC}"
        exit 1
    fi

    echo -e "${GREEN}>> Test passed!${NC}"
    exit 0
}

### MAIN ###
write_kubeconfig
run_popeye