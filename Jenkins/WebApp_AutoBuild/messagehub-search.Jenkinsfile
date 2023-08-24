pipeline {
    agent {
        node {
            label 'ubuntu'
        }
    }

    tools {
        maven 'Maven 3 (latest)'
        jdk 'JDK 1.8 (latest)'
    }

        stage('Checkout') {
        // Checkout PR
        checkout scm

        // Find base branch
        def remoteBranches = sh(script: 'git branch -r', returnStdout: true)
        branchBase = remoteBranches.split('\n')[1].split('/')[1].trim()
        echo "Target branch is ${branchBase}"

        // Find contributor
        commitAuthor = sh(script: 'git log -1 HEAD~2 --pretty=format:\'%an <%ae>\'', returnStdout: true).trim()
        echo "Author is ${commitAuthor}"
    }

    stages {
        stage('Build') {
            steps {
                sh 'mvn'
            }
            post {
                always {
                    junit(testResults: '**/surefire-reports/*.xml', allowEmptyResults: true)
                }
            }
        }
    }
}
