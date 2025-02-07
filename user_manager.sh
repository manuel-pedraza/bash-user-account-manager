#! /bin/bash

addUser () {
    useradd -ms $1
    echo "User $1 added"
}

modifyUser () {
    echo ...
}

deleteUser () {
    echo ...
}

showUsersList() {
    echo ...
}

generatePassword() {
    local len=$1
    echo "Len of pwd: $len"
}

if [ $# -eq "0" ]
then
    select var in "Add User" "Delete User" "Modify User" 
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
            *)
                echo "Named not found"
                ;;
        esac
    done
else

    echo "Param 2: $2"
    case $1 in
        "add")
            if [[ -z $2 || $2 == [0-9]* ]]
            then
                echo "The username is empty or starts with a number"
            else
                addUser
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
            echo "Mark selected"
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
            echo "There is not a parameter with the name $1"
            ;;
    esac
fi