require "../src/plist.cr"

File.open("samples/test.plist") do |file|
  plist = PList.parse(file)
  puts "io_plist: #{plist}"
  puts "conversion to XML"
  puts plist.to_plist
end

xml = <<-XML
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
    <dict>
      <key>key</key>
      <dict>
        <key></key>
        <string>1</string>
        <key>subkey</key>
        <string>2</string>
        <key>int</key>
        <integer>2</integer>
        <key>float</key>
        <real>-2.1233</real>
        <key>bool</key>
        <true/>
      </dict>
    </dict>
  </plist>
XML

plist = PList.parse(xml)
puts "string plist: #{plist}"
puts "conversion to XML"
puts plist.to_plist
