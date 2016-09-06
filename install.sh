#!/usr/bin/env bash
# bash-it installer

# Show how to use this installer
function show_usage() {
  echo -e "\n$0 : Install bash-it"
  echo -e "Usage:\n$0 [arguments] \n"
  echo "Arguments:"
  echo "--help (-h): Display this help message"
  echo "--silent (-s): Install default settings without prompting for input";
  echo "--interactive (-i): Interactively choose plugins"
  exit 0;
}

# enable a thing
function load_one() {
  file_type=$1
  file_to_enable=$2
  mkdir -p "$BASH_IT/${file_type}/enabled"

  dest="${BASH_IT}/${file_type}/enabled/${file_to_enable}"
  if [ ! -e "${dest}" ]; then
    ln -sf "../available/${file_to_enable}" "${dest}"
  else
    echo "File ${dest} exists, skipping"
  fi
}

# Interactively enable several things
function load_some() {
  file_type=$1
  [ -d "$BASH_IT/$file_type/enabled" ] || mkdir "$BASH_IT/$file_type/enabled"
  for path in `ls $BASH_IT/${file_type}/available/[^_]*`
  do
    file_name=$(basename "$path")
    while true
    do
      read -e -n 1 -p "Would you like to enable the ${file_name%%.*} $file_type? [y/N] " RESP
      case $RESP in
      [yY])
        ln -s "../available/${file_name}" "$BASH_IT/$file_type/enabled"
        break
        ;;
      [nN]|"")
        break
        ;;
      *)
        echo -e "\033[91mPlease choose y or n.\033[m"
        ;;
      esac
    done
  done
}

# A mapping from template files to the configuration files that we want to
# replace. The configuration files are assumed to be in the home directory.
# This uses arrays to define the mapping. See 
# http://stackoverflow.com/questions/688849/associative-arrays-in-shell-scripts
# for the non-bash 4 way using this approach
template_files=( "bash_profile.template.bash:.bash_profile"
                 "bashrc.template.bash:.bashrc"
                 "profile.template.sh:.profile" )

# Back up existing configuration files and create new ones for bash-it
function backup_append() {
  for template in "${template_files[@]}"
  do
    src=${template%%:*}
    dest=${template#*:}
    template_file="${BASH_IT}/template/${src}"
    config_file="${HOME}/${dest}"
    test -w "${config_file}" &&
      cp -aL "${config_file}" "${config_file}.bak" &&
      echo -e "\033[0;32mYour original ${config_file} has been backed up to ${config_file}.bak\033[0m"
    sed "s|{{BASH_IT}}|$BASH_IT|" "${template_file}" >> "${config_file}"
    echo -e "\033[0;32mAppended the template ${template_file} to ${config_file}, edit this file to customize bash-it\033[0m"
  done
}

# Back up existing configuration files and create new ones for bash-it
function backup_new() {
  for template in "${template_files[@]}"
  do
    src=${template%%:*}
    dest=${template#*:}
    template_file="${BASH_IT}/template/${src}"
    config_file="${HOME}/${dest}"
    test -w "${config_file}" &&
      cp -aL "${config_file}" "${config_file}.bak" &&
      echo -e "\033[0;32mYour original ${config_file} has been backed up to ${config_file}.bak\033[0m"
    sed "s|{{BASH_IT}}|$BASH_IT|" "${template_file}" > "${config_file}"
    echo -e "\033[0;32mCopied the template ${template_file} into ${config_file}, edit this file to customize bash-it\033[0m"
  done
}

# Check to see if any backup files already exist
function backup_exists() {
  local retval=1
  for template in "${template_files[@]}"
  do
    src=${template%%:*}
    dest=${template#*:}
    backup_file="${HOME}/${dest}.bak"
    [ -e "${backup_file}" ] && 
      echo -e "\033[0;33mBackup file ${backup_file} exists.\033[0m" &&
      retval=0
  done
  return $retval
}

# Process command line options
for param in "$@"; do
  shift
  case "$param" in
    "--help")        set -- "$@" "-h" ;;
    "--silent")      set -- "$@" "-s" ;;
    "--interactive") set -- "$@" "-i" ;;
    *)               set -- "$@" "$param"
  esac
done

OPTIND=1
while getopts "hsi" opt
do
  case "$opt" in
  "h") show_usage; exit 0 ;;
  "s") silent=true ;;
  "i") interactive=true ;;
  "?") show_usage >&2; exit 1 ;;
  esac
done
shift $(expr $OPTIND - 1)

if [[ $silent ]] && [[ $interactive ]]; then
  echo -e "\033[91mOptions --silent and --interactive are mutually exclusive. Please choose one or the other.\033[m"
  exit 1;
fi

BASH_IT="$(cd "$(dirname "$0")" && pwd)"

case $OSTYPE in
  darwin*)
    CONFIG_FILE=.bash_profile
    ;;
  *)
    CONFIG_FILE=.bashrc
    ;;
esac

#------------------------------------------------------------------------------
# Go through installation steps.
#------------------------------------------------------------------------------
echo "Installing bash-it"

# Check to see if backup files already exist. If they do, ask before proceeding.
if backup_exists
then
  echo -e "\033[0;33mBackup file(s) already exists. Make sure to backup your configurations before running this installation.\033[0m" >&2
  while ! [ $silent ];  do
    read -e -n 1 -r -p "Would you like to overwrite the existing backup(s)? This will delete your existing backup file(s) [y/N] " RESP
    case $RESP in
    [yY])
      break
      ;;
    [nN]|"")
      echo -e "\033[91mInstallation aborted. Please come back soon!\033[m"
      exit 1
      ;;
    *)
      echo -e "\033[91mPlease choose y or n.\033[m"
      ;;
    esac
  done
fi

# If not silent, ask about appending or replacing configuration files.
while ! [ $silent ]; do
  read -e -n 1 -r -p "Would you like to keep your configuration files and append bash-it templates at the end? [y/N] " choice
  case $choice in
  [yY])
    backup_append
    break
    ;;
  [nN]|"")
    backup_new
    break
    ;;
  *)
    echo -e "\033[91mPlease choose y or n.\033[m"
    ;;
  esac
done

# If silent, replace configuration files.
if [ $silent ]; then
  # backup/new by default
  backup_new
fi

# Enable some plugins
if [[ $interactive ]] && ! [[ $silent ]] ;
then
  for type in "aliases" "plugins" "completion"
  do
    echo -e "\033[0;32mEnabling $type\033[0m"
    load_some $type
  done
else
  echo ""
  echo -e "\033[0;32mEnabling sane defaults\033[0m"
  load_one completion bash-it.completion.bash
  load_one completion system.completion.bash
  load_one plugins base.plugin.bash
  load_one plugins alias-completion.plugin.bash
  load_one aliases general.aliases.bash
fi

echo ""
echo -e "\033[0;32mInstallation finished successfully! Enjoy bash-it!\033[0m"
echo -e "\033[0;32mTo start using it, open a new tab or 'source "$HOME/$CONFIG_FILE"'.\033[0m"
echo ""
echo "To show the available aliases/completions/plugins, type one of the following:"
echo "  bash-it show aliases"
echo "  bash-it show completions"
echo "  bash-it show plugins"
echo ""
echo "To avoid issues and to keep your shell lean, please enable only features you really want to use."
echo "Enabling everything can lead to issues."
