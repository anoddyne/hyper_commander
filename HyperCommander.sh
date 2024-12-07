#!/usr/bin/env bash

list_files_and_dirs() {
    clear
    echo -e "The list of files and directories: "
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
---------------------------------------------------"
    read -rp "> " input_name
    while true; do
        case "$input_name" in
        0)
            clear
            main
            ;;
        "up")
            cd ..
            list_files_and_dirs
            ;;
        *)
            if [ -d "$input_name" ]; then
                trap 'echo "Error accessing folder"; sleep 5' ERR
                cd ./"$input_name"
                list_files_and_dirs
            elif [ -f "$input_name" ]; then
                trap 'echo "Error accessing file"; sleep 5' ERR
                file_options "$input_name"
            else
                echo -e "\nInvalid input!\n"
                read -rp "Press Enter to continue..."
                clear
            fi
            list_files_and_dirs
            ;;
        esac
    done
}

file_options() {
    echo -e "---------------------------------------------------------------------
| 0 Back | 1 Delete | 2 Rename | 3 Make writable | 4 Make read-only |
---------------------------------------------------------------------"
    read -rp "> " file_name
    case "$file_name" in
    0)
        ;;
    1)
        rm "$1"
        echo -e "$1 has been deleted.\n"
        read -rp "Press Enter to continue..."
        ;;
    2)
        read -rp "Enter the new file name: " new_name
        mv "$1" "$new_name"
        echo -e "\n${1} has been renamed as ${new_name}"
        read -rp "Press Enter to continue..."
        ;;
    3)
        chmod a+rw "$1"
        echo "Permissions have been updated."
        ls -l "$1"
        read -rp "Press Enter to continue..."
        ;;
    4)
        chmod ug+rw,o=r "$1"
        echo "Permissions have been updated."
        ls -l "$1"
        read -rp "Press Enter to continue..."
        ;;
    *)
        file_options "$1"
        ;;
    esac
}

find_executable () {
    echo "Enter an executable name: "
    read -rp "> " exec_name
    location=$(which "$exec_name")
    if [ -n "$location" ]; then
        echo "Located in: $location"
        read -rp "Enter arguments: " arguments
        $exec_name "$arguments"
        read -rp "Press Enter to continue..."
        clear
    else
        echo "The executable with that name does not exist!"
        read -rp "Press Enter to continue..."
        clear
    fi
}

main() {
    while true; do
        echo -e "Hello ${USER}!"
        echo "------------------------------
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
            echo -e "\n$(uname --operating-system --nodename)\n"
            read -rp "Press Enter to continue..."
            clear
            ;;
        2)
            echo -e "\n$(whoami)\n"
            read -rp "Press Enter to continue..."
            clear
            ;;
        3)
            list_files_and_dirs
            ;;
        4)
            find_executable
            ;;
        *)
            echo -e "\nInvalid option!\n"
            read -rp "Press Enter to continue..."
            clear
            ;;
        esac

    done
}
clear
main
