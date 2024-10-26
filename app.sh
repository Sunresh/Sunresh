#!/bin/bash
#!/bin/bash

create_bashrc() {
    local bashrc_content='#!/bin/bash
    
# Global variables
export APP_DIR="/storage/emulated/0/download/github/termux"
export CONFIG_FILE="$APP_DIR/config.sh"

# Function to source the app script
h() {
    source "$APP_DIR/app.sh"
}

# Function to edit the app script
edit_app() {
    nano "$APP_DIR/app.sh"
}

# Function to update the app from GitHub
update_app() {
    cd "$APP_DIR"
    git config --global --add safe.directory $APP_DIR
    git pull
    cd - > /dev/null
}

# Function to show app status
app_status() {
    if [ -f "$APP_DIR/app.sh" ]; then
        echo "App script exists"
        echo "Last modified: $(stat -c %y "$APP_DIR/app.sh")"
    else
        echo "App script not found"
    fi
}

# Function to load custom configuration
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        echo "Configuration loaded"
    else
        echo "Configuration file not found"
    fi
}

cdapp() {
   cd "$APP_DIR"
}

home() {
   cd "$HOME"
}


'

    echo "$bashrc_content" > "$HOME/.bashrc"
    echo ".bashrc file created successfully in $HOME"
    
    BASH_PATH_TARGET="$HOME"

    # Make sure .bashrc is readable (not executable)
    chmod 644 "$BASH_PATH_TARGET/.bashrc"
    echo "Permissions set for .bashrc"

    # Source the new .bashrc
    source "$BASH_PATH_TARGET/.bashrc"
    echo "New .bashrc applied"

    echo "Setup complete. You can now use custom aliases and configurations."
}

# Call the function to create .bashrc

# Declare the global variable
TERMUX_PATH="/storage/emulated/0/Download/github/termux"
# TERMUX_PATH="$PWD"
setup_github() {
    # Configure Git
    read -p "GitHub username: " username
    read -p "GitHub email: " email
    git config --global user.name "$username"
    git config --global user.email "$email"
    git config --global credential.helper store

    # Setup GitHub CLI
    gh auth login -h github.com -p https -w || { echo "GitHub CLI setup failed"; exit 1; }

    # Prepare for GUI
    mkdir -p ~/.termux-github
    echo '{"gui_enabled":false,"gui_port":8080}' > ~/.termux-github/gui_config.json

    echo "GitHub setup complete. Credentials stored locally."
}

# Function to clone a repository
clone_repository() {
  echo "Cloning a repository...from sunresh"
  read -p "Enter GitHub repo: " repo_name

  # check_and_create_path "storage/downloads/Github/$repo_name"
  find "$TERMUX_PATH/$repo_name" -mindepth 1 -delete

  git clone "https://www.github.com/sunresh/$repo_name" "$TERMUX_PATH/$repo_name"
  git config --global --add safe.directory $TERMUX_PATH/$repo_name
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
    setup_github
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
        3) create_bashrc ;;
        4) exit_script ;;
        5) clear ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
}

main
