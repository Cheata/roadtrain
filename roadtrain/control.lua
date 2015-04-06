require "defines"
require "trailer"
require "GUI"
require "config"

remote.addinterface("roadtrain",
  {
    addtocargo = function(entity,item,count)
      if glob.towbar[entity.name] then
        for i=1,#glob.trailers do
          if glob.trailers[i].vehicle.equals(entity) then
            return addcargo(glob.trailers[i],item,count)
          end
        end
      end
      return false
    end,
    printtowbars=function()
      for i,f in pairs(glob.towbar) do
        game.player.print(i.." "..tostring(f))
      end
    end,
    gettrailers = function()
      return glob.trailers
    end,
    settowbar = function(name,state)
      glob.towbar[name]=state
    end,
    settowable = function(name,state)
      glob.towable[name]=state
    end,
    settrailer = function(name,state)
      glob.trailer[name]=state
    end
  })

  function addcargo(trailer,item,count)
    if trailer.child then
      return addcargo(trailer.child,item,count)
    end
    if trailer.vehicle.getinventory(2).caninsert({name = item, count = count}) then
        trailer.vehicle.getinventory(2).insert({name = item, count = count})
        return true
    end
    return false
  end

  function resetMetatable(o, mt)
    setmetatable(o,{__index=mt})
    return o
  end

  local function onTick(event)

    if event.tick % 10 == 0  then
      for pi, player in ipairs(game.players) do
        if (player.vehicle ~= nil and (towbar[player.vehicle.name] or towable[player.vehicle.name])) then
          if player.gui.left.trailer == nil then
            TRAILER.onPlayerEnter(player)
            GUI.createGUI(player)
          end
        end
        if player.vehicle == nil and player.gui.left.trailer ~= nil then
          TRAILER.onPlayerLeave(player)
          GUI.destroyGui(player)
        end
      end
    end
    
    for i, trailer in ipairs(glob.trailers) do
      if trailer.parent then
        trailer:update(event)
      end
    end

  end
  
  local function onGuiClick(event)
    local index = event.playerindex or event.name
    local player = game.players[index]
    if player.gui.left.trailer ~= nil then
      local trailer= TRAILER.findByPlayer(player)
      if trailer then
        GUI.onGuiClick(event, trailer, player)
      else
        player.print("GUI without towbar, wrooong!")
        GUI.destroyGui(player)
      end
    end
  end
  
  function onpreplayermineditem(event)
    local ent = event.entity
    local cname = ent.name
    if (towbar[event.entity.name] or towable[event.entity.name]) then
      for i=1,#glob.trailers do
        if glob.trailers[i].vehicle.equals(ent) then
          unhitch(glob.trailers[i])
          glob.trailers[i].delete = true
        end
      end
    end
  end

  function onplayermineditem(event)
    if  towbar[event.itemstack.name ] or towable[event.itemstack.name] then
      for i=#glob.trailers,1,-1 do
        if glob.trailers[i].delete then
          table.remove(glob.trailers, i)
        end
      end
    end
  end
  
  local function onplayercreated(event)
    local player = game.getplayer(event.playerindex)
    local GUI = player.gui
    if GUI.top.trailer ~= nil then
      GUI.top.trailer.destroy()
    end
  end

  game.onevent(defines.events.onplayercreated, onplayercreated)
  
  local function initGlob()
    if glob.version == nill or glob.version < "0.0.1" then
      glob = {}
      glob.settings = {}
      glob.version = "0.0.1"
    end
    glob.trailers = glob.trailers or {}
    glob.trailer = glob.trailer or trailer
    glob.towable = glob.towable or towable
    glob.towbar = glob.towbar or towbar
    for i,trailer in ipairs(glob.trailers) do
      trailer = resetMetatable(trailer, TRAILER)
      trailer.index = nil
   end
  end
  
  local function oninit() initGlob() end

  local function onload()
    initGlob()
  end
  
  local function onbuiltentity(event)
     if towbar[event.createdentity.name] or towable[event.createdentity.name] then
        table.insert(glob.trailers,TRAILER.new(event.createdentity))
     end
  end
  
  local function onentitydied(event)
     if towbar[event.entity.name] or towable[event.entity.name] then
        for i=#glob.trailers,1,-1 do
        if event.entity.equals(glob.trailers[i].vehicle) then
          unhitch(glob.trailers[i])
          table.remove(glob.trailers, i)
        end
      end
     end
  end
  
function unhitch(trailer)
  if trailer.child then
   trailer:detach()
  end
  if trailer.parent then
   trailer.parent:detach()
  end
end
  
  game.oninit(oninit)
  game.onload(onload)
  game.onevent(defines.events.ontick, onTick)
  game.onevent(defines.events.onguiclick, onGuiClick)
  game.onevent(defines.events.onplayermineditem, onplayermineditem)
  game.onevent(defines.events.onpreplayermineditem, onpreplayermineditem)
  game.onevent(defines.events.onbuiltentity, onbuiltentity)
  game.onevent(defines.events.onentitydied, onentitydied)