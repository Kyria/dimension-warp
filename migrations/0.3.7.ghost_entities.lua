--- If the player had the item from start, override ghost
if settings.global['dw-helper-starter-item'].value then
    game.forces.player.create_ghost_on_entity_death = true
end