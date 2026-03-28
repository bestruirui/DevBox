# ==============================================================================
# bestrui.zsh-theme
# ==============================================================================

# 命令状态指示符
# > 绿色: 上一条命令成功
# > 红色: 上一条命令失败
local ret_status="%(?:%{$fg_bold[green]%}>:%{$fg_bold[red]%}>)"

# 自定义路径显示函数
# /workplace 路径显示为 @/剩余路径
# 其他路径截断为最后 3 级目录
custom_pwd() {
  if [[ "$PWD" == /workplace* ]]; then
    local remaining="${PWD#/workplace}"
    # 截断为最后 3 级
    echo "@$(echo "$remaining" | awk -F/ '{if(NF>3) print "/../" $(NF-2) "/" $(NF-1) "/" $NF; else print $0}')"
  else
    print -P "%(4~|.../%3~|%~)"
  fi
}

# Git 分支颜色函数
# main/master 显示为绿色，其他分支显示为红色
git_branch_color() {
  local branch=$(git_current_branch)
  if [[ "$branch" == "main" || "$branch" == "master" ]]; then
    echo "%{$fg[green]%}"
  else
    echo "%{$fg[red]%}"
  fi
}

# 主提示符
# 格式: [状态] [路径] (git分支) $
# root 用户 $ 显示为红色
PROMPT='${ret_status} %{$fg[cyan]%}$(custom_pwd)%{$fg_bold[blue]%}$(git_prompt_info)%{$reset_color%} %(!.%{$fg_bold[red]%}#.%{$fg[white]%}$)%{$reset_color%} '

# Git 分支显示
ZSH_THEME_GIT_PROMPT_PREFIX=" ($(git_branch_color)"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Git 状态符号 (显示在右侧提示符)
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%} +"      # 已暂存的新文件
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} ~" # 已修改的文件
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} -"     # 已删除的文件
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%} >"    # 重命名的文件
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%} !" # 合并冲突
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[white]%} ?" # 未跟踪的文件

# 右侧提示符: git 状态 + 时间戳
RPROMPT='$(git_prompt_status)%{$reset_color%} %{$fg[white]%}%T%{$reset_color%}'
