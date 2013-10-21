

#
# Global DHCP config settings
#
template node[:dhcp][:config_file] do
  owner "root"
  group "root"
  mode 0644
  source "dhcpd.conf.erb"
  variables(
    :allows => node[:dhcp][:allows] || [],
    :parameters =>  node[:dhcp][:parameters] || [],
    :options =>  node[:dhcp][:options] || [],
    :my_ip => node[:ipaddress],
    )
  action :create
end

#
# Create the dirs and stub files for each resource type
#
%w{groups.d hosts.d subnets.d}.each do |dir|
  directory "#{node[:dhcp][:dir]}/#{dir}"
  file "#{node[:dhcp][:dir]}/#{dir}/list.conf" do
    action :create_if_missing
    content ""
  end
end


