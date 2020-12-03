echo "start ai docker images"

export SERVER=http://192.168.1.120:19001
echo ${SERVER}

export DEVICE_NAME=ai-device-01
echo ${DEVICE_NAME}

export IMAGE=192.168.1.120:10080/ax/ai-garbage:v1.0-arm64
echo ${IMAGE}

docker rm `docker ps -a |grep ${IMAGE} |awk '{print $1}'` -f

docker run --restart=always -d  ${IMAGE} -e ENV_SERVER_ADDRESS=${SERVER} -e ENV_DEVICE_NAME=${DEVICE_NAME}


docker ps -a |grep ${IMAGE}
