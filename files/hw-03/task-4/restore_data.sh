#!/bin/bash
declare -A BACKUPS
INDEX=1
SOURCE=/home/boris/GIT/
REMOTE=vm01@192.168.1.66

for path_to_backup in $(ssh vm01@192.168.1.66 "ls -d /tmp/backup/*/*"); do #наполнение массива данных
    BACKUPS[$INDEX]=$path_to_backup
    ((INDEX++))
done

restore_data(){  #вызов команды по восстановления данных из бэкапа
    rsync -a $REMOTE:${BACKUPS[$1]}/ \
    $SOURCE
}


show_backup_list(){ #вывод в консоль пользователю список доступных бэкапов
    echo "Доступные бэкапы:"
    echo -e "================= \n"

    for backup_dir in $(printf '%s\n' "${!BACKUPS[@]}" | sort -n); do
        echo "$backup_dir" = "${BACKUPS[$backup_dir]#/tmp/backup/}"
    done
}

confirm_choice() {  #запрос на подтверждение выбора пользователя
     while true; do
        echo -e "================= \n"
        echo -e "Вы выбрали бэкап: "${BACKUPS[$choice]#/tmp/backup/}"\v"
        echo -e "Начать процесс восстановления данных? \nYes - запустиь процесс, No - вернуться к выбору бэкапа\nДля отметы Ctr + C\n"

        read confirmation

        case $confirmation in
            [Yy][Ee][Ss]|[Yy])
                echo "Запуск восстановления..."
                restore_data $choice
                echo "Восстановление завершено!"
                return 0
                ;;
            [Nn][Oo]|[Nn])
                echo -e "Возврат к выбору бэкапа... \n"
                return 1
                ;;
            *)
                echo -e "Пожалуйста, введите Yes или No\n"
                ;;
        esac
    done        
}

while true; do  #запуск основного вечного цикла, выход из цикла в случае подтверждения выбора от пользователя
    show_backup_list

    echo "Введите номер бэкап для восстановления"
    read choice

    if confirm_choice; then
        break
    else
        continue
    fi
done


