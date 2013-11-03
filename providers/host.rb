use_inline_resources 

def write_include(file_includes)

  template "#{new_resource.conf_dir}/hosts.d/list.conf" do
    cookbook "dhcp"
    source "list.conf.erb"
    owner "root"
    group "root"
    mode 0644
    variables( :files => file_includes )
  end
end

action :add do
  directory "#{new_resource.conf_dir}/hosts.d/"

  template  "#{new_resource.conf_dir}/hosts.d/#{new_resource.hostname}.conf" do
    cookbook "dhcp"
    source "host.conf.erb"
    variables(
      :name => new_resource.name,
      :hostname => new_resource.hostname,
      :macaddress => new_resource.macaddress,
      :ipaddress => new_resource.ipaddress,
      :options => new_resource.options,
      :parameters => new_resource.parameters
    )
    owner "root"
    group "root"
    mode 0644
  end
  file_includes = []
  file_includes << "#{new_resource.conf_dir}/hosts.d/#{new_resource.name}.conf"	  
  write_include file_includes
end

action :remove do
  file "#{new_resource.conf_dir}/hosts.d/#{new_resource.name}.conf" do
    action :delete
    notifies :restart, "service[#{node[:dhcp][:service_name]}]", :delayed
  end

  write_include
end


