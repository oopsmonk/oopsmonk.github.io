#!/bin/bash 
# 
# Build script for wayland weston with DRM backdend 
# RaspberryPi image: 2017-04-10-raspbian-jessie-lite 
# By oopsmonk@gmail.com
# 

WLROOT=$PWD/weston-build/

clone_or_update() {
    repo=$1
    dest=$(basename $repo)

    cd ${WLROOT}
    if [ $? != 0 ]; then
	echo "Error: Could not cd to ${WLROOT}.  Does it exist?"
	exit 1
    fi
    echo
    echo checkout: $dest
    if [ ! -d ${dest} ]; then
	git clone ${repo} ${dest}
	if [ $? != 0 ]; then
	    echo "Error: Could not clone repository"
	    exit 1
	fi
    fi
    cd ${dest}
    git checkout master
    if [ $? != 0 ]; then
	echo "Error: Problem checking out master"
	exit 1
    fi
    git pull
    if [ $? != 0 ]; then
	echo "Error: Could not pull from upstream"
	exit 1
    fi
    
    if [[ $2 ]]; then
        branch=$2
        git checkout ${branch} -b ${branch}_local
	if [ $? != 0 ]; then
	    git checkout ${branch}_local
	fi
    fi
    cd ${WLROOT}
}

do_deps(){
    sudo apt-get update 
    sudo apt-get install git autoconf libtool build-essential -y
    # wayland
    sudo apt-get install libffi-dev libexpat1-dev libxml2-dev -y
    # libinput
    sudo apt-get install libmtdev-dev libudev-dev libevdev-dev libwacom-dev -y
    # drm
    sudo apt-get install xutils-dev -y
    # mesa
    sudo apt-get install bison flex python-mako gettext -y
    # weston 
    sudo apt-get install libpam0g-dev libjpeg-dev -y
}

do_checkout(){
    clone_or_update git://anongit.freedesktop.org/wayland/wayland 1.13.0
    clone_or_update git://anongit.freedesktop.org/wayland/wayland-protocols 1.7
    clone_or_update git://anongit.freedesktop.org/wayland/libinput 1.7.2
    clone_or_update git://anongit.freedesktop.org/git/mesa/drm libdrm-2.4.81
    clone_or_update git://anongit.freedesktop.org/mesa/mesa mesa-17.1.1
    clone_or_update git://github.com/xkbcommon/libxkbcommon xkbcommon-0.7.1
    clone_or_update git://anongit.freedesktop.org/pixman pixman-0.34.0
    clone_or_update git://anongit.freedesktop.org/cairo 1.15.4
    clone_or_update git://anongit.freedesktop.org/wayland/weston 2.0.0
    clone_or_update https://github.com/glmark2/glmark2.git
}

gen(){                                                                                                                                                                    
    pkg=$1
    shift
    echo
    echo autogen $pkg
    cd $WLROOT/$pkg
    if [ ! -f ".done_gen" ]; then
	echo "./autogen.sh $*"
	./autogen.sh $*
	if [ $? != 0 ]; then
	    echo "Configure Error.  Terminating"
	    exit 1
	fi
	touch .done_gen
    fi
}

compile(){                                                                                                                                                                
    if [ ! -f ".done_make" ]; then
	make -j4
	if [ $? != 0 ]; then
	    echo "Build Error.  Terminating"
	    exit 1
	fi
	touch .done_make
        echo build done...
    fi

    if [ ! -f ".done_install" ]; then
        sudo make install
        if [ $? != 0 ]; then
            echo "Install Error.  Terminating"
            exit 1
        fi
        touch .done_install
        echo install done... 
    fi
}

