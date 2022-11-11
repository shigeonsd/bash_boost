#! /bin/bash
#
# load.sh -- モジュールに関する定義
#
__load_silence=false;
function if_load_silence_true() {
    if_true __load_silence
}

function __defun_load_func() {
    local funcname="$1";
    local tmplfunc="$2";
    if_load_silence_true && tmplfunc=mod_nop;
    defun "${funcname}" "${tmplfunc}";
}

function defun_load_info() {
    __defun_load_func $1 mod_info;
}

function defun_load_debug() {
    __defun_load_func $1 mod_debug;
}

defun_load_info  __load_info;
defun_load_debug __load_debug;

function __invoke_init() {
    local module_name="$1";
    local func="_${module_name}_init";
    exist_func "$func" || return;
    __load_info  "Initializing ${module_name}... ";
    "${func}";
    __load_info "done";
}

function __add_cleanup() {
    local module_name="$1";
    local func="_${module_name}_cleanup";
    exist_func "$func" || return;
    __cleanup_funcs+=("${func}");
}

function __load_if_exist() {
    exist_file "$1" && {
	source "$1";
	__load_info "$1";
    }
}

function _load() {
    local module_name="$1";

    [ -v "__${module_name}_loaded" ] && return ;

    __load_info "Loading ${module_name}... ";
    __load_if_exist "${progdir}/${module_name}.sh" \
	|| __load_if_exist "${modules_dir}/${module_name}.sh" \
	    || die "Module not found. '${module_name}'";
    __load_info "done";

    __add_cleanup "${module_name}";
    __invoke_init "${module_name}";
    eval "__${module_name}_loaded=1";
}

function load() {
    case $1 in
    -s) __load_silence=true; 
	defun_load_info  __load_info;
	defun_load_debug __load_debug;
	shift; ;;
    -v) __load_silence=false;
	defun_load_info  __load_info;
	defun_load_debug __load_debug;
	shift; ;;
    esac

    loca lmod;
    for mod in $@; do
	_load "${mod}";
    done;
}

function _interface() {
    local func="$1"
    exist_func "${func}" || die "Function not found. '${func}'";
}

function interface() {
    for f in $@; do
	_interface "${f}";
    done;
}

function get_module_name() {
    echo $1 | sed -e 's/^__//' -e 's/_.*$//';
}

function __on_exit() {
    for f in "${__cleanup_funcs[@]}"; do
	echo $f;
    done \
    | tac \
    | while read cleanup; do
	__load_info "Cleanup $(echo ${cleanup} | sed -e 's/^_//' -e 's/_cleanup//')... ";
	"${cleanup}";
	__load_info "done";
    done;
}

__cleanup_funcs=();
trap __on_exit EXIT;
