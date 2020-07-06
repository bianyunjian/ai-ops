pipeline {
   agent any
   tools {
        maven 'maven3'
        git 'git1.8.3.1'
        jdk 'jdk8'
    }
   stages {
      stage('init') {
           steps {
             script{
               def dockerPath = tool 'docker' //全局配置里的docker
               env.PATH = "${dockerPath}/bin:${env.PATH}" //添加了系统环境变量上
               
               GitCred="435dc768-a5ae-4bf9-8508-849a45ff5046"
	       GitPath="https://gitee.com/hankutech/gateway.git"

	       MavenBuild="mvn -f ./gateway/pom.xml clean compile -DskipTests package"

	       ImageName="gateway"	       
	       DockerBuild="docker build -t ${ImageName}:${IMAGE_VERSION_NO}  ./gateway/"

	       HarborAddress="http://172.16.114.245:5000/"
 	       HarborUserName="docker"
	       HarborPassword="Docker123"
               FullImageName="172.16.114.245:5000/ezml/${ImageName}:${IMAGE_VERSION_NO}"
               
	       Pod="http://172.16.114.72:32567/k8s-api/apis/apps/v1/namespaces/default/deployments/gateway-springcloud-gateway"
	      } 
           }
      }
      stage('check out source code') {
         steps {
            git credentialsId: "${GitCred}", url: "${GitPath}"
         }
      }
      stage('maven build'){
         steps {
            sh "${MavenBuild}"
         }  
      }      
      stage('build docker image'){
         steps {
            sh "${DockerBuild}"
         }  
      }      
      stage('tag and push docker image'){
         steps {
            echo 'push to harbor repository'

            sh "docker login  ${HarborAddress} -u ${HarborUserName} -p ${HarborPassword}"
            //给镜像重新打标签，直接原镜像无法上传到远程镜像仓库
            
            sh "docker tag ${ImageName}:${IMAGE_VERSION_NO} ${FullImageName}"

            //#上传到远程镜像仓库 
            sh "docker push ${FullImageName}"
            
         }  
      }
      stage('deploy to k8s'){
         steps {
            echo 'trigger remote k8s to update pods'

	    sh "curl -X PATCH \
		  -H \"content-type: application/strategic-merge-patch+json\" \
		  -H \"Authorization:Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6ImlUTFhkQWhQRVVwUGIyczdocW53T1RkVTVmUkdxcjBjZ0pYNXZXZEp2VG8ifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJrdWJvYXJkLXVzZXItdG9rZW4tZHd2ZzIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoia3Vib2FyZC11c2VyIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiZjllNWNjYTItNTBjNC00ZGI3LThiNmEtMjk2NzJjZDcxNTk1Iiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOmt1Ym9hcmQtdXNlciJ9.Fu2d0EAXBmDxJ95Kw60rKCQHqLQh4-pE4UgGqjO4XjyQsEDJShg7d_ZLO3sU9IvuthqF2mzrCjp9G5ArDK0ivsEAQqFzklVG-4gYFeYF7yJubRwDh5ZtOm9XM0j-4tB1Zx4CWENNw1VO4U9Oew2W6sc4v5KajM3TmOhkhwXqDVpoYG7-I0MuYTNk4mNflDllMVRhFLNCmFjppjPkwZW-YPx2YbkB84CoTFQAasyP7-ZA7a8WnfgcV1ZfAEyNmmNvGxYoYlA_AG3Xdd6A_QO0eT2hDjNGHxLNyIcHx8j_P2uhmWTNgG0Utsp3GMSAgTcKaXn6vT1oc5JEcWT4jT5gnw\" \
		  -d '{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\":\"${ImageName}\",\"image\":\"${FullImageName}\"}]}}}}' \
		\"${Pod}\" "
         }  
      } 
   }
}

