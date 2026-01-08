# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# Plugin Name: gsed
# Repository: https://github.com/johnstonskj/zsh-gsed-plugin
#
# Description:
#
#   Add one-line description here...
#
# Public variables:
#
# * `GSED`; plugin-defined global associative array with the following keys:
#   * \`_ALIASES\`; a list of all aliases defined by the plugin.
#   * \`_FUNCTIONS\`; a list of all functions defined by the plugin.
#   * \`_PLUGIN_DIR\`; the directory the plugin is sourced from.
#

############################################################################
# Standard Setup Behavior
############################################################################

# See https://wiki.zshell.dev/community/zsh_plugin_standard#zero-handling
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# See https://wiki.zshell.dev/community/zsh_plugin_standard#standard-plugins-hash
declare -gA GSED
GSED[_PLUGIN_DIR]="${0:h}"
GSED[_FUNCTIONS]=""

############################################################################
# Internal Support Functions
############################################################################

#
# This function will add to the `GSED[_FUNCTIONS]` list which is
# used at unload time to `unfunction` plugin-defined functions.
#
# See https://wiki.zshell.dev/community/zsh_plugin_standard#unload-function
# See https://wiki.zshell.dev/community/zsh_plugin_standard#the-proposed-function-name-prefixes
#
.gsed_remember_fn() {
    builtin emulate -L zsh

    local fn_name="${1}"
    if [[ -z "${GSED[_FUNCTIONS]}" ]]; then
        GSED[_FUNCTIONS]="${fn_name}"
    elif [[ ",${GSED[_FUNCTIONS]}," != *",${fn_name},"* ]]; then
        GSED[_FUNCTIONS]="${GSED[_FUNCTIONS]},${fn_name}"
    fi
}
.gsed_remember_fn .gsed_remember_fn

.gsed_define_alias() {
    local alias_name="${1}"
    local alias_value="${2}"

    alias ${alias_name}=${alias_value}

    if [[ -z "${GSED[_ALIASES]}" ]]; then
        GSED[_ALIASES]="${alias_name}"
    elif [[ ",${GSED[_ALIASES]}," != *",${alias_name},"* ]]; then
        GSED[_ALIASES]="${GSED[_ALIASES]},${alias_name}"
    fi
}
.gsed_remember_fn .gsed_define_alias

#
# This function does the initialization of variables in the global variable
# `GSED`. It also adds to `path` and `fpath` as necessary.
#
gsed_plugin_init() {
    builtin emulate -L zsh
    builtin setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    .gsed_define_alias sed 'gsed'
    .gsed_define_alias sedi 'gsed -i'
}
.gsed_remember_fn gsed_plugin_init

############################################################################
# Plugin Unload Function
############################################################################

# See https://wiki.zshell.dev/community/zsh_plugin_standard#unload-function
gsed_plugin_unload() {
    builtin emulate -L zsh

    # Remove all remembered functions.
    local plugin_fns
    IFS=',' read -r -A plugin_fns <<< "${GSED[_FUNCTIONS]}"
    local fn
    for fn in ${plugin_fns[@]}; do
        whence -w "${fn}" &> /dev/null && unfunction "${fn}"
    done
    
    # Remove all remembered aliases.
    local aliases
    IFS=',' read -r -A aliases <<< "${GSED[_ALIASES]}"
    local alias
    for alias in ${aliases[@]}; do
        unalias "${alias}"
    done

    # Remove the global data variable.
    unset GSED

    # Remove this function.
    unfunction gsed_plugin_unload
}

############################################################################
# Initialize Plugin
############################################################################

gsed_plugin_init

true
