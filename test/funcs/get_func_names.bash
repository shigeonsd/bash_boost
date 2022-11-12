#! /bin/bash
source ${1};
declare -f \
    | grep " () $" \
    | sed -e 's/ () $//' \
    | awk '
/^__[^_]+$/ {
    next;
}
/^_[^_]+$/ {
    next;
}
{
    print;
}
'
