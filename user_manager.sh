#! /bin/bash

addUser () {
    useradd -m -s /bin/bash $1
    echo "User $1 added"
}

modifyUser () {
    echo ...
}

deleteUser () {
    userdel 
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
            echo "User: ${array[0]} | ID: $id | Home dir: ${array[5]}"
        fi
    done       
}

generatePassword() {
    local len=$1
    echo "Len of pwd: $len"
}

if [ $# -eq "0" ]
then
    select var in "Add User" "Delete User" "Modify User" "Quit"
    do
        echo "$var selected"
        case $var in
            "Add User")
                echo "Mark selected"
                ;;
            "Delete User")
                echo "Mark selected"
                ;;
            "Modify User")
                echo "Mark selected"
                ;;
            "Quit")
                exit
                ;;
            *)
                echo "Named not found"
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
                addUser $2
            fi
            ;;
        "delete")
            if [[ -z $2 || $2 == [0-9]* ]]
            then
                echo "The username is empty or starts with a number"
            else
                deleteUser
            fi
            ;;
        "list")
            showUsersList
            ;;
        "password")
            if [[ -z $2 || $2 == *[a-zA-z'!'@#\$%^\&*()_+]* ]]
            then
                echo "The password length is not valid"
            else
                generatePassword $2
            fi
            ;;
        *)
            echo "There is not a parameter with the name $2"
            ;;
    esac
fi