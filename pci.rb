provides "pci"

$devices = Mash.new
lspci = `lspci -vnnmk`

$h = /[0-9a-fA-F]/ #any hex digit
$hh = /#{$h}#{$h}/ #any 2 hex digits
$hhhh = /#{$h}#{$h}#{$h}#{$h}/ #any 4 hex digits

$d_id = String.new #This identifies our pci devices

def standard_form( tag, line )
  tmp = line.scan(/(.*)\s\[(#{$hhhh})\]/)[0]
  $devices[$d_id]["#{tag}_name"] = tmp[0]
  $devices[$d_id]["#{tag}_id"] = tmp[1]
end

def standard_array( tag, line )
  if !$devices[$d_id][tag].kind_of?(Array) 
    $devices[$d_id][tag] = [ line ]
  else
    $devices[$d_id][tag].push( line )
  end
end

lspci.split("\n").each do |line|
  dev = line.scan(/^(.*):\s(.*)$/)[0]
  next if dev.nil?
  case dev[0]
  when "Device" # There are two different Device tags
    if tmp = dev[1].match(/(#{$hh}:#{$hh}.#{$h})/) then #We have a device id
      $d_id = tmp # From now on we will need this id
      $devices[$d_id] = Mash.new
    else
      standard_form( "device", dev[1])
    end
  when "Class"
    standard_form( "class", dev[1])
  when "Vendor"
    standard_form( "vendor", dev[1])
  when "Driver"
    standard_array( "driver", dev[1])
  when "Module"
    standard_array( "module", dev[1])
  else
  end
end

pci $devices
