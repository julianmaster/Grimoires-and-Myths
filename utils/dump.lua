-- Source : https://stackoverflow.com/questions/55650773/trying-to-print-a-table-in-lua

function dump(value, call_indent)
  if not call_indent then
    call_indent = ""
  end

  local indent = call_indent .. "  "

  local output = ""

  if type(value) == "table" then
    output = output .. "{"
    local first = true
    for inner_key, inner_value in pairs ( value ) do
      if not first then
        output = output .. ", "
      else
        first = false
      end
      output = output .. "\n" .. indent
      output = output  .. inner_key .. " = " .. dump ( inner_value, indent )
    end
    output = output ..  "\n" .. call_indent .. "}"
  elseif type (value) == "userdata" then
    output = "userdata"
  else
    output =  value
  end
  return output
end
