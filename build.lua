local book = arg[1]

if not book then
	print("Para compilar, use 'lua build.lua <nome-do-livro>'")
	os.exit(1)
end

local folder = book
local output = "output/" .. book .. ".pdf"
os.execute("mkdir -p output")

local files = {
  "shared/base_style.yaml",
  folder .. "/metadata.yaml",
  folder .. "/pre-textual.md"
}

local function capitulo_files(folder)
  local handle = io.popen("ls " .. folder .. "/capitulo*.md 2>/dev/null")
  local found = {}

  if handle then
    for line in handle:lines() do
      table.insert(found, line)
    end
    handle:close()
  end

  table.sort(found, function(a, b)
    return tonumber(a:match("capitulo(%d+)%.md")) < tonumber(b:match("capitulo(%d+)%.md"))
  end)

  return found
end

for _, path in ipairs(capitulo_files(folder)) do
  table.insert(files, path)
end

local optionals = {
  "bonus.md",
  "referencias.md"
}

for _, p in ipairs(optionals) do
  local path = folder .. "/" .. p

  if io.open(path, "r") then
    table.insert(files, path)
  end
end

local cmd = string.format(
  "pandoc %s -o %s --pdf-engine=tectonic --pdf-engine-opt=--print",
  table.concat(files, " "),
  output
)

print("-- Compilando " .. book .. ", aguarde...")
local status = os.execute(cmd)

if status then
	print("-- PDF gerado com sucesso: " .. output)
else
	print("-- Erro na compilação.")
end
