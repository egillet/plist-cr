require "./plist/*"

module PList
  alias Value = String | Int64 | Float64 | Bool | Bytes | Time | Array(Value) | Hash(String, Value) | Nil
  DATE_FORMAT = "%FT%X"
end
