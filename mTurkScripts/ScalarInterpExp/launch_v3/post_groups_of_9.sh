# ./post_groups_of_9.sh forcedchoice-2 5
EXPERIMENT_TAG=$1
NROUNDS_TO_POST=$2
ROUND_SIZE=9

cd $EXPERIMENT_TAG

if [ ! -d "round1" ]; then
	next_dir_index=1
	end_dir_index=$NROUNDS_TO_POST
else 
	num_round_dirs=$(echo round*/ | wc | awk '{print $2}')
	next_dir_index=$(($num_round_dirs + 1))
	end_dir_index=$(($num_round_dirs + $NROUNDS_TO_POST))
fi

for i in `seq $next_dir_index $end_dir_index`;
do
	submiterator posthit $EXPERIMENT_TAG
	mkdir round$next_dir_index
	mv $EXPERIMENT_TAG.success round$next_dir_index
	rm *.input
	rm *.properties
	rm *.question
	num_round_dirs=$(echo round*/ | wc | awk '{print $2}')
	next_dir_index=$(($num_round_dirs + 1))
done
