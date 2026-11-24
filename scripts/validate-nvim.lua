-- Run after normal startup so plugins load with the same settings as the editor.
local ok, err = pcall(function()
  assert(vim.fn.has("nvim-0.11") == 1, "Neovim is too old")
  assert(vim.fn.exists(":Lazy") == 2, "Lazy is unavailable")
  local lock = vim.json.decode(table.concat(vim.fn.readfile(vim.fn.stdpath("config") .. "/lazy-lock.json"), "\n"))
  local plugins = require("lazy.core.config").plugins
  for name, pin in pairs(lock) do
    local plugin = plugins[name]
    assert(plugin, "Locked plugin is missing from configuration: " .. name)
    local commit = vim.trim(vim.fn.system({ "git", "-C", plugin.dir, "rev-parse", "HEAD" }))
    assert(commit == pin.commit, "Plugin is missing or differs from lockfile: " .. name)
  end
end)
if not ok then
  io.stderr:write(tostring(err) .. "\n")
  vim.cmd("cquit 1")
end
print("PASS Neovim configuration and all locked plugin commits")
vim.cmd("qa!")
