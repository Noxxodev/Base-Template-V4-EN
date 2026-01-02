---------------------------------------------------------------------------------------------------
-- /me

-- Global configuration
Config = {
    language = 'en',
    color = { r = 230, g = 230, b = 230, a = 255 }, -- Text color
    font = 0, -- Text font
    time = 5000, -- Duration to display the text (in ms)
    scale = 0.5, -- Text scale
    dist = 250, -- Min. distance to draw
}

-- Available languages
Languages = {
    ['en'] = {
        commandName = 'me',
        commandDescription = 'Display an action above your head.',
        commandSuggestion = {{ name = 'action', help = '"scratch his nose" for example.' }},
        prefix = 'the person '
    },
    ['fr'] = {
        commandName = 'me',
        commandDescription = 'Display an action above your head.',
        commandSuggestion = {{ name = 'action', help = '"scratches his nose" for example.' }},
        prefix = 'the person '
    },
    ['dk'] = {
        commandName = 'me',
        commandDescription = 'Display an action above your head.',
        commandSuggestion = {{ name = 'action', help = '"takes a cigarette from his pocket" for example.' }},
        prefix = 'the person '
    },
}

---------------------------------------------------------------------------------------------------
-- Car rental

Config.notif = 1 -- Notification type: 1 = ESX notification | 2 = OX notification

Config.location = {
    {
        id = "location1", -- Unique string or number for each rental location

        pos = { x = 239.92, y = -861.94, z = 29.75, h = 340.08 }, -- Blip and ped position
        name = 'csb_car3guy1', -- Ped model name
        blocking = true, -- true = ped is blocked | false = ped can be pushed
        invincible = true, -- true = ped is immortal | false = ped can die
        freeze = true, -- true = ped stays still | false = ped can move

        icon = 'fa-solid fa-car-side', -- Interaction icon: https://fontawesome.com/search
        titre = 'Car rental', -- Interaction title
        distance = 2.5, -- Interaction distance

        posspawn = { x = 240.92, y = -859.09, z = 29.60, h = 248.83 }, -- Vehicle spawn position
        tempslocation = 30000, -- Rental duration in milliseconds

        blip = {
            sprite = 464, -- Blip icon
            scale = 0.8, -- Blip scale
            colour = 11, -- Blip color
            name = "Car rental", -- Blip name
        },

        vehicle = {
            {
                label = "Faggio", -- Menu name
                vehicule = "faggio", -- Vehicle name
                description = "You can rent a Faggio for: $20", -- Menu description
                prix = 20, -- Vehicle price
                image = "https://docs.fivem.net/vehicles/faggio.webp", -- Vehicle image
            },
            {
                label = "Sultan",
                vehicule = "sultan",
                description = "You can rent a Sultan for: $300",
                prix = 300,
                image = "https://www.grandtheftauto5.fr/images/vehicules/hd2020/sultan.jpg",
            },
        }
    },
    {
        id = "location2",

        pos = { x = 1894.66, y = 3715.32, z = 32.75, h = 124.56 },
        name = 'csb_car3guy1',
        blocking = true,
        invincible = true,
        freeze = true,

        icon = 'fa-solid fa-car-side',
        titre = 'Car rental',
        distance = 2.5,

        posspawn = { x = 1890.39, y = 3712.03, z = 32.85, h = 213.11 },
        tempslocation = 30000,

        blip = {
            sprite = 464,
            scale = 0.8,
            colour = 11,
            name = "Car rental",
        },

        vehicle = {
            {
                label = "Faggio",
                vehicule = "faggio",
                description = "You can rent a Faggio for: $20",
                prix = 20,
                image = "https://docs.fivem.net/vehicles/faggio.webp",
            },
            {
                label = "Sultan",
                vehicule = "sultan",
                description = "You can rent a Sultan for: $300",
                prix = 300,
                image = "https://www.grandtheftauto5.fr/images/vehicules/hd2020/sultan.jpg",
            },
        }
    },
    {
        id = "location3",

        pos = { x = 1702.86, y = 4917.30, z = 42.22, h = 145.94 },
        name = 'csb_car3guy1',
        blocking = true,
        invincible = true,
        freeze = true,

        icon = 'fa-solid fa-car-side',
        titre = 'Car rental',
        distance = 2.5,

        posspawn = { x = 1691.52, y = 4916.34, z = 42.08, h = 64.46 },
        tempslocation = 30000,

        blip = {
            sprite = 464,
            scale = 0.8,
            colour = 11,
            name = "Car rental",
        },

        vehicle = {
            {
                label = "Faggio",
                vehicule = "faggio",
                description = "You can rent a Faggio for: $20",
                prix = 20,
                image = "https://docs.fivem.net/vehicles/faggio.webp",
            },
            {
                label = "Sultan",
                vehicule = "sultan",
                description = "You can rent a Sultan for: $300",
                prix = 300,
                image = "https://www.grandtheftauto5.fr/images/vehicules/hd2020/sultan.jpg",
            },
        }
    },
    {
        id = "location4",

        pos = { x = -269.99, y = 6073.13, z = 31.46, h = 182.81 },
        name = 'csb_car3guy1',
        blocking = true,
        invincible = true,
        freeze = true,

        icon = 'fa-solid fa-car-side',
        titre = 'Car rental',
        distance = 2.5,

        posspawn = { x = -267.79, y = 6067.05, z = 31.46, h = 123.57 },
        tempslocation = 30000,

        blip = {
            sprite = 464,
            scale = 0.8,
            colour = 11,
            name = "Car rental",
        },

        vehicle = {
            {
                label = "Faggio",
                vehicule = "faggio",
                description = "You can rent a Faggio for: $20",
                prix = 20,
                image = "https://docs.fivem.net/vehicles/faggio.webp",
            },
            {
                label = "Sultan",
                vehicule = "sultan",
                description = "You can rent a Sultan for: $300",
                prix = 300,
                image = "https://www.grandtheftauto5.fr/images/vehicules/hd2020/sultan.jpg",
            },
        }
    },
}

