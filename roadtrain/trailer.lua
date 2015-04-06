require "util"

local r2d = 180/math.pi

function addPos(p1,p2)
  if not p1.x then
    error("Invalid position", 2)
  end
  local p2 = p2 or {x=0,y=0}
  return {x=p1.x+p2.x, y=p1.y+p2.y}
end

function calcVector(p1,p2)
  dif = subPos(p2,p1)
  deg = r2d*math.atan2(dif.x,dif.y)
  return deg
end

function subPos(p1,p2)
  local p2 = p2 or {x=0,y=0}
  return {x=p1.x-p2.x, y=p1.y-p2.y}
end

local rot = {}
for i=0,7 do
  local rad = i* (math.pi/4)
  rot[i] = {cos=math.cos(rad),sin=math.sin(rad)}
end



function rotate(pos, deg)
  --local cos = rot[rad].cos
  --local sin = rot[rad].sin
  --local r = {{x=cos,y=-sin},{x=sin,y=cos}}
  local ret = {x=0,y=0}
  local rad = deg/r2d
  ret.x = (pos.x*math.cos(rad)) - (pos.y*math.sin(rad))
  ret.y = (pos.x*math.sin(rad)) + (pos.y*math.cos(rad))
  --ret.x = pos.x * r[1].x + pos.y * r[1].y
  --ret.y = pos.x * r[2].x + pos.y * r[2].y
  return ret
end

function pos2Str(pos)
  if not pos.x or not pos.y then
    pos = {x=0,y=0}
  end
  return util.positiontostr(pos)
end

function fixPos(pos)
  local ret = {}
  if pos.x then ret[1] = pos.x end
  if pos.y then ret[2] = pos.y end
  return ret
end

local RED = {r = 0.9}
local GREEN = {g = 0.7}
local YELLOW = {r = 0.8, g = 0.8}
  


function getNextTrailer(trailer)
   return trailer.child
end

function getPrevTrailer(trailer)
   return trailer.parent
end

TRAILER = {
  new = function(entity)
    local new = {
      vehicle = entity,
      driver=false, 
      active=false, -- need to rethink this
      parent=false,
      child=false,
      position=entity.position,
      orientation=entity.orientation,
      selfdrive=false
    }
    if not glob.trailer[entity.name] then
        new["selfdrive"]=true
    end
    setmetatable(new, {__index=TRAILER})
    return new
  end,

  onPlayerEnter = function(player)
     if  glob.towbar[player.vehicle.name] then
       local i = TRAILER.findByVehicle(player.vehicle) 
    
        if  not i then
          i=TRAILER.new(player.vehicle)
          table.insert(glob.trailers,i)
       end
       i = i.getFirst(i)
       
       if not i.selfdrive then
          i.vehicle.passenger=nil
          game.player.print("vehicle is not driveable")
       else
           if not i.vehicle.equals(player.vehicle) then
               player.vehicle.passenger=nil
               i.vehicle.passenger=player.character
               i.driver = player
           end
       end
    end
  end,

  onPlayerLeave = function(player)
    local i = TRAILER.findByPlayer(player)
      if  i then
        i.driver = false
     end
  end,

  findByVehicle = function(entity)
    for i,f in ipairs(glob.trailers) do
      if entity.equals(f.vehicle) then
        return f
      end
    end
    return false
  end,

  findByPlayer = function(player)
    for i,f in ipairs(glob.trailers) do
      if f.vehicle.equals(player.vehicle) then
        f.driver=player
        return f
      end
    end
    return false
  end,
  
  attach=function(self)
     trailer=self:getLast()
     pos={x=0,y=2.2}
     pos=addPos(rotate(pos,trailer.vehicle.orientation*360),trailer.vehicle.position)
     area={pos,pos}
     --trailer:fillWater(area)
     for _, entity in ipairs(game.findentitiesfiltered{area = area, type = "car"}) do
      if glob.towable[entity.name] then
        newtrailer=TRAILER.findByVehicle(entity)
      end
     end
     if newtrailer then
       trailer.child=newtrailer
       trailer.child.parent=trailer
       trailer.position=trailer.vehicle.position
       newtrailer=false
     else
       self:print("no trailer found in range")
     end
  end,
  
    fillWater = function(self, area)
         -- following code mostly pulled from landfill mod itself and adjusted to fit
        local tiles = {}
        local st, ft = area[1],area[2]
        game.player.print("TL.x "..st.x.." TL.y "..st.y.." br.x "..ft.x.." br.y "..ft.y)
        for x = st.x, ft.x, 1 do
          for y = st.y, ft.y, 1 do
            table.insert(tiles,{name="sand", position={x, y}})
          end
        end
        game.settiles(tiles) 
    end,
  
  detach=function(self)
    if self.child then
      self.child.parent=false
      self.child=false
    end
  end,
  
  removeItemFromTarget = function(self,entity,item,count,inv)
    local count = count or 1
    entity.getinventory(inv).remove({name = item, count = count})
  end,
  
  print = function(self, msg)
    if self.driver.name ~= "trailer_player" then
      self.driver.print(msg)
    else
      self:flyingText(msg, RED, true)
    end
  end,
  
  flyingText = function(self, line, color, show, pos)
    if show then
      local pos = pos or addPos(self.vehicle.position, {x=0,y=-1})
      color = color or RED
      game.createentity({name="flying-text", position=pos, text=line, color=color})
    end
  end,
  
getLast = function(trailer)
     if  trailer.child then
      return trailer.child:getLast()
     else
      return trailer
     end
end,

getFirst = function(trailer)
   if  trailer.parent then
      return trailer.parent:getFirst()
   else
       return trailer
   end
end,

update=function(self,event)
    if self.parent.vehicle.position.x ~= self.parent.position .x or self.parent.vehicle.position.y ~= self.parent.position.y then
      hitchpoint=addPos(self.parent.vehicle.position,rotate({x=0,y=1.3},self.parent.vehicle.orientation*360))
      pos=rotate({x=0,y=2.5},calcVector(self.vehicle.position,hitchpoint))
      pos=addPos(self.parent.vehicle.position,rotate({x=0,y=2.5},self.parent.vehicle.orientation*360))
      self.vehicle.teleport(pos)
      
      vect=calcVector(hitchpoint,self.vehicle.position)
      self.vehicle.orientation=((360-vect)/360)
      self.parent.position = self.parent.vehicle.position
    end
  end,

detachAll = function(self)
  if self.child then
    game.player.print(self.vehicle.name)
    self.child:detachAll()
    self:detach()
  end
end,
}
