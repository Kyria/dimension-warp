local nauvis_mapgen = data.raw.planet.nauvis.map_gen_settings
local neo_nauvis_mapgen = data.raw.planet['neo-nauvis'].map_gen_settings
if  nauvis_mapgen and nauvis_mapgen.autoplace_settings and nauvis_mapgen.autoplace_settings.tile and
    neo_nauvis_mapgen and neo_nauvis_mapgen.autoplace_settings and neo_nauvis_mapgen.autoplace_settings.tile then

    neo_nauvis_mapgen.autoplace_settings.tile.settings = table.deepcopy(nauvis_mapgen.autoplace_settings.tile.settings)
end
if nauvis_mapgen and nauvis_mapgen.autoplace_controls and neo_nauvis_mapgen and neo_nauvis_mapgen.autoplace_controls then
    neo_nauvis_mapgen.autoplace_controls = table.deepcopy(nauvis_mapgen.autoplace_controls)
end
