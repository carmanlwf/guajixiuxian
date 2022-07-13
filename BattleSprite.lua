require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "GetAttribute"
import "getskill"
import "petatt"
local Item = import "item"
local Role = import "role"
local battle = import "battle"
local skill = import "skill"
local ptskill = import "petskill"
local 境界 = import "tupo"
local ptjj = import "pettupo"

function skill:GetTable(key,lv)
  local x = 1
  local tb
  repeat
  if key == self[x].key then
    local ins = self[x].inpow * ((self[x].step + 1) ^ lv)
    local out = self[x].outpow * ((self[x].step + 1) ^ lv)
    local cost = math.ceil(self[x].cost * ((self[x].step + 1) ^ lv))
    tb={inpow=ins,["属性"]=self[x]["属性"],outpow=out,cost=cost,MaxCd=self[x].MaxCd,Cd=0,hit=self[x].hit,["品质"]=self[x]["品质"]}
    break
   else
    x = x + 1
  end
  until x > #self
  return tb
end

function ptskill:GetTable(key,lv)
  local tb
  local ins = self[key].inpow * ((self[key].step + 1) ^ lv)
  local out = self[key].outpow * ((self[key].step + 1) ^ lv)
  local cost = math.ceil(self[key].cost * ((self[key].step + 1) ^ lv))
  tb={inpow=ins,["属性"]=self[key]["属性"],outpow=out,cost=cost,MaxCd=self[key].MaxCd,Cd=0,hit=self[key].hit,["品质"]=self[key]["品质"]}
  return tb
end

function Role:GetTable(key,num)
  local role
  local x = 1
  repeat
  if key == self[x].ID then
    role = self[x]
    for k,v in pairs(role.skill) do
      if v.eq == 1 then
        role.skill[k]["战斗参数"] = skill:GetTable(v.key,v.level)
      end
    end
    break
   else
    x = x + 1
  end
  until x > #self
  return role
end

function GetSpriteTable(key)
  id = 0
  local num = math.random(1,#battle[key])
  local SpriteTable = {}
  local maxsp = 0
  for k,v in pairs(battle[key][num]) do
    local role = Role:GetTable(v.ID)
    for i=1,v.number do
      local _role = {}
      for k,v in pairs(role) do
        _role[k] = v
      end
      if _role.level < 17 then
        _role["真元"] = math.ceil(_role["真元"] * 1.5)
        _role["体质"] = math.ceil(_role["体质"] * 1.5)
        _role["身法"] = math.ceil(_role["身法"] * 1.5)
        _role["肉身"] = math.ceil(_role["肉身"] * 1.5)
       elseif _role.level > 28 then
        _role["真元"] = math.ceil(_role["真元"] * 1.3)
        _role["体质"] = math.ceil(_role["体质"] * 1.3)
        _role["身法"] = math.ceil(_role["身法"] * 1.3)
        _role["肉身"] = math.ceil(_role["肉身"] * 1.3)
       elseif _role.level > 20 then
        _role["真元"] = math.ceil(_role["真元"] * 2.5)
        _role["体质"] = math.ceil(_role["体质"] * 2.5)
        _role["身法"] = math.ceil(_role["身法"] * 2.5)
        _role["肉身"] = math.ceil(_role["肉身"] * 2.5)
       else
        _role["真元"] = math.ceil(_role["真元"] * 2)
        _role["体质"] = math.ceil(_role["体质"] * 2)
        _role["身法"] = math.ceil(_role["身法"] * 2)
        _role["肉身"] = math.ceil(_role["肉身"] * 2)
      end
      _role.hard = 境界[_role.level].hard
      _role.team = v.team
      _role.Attribute = Item:GetTirgger(_role)
      _role.Hp = _role.Attribute["气血上限"]
      _role.Mp = _role.Attribute["法力上限"]
      _role.NowSp = 500
      _role.Die = false
      _role.sp = (_role.Attribute["身法"]+_role.hard*2)*_role.hard/10
      maxsp = maxsp + _role.sp
      GetTalent(_role)
      table.insert(SpriteTable,_role)
    end
  end
  local owner = table.clone(SaveTable.owner)
  owner.team = 1
  owner.Attribute = Item:GetTirgger(owner)
  owner.Hp = owner.Attribute["气血上限"]
  owner.Mp = owner.Attribute["法力上限"]
  owner.NowSp = 500
  owner.hard = 境界[owner.level].hard
  if owner.buff ~= nil then
    if owner.buff["转生"] ~= nil then
      if owner.buff["转生"] > owner.level then
        owner.hard = owner.hard + 境界[owner.buff["转生"]].hard * 0.2
      end
      if owner.hard > 境界[owner.buff["转生"]].hard then
        owner.hard = 境界[owner.buff["转生"]].hard
      end
    end
  end
  owner.Die = false
  for k,v in pairs(owner.skill) do
    if v.eq == 1 then
      owner.skill[k]["战斗参数"] = skill:GetTable(v.key,v.level)
    end
  end
  owner.sp = (owner.Attribute["身法"]+owner.hard*2)*owner.hard/10
  GetTalent(owner)
  table.insert(SpriteTable,owner)
  maxsp = maxsp + owner.sp
  for k,v in pairs(SaveTable.pet) do
    if v.eq == 1 then
      local ptb = {}
      ptb.team = 1
      ptb.name = v.name
      ptb.key = ptb.name
      ptb.level = v.level
      ptb.key1 = v.key1
      ptb.buff = v.buff
      ptb.ph = v.bh
      ptb.pd = k
      ptb.skill = v.skill
      ptb.inskill = v.inskill
      ptb.Attribute = petat(v)
      ptb.Hp = ptb.Attribute["气血上限"]
      ptb.Mp = ptb.Attribute["法力上限"]
      ptb.NowSp = 500
      ptb.hard = ptjj[v.level].hard
      ptb.Die = false
      GetTalent(ptb)
      for n,m in pairs(v.skill) do
        if m.eq == 1 then
          ptb.skill[n]["战斗参数"] = ptskill:GetTable(m.key,m.level)
        end
      end
      ptb.sp = (ptb.Attribute["身法"]+ptb.hard*2)*ptb.hard/10
      table.insert(SpriteTable,ptb)
      maxsp = maxsp + owner.sp
    end
  end
  return SpriteTable
end