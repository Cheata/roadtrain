Observer = {
  onNotify = function(self, entity, event)

  end
}

GUI = {

   styleprefix = "trailer_",

    defaultStyles = {
      label = "label",
      button = "button",
      checkbox = "checkbox"
    },

    bindings = {},

    callbacks = {},

    new = function(index, player)
      local new = {}
      setmetatable(new, {__index=GUI})
      return new
    end,

    onNotify = function(self, entity, event)

    end,

    add = function(parent, e, bind)
      local type, name = e.type, e.name
      if not e.style and GUI.defaultStyles[type] then
        e.style = GUI.styleprefix..type
      end
      if bind then
        if e.type == "checkbox" then
          e.state = GUI.bindings[e.name]
        end
      end
      local ret = parent.add(e)
      if bind and e.type == "textfield" then
        ret.text = bind
      end
      return ret
    end,

    addButton = function(parent, e, bind)
      e.type = "button"
      if bind then
        GUI.callbacks[e.name] = bind
      end
      return GUI.add(parent, e, bind)
    end,

    createGUI = function(player)
      if player.gui.left.trailer ~= nil then return end
      local trailer = GUI.add(player.gui.left, {type="frame", direction="vertical", name="trailer"})
      local rows = GUI.add(trailer, {type="table", name="rows", colspan=1})
      local buttons = GUI.add(rows, {type="table", name="buttons", colspan=3})
      GUI.addButton(buttons, {name="attach",caption={"text-attach"}}, GUI.attach)
      GUI.addButton(buttons, {name="detach",caption={"text-detach"}}, GUI.detach)
      GUI.addButton(buttons, {name="detachAll",caption={"text-detatchAll"}}, GUI.detachAll)
    end,

    destroyGui = function(player)
      if player.gui.left.trailer == nil then return end
      player.gui.left.trailer.destroy()
    end,

    onGuiClick = function(event, trailer, player)
      local name = event.element.name
      if GUI.callbacks[name] then
        return GUI.callbacks[name](event, trailer, player)
      end
    end,

    attach = function(event, trailer, player)
      trailer:attach()
    end,
    
    detach = function(event, trailer, player)
      TRAILER.detach(trailer:getLast().parent)
    end,
    
    detachAll = function(event, trailer, player)
      trailer:detachAll()
    end,
}
