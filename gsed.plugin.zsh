# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# @name: gsed
# @brief: Replace `sed`` with GNU sed (`gsed`).
# @repository: https://github.com/johnstonskj/zsh-gsed-plugin
# @version: 0.1.1
# @license: MIT AND Apache-2.0
#

############################################################################
# @section Lifecycle
# @description Plugin lifecycle functions.
#

gsed_plugin_init() {
    builtin emulate -L zsh

    @zplugins_define_alias gsed sed 'gsed'
    @zplugins_define_alias gsed sedi 'gsed -i'
}
