FROM 192.168.1.120:10080/dev/deepstream-l4t:5.0-dp-20.04-base-arm64
#外部环境变量
ENV ENV_SERVER_ADDRESS http://127.0.0.1
ENV ENV_DEVICE_NAME device1
ENV ENV_WORK_DIR /opt/nvidia/deepstream/aixin_demo
#时区设置
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY aixin_demo $ENV_WORK_DIR
COPY start.sh $ENV_WORK_DIR/start.sh
RUN bash -c  'chmod 777 $ENV_WORK_DIR/start.sh'
RUN bash -c  'chmod 777 $ENV_WORK_DIR/deepdetect'
RUN bash -c  'cat $ENV_WORK_DIR/start.sh'
RUN bash -c  'ls -h $ENV_WORK_DIR'
ENTRYPOINT ["sh","-c","$ENV_WORK_DIR/start.sh"]