build_glmark2(){
    cd ${WLROOT}/glmark2.git
    if [ ! -f ".done_gen" ]; then
        echo "configure glmark2" 
        ./waf configure --with-flavors=drm-glesv2,wayland-glesv2
	if [ $? != 0 ]; then
	    echo "Configure Error.  Terminating"
	    exit 1
	fi
	touch .done_gen
    fi

    if [ ! -f ".done_make" ]; then
        ./waf
	if [ $? != 0 ]; then
	    echo "Build Error.  Terminating"
	    exit 1
	fi
	touch .done_make
        echo build done...
    fi

    if [ ! -f ".done_install" ]; then
	sudo ./waf install
	if [ $? != 0 ]; then
	    echo "Install Error.  Terminating"
	    exit 1
	fi
	touch .done_install
        echo install done...
    fi
}

do_build(){
    gen wayland --disable-documentation
    compile

    gen wayland-protocols
    compile

    gen libinput
    compile

    gen drm
    compile

    # VC4_CFLAGS for 
    # Error: selected processor does not support ARM mode `vst1.8 d0,[r5],r3’
    export VC4_CFLAGS="-march=armv7-a -mfpu=neon"
    gen mesa \
        --enable-gles2 --disable-glx --enable-gbm \
        --enable-shared-glapi --with-gallium-drivers=vc4 \
        --with-dri-drivers= --with-egl-platforms=wayland,drm \
        --disable-dri3 
        #--disable-dri3 VC4_CFLAGS="-march=armv7-a -mfpu=neon"\' 
    # mesa hack src/egl/main/egl.pc
    sed -i '/^Libs:/ s/$/ -ldrm/' src/egl/main/egl.pc
    unset VC4_CFLAGS
    compile

    gen libxkbcommon --disable-x11 --disable-docs
    compile

    # --disable-arm-iwmmxt for compiler error:
    # internal compiler error: Max. number of generated reload insns per insn is achieved (90)
    gen pixman --disable-arm-iwmmxt 
    compile

    gen cairo
    compile

    gen weston \
        --with-cairo=image \
        --enable-clients --enable-headless-compositor \
        --enable-demo-clients-install --enable-drm-compositor \
        --disable-xwayland --enable-setuid-install=no \
        --disable-x11-compositor
    compile

    build_glmark2

}

pkg_uninstl(){
    pkg=$1
    shift
    echo
    echo uninstall $pkg
    cd $WLROOT/$pkg
    sudo make uninstall
    rm .done_install
}

do_uninstall(){
    pkg_uninstl wayland
    pkg_uninstl wayland-protocols
    pkg_uninstl libinput
    pkg_uninstl drm
    pkg_uninstl mesa
    pkg_uninstl libxkbcommon
    pkg_uninstl pixman
    pkg_uninstl cairo
    pkg_uninstl weston

    cd $WLROOT/glmark2.git
    sudo ./waf uninstall
    rm .done_install
}

pkg_distc(){
    pkg=$1
    shift
    echo
    echo clean $pkg
    cd $WLROOT/$pkg
    git clean -dxf
}

do_distclean(){
    pkg_distc wayland
    pkg_distc wayland-protocols
    pkg_distc libinput
    pkg_distc drm
    pkg_distc mesa
    pkg_distc libxkbcommon
    pkg_distc pixman
    pkg_distc cairo
    pkg_distc weston
    pkg_distc glmark2.git
}

if [ "$1" = "" ]; then                                                                                                                                                       
    echo "$0 commands are:  "
    echo "    all           "
    echo "    deps          "
    echo "    checkout      "
    echo "    build         "
    echo "    uninstall     "
    echo "    distclean     "
else
    if [ ! -d ${WLROOT} ]; then
        mkdir -p ${WLROOT}
        if [ $? != 0 ]; then
            echo "Error: Could not create dir ${WLROOT}"
            exit 1
        fi
    fi

    while [ "$1" != "" ]
    do
        case "$1" in
            all)
                do_deps
                do_checkout
                do_build
                ;;
            deps)
                do_deps
                ;;
            checkout)
                do_checkout
                ;;
            build)
                do_build
                ;;
            uninstall)
                do_uninstall
                ;;
            distclean)
                do_uninstall
                do_distclean
                ;;
            *)
                echo -e "$0 \033[47;31mUnknown CMD: $1\033[0m"
                exit 1
                ;;
        esac
        shift 1
    done
    cd $WLROOT
fi


exit 0
