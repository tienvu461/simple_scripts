if [ $# -ge 1 ]
then
    CONFIG=$1
else
    CONFIG=~/.config/ssh_peco/remote_hosts
fi

function read_ini_file() {
    local obj=$1
    local key=$2
    local file=$3
    awk '/^\[.*\]$/{obj=$0}/=/{print obj $0}' $file \
        | grep '^\['$obj'\]'$key'=' \
        | perl -pe 's/.*=//'
}

function ssh_start() {
    REMOTE=$(grep -iE "\[*\]" $CONFIG | tr -d "[]" | peco)
    echo $REMOTE
    IP=$(read_ini_file $REMOTE ip $CONFIG)
    BASTION=$(read_ini_file $REMOTE bastion $CONFIG)
    if [ -z ${BASTION} ]; then
        ssh $IP
    else
        BASTION_IP=$(read_ini_file $BASTION ip $CONFIG)
        ssh -J $BASTION_IP $IP
    fi
}

ssh_start

