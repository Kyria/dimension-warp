dw = dw or {}

core_util = require("__core__/lualib/util.lua")
math2d = require("__core__/lualib/math2d")
mod_gui = require("__core__/lualib/mod-gui")

require "defines"
require "events"
require "utils"

--- surfaces where players are safe when they connect (no need for safe teleport)
dw.safe_surfaces = {

}