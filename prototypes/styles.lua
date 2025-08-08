-- create a frame style, but with opacity
local frame = table.deepcopy(data.raw['gui-style'].default.frame)
frame.graphical_set.base.opacity = 0.75
frame.graphical_set.base.background_blur = true
data.raw['gui-style'].default.dw_frame = frame