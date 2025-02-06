#! /bin/bash

# Sys Vars
# ; append command rm -f text.txt; echo lol
echo $BASH
echo $BASH_VERSION
echo $HOME
echo $PWD
echo $LANG
echo "PID is $$"

# Read user inputs
echo "==============================="
echo "Enter new name: "
read newName newName2 newName3
echo "Entered names: $newName, $newName2, $newName3"
read -p "Username: " username
read -sp "Password: " password
echo
echo "Username: $username"
echo "Enter numbers: "
read -a numbers
echo "Numbers: ${numbers[0]}, ${numbers[1]}, ${numbers[2]}"
echo "Reply"
read
echo "Default var reply: $REPLY"

# Read Arguments from a bash script
# $0 is the name of the file 
echo $0 $1 $2 $3 " > echo $1 $2 $3"
args =("$@")
echo $@
echo $#
echo ${args[0]} ${args[1]} ${args[2]} ${args[3]}" > echo $1 $2 $3"

# If statement
# Integers [$a -lt $b] or (($a < $b))
# -eq - is equal to 
# -ne - is not equal to
# -gt - is greater than
# -ge - is greater than or eq to
# -lt - is less than
# -le - is less than or eq to
# String
# =, ==, !=, >, <, 
# -z - string is null, that is, has zero length

count=10
if [ $count -gt 9 ] # (($count > 9)) or [$count > 9]
then
    echo "Condition is true"
fi

word="Hello world"
if [$word != "Hello world"] 
then 
    echo "It's not hello world"
else
    echo $word
if

# File operators
# echo -e for let the cursor be at the \c position, its gonna interpret the \c
echo -e "Enter the name of the file: \c"
read file_name

# -e check if file exists, -f if its a file, -d if its a dir, 
# There are two types of files binary (images, vids, etc) and character type files (.sh, .txt, etc)
# -b check if its a binary file, -c check if its a character file
# -s check if its empty or not
# -r, -w, -x check if it has the respective permission
if [ -f $file_name ]
then
    if [ -w $file_name]
    then
        echo "Type some text data. To quit press ctrl+d"
        cat >> $file_name
    else
        echo "The file do not have write permissions"
    fi
else
    ehco "$file_name does not exist"
fi


# Append text to a file
# > overrides, >> appends
# chmod -w text.txt => removes writable permission
# chmod +w text.txt => adds writable permission

age=25

# Logicals operators
# AND: [] && [], [ -a ], [[ && ]]
# OR: [] || [], [ -o ], [[ || ]]
if [ $age -gt 18] && [$age -lt 30]
# if [ $age -gt 18 -a $age -lt 30]
# if [[ $age -gt 18 && $age -lt 30]]
then
    echo "Valid age"
else
    echo "Unvalid age"
fi

num=1
num2=1
# ((num + num2))
# ((num - num2))
# ((num * num2))
# ((num / num2))
# ((num % num2))
echo $(( num + num2 ))
echo $(expr $num + $num2 )
echo $(expr $num \* $num2 )

numF=27

# Work with floats, see bc language
echo "20.5+5" | bc
echo "scale=2;20.5/5" | bc
echo "scale=2;sqrt($numF)" | bc -l
echo "scale=2;3^3" | bc -l

# Switch case
vehicle="car"
case $vehicle in
    "car" )
        echo "Rent of $vehicle is 100 dollars"
        ;;
    "van" )
        echo "Rent of $vehicle is 120 dollars"
        ;;
    "bicycle" )
        echo "Rent of $vehicle is 15 dollars"
        ;;
    "truck" )
        echo "Rent of $vehicle is 150 dollars"
        ;;
    * )
        echo "Unknown of vehicule"
        ;;
esac

# Example of switch case 

echo -e "Enter some character: \c"
read value

case $value  in
    [a-z])
        command "User entered $value, a to z"
        ;;
    [A-Z])
        command "User entered $value, A to Z"
        ;;
    [0-9])
        command "User entered $value, 0 to 9"
        ;;
    ? )
        command "User entered $value, special character"
        ;;
    *)
        command "Unknown input"
        ;;
esac


# Arrays

os=("ubuntu" "windows" "kali" "mac")

os[4]="mint"

echo "${os[@]}"
echo "${os[0]}"
echo "${!os[@]}" # 0 1 2 3
echo "${#os[@]}" # length 4

unset os[2]

string=djaskldjoaiwdjoaiwjdo
echo "${string[@]}
echo "${string[0]}

# While Loop
n=1
while [ $n -le 10 ]
# while (( $n <= 10 ))
do
    echo "$n"
    n=$(( n+1 ))
    #(( n++))
    #(( ++n ))
done

# Using sleep with loops

num=1
while [ $n -le 10 ]
# while (( $n <= 10 ))
do
    echo "$n"
    n=$(( n+1 ))
    #(( n++))
    #(( ++n ))
    sleep 1 # in sec
    #gnome-terminal &
    #xterm &
done

# Read file content
# 1st method
#while read p 
#do 
#    echo $p
# done < tests.sh

# 2nd method
# cat tests.sh | while read p
# do 
#     echo $p
# done

# 3rd method
while IFS=' ' read -r line 
do 
    echo $line
done < tests.sh

# unitl is like adding a not to the while loop
n2=1

until [ $n2 -ge 10]
do 
    echo $num2
    n2=$(( n2+1))
done

# for loop 

# EX_1
# for i in 1 2 3 4 5
# for i in {1..10}
#for i in {1..10..2} # increment by 2 => 1 3 5
for ((i=0;  i<5;  i++))
do 
    echo $char
done

for command in ls pwd date
do 
    echo "---------------$command----------------"
    echo $command
    $command
done

for item in * # iterate every file in the curent dir
do 
    if [ -d $item ]
    then
        echo $item
    else 
        echo "There was an error listing the files"
        continue
        # break
    fi
done

# Select
select var in "mark" "john" "tom"
do
    echo "$var selected"

    case $var in
        "mark")
            echo "Mark selected"
            ;;
        "john")
            echo "Mark selected"
            ;;
        "tom")
            echo "Mark selected"
            ;;
        *)
            echo "Named not found"
            ;;
    esac

done

# functions, 2 ways to create a func

#getName () {
function sayHello() {
    echo "Hello"

}

function print(){
    echo $1
}

quit () {
    exit
}

function test(){
    # tmpName=$1
    local tmpName=$1
    echo "The name is $name"
}

is_file_exists() {
    local file="$1"
    [[ -f "$file" ]] && return 0 || return 1
}

tmpName="Tom"
echo "The name is $tmpName"

print "Max"

sayHello
print "Hello World"

#Readonly aka const

newVar=31
readonly newVar

hello(){
    echo "Hello there"
}

readonly -f hello
readonly -p # list of all read only vars

# Signals and Traps
# SIGKILL and SIGSTOP are not trapable
# ctrl+C => exit signal
# ctrl+z => stop signal
# command: kill -9 pid => kill signal

trap "echo Exit command is detected" 0
trap "echo Exit siganl is detected" SIGINT # SIGINT = 2
trap "echo Kill siganl is detected" SIGKILL # SIGINT = 2
echo "Hello world"

file=/home/test/Desktop/file.txt

trap "rm -f $file && echo file deleted; exit" 0 2 15

exit 0

# Extra debugg prompts => bash -x ./tests.sh
# Activate debugging or at the start => #!/bin/bash -x
set -x