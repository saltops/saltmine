#!yaml

# Command-line pip examples:
# pip install boto

# upgrade to latest version... (also uninstalls)
# pip install -U boto

# install specific file from arbitrary location
# pip install http://dl.dropbox.com/u/174789/m2crypto-0.20.1.tar.gz

# install specific version from pypi (With md5)
# first, look up the pip module here: http://pypi.python.org/simple/
# then, go to the directory and copy the url to the file you want...
# pip install http://pypi.python.org/packages/source/b/boto/boto-2.7.0.tar.gz\#md5\=b19c6856c1e116556a0cab1aefc29ae2

# python-pip-pkg:
#   pkg.installed:
#     - name: python-pip

python-pip-cmd:
  cmd.run:
    - name: easy_install pip
    - unless: pip --version 2> /dev/null
