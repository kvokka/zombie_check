##Severs.com, тестовое задание

Нужно написать приложение:

Приложение имеет следующие вызовы:
1) Добавить IP-адрес к подсчету статистики (параметр - IP-адрес, нотацию выбери сам)
2) Удалить IP-адрес из подсчета статистики (параметр - IP-адрес, нотацию выбери сам)
3) Сообщить статистику доступности IP-адреса по ICMP [то есть посредством ping] (параметры - IP-адрес, начало интервала времени, конец интервала времени). Получив начало и конец интервала времени, должно вернуть JSON, содержащий следующие поля:
       - среднее RTT (время отклика на пинг) за этот период
       - минимальное RTT за этот период
       - максимальное RTT за этот период
       - медианное RTT за этот период
       - среднеквадратичное отклонение замеров RTT за этот период
       - процент потерянных пакетов ICMP (ping) до указанного адреса за этот период.

Если какую-то часть времени в этом периоде IP-адрес был вне расчета статистики (не был добавлен или был удален) - эту часть времени учитывать не нужно. Например, мы добавили ip-адрес 8.8.8.8 в 1 час, выключили в 2, включили в 3 и выключили в 4. Если я запросил статистику с 1 по 4 часа — надо объединить интервалы 1-2, 3-4 и отдать эту статистику по объединенному интервалу. Если IP-адрес не был в расчете статистики все время или был настолько мало времени, что мы не успели сделать хотя бы 1 замер - надо вернуть сообщение об ошибке.

Соответственно, удаленные машины, имеющие IP-адреса из этого списка могут вести себя очень странно - не отвечать на пинги, отвечать с ооочень большой задержкой - например, минуту (если захочется поиграться с этим случаем, его можно смоделировать на машинке, поставив, например, Charles http://www.charlesproxy.com/documentation/proxying/throttling/ туда).

Задание может быть выполнено на разном уровне сложности - можно замахнуться на то, чтобы сделать идеально и таки научиться обрабатывать ситуации с пингом в минуту, или пытаться оптимизировать производительность - а можно не делать ничего из этого. Ты можешь пойти любым путем в зависимости от твоего свободного времени.

Ниже доступ в панель servers.com  — там ты можешь завести сколько тебе понадобится для выполнение виртуалок в клауде под Linux или Windows (на случай если тебе нужна среда запуска приложения или баз данных или еще чего-то, а на своем компьютере почему-то ты этого делать не хочешь).

URL: http://portal.servers.com
Login: foo@servers.com
Password: xxx


## Мои комментарии

 Стартовать надо через sudo, ибо `net-ping` полключается напрямую к сокетам. Можно переколбасить на обычный ping, если критично.

 В качестве интерфейса для хостов юзается фаил `hosts.txt` в корне. Но это можно переписать аргументами

 Ранее не было проблем с запуском pry, да и sudo в реальсе не особо нужен.  Словил прикольный момент, 
 который несколько смутил. Все шустро решилось, но все
 же http://stackoverflow.com/questions/37458855/unix-sudo-pry-does-not-start

 Charles умеет делать задержки для tcp или udp запросов, но вот ничего в настройках про icmp я так и не увидел. В любом случае буду признателен за тычек пальцем в нужную сторону.

 Если убрать задержку в `zombie_check delay:0` (чтобы замутить попытку DOS через ping :) то потоки долго убиваются. Я пока что не нашел способа это ускорить. Как вариант приписать #join в 19й строке checker.rb, но тогда исчезает все веселье.

 В данном виде, на бесконечном отрезке времени прога сожрет всю память. Я вкурсе, если это важно- поправлю.

 Если нужны тесты- приделаю. 

 Ввиду net-ping тесты придется стартовать под `sudo -i`. 

## UPDATED

Приделал тесты. Прошу учесть, что feature спеки хотят `sudo -i`. Unit тесты sudo не требуют.

## UPDATED 2

Тк провера затянулось, а меня давно подмывало избавиться в ТЗ от sudo, приделал адаптер для обычного ping из Unix.
Старый функционал так же оставил, переключается через опцию `tool:unix_ping` или `tool:net_ping`. Тесты не менял, 
ибо акцептанс живут также, а тестить в юнит тестах тут нечего имхо (хотя, если это противит политике партии, 
то это лечится, без эвтаназии :)
