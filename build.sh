#! /bin/bash

set -e

case "$1" in
    leeloo|rev2)
        KEYBOARD="leeloo_rev2"
        ;;
    leeloo-micro|micro)
        KEYBOARD="leeloo_micro"
        ;;
    kyria)
        KEYBOARD="kyria_rev3"
        ;;
    *)
        #echo "ERROR: Keyboard must be specified or is unknown"
        #exit 1
        KEYBOARD="kyria_rev3"
	;;
esac

if [ "$2" ]; then
    SIDES="$2"
else
    SIDES="left right"
fi

# Lets me use a private repo.
if [ "$SSH_AUTH_SOCK" != "" ]; then
    SSH_AUTH_VOLUME="-v $(readlink -f $SSH_AUTH_SOCK):/.ssh-agent -e SSH_AUTH_SOCK=/.ssh-agent"
else
    SSH_AUTH_VOLUME=
fi

TAG="private/zmk-flash:${KEYBOARD}"

podman build --tag ${TAG} .

mkdir -p .app/${KEYBOARD} output/${KEYBOARD}

for side in ${SIDES}; do
    podman run --rm -it ${SSH_AUTH_VOLUME} \
           -e SHIELD="${KEYBOARD}" \
           -v $(pwd)/.app/${KEYBOARD}:/app:z \
           -v $(pwd)/config:/app/config:z,ro \
           -v $(pwd)/output/${KEYBOARD}:/app/output:z \
           -v $(pwd):/src:z,ro \
           ${TAG} /src/_build.sh ${side}
done
