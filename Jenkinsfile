// Declarative pipeline of Batyr Gazizbek (IT2-2301) for gazizbek-batyr-student-api
// Jenkins job: Gazizbek_Batyr_Student_API
pipeline {
    // Docker-capable agent (JDK 21 + Docker CLI), see jenkins/agent/Dockerfile
    agent { label 'docker' }

    tools {
        jdk 'jdk21'
    }

    options {
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '20'))
        timeout(time: 30, unit: 'MINUTES')
    }

    // Polling trigger: Jenkins checks GitHub every minute and builds new commits
    triggers {
        pollSCM('* * * * *')
    }

    environment {
        STUDENT_NAME  = 'Batyr Gazizbek'
        STUDENT_GROUP = 'IT2-2301'
        STUDENT_ID    = '38091'
        IMAGE_NAME    = 'gazizbek-batyr-student-api'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    env.APP_VERSION = sh(script: "sed -n \"s/^version = '\\(.*\\)'/\\1/p\" build.gradle", returnStdout: true).trim()
                    def shortVersion = env.APP_VERSION.tokenize('.').take(2).join('.')
                    // main gets the release tag, other branches get their own suffix
                    def suffix = env.BRANCH_NAME == 'main' ? '' : '-' + env.BRANCH_NAME.replaceAll('[^a-zA-Z0-9_.-]', '-')
                    env.IMAGE_TAG = "v${shortVersion}-gazizbek-batyr${suffix}"
                }
                sh '''
                    echo "=================================================="
                    echo " Pipeline of $STUDENT_NAME ($STUDENT_GROUP, ID $STUDENT_ID)"
                    echo "=================================================="
                    echo "Branch      : $BRANCH_NAME"
                    git log -1 --format='Commit      : %h %s (%an)'
                    echo "App version : $APP_VERSION"
                    echo "Docker image: $IMAGE_NAME:$IMAGE_TAG"
                '''
            }
        }

        stage('Build') {
            steps {
                echo "Compiling the Spring Boot application of ${env.STUDENT_NAME}"
                sh 'chmod +x gradlew && ./gradlew --no-daemon --console=plain clean compileJava'
            }
        }

        stage('Test') {
            steps {
                echo "Running automated tests for ${env.STUDENT_NAME}"
                // a failing test makes this step return non-zero, the pipeline stops here
                sh './gradlew --no-daemon --console=plain test'
            }
            post {
                always {
                    junit allowEmptyResults: true, testResults: 'build/test-results/test/*.xml'
                }
            }
        }

        stage('Docker Build') {
            steps {
                echo "Building Docker image ${env.IMAGE_NAME}:${env.IMAGE_TAG} for ${env.STUDENT_NAME}"
                sh '''
                    docker build \
                        --build-arg APP_VERSION=$APP_VERSION \
                        -t $IMAGE_NAME:$IMAGE_TAG \
                        -t $IMAGE_NAME:build-$BUILD_NUMBER-$(echo $BRANCH_NAME | tr '/' '-') \
                        .
                '''
            }
        }

        stage('Verify') {
            steps {
                sh '''
                    echo "Checking that the image exists"
                    docker image inspect $IMAGE_NAME:$IMAGE_TAG \
                        --format 'Image {{index .RepoTags 0}} | id {{.Id}} | created {{.Created}} | size {{.Size}} bytes'
                    docker images $IMAGE_NAME
                '''
                // Smoke test: start the new image with PostgreSQL and call the API
                withCredentials([string(credentialsId: 'gazizbek-batyr-verify-db-password', variable: 'DB_PASSWORD')]) {
                    sh '''
                        SUFFIX=$(echo "$BRANCH_NAME-$BUILD_NUMBER" | tr '/' '-')
                        NET=gb-verify-$SUFFIX
                        docker network create $NET
                        docker run -d --name gb-verify-db-$SUFFIX --network $NET --network-alias verify-db \
                            -e POSTGRES_DB=verify -e POSTGRES_USER=verify -e POSTGRES_PASSWORD="$DB_PASSWORD" \
                            postgres:17-alpine
                        until docker exec gb-verify-db-$SUFFIX pg_isready -U verify -d verify; do sleep 1; done
                        docker run -d --name gb-verify-app-$SUFFIX --network $NET --network-alias verify-app \
                            -e SPRING_DATASOURCE_URL=jdbc:postgresql://verify-db:5432/verify \
                            -e SPRING_DATASOURCE_USERNAME=verify -e SPRING_DATASOURCE_PASSWORD="$DB_PASSWORD" \
                            $IMAGE_NAME:$IMAGE_TAG
                        for i in $(seq 1 60); do
                            if docker exec gb-verify-db-$SUFFIX wget -qO /tmp/info.json http://verify-app:8091/; then break; fi
                            sleep 1
                        done
                        docker exec gb-verify-db-$SUFFIX cat /tmp/info.json; echo
                        docker exec gb-verify-db-$SUFFIX grep -q '"student":"Batyr Gazizbek"' /tmp/info.json
                        docker exec gb-verify-db-$SUFFIX wget -qO- http://verify-app:8091/api/gazizbek-batyr/students; echo
                        echo "VERIFY OK: $IMAGE_NAME:$IMAGE_TAG starts and answers for $STUDENT_NAME"
                    '''
                }
            }
            post {
                always {
                    sh '''
                        SUFFIX=$(echo "$BRANCH_NAME-$BUILD_NUMBER" | tr '/' '-')
                        docker rm -f gb-verify-app-$SUFFIX gb-verify-db-$SUFFIX >/dev/null 2>&1 || true
                        docker network rm gb-verify-$SUFFIX >/dev/null 2>&1 || true
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "SUCCESS: pipeline of ${env.STUDENT_NAME} built ${env.IMAGE_NAME}:${env.IMAGE_TAG}"
        }
        failure {
            echo "FAILURE: pipeline of ${env.STUDENT_NAME} stopped, see the failed stage above"
        }
    }
}
