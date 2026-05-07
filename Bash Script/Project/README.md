# Bash Script Project

## 📁 Folder Contents

This folder contains the Bash scripting final project for ITI System Administration (Intake 46):

- **[`Bash_Script_Project.sh`](Bash_Script_Project.sh)**: the executable Bash script.
- **[`Bash Script Project.pdf`](Bash%20Script%20Project.pdf)**: full project documentation and testing report.

## 🧰 About `Bash_Script_Project.sh`

`Bash_Script_Project.sh` is an interactive **User & Group Management Tool** built with `whiptail` (TUI).

It provides a menu-driven interface to perform Linux administration tasks:

### User management
- Add user
- Modify (rename) user
- Delete user
- List regular users

### Group management
- Add group
- Modify group (add user to group)
- Delete group
- List groups

### Account control
- Disable (lock) user account
- Enable (unlock) user account
- Change user password

### Utility
- About screen
- Main loop with safe exit behavior

## ▶️ How to run

> Run as root (or with `sudo`) because user/group commands require elevated privileges.

```bash
chmod +x "Bash_Script_Project.sh"
sudo ./Bash_Script_Project.sh
```

## 📄 About `Bash Script Project.pdf`

The PDF explains and documents the project in detail, including:

- Introduction to the tool and `whiptail`
- Script structure and function-by-function explanation
- Linux command references used in the script (`useradd`, `usermod`, `userdel`, `groupadd`, `groupdel`, `chpasswd`, etc.)
- Practical testing scenarios with expected results and verification commands
- Screenshots and outputs for each scenario

### Covered test scenarios in the PDF
- Add a new user
- Add a new group
- Add user to group
- List users and groups
- Lock/unlock a user
- Change password
- Delete user
- Delete group

## 👤 Project info

- **Track**: System Administration
- **Intake**: 46
- **Author**: Ahmed Gamal
- **Supervisor**: Eng. Romany Nageh
