require "xml"
require "base64"

module PList
  def self.to_plist(d : Value)
    XML.build(indent: "  ") do |xml|
      xml.dtd("plist", "-//Apple//DTD PLIST 1.0//EN", "http://www.apple.com/DTDs/PropertyList-1.0.dtd")
      xml.element("plist", version: "1.0") do
        to_val(xml, d)
      end
    end
  end

  private def self.to_val(xml, d : Value)
    case d
    when String
      xml.element "string" do
        xml.text d
      end
    when Int8 | Int16 | Int32 | Int64
      xml.element "integer" do
        xml.text "#{d}"
      end
    when Float32 | Float64
      xml.element "real" do
        xml.text "#{d}"
      end
    when Bool
      xml.element d ? "true" : "false"
    when Time
      xml.element "date" do
        xml.text d.to_s(DATE_FORMAT)
      end
    when Bytes
      xml.element "data" do
        xml.text Base64.encode(d).strip
      end
    when Hash(String, Value)
      xml.element "dict" do
        d.each do |k, v|
          xml.element("key") { xml.text k }
          to_val(xml, v)
        end
      end
    when Array(Value)
      xml.element "array" do
        d.each do |v|
          to_val(xml, v)
        end
      end
    end
  end
end # module

class Hash(K, V)
  def to_plist
    PList.to_plist(self)
  end
end
