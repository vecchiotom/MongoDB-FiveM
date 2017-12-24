url = "http://localhost:3000/foo/"

-- code --
function urlencode(str)
   if (str) then
      str = string.gsub (str, "\n", "\r\n")
      str = string.gsub (str, "([^%w ])",
         function (c) return string.format ("%%%02X", string.byte(c)) end)
      str = string.gsub (str, " ", "+")
   end
   return str    
end


function MongoInsert(collection, ins)
	
	PerformHttpRequest(url .. collection, function(err, text, headers) end, 'POST', json.encode(ins), { ['Content-Type'] = 'application/json' })
	return true
end
function MongoDelete(collection, id)
	PerformHttpRequest(url .. collection .. "/"..id, function(err, text, headers) print(text) end, 'DELETE', "", { ['Content-Type'] = 'application/json' })
	return true
end

function MongoFind(collection, querys, skip, limit, callback)
	local jsonquery = json.encode(querys)
    PerformHttpRequest(url .. collection .. "?query="..urlencode(jsonquery),function(err, text, headers) if text then callback(json.decode(text), text) elseif text == nil then callback(nil, "") end print(text) return end, 'GET', "", { ['Content-Type'] = 'application/json' })
end

function MongoUpdate(collection, id, val)
    PerformHttpRequest(url .. collection .. "/" .. id,function(err, text, headers) print(text) return end, 'PUT', '{ "$set" : ' .. json.encode(val) .. "}", { ['Content-Type'] = 'application/json' })
    return true
end
