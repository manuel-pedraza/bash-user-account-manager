# User Account Manager & Random Password Generator

## Description
This project is a Bash script that allows system administrators to manage user accounts efficiently while also generating secure random passwords for new users. The script provides an easy-to-use command-line interface for creating, deleting, and listing users while ensuring strong password security.

## Features
- **User Account Management**
  - Add new users to the system.
  - Remove existing users.
  - List all system users.
  - Assign users to specific groups.
- **Random Password Generator**
  - Generates secure passwords with user-defined length.
  - Supports alphanumeric and special characters.
  - Automatically assigns generated passwords to new users.
- **Logging & Security**
  - Logs all user account operations for auditing in: **/var/log/user_manager.log**.
  - Ensures password strength compliance.
- **Groups Manager**
  - Creates one or more groups.
  - Deletes one or more groups.

## Usage (App Mode)
### Start the app
```bash
./user_manager.sh
```
This will start the app showing you the options to select from.

**NOTE:** An option containing **[]** means that you need to write something after the number to work **( e.g.: 4 John or 5 group1234,test935 )**

## Usage (Standalone Mode)
### Adding a New User
```bash
./user_manager.sh add [username]
```
This will create a new user with a randomly generated secure password.

### Deleting a User
```bash
./user_manager.sh delete [username]
```
Removes the specified user from the system.

### Listing All Users
```bash
./user_manager.sh list
```
Displays a list of all users on the system.

### Generating a Random Password 
```bash
./user_manager.sh password [length]
```
Generates a secure password of the specified length.

## Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/manuel-pedraza/bash-user-account-manager.git
   cd user-account-manager
   ```
2. Make the script executable:
   ```bash
   chmod +x user_manager.sh
   ```
3. Run the script with appropriate privileges (requires sudo for user management):
   ```bash
   sudo ./user_manager.sh
   ```

## Requirements
- Linux-based operating system
- Bash shell
- Root/sudo privileges for user management

## Author
Developed by Manuel A. Pedraza S.
