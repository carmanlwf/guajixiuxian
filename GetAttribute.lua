require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

local Item = import "item"
local skill = import "skill"
local inskill = import "inskill"


local function GetEquipmentShow(ltb)
  local x = 1
  local tb
  local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中"}
  repeat
  if ltb.key == Item[x].key then
    tb={type=Item[x].type,Info=Item[x].Info,["品质"]=Item[x]["品质"],price=Item[x].price,pet=Item[x].pet}
    for k,v in pairs(ltb) do
      tb[k] = v
    end
    for k,v in pairs(tab) do
      if Item[x][v] then
        if tb[v] == nil then
          tb[v] = 1
        end
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

function Item:GetPinzhi(key)
  local x = 1
  local p
  repeat
  if key == self[x].key then
    p = self[x]["品质"]
    break
   else
    x = x + 1
  end
  until x > #self
  return p
end

local function EquipmentShow(eq1)
  local tb = {}
  for k,v in pairs(eq1) do
    tb[#tb+1] = GetEquipmentShow(eq1)
  end
  return tb
end

function getjicu(role)
  local EqTable = EquipmentShow(role.eq)
  for k,v in pairs(role.eq) do
    if v.level == nil then
      v.level = 0
    end
  end
  local z = math.floor(role.eq[1].level/5)
  local djp
  for k,v in pairs(role.eq) do
    if k <= 6 then
      if djp == nil then
        djp = Item:GetPinzhi(v.key)
       elseif Item:GetPinzhi(v.key) < djp then
        djp = Item:GetPinzhi(v.key)
      end
      local fl = math.floor(v.level/5)
      if z > fl then
        z = fl
      end
    end
  end
  local stri
  if djp >= 13 then
    stri = "仙器"
    numi = math.ceil((10+10*z)*z/2)
   elseif djp >= 10 then
    stri = "天阶"
    numi = math.ceil((7+7*z)*z/2)
   elseif djp >= 7 then
    stri = "地阶"
    numi = math.ceil((5+5*z)*z/2)
   elseif djp >= 4 then
    stri = "玄阶"
    numi = math.ceil((3+3*z)*z/2)
   else
    stri = "黄阶"
    numi = math.ceil((2+2*z)*z/2)
  end
  return numi
end
--获得人物学习的技能对角色的属性提升
function skill:GetTirgger(role,tb)
  local t = {}
  for k,v in pairs(role.skill) do
    t[#t+1]={key=v.key,level=v.level}
  end
  if #t > 0 then
    for i=1,#self do
      local x = 1
      repeat
      if t[x].key == self[i].key then
        for k,v in pairs(tb) do
          if self[i][k] then
            tb[k] = tb[k] + math.ceil(self[i][k] * ((self[i].step+1)^t[x].level))
          end
        end
        if self[i].updata then
          for k,v in pairs(self[i].updata) do
            if t[x].level >= v.level then
              for n,m in pairs(v.Attribute) do
                tb[n] = tb[n] + m
              end
            end
          end
        end
        break
       else
        x = x + 1
      end
      until x > #t
    end
  end
  return tb
end
--获得人物学习的心法对角色的属性提升
function inskill:GetTirgger(role,tb)
  local t = {}
  for k,v in pairs(role.inskill) do
    t[#t+1]={key=v.key,level=v.level}
  end
  if #t > 0 then
    for i=1,#self do
      local x = 1
      repeat
      if t[x].key == self[i].key then
        for k,v in pairs(tb) do
          if self[i][k] then
            tb[k] = tb[k] + math.ceil(self[i][k] * ((self[i].step+1)^t[x].level))
          end
        end
        if self[i].updata then
          for k,v in pairs(self[i].updata) do
            if t[x].level >= v.level then
              for n,m in pairs(v.Attribute) do
                tb[n] = tb[n] + m
              end
            end
          end
        end
        break
       else
        x = x + 1
      end
      until x > #t
    end
  end
  return tb
end
--获得人物装备的物品对角色的属性提升
function Item:GetTirgger(role)
  local t = {}
  local tb = {["体质"]=role["体质"],["真元"]=role["真元"],["身法"]=role["身法"],["肉身"]=role["肉身"],["外攻"]=0,["内攻"]=0,["气血上限"]=0,["法力上限"]=0,["外防"]=0,["内防"]=0,["会心率"]=0,["抗会心率"]=0,["会心伤害"]=20,["会心免伤"]=0,["闪避"]=0,["命中"]=0,["最终伤害放大"]=0,["最终伤害抵消"]=0,["基础生命"]=0,["基础法力"]=0,["基础攻击"]=0,["基础防御"]=0,["基础会心"]=0,["基础闪避"]=0,["基础命中"]=0}
  for k,v in pairs(role.eq) do
    t[#t+1]={key=v.key,["附加属性"]=v["附加属性"]}
  end
  if #t ~= 0 then
    for i=1,#self do
      local x = 1
      repeat
      if t[x].key == self[i].key then
        for k,v in pairs(tb) do
          if self[i][k] then
            if role.eq[x].level == nil or role.eq[x][k] == nil then
              role.eq[x].level = 0
              role.eq[x][k] = 1
            end
            tb[k] = tb[k] + math.ceil(self[i][k] *role.eq[x][k]*(1.1^role.eq[x].level))
          end
        end
        if t[x]["附加属性"] then
          for k,v in pairs(t[x]["附加属性"]) do
            tb[v[1]] = tb[v[1]] + math.ceil(v[2] *(1.1^role.eq[x].level))
          end
        end
        break
       else
        x = x + 1
      end
      until x > #t
    end
  end
  tb = skill:GetTirgger(role,tb)
  tb = inskill:GetTirgger(role,tb)
  --计算四维属性对其他属性的影响
  if #role.eq >= 6 then
    local numi = getjicu(role)
    if numi ~= 0 then
      tb["基础生命"]=tb["基础生命"]+numi
      tb["基础法力"]=tb["基础法力"]+numi
      tb["基础攻击"]=tb["基础攻击"]+numi
      tb["基础防御"]=tb["基础防御"]+numi
      tb["基础命中"]=tb["基础命中"]+numi
      tb["基础闪避"]=tb["基础闪避"]+numi
      tb["基础会心"]=tb["基础会心"]+numi
    end
  end
  tb["气血上限"]=tb["气血上限"]+math.ceil((tb["体质"]*50+tb["真元"]*16+tb["肉身"]*16)*(1+tb["基础生命"]*0.01))
  tb["法力上限"]=tb["法力上限"]+math.ceil((tb["真元"]*40)*(1+tb["基础法力"]*0.01))
  tb["内攻"]=tb["内攻"]+math.ceil((tb["真元"]*8)*(1+tb["基础攻击"]*0.01))
  tb["外攻"]=tb["外攻"]+math.ceil((tb["肉身"]*4.5+tb["体质"]*4+tb["身法"]*0.8)*(1+tb["基础攻击"]*0.01))
  tb["内防"]=tb["内防"]+math.ceil((tb["真元"]*2.4+tb["肉身"]*3.2+tb["体质"]*2.4)*(1+tb["基础防御"]*0.01))
  tb["外防"]=tb["外防"]+math.ceil((tb["真元"]*0.8+tb["肉身"]*4+tb["体质"]*3.2)*(1+tb["基础防御"]*0.01))
  tb["会心率"]=tb["会心率"]+math.ceil((tb["真元"]*0.8+tb["身法"]*4)*(1+tb["基础会心"]*0.01))
  tb["抗会心率"]=tb["抗会心率"]+math.ceil((tb["体质"]*2.4+tb["肉身"]*2.4))
  tb["闪避"]=tb["闪避"]+math.ceil((tb["身法"]*4)*(1+tb["基础闪避"]*0.01))
  tb["会心伤害"]=tb["会心伤害"]+(math.ceil(tb["真元"]*0.16+tb["身法"]*0.24+tb["肉身"]*0.08+50))
  tb["命中"]=tb["命中"]+math.ceil((tb["身法"]*2.4+tb["真元"]*1.6)*(1+tb["基础命中"]*0.01))
  tb["会心免伤"]=tb["会心免伤"]+(math.ceil(tb["体质"]*0.12+tb["肉身"]*0.24+50))
  tb["最终伤害放大"]=tb["最终伤害放大"]+(math.ceil(tb["真元"]*0.16+tb["身法"]*0.24))
  tb["最终伤害抵消"]=tb["最终伤害抵消"]+(math.ceil(tb["肉身"]*0.24+tb["体质"]*0.2))
  return tb
end