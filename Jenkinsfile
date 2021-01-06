pipeline {
  agent any
  stages {
    stage('workflow:sandbox') {
      when { anyOf { environment name: 'DATAGOV_WORKFLOW', value: 'sandbox' } }
      stages {
        stage('deploy:sandbox') {
          when { anyOf { branch 'master' } }
          environment {
            ANSIBLE_VAULT_FILE = credentials('ansible-vault-secret')
            SSH_KEY_FILE = credentials('datagov-sandbox')
          }
          steps {
            ansiColor('xterm') {
              echo 'Deploying with Ansible'
              sh 'bin/jenkins_ansible sandbox catalog.yml catalog-next'
            }
          }
        }
      }
    }
    stage('workflow:production') {
      when { anyOf { environment name: 'DATAGOV_WORKFLOW', value: 'production' } }
      environment {
        ANSIBLE_VAULT_FILE = credentials('ansible-vault-secret')
      }
      stages {
        stage('deploy:staging') {
          when { anyOf { branch 'master' } }
          environment {
            SSH_KEY_FILE = credentials('datagov-staging')
          }
          steps {
            ansiColor('xterm') {
              echo 'Deploying with Ansible'
              sh 'bin/jenkins_ansible staging catalog.yml catalog-next'
            }
          }
        }
        stage('deploy:production') {
          when { anyOf { branch 'master' } }
          environment {
            SSH_KEY_FILE = credentials('datagov-production')
          }
          steps {
            ansiColor('xterm') {
              echo 'Deploying with Ansible'
              sh 'bin/jenkins_ansible production catalog.yml catalog-next'
            }
          }
        }
      }
    }
  }
  post {
    always {
      step([$class: 'GitHubIssueNotifier', issueAppend: true])
    }
  }
}
