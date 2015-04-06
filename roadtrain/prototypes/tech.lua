data:extend(
{
  {
    type = "technology",
    name = "trailer",
    icon = "__roadtrain__/graphics/icons/trailer.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "trailer"
      },
    },
    prerequisites = {"automobilism"},
    unit =
    {
      count = 450,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
        {"science-pack-3", 1}
      },
      time = 20
    },
    order = "e-c-c"
  },
}
)