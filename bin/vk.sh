#!/bin/bash

#-------------- Module Identification Data -------------#
export MODULE_AKEY="b8d5d6eca9ef30427712f2f0151334a2"
export MODULE_AUTH=""
export MODULE_NAME="VK"
export MODULE_VERS="-0.95"
export MODULE_DATE="06.IX.2011"
export MODULE_DESC="Поиск музыки ВКонтакте"
export MODULE_URII="http://ftemp.net/static/vksearch";
export MODULE_DPDC="mpv sed awk grep wget ps"
export MODULE_CPID="$$"
export MODULE_FILE="$0"
#-------------- Module Identification Ends -------------#


SETTINGsimilarartcount=10 #кол-во артистов в поиске похожих
SETTINGsimilartrcount=5   #кол-во песен каждого артиста в поиске похожих

id="5807425" # системная переменная. Взято из VK_Search Amarok Script (c) Взято из vksearch by snoopcatt script
d_method='audio.search' # метод поиска музыки ВКонтакте. by default.  Взято из vksearch by snoopcatt script
secret='dTckAoaSzH' # системная переменная. Секретный код приложения. Взято из VK_Search Amarok Script (c)  Взято из vksearch by snoopcatt script
d_query="$*"
#show_filtered=0 # лол фильтрованные  #лол хуёвые у тебя фильтрованные, сматри как нада
cat $HOME/.vk_filter &>/dev/null || echo "Настройки фильтра неизвестны, используйте sf" && show_filtered=0
source $HOME/.vk_filter 2>/dev/null

#player="mpv -volume 1"
save_last=1 # лол последнее (типа плейлист)
vr=$$
ifs_backup=$IFS
help='Возможные действия: p(проиграть) d(скачать) t(печатать текст) e(выход) l(напомнить список) k(убить mpv) r(случайное) h(помощь) h all(расширенная помощь) s(новый поиск) +f/-f(включить/отключить режим повтора)  m(найти похожие), qa(добавить в очередь), qd(удалить из очереди), ql(просмотреть очередь), qc(очистить очередь), +q/-q(включить/отключить проигрывание очереди), qh(подробнее о режиме очереди), sf(настройки фильтра)'
if [ -z "$*" ] ;then
 #echo "Не указан запрос для поиска"
 #echo "Введите '$0 запрос' для поиска данных или $0 --help для получения расширенной помощи"
 #kill -11 $$
 #fi
 [ -f /tmp/last_query ] && d_query="$( cat /tmp/last_query )"
fi
me_man()
{
 echo "Запуск: $0 'запрос'  (при наличии пробелов и спецсимволов в запросе кавычки обязательны)"
 echo "Внутренние команды:"
 echo "p <номер> -- воспроизведение песни с указанным порядковым номером"
 echo "d <номер> -- скачивание песни с указанным порядковым номером"
 echo "k <номер> -- прервать воспроизведение песни с указанным порядковым номером"
 echo "k -- завершить _все_ процессы mpv"
 echo "t <номер> -- показать текст выбранной песни (если есть)"
 echo "l -- повторно вывести результаты последнего поиска"
 echo "r -- воспроизвести случайную песню из найденных"
 echo "s 'запрос' -- повторно провести поиск с новым запросом (при наличии пробелов и спецсимволов в запросе кавычки обязательны)"
 echo "h -- показать список команд"
 echo "h all -- показать эту справку"
 echo "o <количество> -- указать количество показываемых результатов поиска"
 echo "+f/-f -- включить/отключить режим принудительного повтора. [ВНИМАНИE]: это может быть опасно с командами 'd','l','h','t'"
 echo "m <номер> -- найти исполнителей, схожих с исполнителем песни с указанным номером"
 echo "+q/-q -- включить/отключить режим воспроизведения очереди. [ВНИМАНИЕ]: в режиме воспроизведения очереди недоступны мультикоманды, а также переход в режим force forever"
 echo "qa <номер или выражение> -- добавить треки в очередь. введите qh для вывода подробной информации"
 echo "qd <номер пункта очереди> -- удалить выбранный пункт очереди"
 echo "qc -- очистить очередь"
 echo "ql -- вывести текущее состояние очереди на экран"
 echo ". -- повтор предыдущей команды"
 echo "sf <0/1> -- показывать песни, отфильтрованные как дубликаты"
 echo "lms -- команда для отладки, которой не нужно пользоваться"
}
if [ "$1" = "--help" ]; then

 me_man
 exit 0
