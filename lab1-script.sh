#!/usr/bin/bash

#echo "Выполнение скрипта $0:"

HTML_PAGE_PATH="/var/www/html/index.html"
CURR_DATE=$(TZ=":Europe/Moscow" date +%Y-%m-%d)
CURR_TIME=$(TZ=":Europe/Moscow" date +%H:%M%Z)

#читаем первый параметр командной строки 
CITY=$1

#curl-им контент в формате json
CONTENT=$(curl -s https://wttr.in/${CITY}?format=j1)
# echo ${CONTENT} | jq '.["current_condition"][0] | .observation_time,.temp_C,.humidity'

#с помощью jq парсим json
RES_TIME=$(echo "${CONTENT}" | jq -r '.["current_condition"][0] | .observation_time')
RES_TEMP=$(echo "${CONTENT}" | jq -r '.["current_condition"][0] | .temp_C')
RES_HUMID=$(echo "${CONTENT}" | jq -r '.["current_condition"][0] | .humidity')

#формируем вывод
RES=$(echo "<!DOCTYPE html>\n<html lang=\"ru\">\n<head><meta charset=\"UTF-8\"><title>Погода</title></head>\n<body> \n")
RES+=$(echo "Погода сегодня в $CITY: \n")
RES+=$(echo "<ul>\n <li> температура ${RES_TEMP} °C </li>\n <li> влажность ${RES_HUMID} % </li> \n <li> время замера параметров - ${RES_TIME} </li> \n</ul> \>
RES+=$(echo "Текущее время $CURR_DATE $CURR_TIME \n")
RES+=$(echo "</body>\n</html>")

#печатаем
echo -e ${RES}

#перезаписываем html-страницу для вывода по запросу
#echo -e ${RES} > ${HTML_PAGE_PATH} 
