# chef11
use_inline_resources

def write_include(file_includes)

  template "#{new_resource.conf_dir}/subnets.d/list.conf" do
    cookbook "dhcp"
    source "list.conf.erb"
    owner "root"
    group "root"
    mode 0644
    variables( :files => file_includes )
  end
end


action :add do
  directory "#{new_resource.conf_dir}/subnets.d/"

  template "#{new_resource.conf_dir}/subnets.d/#{new_resource.subnet}.conf" do
    cookbook "dhcp"
    source "subnet.conf.erb"
    variables(
      :subnet => new_resource.subnet,
      :netmask => new_resource.netmask,
      :broadcast => new_resource.broadcast,
      :routers => new_resource.routers,
      :options => new_resource.options,
      :range => new_resource.range,
    )
    owner "root"
    group "root"
    mode 0644
  end
  file_includes = []
  file_includes << "#{new_resource.conf_dir}/subnets.d/#{new_resource.name}.conf"
  write_include file_includes
end

action :remove do
  file "#{new_resource.conf_dir}/subnets.d/#{new_resource.name}.conf" do
    action :delete
    notifies :restart, resources(:service => node[:dhcp][:service_name]), :delayed
    notifies :send_notification, new_resource, :immediately
  end
  write_include
end

