# GitHub commits by date

Usage:
```
Usage: ./print-github-commits-by-date.sh [options]
Requirements: set local environment variable GITHUB_API_TOKEN to your GitHub API token: https://docs.github.com/en/rest/overview/other-authentication-methods#via-oauth-tokens
  The token should not require any priviledges, with private repositories allow the `repo`-flag (not tested).
Options:
  -h, --help
  -o, --owner <repository owner>
  -a, --author <username>
  -d, --date <YYYY-MM-DD>
```

Example:
```
./print-github-commits-by-date.sh -o lsipii -a lsipii -d 2024-01-30
###
### Author: lsipii
### Organization: lsipii
### Date: 2024-01-30
###
-----------------------------------------------------------------
Repository: --> github-commits-by-date <--
Update README.md
Create README.md

###
```
