#!/bin/sh

function pik  {
  pik_runner.exe pik.sh $@
  if [[ -n "${PIK_HOME}" ]]; then
    [[ -s $PIK_HOME/pik_run.sh ]] && source $PIK_HOME/pik_run.sh
  else 
    [[ -s ~/.pik/pik_run.sh ]] && source ~/.pik/pik_run.sh
  fi 
} 