fi
qhelp(){
 echo "Добавление в очередь: "
 echo "Возможны следующие варианты: "
 echo "qa <номер> -- добавить трек в конец очереди  (например, 'qa 5' добавляет 5-ю песню в конец очереди)"
 echo "qa r -- добавить случайный трек в конец очереди"
 echo "qa <НомерПервой>.<НомерПоследней> -- добавить песни от Первой до Последней в очередь (например, 'qa 3.7' добавляет песни 3,4,5,6,7 в конец очереди"
 echo "qa <номер/r>x<количество> -- добавить песню <номер> в конец очереди Количество раз (например, 'qa 4x2' добавляет песню №4 в конец очереди два раза, 'qa rx3' добавляет 3 случайных песни в конец очереди"
 echo "qa all -- добавить все песни в конец очереди. [ВНИМАНИЕ] Аргумент 'all' не допустим для перечисления через запятую вместе с остальными"
 echo ""
 echo "Также, ввод"
 echo "qa 4"
 echo "qa 6"
 echo "И ввод"
 echo "qa 4,6"
 echo "Абсолютно идентичны. Чтобы добавить несколько треков, идущих не-подряд, в очередь, просто разделите их запятыми. Также, допустим ввод"
 echo "qa 4,6,1.3,rx2"
 echo "Будут добавлены последовательно треки: 4,6,1,2,3,Случайный,Случайный"
 echo "Недопустимо сочетание '.' и 'x' в одном аргументе"
 echo "Недопустимо сочетание '.' и 'r' в одном аргументе"
 echo "Например 'qa 1.10x2' -- недопустимо"
 echo "Например 'qa r.7' -- недопустимо"
 echo ""
 echo "Также, вместо команды qa можно использовать просто q"
 echo ""
 echo ""
 echo "Удаление из очереди: "
 echo "Возможны следующие варианты: "
 echo "qd <номерПунктаОчереди> -- удалить пункт №номерПунктаОчереди из очереди, сместив все нижестоящие элементы на позицию вверх"
 echo "qd <номерПервогоПункта>,<номерПоследнегоПункта> -- удалить все элементы очереди от №номерПервого до №номерПоследнего, сместив все нижестоящие элементы на некоторое количество позиций вверх, равное суммарному количеству удалённых последним выполнением команды qd из очереди элементов"
 echo ""
 echo ""
 echo "Листинг очереди: "
 echo "ql -- вывести список всех элементов очереди в виде"
 echo "<номерПунктаОчереди Команда>"
 echo ""
 echo ""
 echo "Очистка очереди: "
 echo "Команда 'qc' очищает очередь, удаляя из неё абсолютно все элементы. Удаленная очередь восстановлению не подлежит"
}

get_data(){ # Получение списка
 method="$1"
 count="$2"
 query="$3"
 if [ "$4" = "" ]; then
  outfile="/tmp/vk$vr"
 else
  outfile="$4"
 fi
#echo $1 / $2 / $3 / $4
#echo $outfile
 sig=`echo -n "${id}api_id=1696393count=${count}method=${method}q=${query}test_mode=1v=2.0${secret}"|md5sum|awk '{ print $1 }'`
 fields="aid artist title duration url lyrics_id"
 wget "http://api.vkontakte.ru/api.php?api_id=1696393&count=${count}&v=2.0&method=${method}&sig=$sig&test_mode=1&q=$query" -qO "$outfile"
}
print_text(){
 method="audio.getLyrics"
 sig=`echo -n "${id}api_id=1696393lyrics_id=${1}method=${method}test_mode=1v=2.0${secret}"|md5sum|awk '{ print $1 }'`
 wget "http://api.vkontakte.ru/api.php?api_id=1696393&v=2.0&method=${method}&sig=$sig&test_mode=1&lyrics_id=$1" -qO /tmp/vkl$vr
 cat /tmp/vkl$vr | sed 's/<.*>//g' | grep -oE '^.*$'
}

