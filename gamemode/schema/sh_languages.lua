SCHEMA.languages = {"Latin", "Spanish", "French",  "Xin-Xao", "Zin-Tao", "Korean", "Russian", "German", "Chinese"}

for k, v in pairs(SCHEMA.languages) do
	SCHEMA:RegisterTrait(string.GetChar(v,1), v, "Allows you to speak in "..v)
end