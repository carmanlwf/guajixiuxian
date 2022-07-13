require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

local tp = import "pettupo"
local tupo = import "tupo"
local exp = import "skillexp"
local inskill = import "petinskill"
local pskill = import "petskill"
local quanju = import "quanju"
local ky = import "keyao"

local Color = {hui="#C6C6C6",black="#000000",white="#FFFFFF",green="#008000",blue="#0000FF",red="#FF0000",orange="#FFA500",cyan="#00FFFF",gold="#FFD700"}
function Color:Get(str,lv)
  if lv >= 13 then
    str={"<font color=",self.gold,">",str,"</font>"}
   elseif lv >= 10 then
    str={"<font color=",self.orange,">",str,"</font>"}
   elseif lv >= 7 then
    str={"<font color=",self.red,">",str,"</font>"}
   elseif lv >= 4 then
    str={"<font color=",self.blue,">",str,"</font>"}
   else
    str={"<font color=",self.green,">",str,"</font>"}
  end
  return table.concat(str)
end

function addpetxw(adxw,num,zz)
  local tb = SaveTable.pet
  tb[num]["修为"] = tb[num]["修为"] + adxw
  if (tb[num]["修为"] >= tp[tb[num].level].cost and tp[tb[num].level].hard < tupo[SaveTable.owner.level].hard) then
    tb[num]["修为"] = tb[num]["修为"] - tp[tb[num].level].cost
    tb[num].level = tb[num].level + 1
  end
  for i=1,#tb[num].inskill do
    local pz = inskill[tb[num].inskill[i].key]["品质"]
    tb[num].inskill[i].exp = tb[num].inskill[i].exp + adxw
    if type(exp[pz][tb[num].inskill[i].level]) == "number" then
      if tb[num].inskill[i].exp >= exp[pz][tb[num].inskill[i].level] then
        tb[num].inskill[i].level = tb[num].inskill[i].level + 1
        tb[num].inskill[i].exp = 0
      end
    end
  end
end

function shuaxin()
  local x,y = dxup(SaveTable.owner.level)
  if probability(1/x) then
    SaveTable.owner["道心"] = SaveTable.owner["道心"] + y
    提示("修炼之余，感悟天道，道心提升"..y.."点！")
  end
  if SaveTable["刷新"] == nil then
    SaveTable["刷新"] = {}
  end
  for k,v in pairs(SaveTable["刷新"]) do
    v.number[1] = v.number[1] + 1
    if v.number[1] >= v.number[2] then
      MD提示(v.key.."已刷新！")
      SaveTable["刷新"][k] = nil
    end
  end
end

