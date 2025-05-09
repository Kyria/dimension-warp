local nauvis = data.raw['planet']['nauvis']
nauvis.distance = 12
nauvis.orientation = 0.5
nauvis.draw_orbit = false

if mods['space-age'] then
    local vulcanus = data.raw['planet']['vulcanus']
    vulcanus.draw_orbit = false
    -- distance = 10,
    -- orientation = 0.1,
    vulcanus.distance = 10
    vulcanus.orientation = 0.3

    local gleba = data.raw['planet']['gleba']
    gleba.draw_orbit = false
    -- distance = 20,
    -- orientation = 0.175,
    gleba.distance = 20
    gleba.orientation = 0.4

    local fulgora = data.raw['planet']['fulgora']
    fulgora.draw_orbit = false
    -- distance = 25,
    -- orientation = 0.325,
    fulgora.distance = 10
    fulgora.orientation = 0.66

    local aquilo = data.raw['planet']['aquilo']
    aquilo.draw_orbit = false
    -- distance = 35,
    -- orientation = 0.225,
    aquilo.distance = 25
    aquilo.orientation = 0.6

    data.raw['space-location']['solar-system-edge'].distance = 30
    data.raw['space-location']['shattered-planet'].distance = 50
end