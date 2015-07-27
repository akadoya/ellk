class Chef
  class Provider
    class LogstashForwarder < Chef::Provider::LWRPBase
      use_inline_resources if defined?(use_inline_resources)

      provides :logstash_forwarder
      service_name = 'logstash_forwarder'

      action :install do
        user new_resource.user
        group new_resource.group

        # TODO: react to os/arch
        remote_file '/opt/bin/logstash-forwarder' do
          owner new_resource.user
          group new_resource.group
          mode '0755'
          source 'https://download.elastic.co/logstash-forwarder/binaries/logstash-forwarder_linux_amd64'
          checksum '5f49c5be671fff981b5ad1f8c5557a7e9973b24e8c73dbf0648326d400e6a4a1'
        end

        runit_service service_name do
          default_logger true
          owner new_resource.user
          group new_resource.user
          cookbook new_resource.source
          action [:create, :enable]
        end
      end

      action :remove do
        runit_service service_name do
          action :stop
        end
      end

      ## SERVICE

      action :enable do
        service service_name do
          action :enable
        end
      end

      action :disable do
        service service_name do
          action :disable
        end
      end

      action :restart do
        service service_name do
          action :restart
        end
      end

      action :start do
        service service_name do
          action :start
        end
      end

      action :stop do
        service service_name do
          action :stop
        end
      end
    end
  end
end
