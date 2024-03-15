-- This file contains the built-in components. Each componment is a function
-- that takes the following arguments:
--      config: A table containing the configuration provided by the user
--              when declaring this component in their renderer config.
--      node:   A NuiNode object for the currently focused node.
--      state:  The current state of the source providing the items.
--
-- The function should return either a table, or a list of tables, each of which
-- contains the following keys:
--    text:      The text to display for this item.
--    highlight: The highlight group to apply to this text.

local highlights = require("neo-tree.ui.highlights")
local common = require("neo-tree.sources.common.components")
local utils = require("neo-tree.utils")

local icons = {
  c = "󰠱", -- Class
  f = "󰊕", -- Function
  m = "󰊕", -- method
  v = "󰀫", -- Variable
  Text = "󰉿",
  Constructor = "",
  Field = "󰜢",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "",
}

local M = {}
M.indent = common.indent
M.icon = function(config, node, state)
  local icon = icons[node.extra.type]
  if icon ~= nil then
    return {
      text = string.format("%s ", icon),
      highlight = highlights.FILE_ICON,
    }
  end
end
M.created = function(config, node, state) end
M.last_modified = function(config, node, state) end
M.file_size = function(config, node, state) end

M.type = function(config, node, state)
  return {
    text = node.extra.type,
    highlight = highlight,
  }
end

M.name = function(config, node, state)
  local highlight = config.highlight or highlights.FILE_NAME_OPENED
  local name = node.name
  if node.type == "directory" then
    if node:get_depth() == 1 then
      highlight = highlights.ROOT_NAME
    else
      highlight = highlights.DIRECTORY_NAME
    end
  end
  return {
    text = name,
    highlight = highlight,
  }
end

return vim.tbl_deep_extend("force", common, M)
