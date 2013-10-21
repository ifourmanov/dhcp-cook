
#
# Setup subnets
#

if node[:dhcp][:networks].empty?
  Chef::Log.warn "node[:dhcp][:networks] must contain entries for dhcpd to operate"
end

node[:dhcp][:networks].each do |net|
  net_bag = data_bag_item( node[:dhcp][:networks_bag], Helpers::DataBags.escape_bagname(net) )

  next unless net_bag
  # run the lwrp with the bag data
  dhcp_subnet net_bag["address"] do
    broadcast net_bag["broadcast"]
    netmask   net_bag["netmask"]
    routers   net_bag["routers"] || []
    options   net_bag["options"] || []
    range     net_bag["range"] || ""
    conf_dir  node[:dhcp][:dir]
  end
end

