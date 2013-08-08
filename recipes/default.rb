#
# Cookbook Name:: newrelic-java
# Recipe:: default
#
# Copyright (C) 2013 Wyndham Jade LLC
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

attribs = node['newrelic']['java']
agent_dir = attribs['agent_path']
agent_version = attribs['agent_version']

def truthy_keys(m)
  m.select { |k,v| v }.keys.join(',')
end

ignore_http_params = truthy_keys(attribs['ignore_http_params'])
obfuscated_sql_fields = truthy_keys(attribs['transaction_tracer']['obfuscated_sql_fields'])
ignore_errors = truthy_keys(attribs['error_collector']['ignore_errors'])
ignore_status_codes = truthy_keys(attribs['error_collector']['ignore_status_codes'])

directory agent_dir do
  user 'root'
  group 'root'
  mode 0755
end

remote_file "#{agent_dir}/newrelic.jar" do
  user 'root'
  group 'root'
  mode 0644
  source "http://central.maven.org/maven2/com/newrelic/agent/java/newrelic-agent/#{agent_version}/newrelic-agent-#{agent_version}.jar"
end

remote_file "#{agent_dir}/newrelic-api.jar" do
  user 'root'
  group 'root'
  mode 0644
  source "http://central.maven.org/maven2/com/newrelic/agent/java/newrelic-api/#{agent_version}/newrelic-api-#{agent_version}.jar"
end

template "#{agent_dir}/newrelic.yml" do
  user 'root'
  group 'root'
  mode 0644
  variables({
    license: node['newrelic']['application_monitoring']['license'],
    enabled: attribs['enabled'],
    auto_app_naming: attribs['auto_app_naming'],
    auto_transaction_naming: attribs['auto_transaction_naming'],
    appname: attribs['app_name'],
    log_level: attribs['log_level'],
    audit_mode: attribs['audit_mode'],
    log_file_count: attribs['log_file_count'],
    log_limit_in_kbytes: attribs['log_limit_in_kbytes'],
    log_daily: attribs['log_daily'],
    log_file_name: attribs['log_file_name'],
    log_file_path: attribs['log_file_path'],
    ssl: attribs['ssl'],
    proxy_enabled: attribs['proxy']['enabled'],
    proxy_host: attribs['proxy']['host'],
    proxy_port: attribs['proxy']['port'],
    proxy_user: attribs['proxy']['user'],
    proxy_password: attribs['proxy']['password'],
    capture_http_params: attribs['capture_http_params'],
    ignore_http_params: ignore_http_params,
    trans_tracer_enabled: attribs['transaction_tracer']['enabled'],
    trans_tracer_threshold: attribs['transaction_tracer']['threshold'],
    trans_tracer_record_sql: attribs['transaction_tracer']['record_sql'],
    trans_tracer_obfuscated_sql_fields: obfuscated_sql_fields,
    trans_tracer_log_sql: attribs['transaction_tracer']['log_sql'],
    trans_tracer_stack_trace_threshold: attribs['transaction_tracer']['stack_trace_threshold'],
    trans_tracer_explain_enabled: attribs['transaction_tracer']['explain_enabled'],
    trans_tracer_explain_threshold: attribs['transaction_tracer']['top_n'],
    error_collector_enabled: attribs['error_collector']['enabled'],
    error_collector_ignore_errors: ignore_errors,
    error_collector_ignore_status_codes: ignore_status_codes,
    cross_application_tracer_enabled: attribs['cross_application_tracer']['enabled'],
    thread_profiler_enabled: attribs['thread_profiler']['enabled'],
    browser_monitoring_auto_instrument: attribs['browser_monitoring']['auto_instrument'],
    browser_monitoring_enabled: attribs['browser_monitoring']['enabled']
  })
end

