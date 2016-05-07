#!/bin/bash

go_to() {
  cd $ANSIBLE_HOME
  git co -q $1
  git submodule update -q
  find . -name \*.pyc | xargs rm
  cd -
}

play_run() {
  time python -m cProfile -s time $ANSIBLE_HOME/bin/ansible-playbook -i hosts $* | \
    grep -A 10 'function calls'
}

for v in upstream/stable-1.9 upstream/stable-2.1 upstream/devel; do
  go_to $v > /dev/null
  cat <<EOF
********************************************************************************
EOF
  $ANSIBLE_HOME/bin/ansible-playbook --version
  [ -e "$ANSIBLE_CONFIG" ] && tail "$ANSIBLE_CONFIG"
  play_run speedtest.yml $*
done
