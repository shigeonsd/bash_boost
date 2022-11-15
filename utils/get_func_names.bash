#! /bin/bash
cat ${1} \
    | grep "^function" \
    | sed -e 's/().*$//' \
          -e 's/^function //' \
    | awk '
/^__$/ {
    print;
}
/^_.*$/ {
    next;
}
{
    print;
}
'
