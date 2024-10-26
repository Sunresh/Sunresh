#!/bin/bash

# Declare the global variable
TERMUX_PATH="/storage/emulated/0/Download/github/termux"
# TERMUX_PATH="$PWD"

# Function to clone a repository
clone_repository() {
  echo "Cloning a repository...from sunresh"
  read -p "Enter GitHub repo: " repo_name
  
  find "$TERMUX_PATH/$repo_name" -mindepth 1 -delete

  git clone "https://www.github.com/sunresh/$repo_name" "$TERMUX_PATH/$repo_name"
  git config --global --add safe.directory "$TERMUX_PATH/$repo_name"
  if [ $? -eq 0 ]; then
    echo "$repo_name is cloned successfully into $TERMUX_PATH/$repo_name"
  else
    echo "Failed to clone repository. Please check the URL and your permissions."
  fi
}
# Function to fetch changes from a repository
fetch_changes() {
    echo "Fetching changes from a repository..."
    read -p "Enter the path to your local repository: " local_dir
    
    if [ ! -d "$TERMUX_PATH/$local_dir" ]; then
        echo "The specified directory does not exist."
        return 1
    fi

    git config --global --add safe.directory "$TERMUX_PATH/$local_dir"

    cd "$TERMUX_PATH/$local_dir"

    if [ ! -d .git ]; then
        echo "The specified directory is not a Git repository."
        return 1
    fi

    git fetch --all

    if [ $? -eq 0 ]; then
        echo "Changes fetched successfully!"
        echo "Use 'git branch -a' to see all branches, including remote ones."
        echo "Use 'git merge' or 'git rebase' to integrate the changes."
    else
        echo "Failed to fetch changes. Please check your network and permissions."
    fi
}


mkdir "$TERMUX_PATH"
function load_file() {
    source "$TERMUX_PATH/$1"
}

function exit_script() {
    echo "Exiting script..."
    exit 0
}

function updatae() {
   fetch_changes
}

function g_setup() {
    clear 
    source "$TERMUX_PATH/g_setup.sh"
}

function esr() {
    source "$TERMUX_PATH/c.sh"
}

function git_menu() {
    clear
    echo "###################################"
    echo "#  GitHub  Operations   Menu:     #"
    echo "###################################"
    echo "# 1. Setup            2. Clone    #"
    echo "# 3. Push repos       4. Fetch    #"
    echo "# 5. Choose Branch    6. Back     #"
    echo "###################################"

    read -p "Enter your choice: " choice

    case $choice in
        1) g_setup ;;
        2) clone_repository ;;
        3) load_file "g_push.sh" ;;
        4) fetch_changes ;;
        5) load_file "g_choose.sh" ;;
        6) load_file "app.sh" ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
}

function main() {
    clear
    echo "###################################"
    echo "#  Sunresh  Operations   Menu:    #"
    echo "###################################"
    echo "# 1. Git              2. Update   #"
    echo "# 3. make h command               #"
    echo "# 4. Exit             5. clear    #"
    echo "###################################"

    read -p "Enter your choice: " choice

    case $choice in
        1) git_menu ;;
        2) updatae ;;
        3) load_file "init_setup.sh" ;;
        4) exit_script ;;
        5) clear ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
}

main
