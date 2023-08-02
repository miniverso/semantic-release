def imageName = "registry.gitlab.com/miniverso/semantic-release"
def CURRENT = "current"

pipeline {
  agent {
    kubernetes {
      label 'jenkins-pod'
    }
  }
  stages {
    stage('Docker Login') {
      environment {
        REGISTRY = credentials('gitlab')
      }      
      steps {
        script {
          sh 'docker login -u $REGISTRY_USR -p $REGISTRY_PSW registry.gitlab.com'
        }
      }
    }
    stage('Build Docker Image') {
      steps {
        script {
          
          sh "docker build \
            --network host \
            --add-host=github.com:`dig +short github.com` \
            --add-host=registry.yarnpkg.com:`dig +short registry.yarnpkg.com | head -2 | tail -1` \
            --add-host=raw.githubusercontent.com:`dig +short raw.githubusercontent.com | head -2 | tail -1` \
            -t ${imageName}:${CURRENT} ."
        }
      }
    }
    stage('Creating Release and Tagging') {
      when {
        branch 'develop'
      }
      environment{
        GH_TOKEN = credentials('gh-token')
      }
      steps {
        sh "docker run -v `pwd`:/opt/app -e GH_TOKEN=$GH_TOKEN ${imageName}:prd run"
      }
    }
    stage('Tagging Image') {
      parallel {
        stage('Tagging Dev') {
          when {
              branch 'develop'      
          }        
          steps {
            script {
              def TAGA = sh(returnStdout: true, script: './scripts/getTag.sh 3').trim()
              def TAGB = sh(returnStdout: true, script: './scripts/getTag.sh 2').trim()
              def TAGC = sh(returnStdout: true, script: './scripts/getTag.sh 1').trim()
              def ENV = (env.BRANCH_NAME == 'main' ) ? 'prd' : 'dev'
              
              sh "docker tag ${imageName}:${CURRENT} ${imageName}:${ENV}"
              sh "docker push ${imageName}:${ENV}"

              sh "docker tag ${imageName}:${CURRENT} ${imageName}:${TAGA}"
              sh "docker push ${imageName}:${TAGA}"

              sh "docker tag ${imageName}:${CURRENT} ${imageName}:${TAGB}"
              sh "docker push ${imageName}:${TAGB}"

              sh "docker tag ${imageName}:${CURRENT} ${imageName}:${TAGC}"
              sh "docker push ${imageName}:${TAGC}"
            }
          }
        }  
        stage('Tagging Prd') {
          when {
            branch 'main'
          }
          steps {
            script {
              def TAG = sh(returnStdout: true, script: './scripts/getTag.sh 3').trim()

              sh "docker pull ${imageName}:${TAG}"
              sh "docker tag ${imageName}:${TAG} ${imageName}:prd"
            }
          }
        }
      }
    }
  }
}