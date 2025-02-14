#!/bin/bash

count=0

while IFS= read -r line; do
    if [[ $line ==  *"POST"* ]] || [[ $line == *"GET"* ]] || [[ $line == *"PUT"* ]] || [[ $line == *"DELETE"* ]] ; then
       let count+=1
   fi
done < access.log

echo "Отчет о логе веб-сервера" > report.txt
echo "========================" >> report.txt
echo "Общее количество запросов:   $count" >> report.txt
 
awk '{IPs[$1]++} END {print "Количество уникальных IP-адресов:   ", length(IPs) >> "report.txt"}' access.log

echo "" >> report.txt
echo "Количество запросов по методам:" >> report.txt

awk '{METHOD[$6]++}
 END {for (met in METHOD){print METHOD[met], substr(met,2) >> "report.txt"}}' access.log

echo "" >> report.txt

awk '{URL[$7]++
max_value=-1
max_key=""
for (key in URL){
    if (URL[key]>max_value){
	max_value=URL[key]
	max_key=key
}}} END{print "Самый популярный URL:", max_value, max_key >> "report.txt"}' access.log

echo "Отчет сохранен в файл report.txt"
