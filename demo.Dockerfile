FROM moses_server

ARG model_name=ar2enwiki
ENV model_name=${model_name}
ARG port=8085
ENV port=${port}

COPY ./moses-models/${model_name} /home/moses/moses-models/${model_name}
COPY ./docker-entrypoint.sh /home

RUN chmod +x /home/docker-entrypoint.sh
ENTRYPOINT "/home/docker-entrypoint.sh"
