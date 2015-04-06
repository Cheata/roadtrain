data:extend(
  {
    {
      type = "font",
      name = "trailer-small",
      from = "default",
      size = 13
    },
    {
      type ="font",
      name = "trailer-small-bold",
      from = "default-bold",
      size = 13
    }
  }
)

data.raw["gui-style"].default["trailer_label"] =
  {
    type = "label_style",
    font = "trailer-small",
    font_color = {r=1, g=1, b=1},
    top_padding = 0,
    bottom_padding = 0
  }

data.raw["gui-style"].default["trailer_textfield"] =
  {
    type = "textfield_style",
    left_padding = 3,
    right_padding = 2,
    minimal_width = 60,
    font = "trailer-small"
  }

data.raw["gui-style"].default["trailer_textfield_small"] =
  {
    type = "textfield_style",
    left_padding = 3,
    right_padding = 2,
    minimal_width = 30,
    font = "trailer-small"
  }
data.raw["gui-style"].default["trailer_button"] =
  {
    type = "button_style",
    parent = "default",
    font = "trailer-small-bold"
  }
data.raw["gui-style"].default["trailer_checkbox"] =
  {
    type = "checkbox_style",
    parent = "checkbox_style",
    font = "trailer-small",
  }
