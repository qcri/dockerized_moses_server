#!/bin/bash
model_name=$model_name
port=$port
# this is just an example of how to run a model. You need to change it to pass the paramters you need
run_cmd="cd moses-models && /home/moses/mosesdecoder/bin/mosesserver -search-algorithm 1 -cube-pruning-pop-limit 5000 -s 5000 -drop-unknown -distortion-limit 0 -f $model_name/moses.tuned.nbest.ini --server-port ${port}"

eval $run_cmd


