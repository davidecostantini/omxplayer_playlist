#! /bin/bash

get_rnd() {
   rnd_num=$(shuf -i 0-$list_lenght -n 1)
   echo $rnd_num
}

get_next_song() {
   while :
   do
      rnd_number=$(get_rnd)
      if check_played $played_songs $rnd_number == "no"; then
         played_songs+=($rnd_number)
         echo $rnd_number
         break
      fi
   done
}

play_song()
{
   rnd=$(shuf -i 0-$list_lenght -n 1)
   #rnd=$(get_next_song)
   song=${LIST[$rnd]}
   echo
   echo "### Playing number $rnd - $song"
   omxplayer -o alsa "$song" 

}

load_files() {
   if [ -z "$1" ]; then
      path="/mount/Music"
   else
      path="$1"
   fi

   echo "Searching music on $path"

   i=0
   while read line
   do
       LIST[ $i ]="$line"        
       (( i++ ))
   done < <(find $path -type f -name "*.mp3")
}

echo "GUIDE:"
echo "To clean processes run: /home/pi/scripts/clean_omxplayer.sh"
echo "TO skip song click 'q'"
echo 


#load songs
load_files $1

list_lenght="${#LIST[@]}"
echo "Found $list_lenght files"

while :
do
   play_song 
   sleep 2
done