fill_array(){
#echo $1
 ctr=0
 IFS=$'\n'
 field=$1
#echo fillarray $2
 if [ "$2" = "" ];
   then filevr="/tmp/vk$vr";
   else filevr="$2";
 fi
 for i in `cat "$filevr" | grep $field | sed "s/[</]\{1,2\}$field>//g" | sed 's/^[ \t]*//;s/[ \t]*$//'`; do
    ctr=$[ctr+1];
    fl="`echo "$i" | sed 's/&//g'| sed 's/;//g'`"
    #echo "Ща будет eval $fileds [$ctr] = '$fl'"
    eval $field[$ctr]=\'$fl\' 2>/dev/null;
 done
# echo $ctr
 IFS=$ifs_backup
}

get_similar() {
 wget -qO - "http://ws.audioscrobbler.com/2.0/artist/$1/similar.txt" | awk -F "," '{print $3}' > /tmp/vksim$$
 IFSA=$IFS
 IFS=$'\n'
 #echo -ne "Обрабатываются схожие исполнители..\e[0;33m ["
 for i in `cat /tmp/vksim$$ | head -n $SETTINGsimilarartcount`; do
  IFS=$IFSA
  get_data $d_method $SETTINGsimilartrcount "$i" /tmp/vksem$$
  cat /tmp/vksem$$ >> /tmp/vktsem$$
  #echo -ne '#'
  IFS=$'\n'
 done
 #echo -ne "] \e[0m "
 #echo "Done."
 IFS=$IFSA
  fields="aid artist title duration url lyrics_id"
  for i in $fields; do fill_array $i "/tmp/vktsem$$"; done
  total=0
  get_list
  #echo $help
  #echo 'Поиск завершён. Выберите действие и номер найденного трека:'
  rm /tmp/vksim$$ /tmp/vksem$$ /tmp/vktsem$$
}

get_list () {
IFS=$ifs_backup
filtered=0
echo > /tmp/vkli$vr
echo > /tmp/vkdi$vr
 for num in $(seq 1 $cnt); do
  total=$num
  if [ -z "${artist[$num]}" ] && [ -z "${title[$num]}" ]; then break; fi
  if [ -z $( echo ${lyrics_id[$num]} | grep -oE '[0-9]*') ]; then TEXT='\e[1;31m[-]\e[0;37m'; else TEXT='\e[1;33m[+]\e[0;37m'; fi
  clmr=${duration[$num]} #длительность
  clmo=$((clmr%60)) #секунды длительности
  if [ "$(echo -n $clmo | wc -m)" = "1" ]; then
   clmo="0$clmo"
  fi
  onum=$(cat /tmp/vkli$vr | grep -n "${artist[$num]}  -  ${title[$num]}" | head -n 1)
# echo $onum
  echo "${artist[$num]}  -  ${title[$num]}" >> /tmp/vkli$vr
  if [ -z "$onum" ] ; then
   filtered=$((filtered+1)) ;
   echo -e "\e[0;35m$num. \e[1;37m${artist[$num]}  -  ${title[$num]} $TEXT \e[0;34m$((clmr/60)):$clmo\e[0;37m";
   echo $num >> /tmp/vkdi$vr
 else
   [ $show_filtered -eq 1 ] && echo $num удалена как повтор записи $onum;
 fi
 done
 echo '--- Найдено ' $cnt', из них отфильтровано '$((cnt-filtered))
}
get_pid_for_song() { #для убийства конкретного плеера
 echo $(ps uax | grep "mpv ${url[$1]}" | awk '{print $2}')
}

 #--------------------------------------------

