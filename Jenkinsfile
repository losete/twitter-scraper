pipeline {
  agent { docker { image 'python:3.7.2' } }
  stages {
    stage('Setup workspace'){
      steps{
        sh 'pip install -r requirements.txt'
        sh 'pip install flake8 pytest bandit coverage'
        sh 'mkdir -p reports/'
      }
    }
    stage('validate') {
      steps {
        sh 'flake8 --builtins="process_paragraph" > reports/flake8.txt'
      }
    }
    stage('Test') {
      steps {
        sh 'pytest -rA test.py > reports/tests.txt'
        sh 'coverage report test.py > reports/coverage.txt'
      }
    }
    stage('Package') {
      steps {
        sh 'python3 setup.py build'
      }
    }
    stage('Verify') {
      steps {
        sh 'bandit -r -lll -s B605 ./ -o "reports/bandit.txt"'
      }
    }
    stage('Deploy') {
      steps {
        sh 'tar -cvzf build.tar.gz build/'
      }
    }
    stage('Benchmarking'){
      steps {
        sh 'bash benchmarks/benchmark.sh'
      }
    }
  }
  post {
    success {
      sh 'tar -cvzf reports.tar.gz reports/'
      archiveArtifacts 'reports.tar.gz'
      archiveArtifacts artifacts: 'build.tar.gz'
    }
    failure {
      sh 'tar -cvzf reports.tar.gz reports/'
      mail attachmentsPattern: 'reports.tar.gz', bcc: '', body: 'Workflow failed, check artifacts', cc: '', from: '', replyTo: '', subject: 'Alert', to: 'losetazo@gmail.com'
    }
  }
}