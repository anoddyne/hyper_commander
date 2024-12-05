#!/usr/bin/env bash

list_files_and_dirs() {
    echo -e "\nThe list of files and directories: "
    arr=(*)
    for item in "${arr[@]}"; do
        if [[ -f "$item" ]]; then
            echo "F $item"
        elif [[ -d "$item" ]]; then
            echo "D $item"
        fi

    done
    echo -e "
---------------------------------------------------
| 0 Main menu | 'up' To parent | 'name' To select |
---------------------------------------------------\n"
    read -rp "> " input
    while true; do
        case "$input" in
        0)
            main
            ;;
        "up")
            cd ..
            files_and_dirs
            ;;
        *)
            if [ -d "$input" ]; then
                cd ./"$input"
                list_files_and_dirs
            elif [ -f "$input" ]; then
                echo -e "\nNot implemented!"
            else 
                echo -e "\nInvalid input!"
            fi
            list_files_and_dirs
            ;;
        esac
    done
}

main () {
while true; do
    echo " 
------------------------------
| Hyper Commander            |
| 0: Exit                    |
| 1: OS info                 |
| 2: User info               |
| 3: File and Dir operations |
| 4: Find Executables        |
------------------------------"

    read -rp "> " input

    case "$input" in
    0)
        echo -e "\nFarewell!\n"
        exit 0
        ;;
    1)
        echo -e "\n$(uname --operating-system --nodename)"
        ;;
    2)
        echo -e "\n$(whoami)"
        ;;
    3)
        list_files_and_dirs
        ;;
    4)
        echo -e "\nNot implemented!\n"
        ;;
    *)
        echo -e "\nInvalid option!\n"
        ;;
    esac

done
}

echo -e "Hello ${USER}!"
main