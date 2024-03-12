local M = {}

M.arr_concat = function(...)
  local result = {}
  for _, tbl in ipairs({ ... }) do
    for _, val in ipairs(tbl) do
      if val then
        table.insert(result, val)
      end
    end
  end
  return result
end

return M
