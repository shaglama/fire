#!/bin/bash

function clone(){
	image="$2"	
	numClones="$1"
	outFile="$3"
	current=0
	randoms=`shuf -i1-1000000000000 -n"$numClones"`
	orders=`shuf -i0-$(( $numClones - 1 )) -n"$numClones"`
	i=0
	for word in $randoms
	do
		r_array[$i]=$word
		i=$(( i + 1 ))
	done
	dline=`strings "$image" | grep -m 1 [1-2][0-9][0-9][0-9]:`
	dvars=( $dline ) 
	d_date=${dvars[0]}
	d_time=${dvars[1]}
	IFS=":" read -a d_date_parts <<< "${d_date}"
	IFS=':' read -a d_time_parts <<< "${d_time}"
	d_year=${d_date_parts[0]}
	d_month=${d_date_parts[1]}
	d_day=${d_date_parts[2]}
	d_hour=${d_time_parts[0]}
	d_minute=${d_time_parts[1]}
	d_second=${d_time_parts[2]}
	echo "year: $d_year"
	echo "month: $d_month"
	echo "day: $d_day"
	echo "hour: $d_hour"
	echo "minute: $d_minute"
	echo "second: $d_second"
	
	while ( [[ $current -lt $numClones ]]  );	 do		
		rdm=${r_array[current]}
		out="$outFile.$rdm"
		cp "$2" "$out"
		names[$current]="$out"		
		current=$((current + 1))
	done
	for ord in $orders
	do
		newSecond=$(( d_second + 1 ))
		if [[ $newSecond -gt 59 ]]; then
			$d_second=0;
			newMinute=$(( d_minute + 1 ))
			if [[ $newMinute -gt 59 ]]; then
				d_minute=0
				newHour=$(( d_hour + 1 ))
				if [[ $newHour -gt 23 ]]; then
					d_hour=0
					newDay=$(( d_day + 1 ))
					if [[ $newDay -gt 31 ]]; then
						d_day=1
						newMonth=$(( d_month + 1 ))
						if [[ $newMonth -gt 12 ]]; then 
							d_month=1
							d_year=$(( $d_year + 1 ))
						else
							d_month=$newMonth
						fi
					else
						d_day=$newDay
					fi
				else
					d_hour=$newHour
				fi
			else
				d_minute=$newMinute
			fi
		else
			d_second=$newSecond
		fi
		replace "$dline" "$d_year:$d_month:$d_day $d_hour:$d_minute:$d_second" "${names[ord]}"	
	done
	

}

function replace(){
	local text_to_replace="$1"
	local text_to_replace_with="$2"
	local file="$3"
	sed -i "s%$text_to_replace%$text_to_replace_with%g" "$file" 
}
clone "$1" "$2" "$3"