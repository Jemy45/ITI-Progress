#!/bin/bash
# =============================================================================
# User & Group Management Menu
# Uses whiptail for a simple interactive TUI (Text User Interface)
# =============================================================================

# --- Helper: show a message with a "Back" button (stays inside the TUI) ---
msg() {
    whiptail --title "Info" --ok-button "Back" --msgbox "$1" 12 55
}

# --- Helper: ask a yes/no question, returns 0=yes 1=no ---
confirm() {
    whiptail --title "Confirm" --yesno "$1" 8 50
}

# =============================================================================
# USER FUNCTIONS
# =============================================================================

add_user() {
    USERNAME=$(whiptail --title "Add User" --inputbox "Enter new username:" 8 50 3>&1 1>&2 2>&3)
    [ -z "$USERNAME" ] && return

    PASSWORD=$(whiptail --title "Add User" --passwordbox "Enter password for '$USERNAME':" 8 50 3>&1 1>&2 2>&3)
    [ -z "$PASSWORD" ] && return

    # -m creates the home directory automatically
    useradd -m "$USERNAME" 2>/dev/null
    if [ $? -ne 0 ]; then
        msg "ERROR: Could not create user '$USERNAME'.\nMaybe it already exists?"
        return
    fi

    echo "$USERNAME:$PASSWORD" | chpasswd 2>/dev/null
    msg "User '$USERNAME' created successfully."
}

modify_user() {
    USERNAME=$(whiptail --title "Modify User" --inputbox "Enter username to modify:" 8 50 3>&1 1>&2 2>&3)
    [ -z "$USERNAME" ] && return

    # Check user exists first
    if ! id "$USERNAME" &>/dev/null; then
        msg "ERROR: User '$USERNAME' does not exist."
        return
    fi

    NEWNAME=$(whiptail --title "Modify User" --inputbox "Enter new username for '$USERNAME'\n(Leave blank to cancel):" 9 55 3>&1 1>&2 2>&3)
    [ -z "$NEWNAME" ] && return

    usermod -l "$NEWNAME" "$USERNAME" 2>/dev/null
    if [ $? -eq 0 ]; then
        msg "User '$USERNAME' renamed to '$NEWNAME'."
    else
        msg "ERROR: Could not rename user.\nMake sure user is not logged in."
    fi
}

delete_user() {
    USERNAME=$(whiptail --title "Delete User" --inputbox "Enter username to delete:" 8 50 3>&1 1>&2 2>&3)
    [ -z "$USERNAME" ] && return

    # Check user exists first
    if ! id "$USERNAME" &>/dev/null; then
        msg "ERROR: User '$USERNAME' does not exist."
        return
    fi

    confirm "Are you sure you want to delete '$USERNAME'?\nThis will also remove their home directory!" || return

    userdel -r "$USERNAME" 2>/dev/null
    if [ $? -eq 0 ]; then
        msg "User '$USERNAME' deleted successfully."
    else
        msg "ERROR: Could not delete user '$USERNAME'."
    fi
}

