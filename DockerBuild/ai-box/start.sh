#!/bin/sh
echo `pwd`
env
ls -h /opt/nvidia/deepstream
ls -h /opt/nvidia/deepstream/aixin_demo
cd ${ENV_WORK_DIR}
echo `pwd`
ls -h
rm config_server.ini
echo ';server-config' >> config_server.ini
echo '[server-config]' >> config_server.ini
echo 'server-adress='${ENV_SERVER_ADDRESS} >> config_server.ini
echo 'device-name='${ENV_DEVICE_NAME} >> config_server.ini
cat config_server.ini

rm  ~/.cache/gstreamer-1.0/* 
./deepdetect -c deepstream_app_config_yoloV3_tiny.txt 

