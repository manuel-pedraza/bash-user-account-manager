#! /bin/bash

# Global Vars
PASSWORD=""

# Functions
generatePassword() {
    local len=$1
    # echo "Len of pwd: $len"
    PASSWORD=$(openssl rand -base64 $len)
    echo "PWD: $PASSWORD"
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
    fi
}

showModifyUserMenu() {
    
    local options=("Name [NAME]" "Password [LENGTH]" "Home Directory [PATH]" "Add group [GROUP]" "Remove group [GROUP]" "Back")
    local width=25
    local cols=3

    echo "Choose what to change on the user"

    for ((i=0;i<${#options[@]};i++)); do 
        string="$(($i+1))) ${options[$i]}"
        printf "%s" "$string"
        printf "%$(($width-${#string}))s" " "
        [[ $(((i+1)%$cols)) -eq 0 ]] && echo
    done
    echo
}

modifyUser () {
    if id "$1" >/dev/null 2>&1;
    then
        while true; 
        do
            echo "User to modify: $1"
            echo "Groups: " 
            groups $1

            showModifyUserMenu

            read -p '#? ' var
            IFS=' ' read -r -a arr <<< "$var"
            clear

            case ${arr[0]} in
                1)
                    if id "$name" >/dev/null 2>&1 ;
                    then
                        name=""
                        echo "User alreay exists"
                    fi

                    if [[ $name == [0-9]* ]]
                    then
                        name=""
                        echo "User can't start with a number"
                    fi
                    ;;
                2)
                    echo ...
                    ;;
                3)
                    echo ...
                    ;;
                4)
                    echo ...
                    ;;
                5)
                    echo ...
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
    local options=("List Users" "Add User" "Delete User [NAME]" "Modify User [NAME]" "Quit")
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