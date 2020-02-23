#!/usr/bin/env bash

python=python
prefix=/usr

#site=mirors.aliyun.com
#site_dir=pypi/simple/
site=pypi.douban.com
site_dir=simple
site_override="-i http://${site}/${site_dir} --trusted-host ${site}"

$python -m pip install --upgrade pip setuptools wheel ${site_override}

# Get and build ta-lib
function install-ta-lib()
{
    pushd /tmp
    wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz
    tar -xf ta-lib-0.4.0-src.tar.gz
    cd ta-lib
    ./configure --prefix=$prefix
    make -j
    make install
    popd
}
function ta-lib-exists()
{
    ta-lib-config --libs > /dev/null
}
ta-lib-exists || install-ta-lib

# old versions of ta-lib imports numpy in setup.py
$python -m pip install numpy ${site_override}


# Install extra packages
$python -m pip install ta-lib ${site_override}

$python -m pip install https://vnpy-pip.oss-cn-shanghai.aliyuncs.com/colletion/ibapi-9.75.1-py3-none-any.whl

# Install Python Modules
$python -m pip install -r requirements.txt ${site_override}


# Install local Chinese language environment
locale-gen zh_CN.GB18030

# Install vn.py
$python -m pip install . $@
