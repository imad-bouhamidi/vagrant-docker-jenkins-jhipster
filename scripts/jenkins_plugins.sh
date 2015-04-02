#!/bin/bash
set -e
#: $# is the number of arguments
#: if there are no argument to the script it will exist showing usage example
if [ $# -eq 0 ]; then
#: $0 is the command executed, in this case the script name
  echo "USAGE: $0 plugin1 plugin2 ..."
  exit 1
fi

#: where plugins will be installed. you can change it to match your configuration
plugin_dir=/var/lib/jenkins/plugins
#: file where the configuration will be stored I guess.
file_owner=jenkins.jenkins

#: create the directory if not exist (the -p mean if not exist)
mkdir -p $plugin_dir

#: this is a method in a script shell, this is the way we declare a function [installPlugin "$plugin"] here ${1} is the name of plugin "$plugin"
installPlugin() {
#: test if plugin already installed
#: the ${1} here in the if mean the first argument to this function
  if [ -f ${plugin_dir}/${1}.hpi -o -f ${plugin_dir}/${1}.jpi ]; then
    if [ "$2" == "1" ]; then
      return 1
    fi
    echo "Skipped: $1 (already installed)"
    return 0
  else
#: installing the plugin if not installed yet.
    echo "Installing: $1"
    curl -L --silent --output ${plugin_dir}/${1}.hpi  https://updates.jenkins-ci.org/latest/${1}.hpi
    return 0
  fi
}

#: $* mean all script arguments as list
#: so here iterating on all arguments and runing the installPlugin function to install every plugin in script params
for plugin in $*
do
    installPlugin "$plugin"
done
 
changed=1
maxloops=100

#: this part of code check dependecies for all plugin installed and install them. dependencies of one plugin is retreived from META-INF/MANIFEST.MF in each plugin zip
while [ "$changed"  == "1" ]; do
  echo "Check for missing dependecies ..."
  if  [ $maxloops -lt 1 ] ; then
    echo "Max loop count reached - probably a bug in this script: $0"
    exit 1
  fi
  ((maxloops--))
  changed=0
  for f in ${plugin_dir}/*.hpi ; do
    # without optionals
    #deps=$( unzip -p ${f} META-INF/MANIFEST.MF | tr -d '\r' | sed -e ':a;N;$!ba;s/\n //g' | grep -e "^Plugin-Dependencies: " | awk '{ print $2 }' | tr ',' '\n' | grep -v "resolution:=optional" | awk -F ':' '{ print $1 }' | tr '\n' ' ' )
    # with optionals
    deps=$( unzip -p ${f} META-INF/MANIFEST.MF | tr -d '\r' | sed -e ':a;N;$!ba;s/\n //g' | grep -e "^Plugin-Dependencies: " | awk '{ print $2 }' | tr ',' '\n' | awk -F ':' '{ print $1 }' | tr '\n' ' ' )
    for plugin in $deps; do
      installPlugin "$plugin" 1 && changed=1
    done
  done
done
 
echo "fixing permissions"
 
chown ${file_owner} ${plugin_dir} -R
 
echo "all done"
###########################################
