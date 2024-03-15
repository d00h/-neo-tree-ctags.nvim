--This file should have all functions that are in the public api and either set
--or read the state of this source.

local vim = vim
local utils = require("neo-tree.utils")
local renderer = require("neo-tree.ui.renderer")
local items = require("neo-tree.sources.ctags.libs.items")

local events = require("neo-tree.events")
local manager = require("neo-tree.sources.manager")
local git = require("neo-tree.git")

local M = { name = "ctags" }

local wrap = function(func)
  return utils.wrap(func, M.name)
end


M.follow = function()
end

---Navigate to the given path.
---@param path string Path to navigate to. If empty, will navigate to the cwd.
M.navigate = function(state, path, path_to_reveal)
  state.dirty = true
  local winid, _ = utils.get_appropriate_window(state)
  local bufnr = vim.api.nvim_win_get_buf(winid)
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  items.get_ctags(bufname, state)

end

---Configures the plugin, should be called before the plugin is used.
---@param config table Configuration table containing any keys that the user
--wants to change from the defaults. May be empty to accept default values.
M.setup = function(config, global_config)
  if config.before_render then
    manager.subscribe(M.name, {
      event = events.BEFORE_RENDER,
      handler = function(state)
        local this_state = manager.get_state(M.name)
        if state == this_state then
          config.before_render(this_state)
        end
      end,
    })
  end
end

return M
