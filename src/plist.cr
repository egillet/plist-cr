require "./plist/*"

module PList
  alias Value = String | Int64 | Float64 | Bool | Bytes | Time | Array(PList::Value) | Hash(String, PList::Value)
  DATE_FORMAT = "%FT%X"
end
