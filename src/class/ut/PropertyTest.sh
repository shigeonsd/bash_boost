#! /bin/bash
#
# PropertyTest.sh -- PropertyTest クラス
#
#
use Object;

# Constructor
function PropertyTest() {
    local ___super=null;
    local ___class=${FUNCNAME};
    local ___this="$1";
    shift;

    public    string   name     = "Shigeo NISHIDA";
    public    any      addr     = "Kochi, Japan ";
    protected int      age      = "51";
    private   date     birthday = "1971/02/15";
    private   datetime now      = "$(date '+%Y/%m/%d %T')";

    _new "$@";
}
