#! /bin/bash

# Global Vars
PASSWORD=""
LOG_FILE="/var/log/user_manager.log"

if [ ! -f $LOG_FILE ]
then
    touch  $LOG_FILE
    chmod 644 $LOG_FILE
else
    echo hello
fi

# Functions
log_action() {
    local msg=$1
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$timestamp - $msg" >> "$LOG_FILE"
}

generatePassword() {
    local len=$1
    # echo "Len of pwd: $len"
    PASSWORD=$(openssl rand -base64 $len)
    echo "PWD: $PASSWORD"
    log_action "Password generated successfully"
}

addUser () {
    if id "$1" >/dev/null 2>&1;
    then
        echo "User alreay exists"
    else
        local lenPwd=$2

        if [[ $2 == *[a-zA-z'!'@#\$%^\&*()_+]* || $2 -lt 12 || $2 -gt 24 ]]
        then
            lenPwd=16
        fi

        useradd -m -s /bin/bash $1
        echo "User $1 added"
        generatePassword $lenPwd
        echo "$1:$PASSWORD" | sudo chpasswd
        log_action "User $1 created"
    fi
}

changeName() {
    local oldName=$1
    local newName=$2
    if [ -z $newName ]
    then
        echo "User is not valid"
        return 1
    fi
    
    if id "$newName" >/dev/null 2>&1 ;
    then
        newName=""
        echo "User alreay exists"
        return 1
    fi
    
    if [[ $newName == [0-9]* ]]
    then
        newName=""
        echo "User can't start with a number"
        return 1
    fi
    
    usermod -l $newName $oldName
    groupmod --new-name $newName $oldName
    usermod -m -d "/home/$newName" $newName
    log_action "Changed name of $oldName to $newName, changed home directory and group name"
    return 0
}

showModifyUserMenu() {
    
    local options=("Change name [NAME]" "Change password [LENGTH]" "Home Directory [PATH]" "Add to group(s) [GROUP]" "Remove from group(s) [GROUP]" "Back")
    local width=30
    local cols=3

    echo "Choose what to change in the user"

    for ((i=0;i<${#options[@]};i++)); do 
        string="$(($i+1))) ${options[$i]}"
        printf "%s" "$string"
        printf "%$(($width-${#string}))s" " "
        [[ $(((i+1)%$cols)) -eq 0 ]] && echo
    done
    echo
}

modifyUser () {
    local name=$1
    if id "$name" >/dev/null 2>&1;
    then
        while true; 
        do
            echo "User to modify: $name"
            directory=$( getent passwd "$name" | cut -d: -f6 )
            echo "Home directory: $directory"
            echo "Groups: " 
            groups $name

            showModifyUserMenu

            read -p '#? ' var
            IFS=' ' read -r -a arr <<< "$var"
            clear

            case ${arr[0]} in
                1)
                    changeName $name ${arr[1]} && name=${arr[1]}
                    ;;
                2)
                    local lenPwd=${arr[1]}
                    if [[ -z "$lenPwd" || "$lenPwd" == *[a-zA-z'!'@#\$%^\&*()_+]* || $lenPwd -lt 12 || $lenPwd -gt 24 ]]
                    then
                        echo "Password length is not valid (min: 12, max: 24)"
                    else
                        generatePassword $lenPwd
                        echo "$name:$PASSWORD" | sudo chpasswd
                        log_action "Changed password for user $name"

                    fi
                    ;;
                3)
                    local pathName=${arr[1]}
                    if [[ -z "$pathName" ]]
                    then
                        echo "The new path is empty"
                    else
                        usermod -m -d "$pathName" $name
                        log_action "Changed home directory for user $name from $directory to $pathName"
                    fi
                    ;;
                4)
                    local allG=${arr[1]}
                    IFS=', ' read -r -a groups <<< "$allG"

                    for index in "${!groups[@]}"
                    do 
                        local g=${groups[$index]}
                        if grep -q $g /etc/group
                        then
                            usermod -a -G $g $name
                            log_action "Added $name to group $g"
                        else
                            echo "Group does not exist: $g"
                        fi
                    done
                    ;;
                5)
                    local allG=${arr[1]}
                    IFS=', ' read -r -a groups <<< "$allG"

                    for index in "${!groups[@]}"
                    do 
                        local g=${groups[$index]}
                        if grep -q $g /etc/group
                        then
                            gpasswd --delete $name $g
                            log_action "Removed $name from group $g"
                        else
                            echo "Group does not exist: $g"
                        fi
                    done
                    ;;
                6)
                    break
                    ;;
                *)
                    echo "Selected option is not valid"
                    ;;
            esac
            
        done
    else
        echo "User doesn't exist"
    fi
}

deleteUser () {
    if id "$1" >/dev/null 2>&1;
    then
        userdel -r -f $1
        echo "User $1 deleted" 
        log_action "User $1 deleted"
    else
        echo "User doesn't exist"
    fi
}

showUsersList() {
    local min=$(grep "^UID_MIN" /etc/login.defs)
    local max=$(grep "^UID_MAX" /etc/login.defs)
    min=${min##UID_MIN}
    max=${max##UID_MAX}
    # min="$(echo "${min##UID_MIN}" | tr -d '[:space:]')"
    # max="$(echo "${max##UID_MAX}" | tr -d '[:space:]')"
    # echo "Min: $min, Max: $max"

    cat "/etc/passwd" | while read line; do
        IFS=':' read -r -a array <<< "$line"
        local id=${array[2]}
        if [ $id -ge $min -a $id -le $max ]; then
            echo "User: ${array[0]} | ID: $id | GID: ${array[3]} | Home dir: ${array[5]}"
        fi
    done
}

showAddUserMenu() {

    local name=""
    local lenPwd=0

    #-a $lenPwd -eq 0 
    while [ -z "$name" ] 
    do
        read -p "Enter username: " name

        if id "$name" >/dev/null 2>&1 ;
        then
            name=""
            echo "User alreay exists"
            continue
        fi

        if [[ $name == [0-9]* ]]
        then
            name=""
            echo "User can't start with a number"
        fi
    done


    while [ $lenPwd -eq 0 ] 
    do
        read -p "Enter password length (min: 12 | max: 24): " lenPwd

        if [[ -z "$lenPwd" || "$lenPwd" == *[a-zA-z'!'@#\$%^\&*()_+]* || $lenPwd -lt 12 || $lenPwd -gt 24 ]]
        then
            lenPwd=0
            echo "Password length is not valid"
        fi
    done

    addUser $name $lenPwd
}

showMainMenu() {
    local options=("List Users" "Add User" "Delete User [NAME]" "Modify User [NAME]" "Add Group(s) [GROUP]" "Delete Group(s) [GROUP]" "Quit")
    local width=25
    local cols=3

    for ((i=0;i<${#options[@]};i++)); do 
        string="$(($i+1))) ${options[$i]}"
        printf "%s" "$string"
        printf "%$(($width-${#string}))s" " "
        [[ $(((i+1)%$cols)) -eq 0 ]] && echo
    done
    echo
}

# Main Menu Logic
clear
if [ $# -eq "0" ]
then

    while true; do
        showMainMenu
        read -p '#? ' var
        IFS=' ' read -r -a arr <<< "$var"
        clear
        # echo "var: $var"
        # echo ":"${arr[1]}
        case ${arr[0]} in
            1)
                showUsersList
                ;;
            2)
                showAddUserMenu
                ;;
            3)
                deleteUser ${arr[1]}
                ;;
            4)
                modifyUser ${arr[1]}
                ;;
            5)
                if [[ -z ${arr[1]} ]]
                then
                    echo "Groups field is empty"
                else
                    allG=${arr[1]}
                    IFS=', ' read -r -a groups <<< "$allG"

                    for index in "${!groups[@]}"
                    do 
                        g=${groups[$index]}
                        groupadd $g
                        echo "Group $g added"
                        log_action "Group $g created"

                    done
                fi
                ;;
            6)
                if [[ -z ${arr[1]} ]]
                then
                    echo "Groups field is empty"
                else
                    allG=${arr[1]}
                    IFS=', ' read -r -a groups <<< "$allG"

                    for index in "${!groups[@]}"
                    do 
                        g=${groups[$index]}
                        groupdel $g
                        echo "Group $g deleted"
                        log_action "Group $g deleted"
                    done
                fi
                ;;
            7)
                exit
                ;;
            *)
                echo "Selected option is not valid"
                ;;
        esac
    done

else

    # echo "Param 2: $2"
    case $1 in
        "add")
            if [[ -z $2 || $2 == [0-9]* ]]
            then
                echo "The username is empty or starts with a number"
            else
                addUser $2 $3
            fi
            ;;
        "delete")
            if [[ -z $2 || $2 == [0-9]* ]]
            then
                echo "The username is empty or starts with a number"
            else
                deleteUser $2
            fi
            ;;
        "list")
            showUsersList
            ;;
        "password")
            if [[ -z $2 || $2 == *[a-zA-z'!'@#\$%^\&*()_+]* || $2 -lt 12 || $2 -gt 24 ]]
            then
                echo "The password length is not valid (Min:12, Max: 24)"
            else
                generatePassword $2
            fi
            ;;
        *)
            echo "There is not a parameter with the name $2"
            ;;
    esac
fi