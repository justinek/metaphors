EXPERIMENT_TAG=$1
cd $EXPERIMENT_TAG
num_round_dirs=$(echo round*/ | wc | awk '{print $2}')

for i in `seq 1 $num_round_dirs`;
do
	cd round$i
	submiterator getresults $EXPERIMENT_TAG
	submiterator reformat $EXPERIMENT_TAG
	cd ..
done