---------------------------------------------------------------------------------------------------
-- Weather

Config.adminweather = { -- Ranks allowed to use weather commands
    -- 'owner',
    'admin',
    'modo'
}

---------------------------------------------------------------------------------------------------
-- Teleportation

Config.teleporation = {
    ['point1'] = {
        blips = {
            active = true,
            pos = { x = -1042.39, y = -2745.75, z = 21.36 }, -- Blip position
            sprite = 307,
            scale = 0.8,
            colour = 54,
            name = "Travel",
        },
        ped = {
            active = true,
            nameped = 'csb_car3guy1', -- Ped model
            pos = { x = -1042.39, y = -2745.75, z = 21.36, h = 329.81 },
            blocking = true,
            invincible = true,
            freeze = true,
        },
        ox_target = {
            pos = { x = -1042.39, y = -2745.75, z = 20.36 }, -- Interaction position
            icon = 'fa-solid fa-location-dot',
            titre = 'Cayo Perico',
            distance = 2.5,
        },
        position = {
            {
                label = "Cayo Perico",
                pos = { x = 4435.77, y = -4484.97, z = 4.29 }
            },
        }
    },
    ['point2'] = {
        blips = {
            active = true,
            pos = { x = 4436.62, y = -4482.53, z = 4.32 },
            sprite = 307,
            scale = 0.8,
            colour = 54,
            name = "Travel",
        },
        ped = {
            active = true,
            nameped = 'csb_car3guy1',
            pos = { x = 4436.62, y = -4482.53, z = 4.32, h = 202.95 },
            blocking = true,
            invincible = true,
            freeze = true,
        },
        ox_target = {
            pos = { x = 4436.62, y = -4482.53, z = 3.32 },
            icon = 'fa-solid fa-location-dot',
            titre = 'Los Santos',
            distance = 2.5,
        },
        position = {
            {
                label = "Los Santos",
                pos = { x = -1037.85, y = -2737.74, z = 20.17 }
            },
        }
    },
}
