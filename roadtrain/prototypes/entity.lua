data:extend(
{
  {
    type = "car",
    name = "trailer",
    icon = "__roadtrain__/graphics/icons/trailer.png",
    flags = {"pushable", "placeable-neutral", "player-creation"},
    minable = {mining_time = 1, result = "trailer"},
    max_health = 100,
    corpse = "medium-remnants",
    dying_explosion = "huge-explosion",
    energy_per_hit_point = 1,
    resistances =
    {
      {
        type = "fire",
        percent = 50
      },
      {
        type = "impact",
        decrease = 30,
        percent = 30
      },
    },
    collision_box = {{-0.5, -0.7}, {0.5, 0.7}},
    selection_box = {{-0.5, -0.7}, {0.5, 0.7}},
    effectivity = 0.5,
    braking_power = "200kW",
    burner =
    {
      effectivity = 0.6,
      fuel_inventory_size = 1
    },
    consumption = "0KW",
    friction = 2e-3,
    animation =
    {
      layers =
      {
        {
          width = 90,
          height = 80,
          frame_count = 1,
          axially_symmetrical = false,
          direction_count = 64,
          shift = {-0.140625, -0.28125},
          animation_speed = 8,
          max_advance = 1,
          stripes =
          {
            {
             filename = "__roadtrain__/graphics/entity/trailer/base-1.png",
             width_in_frames = 1,
             height_in_frames = 16,
            },
            {
             filename = "__roadtrain__/graphics/entity/trailer/base-2.png",
             width_in_frames = 1,
             height_in_frames = 24,
            },
            {
             filename = "__roadtrain__/graphics/entity/trailer/base-3.png",
             width_in_frames = 1,
             height_in_frames = 24,
            }
          }
        },
        {
          width = 100,
          height = 75,
          frame_count = 1,
          apply_runtime_tint = true,
          axially_symmetrical = false,
          direction_count = 64,
          max_advance = 1,
          line_length = 2,
          shift = {0, -0.171875},
          stripes = 
          {
            {
              filename = "__base__/graphics/entity/car/car-mask-1.png",
              width_in_frames = 1,
              height_in_frames = 22,
            },
            {
              filename = "__base__/graphics/entity/car/car-mask-2.png",
              width_in_frames = 1,
              height_in_frames = 22,
            },
            {
              filename = "__base__/graphics/entity/car/car-mask-3.png",
              width_in_frames = 1,
              height_in_frames = 20,
            },
          }
        },
      }
    },
    stop_trigger_speed = 0.2,
    stop_trigger =
    {
      {
        type = "play-sound",
        sound =
        {
          {
            filename = "__base__/sound/car-breaks.ogg",
            volume = 0.6
          },
        }
      },
    },
    crash_trigger = crash_trigger(),
    sound_minimum_speed = 0.15;
    working_sound =
    {
      sound =
      {
        filename = "__base__/sound/car-engine.ogg",
        volume = 0.6
      },
      activate_sound =
      {
        filename = "__base__/sound/car-engine-start.ogg",
        volume = 0.6
      },
      deactivate_sound =
      {
        filename = "__base__/sound/car-engine-stop.ogg",
        volume = 0.6
      },
      match_speed_to_activity = true,
    },
    open_sound = { filename = "__base__/sound/car-door-open.ogg", volume=0.7 },
    close_sound = { filename = "__base__/sound/car-door-close.ogg", volume = 0.7 },
    rotation_speed = 0.015,
    weight = 500,
    inventory_size = 100,
  },
}
)