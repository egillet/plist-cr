require "xml"
require "base64"

module PList
  def self.parse(io : IO)
    data = XML.parse(io)
    plist(data.first_element_child)
  end

  def self.parse(xml : String)
    data = XML.parse(xml)
    plist(data.first_element_child)
  end

  private def self.plist(node)
    if node
      if node.name == "plist"
        to_val(node.first_element_child).as?(Hash(String, Value))
      else
        raise "invalid node #{node.name}: not a plist"
      end
    else
      nil
    end
  end

  private def self.to_val(node)
    if node
      case node.name
      when "string"
        to_string(node)
      when "integer"
        to_integer(node)
      when "real"
        to_real(node)
      when "true"
        to_true(node)
      when "false"
        to_false(node)
      when "dict"
        to_dict(node)
      when "array"
        to_array(node)
      when "date"
        to_date(node)
      when "data"
        to_data(node)
      else
        raise "unknow node #{node.name}"
      end
    else
      raise "invalid empty node"
    end
  end

  private def self.to_string(node)
    cnt = node.content
    if cnt
      cnt.as(String)
    else
      ""
    end
  end

  private def self.to_integer(node)
    cnt = node.content
    if cnt
      cnt.to_i64
    else
      0_i64
    end
  end

  private def self.to_real(node)
    cnt = node.content
    if cnt
      cnt.to_f64
    else
      0_f64
    end
  end

  private def self.to_true(node)
    true
  end

  private def self.to_false(node)
    false
  end

  private def self.to_dict(node)
    res = {} of String => Value
    has_key = false
    key = ""
    node.children.select(&.element?).each do |c|
      if has_key
        res[key] = to_val(c)
        has_key = false
      else
        if c.name == "key"
          key = to_string(c)
          has_key = true
        else
          raise "not well formed dict: expected key, received #{c.name}"
        end
      end
    end
    res
  end

  private def self.to_array(node)
    res = [] of Value
    node.children.select(&.element?).each do |c|
      res << to_val(c)
    end
    res
  end

  private def self.to_date(node)
    cnt = node.content
    if cnt
      Time.parse(cnt, DATE_FORMAT, Time::Location::UTC)
    else
      raise "invalid empty date node"
    end
  end

  private def self.to_data(node)
    cnt = node.content
    if cnt
      c = cnt.gsub(/\s/, "")
      Base64.decode(c)
    else
      raise "invalid empty data node"
    end
  end
end
