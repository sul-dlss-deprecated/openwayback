pipeline {
    agent any
    tools {
        maven 'Maven 3.6'
    }
    stages {
        stage ('Initialize') {
            steps {
                sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                '''
            }
        }

        stage ('Build') {
            steps {
                sh 'mvn clean install -Dmaven.javadoc.skip=true'
            }
        }

        stage ('Artifacts') {
            when {
              branch "master"
            }

            steps {
                sh 'mkdir -p /ci/artifacts/wayback-webapp/target'
                sh 'cp ./wayback-webapp/target/*.war /ci/artifacts/wayback-webapp/target'
                sh 'mkdir -p /ci/artifacts/wayback-cdx-server/target'
                sh 'cp ./wayback-cdx-server/target/*.war /ci/artifacts/wayback-cdx-server/target'
                sh 'mkdir -p /ci/artifacts/dist/target'
                sh 'cp ./dist/target/*.tar.gz /ci/artifacts/dist/target'
            }
        }
    }
}
