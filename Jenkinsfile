pipeline {
  agent { docker { image 'python:3.7.2' } }
  stages {
    stage('Clean workspace'){
      steps{
        sh 'rm -rf artifact_tmp'
      }
    }
    stage('Setup workspace'){
      steps{
        sh 'pip install -r requirements.txt'
        sh 'pip install flake8 pytest bandit coverage'
        sh 'mkdir -p artifact_tmp/reports/'
      }
    }
    stage('validate') {
      steps {
        sh 'flake8 --builtins="process_paragraph" > artifact_tmp/reports/flake8.txt'
      }
    }
    stage('Test') {
      steps {
        sh 'pytest -rA test.py > artifact_tmp/reports/tests.txt'
        sh 'coverage report test.py > artifact_tmp/reports/coverage.txt'
      }
    }
    stage('Package') {
      steps {
        sh 'python3 setup.py build'
        sh 'mv build/ artifact_tmp/'
      }
    }
    stage('Verify') {
      steps {
        sh 'bandit -r -lll -s B605 ./ -o "artifact_tmp/reports/bandit.txt"'
      }
    }
    stage('Deploy') {
      steps {
        sh 'tar -cvzf build.tar.gz artifact_tmp/build/'
      }
    }
    stage('Benchmarking'){
      options {
        timeout(time: 1, unit: 'MILLISECONDS')
      }
      steps{
        sh 'python3 -m cProfile -s \'ncalls\' test.py > temp_file && head -n 30 temp_file > artifact_tmp/reports/benchmarks.txt'
      }
    }
  }
  post {
    success {
      sh 'tar -cvzf reports.tar.gz artifact_tmp/reports/'
      archiveArtifacts 'reports.tar.gz'
      archiveArtifacts 'build.tar.gz'
    }
    aborted {
      archiveArtifacts '**'
      build "pipeline1"
    }
  }
}

pipeline1 {
  agent { docker { image 'python:3.7.2' } }
  stages {
    stage('Archive artifacts'){
      sh 'tar -cvzf artifacts.tar.gz artifact_tmp'
      archiveArtifacts 'artifacts.tar.gz'
    }
  }
}