cnt=15 #количество by default
if [ -z "$(cat $HOME/.vk_set_count 2>/dev/null)" ]; then
 echo 'Нет сохранённых настроек для списка. Принято решение использовать стандартные (limit: 15)'
else
  cnt=$(cat $HOME/.vk_set_count)
fi
if [ -n "$d_query" ]; then
[ $save_last -eq 1 ] && echo "$d_query" > /tmp/last_query  || rm -r /tmp/last_query 2>/dev/null
get_data $d_method $cnt "$d_query"
for i in $fields; do fill_array $i; done
total=0
get_list
fi
#echo $help
#echo 'Поиск завершён. Выберите действие и номер найденного трека:'
parse_input() { #выполняется при попадании параметра
userselect_d=$(echo $whatdo | awk '{print $1}')
userselect_n=$(echo $whatdo | awk '{print $2}')
 userselect_d="$1"
 userselect_n="$2"
[ -n "$( echo "$userselect_d" | grep -E '(s|pa|q)' )" ] || songinfo="#VK/${aid[$userselect_n]}: ${artist[$userselect_n]} - ${title[$userselect_n]}"
#echo $userselect_n
 case $userselect_d in
  p)
   if [ -z $userselect_n ] ; then echo "Нечего петь. Введите номер после 'p'" ; else
   if [ -z $(cat /tmp/vkdi$vr | awk '{print $1}' | grep -E "^${userselect_n}\$") ] ; then echo -e "\e[0;31m[$(date +%H:%M:%S)]: Пластинка $userselect_n проигнорирована \e[0m"; else
    echo -e "\e[0;35m[$(date +%H:%M:%S)]\e[0;37m: Запевай пластинку \e[1;37m$songinfo\e[0;37m"
     drrr=${duration[$userselect_n]}  #длительность для forever'a
     $player -volume 5 "${url[$userselect_n]}" &>/dev/null </dev/null &
     P_PID=$(ps uax |grep "mpv ${url[$userselect_n]}" | grep -v grep | awk '{print $2}')
    fi
   fi
   ;;
  d)
   if [ -z $userselect_n ] ; then echo "Нечего скачивать. Введите номер после 'd'" ; else
    echo -e "Пластинка \e[1;37m$songinfo\e[0;37m будет сохранена в \e[1;37m$HOME/${aid[$userselect_n]}.mp3\e[0;37m"
    wget -O "$HOME/${aid[$userselect_n]}.mp3" "${url[$userselect_n]}"
   fi
   ;;
  t)
   test -z $userselect_n || print_text ${lyrics_id[$userselect_n]}
   ;;
  e)
   #echo "Запевай пластинку 295: kill -9 $$"
   kill -9 $$
   ;;
  l)
   get_list
   ;;
          ql)
            echo "Команды в очереди:"
            cat  -b /tmp/vk$$.queue  2>/dev/null|| echo 'Очередь не найдена'
            ;;
          qc)
            rm /tmp/vk$$.queue 2>/dev/null && echo "Очередь очищена"
            ;;
          qa|q)
              cn_prev=$(cat /tmp/vk$$.queue 2>/dev/null | wc -l)
              if [ "$userselect_n" = "all" ]; then
                userselect_all=$(seq 1 $cnt)
              else
                userselect_all="$(echo $userselect_n | sed 's/,/ /g')"
              fi
              for queue_data in $userselect_all; do
                if [ -n "$(echo $queue_data | grep '\.')" ] ; then
                  lz_start="$(echo $queue_data | awk -F '.' ' { print $1 } ')"
                  lz_endop="$(echo $queue_data | awk -F '.' ' { print $2 } ')"
                  for i in $(seq $lz_start $lz_endop); do
                    echo p $i >> /tmp/vk$$.queue
                  done
                else
                  if [ -n "$(echo $queue_data | grep 'x')" ] ; then
                    for zc in `seq 1 $(echo $queue_data | awk -F 'x' '{print $2}')` ; do
                      zr="$(echo $queue_data | awk -F 'x' '{print $1}')"
                      if [ "$zr" == "r" ]; then echo r >> /tmp/vk$$.queue; else echo p $zr >> /tmp/vk$$.queue; fi
                    done
                  else
                    if [ "$queue_data" == "r" ]; then echo r >> /tmp/vk$$.queue; else echo p $queue_data >> /tmp/vk$$.queue; fi
                  fi
                fi
              done
              cn_post=$(cat /tmp/vk$$.queue 2>/dev/null | wc -l)
     #       echo "Команды в очереди:"
     #       cat  -b /tmp/vk$$.queue     2>/dev/null        || echo 'Очередь не найдена'
             echo "Добавлено успешно $((cn_post-cn_prev)) элементов. Для просмотра очереди наберите ql"
            ;;
          qd)
            if [ -n "$userselect_n" ]; then
              sed "${userselect_n}d" /tmp/vk$$.queue > /tmp/vk$$.queue.last
              mv /tmp/vk$$.queue.last /tmp/vk$$.queue
            fi
            echo "Команды в очереди:"
            cat  -b /tmp/vk$$.queue  2>/dev/null || echo 'Очередь не найдена'
            ;;
          qh)
            qhelp
            ;;

  sf)
   case "$userselect_n" in
     1)
     show_filtered=1
     echo Результаты работы фильтра отныне будут  отображаться
     echo show_filtered=1 > $HOME/.vk_filter
     ;;
     0)
     show_filtered=0
     echo Результаты работы фильтра отныне не будут больше отображаться
     echo show_filtered=0 > $HOME/.vk_filter
     ;;
     *)
     echo "0 или 1. Третьего не дано."
     ;;
   esac
   ;;
  pa)
   echo -e "\e[0;35m[$(date +%H:%M:%S)]\e[0;37m: Отправляемся па на \e[1;37m$(echo $userselect_n| sed 's/s/ сек./g;s/h/ ч./g;s/m/ мин./g')\e[0;37m"
   sleep "$userselect_n"
   ;;
  k)
   if [ -z $userselect_n ] ; then
     echo 'Завершаем все процессы mpv'
     killall -v mpv
   else
     echo "Пробуем завершить процесс mpv для пластинки $userselect_n"
     for i in $(get_pid_for_song $userselect_n); do kill -9 $i 2>/dev/null && echo 'Удача!'; done
   fi
   ;;
  r)
   nrand=0
   while [ "$nrand" != "1" ] ; do
     r_d=$[RANDOM%$total];
     if [ -z $(cat /tmp/vkdi$vr | awk '{print $1}' | grep -E "^$r_d\$") ] ; then echo -e "\e[0;35m[$(date +%H:%M:%S)]\e[0;37m: Кубик показал \e[1;37m$r_d\e[0;37m. У кубика нет стороны \e[1;37m$r_d \e[0;37m, поэтому он будет брошен ещё раз"; else nrand=1; fi
   done
   echo -e "\e[0;35m[$(date +%H:%M:%S)]\e[0;37m Кубик показал \e[1;37m$r_d. Запевай пластинку \e[1;37m#VK/${aid[$r_d]}: ${artist[$r_d]} - ${title[$r_d]}\e[0;37m"
   drrr=${duration[$r_d]}
   $player "${url[$r_d]}" &>/dev/null </dev/null &
   P_PID=$(ps uax |grep "mpv ${url[$r_d]}" | grep -v grep | awk '{print $2}')
   ;;
  lms)
   echo 'Это команда для отладки, ей не нужно пользоваться'$'\n'Нет, правда.
    if [ -z "$(ps ax -o pid | grep $P_PID)" ] ; then echo 'Died'; else echo 'Still alive'; fi
   ;;
  h)
   if [ -z "$userselect_n" ]; then echo $help; else me_man; fi
   ;;
  s)
   unset $fields
   fields="aid artist title duration url lyrics_id"
   whatfind="`echo $whatdo | sed 's/^s //g'`"
   get_data $d_method $cnt "$whatfind"
   for i in $fields; do fill_array $i; done
   total=0
   get_list
