--- As the GUI frame change in 0.3.5, destroy it first if it exists so we have a new one.
for _, player in pairs(game.players) do
    local frameflow = mod_gui.get_frame_flow(player)
    if frameflow.warp_frame then frameflow.warp_frame.destroy() end
end