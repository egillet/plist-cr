require "xml"
require "base64"

module PList
  def self.to_plist(d)
    XML.build(indent: "  ") do |xml|
      xml.dtd("plist", "-//Apple//DTD PLIST 1.0//EN", "http://www.apple.com/DTDs/PropertyList-1.0.dtd")
      xml.element("plist", version: "1.0") do
        to_val(xml, d)
      end
    end
  end

  private def self.to_val(xml, d : Hash(String, Value))
    xml.element "dict" do
      d.each do |k, v|
        xml.element("key") { xml.text k }
        to_val(xml, v)
      end
    end
  end

  private def self.to_val(xml, d : Array(Value))
    xml.element "array" do
      d.each do |v|
        to_val(xml, v)
      end
    end
  end

  private def self.to_val(xml, d : String)
    xml.element "string" do
      xml.text d
    end
  end

  private def self.to_val(xml, d : (Int8 | Int16 | Int32 | Int64))
    xml.element "integer" do
      xml.text "#{d}"
    end
  end

  private def self.to_val(xml, d : (Float32 | Float64))
    xml.element "real" do
      xml.text "#{d}"
    end
  end

  private def self.to_val(xml, d : Bool)
    xml.element d ? "true" : "false"
  end

  private def self.to_val(xml, d : Time)
    xml.element "date" do
      xml.text d.to_s(DATE_FORMAT)
    end
  end

  private def self.to_val(xml, d : Bytes)
    xml.element "data" do
      xml.text Base64.encode(d).strip
    end
  end

  private def self.to_val(xml, d : Nil)
  end

  private def self.to_val(xml, d)
    raise "invalid type #{typeof(d)}"
  end
end # module

struct Nil
  def to_plist
    PList.to_plist(nil)
  end
end

class Hash(K, V)
  def to_plist
    PList.to_plist(self)
  end
end
