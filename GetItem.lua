require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "commonHelper"
local Trigger = import "Trigger"

local Item = import "item"
--生成物品属性
function GetFloat(self)
  return math.random(math.ceil(100000000/(self+1)),math.ceil(100000000*(self+1)))/100000000
end

function GetItemId()
  for i=1,#SaveTable.Item do
    SaveTable.Item[i].id = i
  end
end

function AddTriggers(type,lv,s)
  s=s or 1
  local tr = Trigger["属性池"][type]
  local num = math.random(1,#tr)
  print(Trigger["属性"])
  local sx = Trigger["属性"][lv][tr[num]]
  local sp = split(sx,"#")
  local tb = {}
  for k,v in pairs(sp) do
    local sp1 = split(v,"|")
    local tab = {}
    for i=1,#sp1 do
      if tonumber(sp1[i]) then
        table.insert(tab,tonumber(sp1[i]))
       else
        table.insert(tab,sp1[i])
      end
    end
    table.insert(tb,tab)
  end
  local x = #tb
  local num3 = 0
  local y
  local num1 = math.random(1,1000)/1000
  while x ~= 0 do
    num3 = num3 + tb[x][3]*s
    if num1 <= num3 then
      y = x
      break
     else
      x = x - 1
    end
  end
  if tr[num] == "会心伤害" or tr[num] == "会心免伤" or tr[num] == "最终伤害放大" or tr[num] == "最终伤害抵消" or string.find(tr[num],"基础") then
    return {tr[num],math.random(tb[y][1]*10,tb[y][2]*10)/10}
   else
    return {tr[num],math.random(tb[y][1],tb[y][2])}
  end
end

function Itnum(key)
  local num = 0
  for k,v in pairs(SaveTable.Item) do
    if v.key == key then
      num = num + v.number
    end
  end
  return num
end

function GetDrop()
  local tb = {}
  for k,v in pairs(Item) do
    if type(v) == "table" then
      if v.type >= 10 and v.type <= 13 then
        if tb[v["品质"]] == nil then
          tb[v["品质"]] = {}
        end
        table.insert(tb[v["品质"]],v)
      end
    end
  end
  return tb
end

function 删除物品(key,num)
  local tb = {}
  for k,v in pairs(SaveTable.Item) do
    if v.key == key then
      if v.number > num then
        v.number = v.number - num
        break
       elseif v.number == num then
        table.insert(tb,k)
        break
       else
        table.insert(tb,k)
        num = num - v.number
      end
    end
  end
  for i=1,#tb do
    table.remove(SaveTable.Item,tb[i]-i+1)
  end
end

function DeleteItem(key,num)
  local x = 1
  repeat
  if (SaveTable.Item[x].key == key) then
    if SaveTable.Item[x].number > num then
      SaveTable.Item[x].number = SaveTable.Item[x].number - num
     else
      table.remove(SaveTable.Item,x)
    end
    break
   else
    x = x + 1
  end
  until x > #SaveTable.Item
end

function gnum(key)
  local num1 = 0
  for n,m in pairs(SaveTable.Item) do
    if key == m.key then
      num1 = m.number
    end
  end
  return num1
end

--获得物品，key为物品名，num为获得物品的数量
function Item:Add(key,num,p,s)
  local x = 1
  repeat
  if self[x].key == key then
    if self[x].type > 5 then
      local tr = SaveTableClone({key=self[x].key,number=num})
      if tr then
        SaveTable.Item[tr].number = SaveTable.Item[tr].number + num
       else
        SaveTable.Item[#SaveTable.Item+1] = {key=self[x].key,number=num}
      end
     elseif self[x].type >= 0 then
      local tig = AddTriggers(self[x].type+1,self[x]["品质"],s)
      --local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中"}
      local eqtb = {key=self[x].key,number=num,level=0,["附加属性"]={tig}}
      for k,v in pairs(tab) do
        if self[x][v] ~= nil then
          if p == nil then
            eqtb[v] = math.random(0.2*100,2.4*100)/100
           else
            eqtb[v] = math.random(p[1],120)/50
          end
        end
      end
      SaveTable.Item[#SaveTable.Item+1] = eqtb
     else
      local eqtb = {key=self[x].key,number=num,level=0}
      local tba = {
        {key="成丹率",value=40},
        {key="出丹率",value=25},
        {key="神念消耗",value=25},
        {key="材料消耗",value=20},
        {key="获取经验",value=20},
      }
      local tba1 = {
        {key="成功率",value=50},
        {key="评分提升",value=30},
        {key="属性品质",value=30},
        {key="神念消耗",value=30},
        {key="材料消耗",value=25},
        {key="获取经验",value=25},
      }
      local tab = {"神念消耗","材料消耗","成丹率","成功率","出丹率","评分提升","属性品质","获取经验"}
      for k,v in pairs(tab) do
        if self[x][v] ~= nil then
          if p == nil then
            eqtb[v] = math.random((1-self[x].float)*100,(1+self[x].float)*100)/100
           else
            eqtb[v] = math.random(p[1],120)/50
          end
        end
      end
      local tbt = {2,2,2,3,3,3,5,5,5,7,7,7,10}
      local df = import "danfang"
      local tz = import "tuzhi"
      local function tzsz(p)
        local tb = {}
        for k,v in pairs(tz) do
          if p == v["品质"] then
            table.insert(tb,k)
          end
        end
        return tb
      end
      local function dfsz(p)
        local tb = {}
        for k,v in pairs(df) do
          if p == v["品质"] then
            table.insert(tb,k)
          end
        end
        return tb
      end
      local fjtb = {}
      for i=1,tbt[self[x]["品质"]] do
        if self[x].type == -1 then
          local tap = dfsz(self[x]["品质"])
          local cs = tap[math.random(1,#tap)]
          local cstb = tba[math.random(1,#tba)]
          local num = 1
          if s ~= nil then
            num = math.ceil((s - 1) * cstb.value/3/self[x]["品质"])
            if num > math.ceil(cstb.value * 0.6) then
              num = math.ceil(cstb.value * 0.6)
            end
          end
          table.insert(fjtb,{key=cs,value={cstb.key,math.random(num,cstb.value)}})
        end
        if self[x].type == -2 then
          local tap = tzsz(self[x]["品质"])
          local cs = tap[math.random(1,#tap)]
          local cstb = tba1[math.random(1,#tba1)]
          if s ~= nil then
            num = math.ceil((s - 1) * cstb.value/10/self[x]["品质"])
            if num > math.ceil(cstb.value * 0.6) then
              num = math.ceil(cstb.value * 0.6)
            end
          end
          table.insert(fjtb,{key=cs,value={cstb.key,math.random(num,cstb.value)}})
        end
      end
      eqtb["附加属性"] = fjtb
      SaveTable.Item[#SaveTable.Item+1] = eqtb
    end
    break
   else
    x = x + 1
  end
  until x > #self
  GetItemId()
end

function detable(tb,tab)
  local t = true
  if type(tab) == "table" then
    for k,v in pairs(tb) do
      if k ~= "number" and k~= "id" then
        if type(v) == "table" then
          if not detable(v,tab[k]) then
            t = false
            break
           elseif k == "附加属性" and #v ~= #tab[k] then
            t = false
          end
         elseif v ~= tab[k] then
          t = false
          break
        end
      end
    end
   else
    t = false
  end
  return t
end

local function GetEquipmentShow(ltb)
  local x = 1
  local tb
  local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中","神念消耗","材料消耗","成丹率","成功率","出丹率","评分提升","属性品质","获取经验"}
  repeat
  if ltb.key == Item[x].key then
    tb={type=Item[x].type,Info=Item[x].Info,["品质"]=Item[x]["品质"],price=Item[x].price,pet=Item[x].pet}
    for k,v in pairs(ltb) do
      tb[k] = v
    end
    for k,v in pairs(tab) do
      if Item[x][v] then
        tb[v] = math.ceil(Item[x][v] * tb[v])
      end
    end
    if Item[x]["资源参数"] then
      tb["资源参数"]=Item[x]["资源参数"]
    end
    break
   else
    x = x + 1
  end
  until x > #Item
  return tb
end


local function ItemShow()
  local t = {}
  local tp = type or {9,9}
  for k,v in pairs(SaveTable.Item) do
    t[k] = GetEquipmentShow(v)
    t[k]["附加属性"]=v["附加属性"]
  end
  return t
end

--判定背包内是否有相同的物品,返回的t为nil则没有，如果有相同的，则为存放物品的table的索引值
function SaveTableClone(tb)
  local x = 1
  local t
  local itb = ItemShow()
  if itb[x] ~= nil then
    repeat
    if (tb.key == itb[x].key) then
      t = detable(tb,itb[x])
      if t == true then
        t = x
        break
       else
        x = x + 1
      end
     else
      x = x + 1
    end
    until x > #SaveTable.Item
  end
  return t
end
--提取一个物品的type值
function Item:GetType(key)
  local x = 1
  local tp
  repeat
  if key == self[x].key then
    tp = self[x].type
    break
   else
    x = x + 1
  end
  until x > #self
  return tp
end

function Item:GetInfo(key)
  local x = 1
  local tp
  repeat
  if key == self[x].key then
    tp = self[x].Info
    break
   else
    x = x + 1
  end
  until x > #self
  return tp
end

function Item:GetTable(key)
  local x = 1
  local tp
  repeat
  if key == self[x].key then
    tp = self[x]
    break
   else
    x = x + 1
  end
  until x > #self
  return tp
end

function Item:GetLevel(key)
  local x = 1
  local tp
  repeat
  if key == self[x].key then
    tp = self[x]["品质"]
    break
   else
    x = x + 1
  end
  until x > #self
  return tp
end
