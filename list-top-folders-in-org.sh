#!/usr/bin/env bash

#
# DOCUMENTS ARGUMENTS
#

usage() {
  echo -e "\nUsage: $0 [-g] [-h] [organization name]" 1>&2
  echo -e "\nOptions:\n"
  echo -e "    -g    Generate BigQuery insert statements"
  echo -e "    -h    Display command help "
  echo -e "\n"
  exit 1
}

setScriptOptions()
{
    while getopts ":gh" arg; do
      case $arg in
        g) # generate BQ
          BQ="1"
          ;;
        h | * ) # Display help.
          usage
          ;;
      esac
    done
    ORG=${@:$OPTIND:1}
    [ -z "$ORG" ] && usage
}

##########################
##                      ##
## RUN SCRIPT FUNCTIONS ##
##                      ##
##########################

# set options from script input / default value
setScriptOptions "$@"

# We need to work with the organization id instead of the name, so go look it up.
ORGNUM=$(gcloud organizations list --filter="displayName~^$ORG" --format="value(name)")
if [ -z "$ORGNUM" ]
then
  echo "ERROR: Organization not found."
  exit 1
fi

# Get the list of top level folders in the organiation.  Gcloud will output in CSV but not wrapped in quotes.
FOLDERS=$(gcloud resource-manager folders list --organization $ORGNUM --format="csv[no-heading](name,displayName)")

#Wrap the CSV values in double quotes
CSV=$(echo -e "$FOLDERS" | awk -F, -v OFS="," -v re="^'?|'?$" -v q='"' '{for(i=1;i<=NF;i++)if($i)gsub(re,q,$i);else $i=q$i q}7')


# Print the output.  BigQuery insert statements or just the list
if [ "$BQ" = "1" ]
then
  
  OUT=$(
    echo -e "INSERT INTO \`myproject.mydataset.gcp_folder\`"
    echo "(ancestry_number, name) VALUES"
    while read -r line; do
      echo -e "($line),"
    done <<< "$CSV"
  )
  echo "${OUT%?}"

else
  echo -e "$CSV"
fi