function ptm(tb)
  local function cssld(lv)
    if lv > 24 then
      x = 12
     elseif lv > 20 then
      x = 10
     elseif lv > 16 then
      x = 8
     elseif lv > 12 then
      x = 4
     elseif lv > 8 then
      x = 2
     elseif lv > 4 then
      x = 1
     else
      x = 0.5
    end
    return x
  end
  local function sld(lv)
    if lv > 32 then
      x = 12
     elseif lv > 28 then
      x = 10
     elseif lv > 24 then
      x = 8
     elseif lv > 20 then
      x = 4
     elseif lv > 16 then
      x = 2
     elseif lv > 12 then
      x = 1
     else
      x = 0.5
    end
    return x
  end
  local rcs = sld(SaveTable.owner.level)
  for k,v in pairs(SaveTable.owner.skill) do
    local pz = skillgetpz(v.key)
    local num1 = exp[pz][v.level]
    v.exp = v.exp + rcs
    if type(num1) == "number" and v.exp >= num1 then
      v.exp = v.exp - num1
      v.level = v.level + 1
      提示(Html.fromHtml("你的"..Color:Get(v.key,pz).."已修炼至第"..math.ceil(v.level).."重!"))
    end
  end
  tb = SaveTable.pet
  if SaveTable.owner["buff"] ~= nil then
    if SaveTable.owner["buff"]["转生"] ~= nil then
      SaveTable.owner["buff"]["转生"] = nil
    end
  end
  if SaveTable.owner["身法"] > 99999 then
    SaveTable.owner["身法"] = SaveTable.owner["身法"] - 99999
  end
  for k,v in pairs(quanju) do
    if StoryCondition(v.condition) then
      if SaveTable.finish_story == nil then
        SaveTable.finish_story = {}
      end
      if v.round ~= -1 then
        if SaveTable.finish_story[k] == nil or SaveTable.finish_story[k] < v.round then
          文字动画(k,1)
        end
       else
        文字动画(k,1)
      end
    end
  end
  for k,v in pairs(SaveTable.owner.buff) do
    if type(v) == "table" then
      if v.time[1] <= os.time() then
        SaveTable.owner.buff[k] = nil
       elseif v.time[1] > os.time() + v.time[2]
        v.time[1] = os.time() + v.time[2]
      end
    end
  end
  if SaveTable.owner.buff["回复"] == nil and SaveTable.set["嗑药"]["回复"] ~= nil then
    local ltb = ky["回复"][SaveTable.set["嗑药"]["回复"]]
    if Itnum(SaveTable.set["嗑药"]["回复"]) > 0 then
      SaveTable.owner.buff["回复"] = {number={Hp={ltb.value,ltb.number[1]},Mp={ltb.value,ltb.number[2]}},time={os.time()+ltb.time,ltb.time}}
      删除物品(SaveTable.set["嗑药"]["回复"],1)
      提示(Html.fromHtml("已自动为"..Color:Get(SaveTable.owner.key,1).."自动使用了一颗"..Color:Get(SaveTable.set["嗑药"]["回复"],ltb.level)))
     else
      提示(Html.fromHtml(Color:Get(SaveTable.set["嗑药"]["回复"],ltb.level).."数量不足"))
      SaveTable.set["嗑药"]["回复"] = nil
    end
  end
  if SaveTable.owner.buff["增伤"] == nil and SaveTable.set["嗑药"]["增伤"] ~= nil then
    local ltb = ky["增伤"][SaveTable.set["嗑药"]["增伤"]]
    if Itnum(SaveTable.set["嗑药"]["增伤"]) > 0 then
      SaveTable.owner.buff["增伤"] = {number={ltb.value,ltb.number},time={os.time()+ltb.time,ltb.time}}
      删除物品(SaveTable.set["嗑药"]["增伤"],1)
      提示(Html.fromHtml("已自动为"..Color:Get(SaveTable.owner.key,1).."自动使用了一颗"..Color:Get(SaveTable.set["嗑药"]["增伤"],ltb.level)))
     else
      提示(Html.fromHtml(Color:Get(SaveTable.set["嗑药"]["增伤"],ltb.level).."数量不足"))
      SaveTable.set["嗑药"]["增伤"] = nil
    end
  end
  if SaveTable.owner.buff["减伤"] == nil and SaveTable.set["嗑药"]["减伤"] ~= nil then
    local ltb = ky["减伤"][SaveTable.set["嗑药"]["减伤"]]
    if Itnum(SaveTable.set["嗑药"]["减伤"]) > 0 then
      SaveTable.owner.buff["减伤"] = {number={ltb.value,ltb.number},time={os.time()+ltb.time,ltb.time}}
      删除物品(SaveTable.set["嗑药"]["减伤"],1)
      提示(Html.fromHtml("已自动为"..Color:Get(SaveTable.owner.key,1).."自动使用了一颗"..Color:Get(SaveTable.set["嗑药"]["减伤"],ltb.level)))
     else
      提示(Html.fromHtml(Color:Get(SaveTable.set["嗑药"]["减伤"],ltb.level).."数量不足"))
      SaveTable.set["嗑药"]["减伤"] = nil
    end
  end
  if SaveTable.sntime == nil then
    SaveTable.sntime = 0
   else
    SaveTable.sntime = SaveTable.sntime + 1
    if SaveTable.sntime > 300 then
      local num = SaveTable.owner["神念上限"]/100
      SaveTable.owner["神念"] = SaveTable.owner["神念"] + num
      if SaveTable.owner["神念"] > SaveTable.owner["神念上限"] then
        SaveTable.owner["神念"] = SaveTable.owner["神念上限"]
      end
      SaveTable.sntime = 0
    end
  end
  if type(tb)=="table" then
    function xwxl(tb,zz)
      local x
      if tb.level > 24 then
        x = 10
       elseif tb.level > 20 then
        x = 8
       elseif tb.level > 16 then
        x = 5
       elseif tb.level > 12 then
        x = 3
       elseif tb.level > 8 then
        x = 2
       elseif tb.level > 4 then
        x = 1
       else
        x = 0.5
      end
      local y = 1
      for i=1,#tb.inskill do
        local v = tb.inskill[i]
        if type(v) == "table" then
          y = y + (inskill[v.key]["修炼效率"]/100) * ((1 + inskill[v.key].step) ^ v.level)
        end
      end
      x = x * y * zz
      return x
    end
    for num=1,#tb do
      for k,v in pairs(SaveTable.pet[num].buff) do
        if v.time[1] <= os.time() then
          SaveTable.pet[num].buff[k] = nil
         elseif v.time[1] > os.time() + v.time[2]
          v.time[1] = os.time() + v.time[2]
        end
      end
      if SaveTable.pet[num].buff["回复"] == nil and SaveTable.set["嗑药"]["回复"] ~= nil and 应用方式(SaveTable.pet[num].name) == true and SaveTable.pet[num].eq == 1 then
        local ltb = ky["回复"][SaveTable.set["嗑药"]["回复"]]
        if Itnum(SaveTable.set["嗑药"]["回复"]) > 0 then
          SaveTable.pet[num].buff["回复"] = {number={Hp={ltb.value,ltb.number[1]},Mp={ltb.value,ltb.number[2]}},time={os.time()+ltb.time,ltb.time}}
          删除物品(SaveTable.set["嗑药"]["回复"],1)
          提示(Html.fromHtml("已自动为"..获取颜色(SaveTable.pet[num],SaveTable.pet[num].name).."使用了一颗"..Color:Get(SaveTable.set["嗑药"]["回复"],ltb.level)))
         else
          提示(Html.fromHtml(Color:Get(SaveTable.set["嗑药"]["回复"],ltb.level).."数量不足"))
          SaveTable.set["嗑药"]["回复"] = nil
        end
      end
      if SaveTable.pet[num].buff["增伤"] == nil and SaveTable.set["嗑药"]["增伤"] ~= nil and 应用方式(SaveTable.pet[num].name) == true and SaveTable.pet[num].eq == 1 then
        local ltb = ky["增伤"][SaveTable.set["嗑药"]["增伤"]]
        if Itnum(SaveTable.set["嗑药"]["增伤"]) > 0 then
          SaveTable.pet[num].buff["增伤"] = {number={ltb.value,ltb.number},time={os.time()+ltb.time,ltb.time}}
          删除物品(SaveTable.set["嗑药"]["增伤"],1)
          提示(Html.fromHtml("已自动为"..获取颜色(SaveTable.pet[num],SaveTable.pet[num].name).."使用了一颗"..Color:Get(SaveTable.set["嗑药"]["增伤"],ltb.level)))
         else
          提示(Html.fromHtml(Color:Get(SaveTable.set["嗑药"]["增伤"],ltb.level).."数量不足"))
          SaveTable.set["嗑药"]["增伤"] = nil
        end
      end
      if SaveTable.pet[num].buff["减伤"] == nil and SaveTable.set["嗑药"]["减伤"] ~= nil and 应用方式(SaveTable.pet[num].name) == true and SaveTable.pet[num].eq == 1 then
        local ltb = ky["减伤"][SaveTable.set["嗑药"]["减伤"]]
        if Itnum(SaveTable.set["嗑药"]["减伤"]) > 0 then
          SaveTable.pet[num].buff["减伤"] = {number={ltb.value,ltb.number},time={os.time()+ltb.time,ltb.time}}
          删除物品(SaveTable.set["嗑药"]["减伤"],1)
          提示(Html.fromHtml("已自动为"..获取颜色(SaveTable.pet[num],SaveTable.pet[num].name).."使用了一颗"..Color:Get(SaveTable.set["嗑药"]["减伤"],ltb.level)))
         else
          提示(Html.fromHtml(Color:Get(SaveTable.set["嗑药"]["减伤"],ltb.level).."数量不足"))
          SaveTable.set["嗑药"]["减伤"] = nil
        end
      end
      local zz = (tb[num]["四维"][1] + tb[num]["四维"][2] + tb[num]["四维"][3] + tb[num]["四维"][4])/2000
      local adxw = xwxl(tb[num],zz)
      addpetxw(adxw,num,zz)
      local cts = cssld(tb[num].level)
      for k,v in pairs(SaveTable.pet[num].skill) do
        local num1 = exp[pskill[v.key]["品质"]][v.level]
        v.exp = v.exp + cts
        if type(num1) == "number" and v.exp >= num1 then
          v.exp = v.exp - num1
          v.level = v.level + 1
          提示(Html.fromHtml(获取颜色(tb,tb.name).."的"..Color:Get(v.key,pskill[v.key]["品质"]).."已修炼至第"..math.ceil(v.level).."重!"))
        end
      end
    end
  end
  if 道号 ~= nil then
    更新面板()
  end
  if SaveTable.shipei == nil then
    适配()
    loadsavewrite()
    saveloadfile("主界面")
  end
  if SaveTable.owner["道心"] == nil then
    SaveTable.owner["道心"] = 0
  end
end
function pettime(tb)
  call("ptm",tb)
end