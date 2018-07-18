require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut


action :append do
  updated = false
  if [:ipv4, :both].include?(new_resource.ip_version)
    updated |= handle_rule(new_resource, "ipv4")
  end
  if [:ipv6, :both].include?(new_resource.ip_version)
    if new_resource.table == 'nat' &&
        Gem::Version.new(/\d+(\.\d+(.\d+)?)?/.match(node['kernel']['release'])[0]) < Gem::Version.new('3.7')
      raise "NAT table cannot be used with IPv6 before Kernel 3.7"
    end
