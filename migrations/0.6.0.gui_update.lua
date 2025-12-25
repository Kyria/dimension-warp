--- Force GUI recreation to make sure we have everything in the right order.
storage.planet_selector_enabled = false
storage.planet_selector_list = {}
storage.warp.preferred_destination = nil
for _, player in pairs(game.players) do
    local frameflow = mod_gui.get_frame_flow(player)
    if frameflow.dw_frame and frameflow.dw_frame.warp_frame then frameflow.dw_frame.warp_frame.destroy() end
end