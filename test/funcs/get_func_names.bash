source ${1};
declare -f | grep " () " | grep -v '^[_]' | grep ' () $' | sed -e 's/ () $//'
