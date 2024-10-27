#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t -A -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo Welcome to My Salon, how can I help you?
MAIN_MENU(){
if [[ $1 ]]
  then 
  echo -e "\n$1"
fi


psql --username=freecodecamp --dbname=salon -t -A -c "SELECT service_id || ') ' || name FROM services ORDER BY service_id;"
read SERVICE_ID_SELECTED
if [[ ! $SERVICE_ID_SELECTED =~ ^[1-5]+$ ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    echo "What's your phone number?"
    read CUSTOMER_PHONE

    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'") 
    if [[ -z $CUSTOMER_NAME ]]
    then 
      echo "I don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')") 
    fi

    echo "What time would you like your cut, $CUSTOMER_NAME?"
    read SERVICE_TIME

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    APPOINTMENTS_INSERT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

    NAME_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    echo "I have put you down for a $NAME_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
fi
}

MAIN_MENU