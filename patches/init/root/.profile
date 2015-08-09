export SDL_MOUSEDEV=/dev/input/event1
export SDL_MOUSEDRV=TSLIB
export TSLIB_TSDEVICE=/dev/input/event1
export TERM=linux
export DISPLAY=:0

if test -z "${XDG_RUNTIME_DIR}"; then
    export XDG_RUNTIME_DIR=/tmp/root-runtime-dir
    if ! test -d "${XDG_RUNTIME_DIR}"; then
        mkdir "${XDG_RUNTIME_DIR}"
        chmod 0700 "${XDG_RUNTIME_DIR}"
    fi
fi

