#/usr/bin/env bash
# see: https://docs.github.com/en/rest/commits/commits#list-commits
set -e

print_usage() {
    echo "Usage: $0 [options]"
    echo "Requirements: set local environment variable GITHUB_API_TOKEN to your GitHub API token: https://docs.github.com/en/rest/overview/other-authentication-methods#via-oauth-tokens"
    echo "Options:"
    echo "  -h, --help"
    echo "  -o, --owner <repository owner>"
    echo "  -a, --author <username>"
    echo "  -d, --date <YYYY-MM-DD>"
}

print_commits() {
    local OWNER="$1"
    local AUTHOR="$2"
    local DATE="$3"
    local SINCE="${DATE}T00:00:00Z"
    local UNTIL="${DATE}T23:59:59Z"

    #REPOSITORIES=$(gh api -H "Accept: application/vnd.github+json" "/users/${OWNER}/repos" | jq -r '.[].name')
    REPOSITORIES=$(curl -s \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${GITHUB_API_TOKEN}"\
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "https://api.github.com/users/${OWNER}/repos" \
        | jq -r '.[].name')

    echo "###"
    echo "### Author: ${AUTHOR}"
    echo "### Organization: ${OWNER}"
    echo "### Date: ${DATE}"
    echo "###"

    for REPO in ${REPOSITORIES}; do
        #local REPOSITORY_COMMITS=$(gh api -H "Accept: application/vnd.github+json" "/repos/${OWNER}/${REPO}/commits?author=${AUTHOR}&since=${SINCE}&until=${UNTIL}" | jq -r '.[].commit.message')
        local REPOSITORY_COMMITS=$(curl -s \
            -H "Accept: application/vnd.github+json" \
            -H "Authorization: Bearer ${GITHUB_API_TOKEN}"\
            -H "X-GitHub-Api-Version: 2022-11-28" \
            "https://api.github.com/repos/${OWNER}/${REPO}/commits?author=${AUTHOR}&since=${SINCE}&until=${UNTIL}" \
            | jq -r '.[].commit.message')
        
        if [ -z "${REPOSITORY_COMMITS}" ]; then
            continue
        fi
        echo "-----------------------------------------------------------------"
        echo "Repository: --> ${REPO} <--"
        echo "${REPOSITORY_COMMITS}"
        echo ""
    done
    echo "###"
}

main() {
    if [ -z "${GITHUB_API_TOKEN}" ]; then
        echo "GITHUB_API_TOKEN is not set"
        print_usage
        exit 1
    fi

    local OWNER=""
    local AUTHOR=""
    local DATE=""

    # If no arguments, print usage and exit
    if [ $# -eq 0 ]; then
        print_usage
        exit 1
    fi

    while [ $# -gt 0 ]; do
        key="$1"
        case $key in
            -h|--help)
                print_usage
                exit 0
                break
                ;;
            -o|--owner)
                OWNER="$2"
                shift
                shift
                ;;
            -a|--author)
                AUTHOR="$2"
                shift
                shift
                ;;
            -d|--date)
                DATE="$2"
                shift
                shift
                ;;
            *)
                echo "Unknown option: $1"
                print_usage
                exit 1
                ;;
        esac
    done

    if [ -z "${OWNER}" ] || [ -z "${AUTHOR}" ] || [ -z "${DATE}" ]; then
        echo "Missing required arguments"
        print_usage
        exit 1
    fi

    print_commits ${OWNER} ${AUTHOR} ${DATE}
}

main "$@"