list_users() {
    # UID >= 500 covers RedHat/CentOS (500+) and Debian/Ubuntu (1000+)
    # Show: username | UID | home directory
    USERS=$(awk -F: '
        $3 >= 500 && $1 != "nobody" && $1 != "nfsnobody" {
            printf "%-15s UID:%-6s %s\n", $1, $3, $6
        }
    ' /etc/passwd)

    if [ -z "$USERS" ]; then
        USERS="No regular users found."
    fi

    # --scrolltext allows scrolling if many users exist
    whiptail --title "List Users" \
             --scrolltext \
             --msgbox "Username        UID    Home Dir\n────────────────────────────────────\n$USERS" \
             20 60
}

# =============================================================================
# GROUP FUNCTIONS
# =============================================================================

add_group() {
    GROUPNAME=$(whiptail --title "Add Group" --inputbox "Enter new group name:" 8 50 3>&1 1>&2 2>&3)
    [ -z "$GROUPNAME" ] && return

    groupadd "$GROUPNAME" 2>/dev/null
    if [ $? -eq 0 ]; then
        msg "Group '$GROUPNAME' created successfully."
    else
        msg "ERROR: Could not create group '$GROUPNAME'.\nMaybe it already exists?"
    fi
}

modify_group() {
    GROUPNAME=$(whiptail --title "Modify Group" --inputbox "Enter group name to modify:" 8 50 3>&1 1>&2 2>&3)
    [ -z "$GROUPNAME" ] && return

    # Check group exists
    if ! getent group "$GROUPNAME" &>/dev/null; then
        msg "ERROR: Group '$GROUPNAME' does not exist."
        return
    fi

    USERNAME=$(whiptail --title "Modify Group" --inputbox "Enter username to add to '$GROUPNAME':" 8 50 3>&1 1>&2 2>&3)
    [ -z "$USERNAME" ] && return

    # Check user exists
    if ! id "$USERNAME" &>/dev/null; then
        msg "ERROR: User '$USERNAME' does not exist."
        return
    fi

    # -aG = append to group without removing existing group memberships
    usermod -aG "$GROUPNAME" "$USERNAME" 2>/dev/null
    if [ $? -eq 0 ]; then
        msg "User '$USERNAME' added to group '$GROUPNAME'."
    else
        msg "ERROR: Could not modify group '$GROUPNAME'."
    fi
}

delete_group() {
    GROUPNAME=$(whiptail --title "Delete Group" --inputbox "Enter group name to delete:" 8 50 3>&1 1>&2 2>&3)
    [ -z "$GROUPNAME" ] && return

    # Check group exists
    if ! getent group "$GROUPNAME" &>/dev/null; then
        msg "ERROR: Group '$GROUPNAME' does not exist."
        return
    fi

    confirm "Are you sure you want to delete group '$GROUPNAME'?" || return

    groupdel "$GROUPNAME" 2>/dev/null
    if [ $? -eq 0 ]; then
        msg "Group '$GROUPNAME' deleted."
    else
        msg "ERROR: Could not delete group.\nMaybe it is a primary group of a user?"
    fi
}

list_groups() {
    # Build the output line by line by reading /etc/group
    # /etc/group format: groupname:password:GID:member1,member2,...
    OUTPUT=""
    while IFS=: read -r GNAME _ GID MEMBERS; do
        # If the members field is empty, show a placeholder
        [ -z "$MEMBERS" ] && MEMBERS="(no members)"
        OUTPUT="${OUTPUT}$(printf '%-20s GID:%-6s %s\n' "$GNAME" "$GID" "$MEMBERS")"$'\n'
    done < /etc/group

    if [ -z "$OUTPUT" ]; then
        OUTPUT="No groups found."
    fi

    whiptail --title "List Groups" \
             --scrolltext \
             --msgbox "Group Name           GID    Members\n─────────────────────────────────────────\n${OUTPUT}" \
             22 65
}

# =============================================================================
# ACCOUNT CONTROL FUNCTIONS
# =============================================================================

disable_user() {
    USERNAME=$(whiptail --title "Disable User" --inputbox "Enter username to lock:" 8 50 3>&1 1>&2 2>&3)
    [ -z "$USERNAME" ] && return

    # Check user exists
    if ! id "$USERNAME" &>/dev/null; then
        msg "ERROR: User '$USERNAME' does not exist."
        return
    fi

    # -L locks the account by adding ! in front of the password hash in /etc/shadow
    usermod -L "$USERNAME" 2>/dev/null

    if [ $? -eq 0 ]; then
        # Verify: check if /etc/shadow now has ! at the start of the password field
        SHADOW_ENTRY=$(grep "^$USERNAME:" /etc/shadow | cut -d: -f2)
        if [[ "$SHADOW_ENTRY" == !* ]]; then
            msg "User '$USERNAME' is now LOCKED.\n\nTo verify manually run:\n  passwd -S $USERNAME\n  (shows 'L' = Locked)"
        else
            msg "Command ran OK.\nVerify with: passwd -S $USERNAME"
        fi
    else
        msg "ERROR: Could not lock user '$USERNAME'."
    fi
}

enable_user() {
    USERNAME=$(whiptail --title "Enable User" --inputbox "Enter username to unlock:" 8 50 3>&1 1>&2 2>&3)
    [ -z "$USERNAME" ] && return

    # Check user exists
    if ! id "$USERNAME" &>/dev/null; then
        msg "ERROR: User '$USERNAME' does not exist."
        return
    fi

    # -U removes the ! from the password hash to unlock
    usermod -U "$USERNAME" 2>/dev/null

    if [ $? -eq 0 ]; then
        # Verify: password field should NOT start with ! anymore
        SHADOW_ENTRY=$(grep "^$USERNAME:" /etc/shadow | cut -d: -f2)
        if [[ "$SHADOW_ENTRY" != !* ]]; then
            msg "User '$USERNAME' is now UNLOCKED.\n\nTo verify manually run:\n  passwd -S $USERNAME\n  (shows 'P' = Password set/active)"
        else
            msg "Command ran OK.\nVerify with: passwd -S $USERNAME"
        fi
    else
        msg "ERROR: Could not unlock user '$USERNAME'."
    fi
}

change_password() {
    USERNAME=$(whiptail --title "Change Password" --inputbox "Enter username:" 8 50 3>&1 1>&2 2>&3)
    [ -z "$USERNAME" ] && return

    # Check user exists
    if ! id "$USERNAME" &>/dev/null; then
        msg "ERROR: User '$USERNAME' does not exist."
        return
    fi

    PASSWORD=$(whiptail --title "Change Password" --passwordbox "Enter new password for '$USERNAME':" 8 50 3>&1 1>&2 2>&3)
    [ -z "$PASSWORD" ] && return

    echo "$USERNAME:$PASSWORD" | chpasswd 2>/dev/null
    if [ $? -eq 0 ]; then
        msg "Password for '$USERNAME' changed successfully."
    else
        msg "ERROR: Could not change password for '$USERNAME'."
    fi
}

about() {
    whiptail --title "About" --ok-button "Back" --msgbox \
"User & Group Management Tool
─────────────────────────────
Student : Ahmed Gamal
Track     : System Administration - Intake 46
─────────────────────────────
A simple TUI tool built with whiptail
to manage Linux users and groups
from a single interactive menu.

Features: add, modify, delete users
and groups, lock/unlock accounts,
and change passwords." \
    16 52
}

# =============================================================================
# MAIN MENU LOOP
# Runs forever until user presses the Exit button or Esc key
# =============================================================================

while true; do
    CHOICE=$(whiptail --title "User & Group Management" \
        --cancel-button "Exit" \
        --ok-button "Select" \
        --menu "Use arrow keys, press Enter to select:" 22 65 12 \
        "1"  "Add User         - Add a user to the system" \
        "2"  "Modify User      - Modify an existing user" \
        "3"  "Delete User      - Delete an existing user" \
        "4"  "List Users       - List all users on the system" \
        "5"  "Add Group        - Add a group to the system" \
        "6"  "Modify Group     - Add a user to a group" \
        "7"  "Delete Group     - Delete an existing group" \
        "8"  "List Groups      - List all groups on the system" \
        "9"  "Disable User     - Lock the user account" \
        "10" "Enable User      - Unlock the user account" \
        "11" "Change Password  - Change password of a user" \
        "12" "About            - Information about this program" \
        3>&1 1>&2 2>&3)

    # Exit if user pressed "Exit" button or Esc
    [ $? -ne 0 ] && break

    case $CHOICE in
        1)  add_user ;;
        2)  modify_user ;;
        3)  delete_user ;;
        4)  list_users ;;
        5)  add_group ;;
        6)  modify_group ;;
        7)  delete_group ;;
        8)  list_groups ;;
        9)  disable_user ;;
        10) enable_user ;;
        11) change_password ;;
        12) about ;;
    esac

done

clear
echo "Goodbye!"
