
# Constants
PROGRAM="mount.efs-nfs4"
VERSION="1.0.1"
MOUNT_NFS4="/sbin/mount.nfs4"
EC2METADATA="/usr/bin/ec2metadata"

# Check dependencies
[ -x "$MOUNT_NFS4" ] || exit 1
[ -x "$EC2METADATA" ] || exit 1

# Functions

usage() {
    echo "usage: $PROGRAM remotetarget dir [-rvVwfnsh] [-o nfsoptions]"
    echo "options: check 'mount.nfs4 -h' for more info"
}

version() {
    echo "$PROGRAM: $VERSION"
}

usage_and_exit() {
    if [ -n "$1" ]; then
        echo "$PROGRAM: $1" >&2
    fi
    usage >&2
    exit 1
}

# Change args order to place positional args at the end
option_args=""
positional_args=""
while [ "$#" -ne 0 ]; do
    case "$1" in
        -o)
            option_args="$option_args $1 $2"
            shift 2
            ;;
        -*)
            option_args="$option_args $1"
            shift
            ;;
        *)
            positional_args="$positional_args $1"
            shift
            ;;
    esac
done
set -- $option_args $positional_args

# Parse option args
verbose=0
mount_nfs4_options=""
while getopts ":hVrvwfnso:" _param; do
    case "$_param" in
        h)
            usage_and_exit
            ;;
        V)
            version
            exit
            ;;
        v)
            verbose=1
            mount_nfs4_options="$mount_nfs4_options -v"
            ;;
        rwfns)
            mount_nfs4_options="$mount_nfs4_options -$OPTARG"
            ;;
        o)
            mount_nfs4_options="$mount_nfs4_options -o $OPTARG"
            ;;
        :)
            usage_and_exit "option requires an argument -- '$OPTARG'"
            ;;
        \?)
            usage_and_exit "invalid option -- '$OPTARG'"
            ;;
    esac
done

# Parse positional args
shift "$((OPTIND - 1))"
if [ "$#" -eq 0 ]; then
    usage_and_exit "no remote target provided"
elif [ "$#" -eq 1 ]; then
    usage_and_exit "no mount point provided"
elif [ "$#" -gt 2 ]; then
    usage_and_exit "invalid number of parameters"
fi
efs_remote_target="$1"
mount_point="$2"

# Converting the EFS remote target to a valid NFS4 remote target
if ! output=$("$EC2METADATA" --availability-zone 2>&1); then
    usage_and_exit "error while getting ec2 metadata -- $output"
fi
remote_target="${output}.${efs_remote_target}"

# Mount using mount.nfs4
cmd=$(echo "$MOUNT_NFS4 $remote_target $mount_point $mount_nfs4_options" | \
        tr -s " ")
[ "$verbose" -eq 1 ] && echo "$PROGRAM: runnning $cmd"
$cmd