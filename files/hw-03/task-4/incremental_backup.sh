#!/bin/bash
SOURCE=/home/boris/GIT/
REMOTE=vm01@192.168.1.66
ROOT_BACKUP=/tmp/backup
DATE=$(date +%Y%m%d_%H%M%S)

ssh $REMOTE "mkdir -p $ROOT_BACKUP/{full,incr}" #подготовка директорий под бэкапы

full_backup(){  #создание полного бэкапа
    rsync -a --delete ${SOURCE} \
    ${REMOTE}:$ROOT_BACKUP/full/${DATE}
}

incr_backup() { #создание инкрементного бэкапа
    rsync -a --delete --link-dest=$(find_lastbackup) \
    ${SOURCE} \
    ${REMOTE}:${ROOT_BACKUP}/incr/${DATE}
}

find_lastbackup(){  #поиск пути к самому свежему инкрементному бэкапу
    ssh ${REMOTE} "ls -d /tmp/backup/*/* | tail -1" 2> /dev/null
}

count_incrbackup(){ #подсчет количества инкрементных бэкапов
    ssh ${REMOTE} "ls -d /tmp/backup/incr/* | wc -l" 2> /dev/null
}

find_old_incrbackup(){  #поиск самого старого инкрементного бэкапа
    ssh ${REMOTE} "ls -d /tmp/backup/incr/* | head -1" 2> /dev/null
}

if [[ -z "$(find_lastbackup)" ]]; then
    full_backup
elif [[ "$(count_incrbackup)" -ne 5 ]];then
    incr_backup
else ssh $REMOTE "rm -rf $(find_old_incrbackup)" && incr_backup
fi