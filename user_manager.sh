#! /bin/bash

addUser () {
    echo "hi"
}

modifyUser () {
    echo ...
}

removeUser () {
    echo ...
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
    case $1 in
        "add")
            echo "Mark selected"
            ;;
        "delete")
            echo "Mark selected"
            ;;
        "list")
            echo "Mark selected"
            ;;
        "password")
            echo "Mark selected"
            ;;
        *)
            echo "There is not a parameter with the name $1"
            ;;
    esac
fi