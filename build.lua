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

local optionals = {
  "capitulo*.md",
  "bonus.md",
  "referencias.md"
}

for _, p in ipairs(optionals) do
  local path = folder .. "/" .. p

  if p:find("*") or io.open(path, "r") then
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