#   echo 'Поиск завершён. Выберите действие и номер найденного трека:'
   ;;
  m)
   get_similar "${artist[$userselect_n]}"
   ;;
  o)
   [ -n "$userselect_n" ] && cnt=$userselect_n && echo $cnt > $HOME/.vk_set_count && echo -e "Отныне показывать найденных: \e[1;37m$cnt\e[0;37m"
    ;;
  w)
    echo "Ok"
    clear;;
 esac
}

forever() {
  echo "Введите команду. Введите '-f' для останова. Возможно придётся вручную остановить mpv."
  echo -n "data2/VK(+f)# "
  read f_cmd
  d_cmd="force forever"
  while [ "$d_cmd" != '-f' ]; do
    parse_input $f_cmd
    read -t $drrr d_cmd
    if [ -n "$d_cmd" ]; then f_cmd="$d_cmd"; fi #подмена команды на лету
  done
  echo "Force-forever режим отключён. Возможно придётся вручную остановить mpv, если необходимо"
}

just_queue() {
  d_cmd="force queue"
  while [ "$d_cmd" != '-q' ]; do
    if [ -z "$(cat /tmp/vk$$.queue 2> /dev/null)" ] ; then
      break
    else
      echo "Осталось позиций в очереди: $(cat /tmp/vk$$.queue |wc -l)"
    fi
    parse_input $(cat /tmp/vk$$.queue)
    sed '1d' /tmp/vk$$.queue > /tmp/vk$$.queue.last
    mv /tmp/vk$$.queue.last /tmp/vk$$.queue
    echo -n "data2/VK(+q)# "
    while [ -n "$(ps ax -o pid | grep $P_PID)" ]; do
      read -t 5 d_cmd
##      echo alive
      if [ -n "$d_cmd" ]; then
#        d_usselect_d="$(echo $d_cmd | awk '{print $1}')";
#        d_usselect_n="$(echo $d_cmd | awk '{print $2}')";
#        case $d_usselect_d in
          if [ "$d_cmd" = "-q" ]; then
            echo "Прерывание..."
            break 2
          fi;

        parse_input $d_cmd
        echo -n "data2/VK(+q)# "
      fi
    done
    #echo 'died, go next'
  done
  echo "Режим очереди отключен. Возможно, очередь закончилась или ещё не начиналась."
}


while true ; do
 echo -n "data2/VK( )# "; read whatdo
 if [ -z "$d_query" ] ; then
  if [ -z "$(echo $whatdo|awk '{ print $1 }'|grep -iE 's.*')" ] ; then echo "Сначала введите запрос."; continue;
  else
   d_query="$( echo $whatdo | sed 's/s//' )"
   parse_input $whatdo
   whatdo=skip
   fi
 fi
 [ -z "$whatdo" ] && whatdo=nozavison
 [  -z `echo $whatdo | awk '{ print $1 }' | grep -iE '(\.|k|s-*|l-*|t-*|o-*|h-*|w)'` ] && echo "$whatdo" > /tmp/whatdo
 if [ "$whatdo" = "+f" ]; then
  forever
 else
 if [ "$whatdo" = "+q" ]; then
  just_queue
 fi
 if [ "$whatdo" = "." ]; then
  parse_input `cat /tmp/whatdo`
 fi
  IFS='-';
  for does in $whatdo; do #мультикоманды
    IFS=$ifs_backup;
    parse_input $does;

    IFS='-';
  done
 fi
 IFS=$ifs_backup
done
