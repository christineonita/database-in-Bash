#!/bin/bash

db=""

quitfunction() {
  break
}

setdbfunction() {
  db=$var2
  if [ -n "$var3" ]
  then
    echo "Extra arguments ignored"
    if [[ $var2 == "" ]]
    then
      echo "Missing Argument"
    elif [ -f $var2 ] && [ -r $var2 ]
    then
      echo "Database set to "$db
    elif [ -f $var2 ] && [ ! -r $var2 ]
    then
      echo "File "$db" not readable"
    elif [ ! -f $var2 ]
    then
      touch $var2
      echo "File "$db" created. Database set to "$db
    fi
  else
    if [[ $var2 == "" ]]
    then
      echo "Missing Argument"
    elif [ -f $var2 ] && [ -r $var2 ]
    then
      echo "Database set to "$db
    elif [ -f $var2 ] && [ ! -r $var2 ]
    then
      echo "File "$db" not readable"
    elif [ ! -f $var2 ]
    then
      touch $var2
      echo "File "$db" created. Database set to "$db
    fi
  fi
}

addfunction() {
  if [[ $db == "" ]]
  then
    echo "Database has not been set."
  else
    if [[ $var2 == "" ]] || [[ $var3 == "" ]] 
    then
      echo "Incorrect syntax."
    else
      if ! grep -i -q "$var2" $db
      then
        echo $var2":"$var3 >> $db
        echo $var2":"$var3" has been added to the database"
      else
        sed -i "/$var2/c\\$var2:$var3" $db
        echo $var2" has been updated to "$var3
      fi
    fi
  fi
}

deletefunction() {
  if [[ $db == "" ]]
  then
    echo "Database has not been set."
  else
    if [[ $var2 == "" ]]
    then
      echo "Incorrect syntax."
    else
      if ! grep -i -q $var2 "$db"
      then
        echo $var2" does not exist in "$db
      else
        sed -i "/$var2/ d" $db
        echo $var2" has been deleted from "$db
      fi
    fi
  fi
}

printdbfunction() {
  if [[ $db == "" ]]
  then
    echo "Database has not been set."
  else
    printf "    Product        Price\n -------------    --------\n"
    while IFS=“:” read -r product price; do
    printf "%-13s%6s%7s\n" $product $ $price
    done < $db
  fi
}


while [ 1 ]; do

echo -n "$ "

read var1 var2 var3

if [[ $var1 == "setdb" ]]
then
  setdbfunction
elif [[ $var1 == "add" ]]
then
  addfunction
elif [[ $var1 == "delete" ]]
then
  deletefunction
elif [[ $var1 == "printdb" ]]
then
  printdbfunction
elif [[ $var1 == "quit" ]]
then
  quitfunction
else
  echo "Unrecognized command"
fi

done
