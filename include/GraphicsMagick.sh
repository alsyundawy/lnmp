#!/bin/bash
# Author:  yeho <lj2007331 AT gmail.com>
# BLOG:  https://linuxeye.com

Install_GraphicsMagick() {
  if [ -d "${gmagick_install_dir}" ]; then
    echo "${CWARNING}GraphicsMagick already installed! ${CEND}"
  else
    pushd ${current_dir}/src > /dev/null
    tar xJf GraphicsMagick-${graphicsmagick_ver}.tar.xz
    pushd GraphicsMagick-${graphicsmagick_ver} > /dev/null
    ./configure --prefix=${gmagick_install_dir} --enable-shared --enable-static --enable-symbol-prefix
    make -j ${THREAD} && make install
    popd > /dev/null
    rm -rf GraphicsMagick-${graphicsmagick_ver}
    popd > /dev/null
  fi
}

Uninstall_GraphicsMagick() {
  if [ -d "${gmagick_install_dir}" ]; then
    rm -rf ${gmagick_install_dir}
    echo; echo "${CMSG}GraphicsMagick uninstall completed${CEND}"
  fi
}

Install_pecl_gmagick() {
  if [ -e "${php_install_dir}/bin/phpize" ]; then
    pushd ${current_dir}/src > /dev/null
    phpExtensionDir=`${php_install_dir}/bin/php-config --extension-dir`
    if [ "`${php_install_dir}/bin/php-config --version | awk -F. '{print $1}'`" == '5' ]; then
      tar xzf gmagick-1.1.7RC3.tgz
      pushd gmagick-1.1.7RC3 > /dev/null
    else
      tar xzf gmagick-${gmagick_ver}.tgz
      pushd gmagick-${gmagick_ver} > /dev/null
    fi
    export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
    ${php_install_dir}/bin/phpize
    ./configure --with-php-config=${php_install_dir}/bin/php-config --with-gmagick=${gmagick_install_dir}
    make -j ${THREAD} && make install
    popd > /dev/null
    if [ -f "${phpExtensionDir}/gmagick.so" ]; then
      echo 'extension=gmagick.so' > ${php_install_dir}/etc/php.d/03-gmagick.ini
      echo "${CSUCCESS}PHP gmagick module installed successfully! ${CEND}"
      rm -rf gmagick-${gmagick_ver} gmagick-1.1.7RC3
    else
      echo "${CFAILURE}PHP gmagick module install failed, Please contact the author! ${CEND}" && grep -Ew 'NAME|ID|ID_LIKE|VERSION_ID|PRETTY_NAME' /etc/os-release
    fi
    popd > /dev/null
  fi
}

Uninstall_pecl_gmagick() {
  if [ -e "${php_install_dir}/etc/php.d/03-gmagick.ini" ]; then
    rm -f ${php_install_dir}/etc/php.d/03-gmagick.ini
    echo; echo "${CMSG}PHP gmagick module uninstall completed${CEND}"
  else
    echo; echo "${CWARNING}PHP gmagick module does not exist! ${CEND}"
  fi
}
