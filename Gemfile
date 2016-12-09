source "https://rubygems.org"


#####################################
# DO NOT CHANGE: Logstash core gems #
#####################################

gem "logstash-core", ENV.fetch('LOGSTASH_VERSION')
gem "file-dependencies", "0.1.6"
gem "ci_reporter_rspec", "1.0.0", :group => :development
gem "simplecov", :group => :development
gem "coveralls", :group => :development
gem "tins", "1.6", :group => :development
gem "rspec", "~> 3.1.0", :group => :development
gem "logstash-devutils", "~> 0", :group => :development
gem "benchmark-ips", :group => :development
gem "octokit", "3.8.0", :group => :build
gem "stud", "~> 0.0.21", :group => :build
gem "fpm", "~> 1.3.3", :group => :build
gem "rubyzip", "~> 1.1.7", :group => :build
gem "gems", "~> 0.8.3", :group => :build
gem "flores", "~> 0.0.6", :group => :development


#######################################################
# Gems we recommend you keep around to use on Aptible #
#######################################################

gem "logstash-filter-drop"
gem "logstash-input-http"

gem 'logstash-output-syslog'
gem 'logstash-output-elasticsearch', :git => 'https://github.com/krallin/logstash-output-elasticsearch', :ref => 'e6e3aa9'


######################################################################
# Common Logstash gems. Remove those you don't want. Keep the others #
######################################################################

gem "logstash-codec-json"
gem "logstash-codec-json_lines"
gem "logstash-codec-line"
gem "logstash-codec-multiline"
gem "logstash-codec-plain"
gem "logstash-output-http"
gem "logstash-output-s3"