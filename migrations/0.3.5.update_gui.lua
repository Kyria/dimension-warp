for _, player in pairs(game.players) do
    local frameflow = mod_gui.get_frame_flow(player)
    if frameflow.warp_frame then frameflow.warp_frame.destroy() end
end