# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# @name gsed
# @brief Zsh plugin to replace sed with GNU sed aliases.
# @repository https://github.com/johnstonskj/zsh-gsed-plugin
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
