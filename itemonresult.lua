require "import"
import "android.text.Html"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "GetItem"
import "pet"
import "commonHelper"
local exp = import "skillexp"
local ptsk = import "petskill"
local ptinsk = import "petinskill"

local Color = {hui="#C6C6C6",black="#000000",white="#FFFFFF",green="#008000",blue="#0000FF",red="#FF0000",orange="#FFA500",gold="#FFD700"}
local Item = import "item"
local 境界 = import "tupo"

function Color:Set(str,lv)
  if lv >= 13 then
    str="<font color="..self.gold..">"..str.."</font>"
   elseif lv >= 10 then
    str="<font color="..self.orange..">"..str.."</font>"
   elseif lv >= 7 then
    str="<font color="..self.red..">"..str.."</font>"
   elseif lv >= 4 then
    str="<font color="..self.blue..">"..str.."</font>"
   else
    str="<font color="..self.green..">"..str.."</font>"
  end
  return Html.fromHtml(str)
end

function Color:Get(str,lv)
  if lv >= 13 then
    str="<font color="..self.gold..">"..str.."</font>"
   elseif lv >= 10 then
    str="<font color="..self.orange..">"..str.."</font>"
   elseif lv >= 7 then
    str="<font color="..self.red..">"..str.."</font>"
   elseif lv >= 4 then
    str="<font color="..self.blue..">"..str.."</font>"
   else
    str="<font color="..self.green..">"..str.."</font>"
  end
  return str
end

function 预览法术(tb)
  local 品阶 = {"黄阶初级","黄阶中级","黄阶高级","玄阶初级","玄阶中级","玄阶高级","地阶初级","地阶中级","地阶高级","天阶初级","天阶中级","天阶高级","仙术"}
  local h = AlertDialog.Builder(this).show()
  h.getWindow().setContentView(loadlayout(MapUI()["宠兽法术面板"]));
  --local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中"}
  宠兽法术名称.Text=Color:Set(tb.key.."["..品阶[tb["品质"]].."]",tb["品质"])
  宠兽法术消耗.Text=Color:Set("法力消耗:"..math.ceil(tb.cost * ((tb.step + 1) ^ tb.level)),tb["品质"])
  if tb.level >= 10 then
    宠兽法术特效.removeViews(3,1)
   else
    宠兽法术熟练.Text=Color:Set("当前熟练度:"..math.ceil(tb.exp).."/"..exp[tb["品质"]][tb.level],tb["品质"])
  end
  local ostr = ""
  local num = 0
  for k,v in pairs(tb["属性"]) do
    num = num + 1
    if num > 1 then
      ostr=ostr.."、"..k
     else
      ostr=ostr..k
    end
  end
  宠兽法术灵根.text = "属性:"..ostr
  宠兽属性详情.onClick=function
    local m = {
      LinearLayout;
      orientation="vertical";
      layout_width="fill";
      layout_height="fill";
      {
        FrameLayout;
        layout_width="match_parent";
        backgroundColor="#000000";
        layout_height="4%h";
        {
          TextView;
          textSize="15sp";
          text="属性详情";
          textColor="#FFFFFF";
          layout_gravity="center";
        };
      };
      {
        TextView;
        id="灵根属性";
      };
    };
    local function yansea(str,ys)
      str="<font color="..ys..">"..str.."</font>"
      return str
    end
    local str = ""
    local tap = {["金"]="#ffff00",["木"]="#006400",["水"]="#1e90ff",["火"]="#ff0000",["土"]="#b8860b",["风"]="#00ffff",["雷"]="#4b0082"}
    for k,v in pairs(tb["属性"]) do
      str=str..k..":"..yansea(v*100,tap[k]).."%(带有"..yansea(k,tap[k]).."属性的宠兽对法术伤害的增幅强度)<br>"
    end
    local xq=AlertDialog.Builder(activity)
    .setView(loadlayout(m)).show()
    灵根属性.Text=Html.fromHtml(str)
  end
  宠兽法术等级.Text=Color:Set("当前已修炼至第"..math.ceil(tb.level).."重",tb["品质"])
  宠兽法术介绍.Text=tb.info.."\n"
  宠兽法术参数.Text="外攻伤害:"..tb.outpow*((1+tb.step)^tb.level)*100 .."%  \t内攻伤害:"..tb.inpow*((1+tb.step)^tb.level)*100 .."%\n攻击范围:"..tb.hit.."\t  冷却回合:"..tb.MaxCd
  local str = "法术属性:\n"
  for k,v in pairs(tab) do
    if tb[v] then
      if v == "会心伤害" or v == "会心免伤" or v == "最终伤害放大" or v == "最终伤害抵消" or string.find(v,"基础") then
        str=str.."提升"..v..math.ceil(tb[v]*((1+tb.step)^tb.level)*10)/10 .."%\n"
       else
        str=str.."提升"..v..math.ceil(tb[v]*((1+tb.step)^tb.level)).."点\n"
      end
    end
  end
  宠兽法术属性.Text = str
  local uibox = {}
  for k,v in pairs(tb.data) do
    table.insert(uibox,{v[1],v[2],k})
  end
  table.sort(uibox,function(x,y)
    return x[2] < y[2]
  end)
  for k,v in pairs(uibox) do
    local file = "法术修炼至"..math.ceil(v[2]).."重"
    if v[3] == "增伤" or v[3] == "免伤" or v[3] == "物穿" or v[3] == "法穿" or v[3] == "反伤" or string.find(v[3],"基础") then
      file=file..",提升"..v[3]..v[1].."%"
     else
      file=file..",提升"..v[3]..v[1].."点"
    end
    if tb.level >= v[2] then
      file=file.."[已达成]"
      local lt = {
        TextView;
        textSize=getsize(10);
        text=file;
        textColor="#000000";
      };
      宠兽法术特效.addView(loadlayout(lt))
     else
      file=file.."[未达成]"
      local lt = {
        TextView;
        textSize=getsize(10);
        text=file;
        textColor="#C6C6C6";
      };
      宠兽法术特效.addView(loadlayout(lt))
    end
  end
end

local function 预览功法(tb1)
  local 品阶 = {"黄阶初级","黄阶中级","黄阶高级","玄阶初级","玄阶中级","玄阶高级","地阶初级","地阶中级","地阶高级","天阶初级","天阶中级","天阶高级","仙经"}
  local h = AlertDialog.Builder(this).show()
  h.getWindow().setContentView(loadlayout(MapUI()["宠兽功法面板"]));
  宠兽功法名称.Text=Color:Set(tb1.key.."["..品阶[tb1["品质"]].."]",tb1["品质"])
  宠兽修炼效率.Text=Color:Set("修炼效率:"..math.ceil(tb1["修炼效率"]*((1+tb1.step)^tb1.level)) .."%",tb1["品质"])
  if tb1.level >= 10 then
    宠兽功法特效.removeViews(2,1)
   else
    宠兽功法熟练.Text=Color:Set("当前熟练度:"..math.ceil(tb1.exp).."/"..exp[tb1["品质"]][tb1.level],tb1["品质"])
  end
  宠兽功法等级.Text=Color:Set("当前已修炼至第"..math.ceil(tb1.level).."重",tb1["品质"])
  宠兽功法介绍.Text=tb1.info.."\n"
  --local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中"}
  local str = "功法属性:\n"
  for k,v in pairs(tab) do
    if tb1.Attribute[v] then
      if v == "会心伤害" or v == "会心免伤" or v == "最终伤害放大" or v == "最终伤害抵消" or string.find(v,"基础") then
        str=str.."提升"..v..math.ceil(tb1.Attribute[v]*((1+tb1.step)^tb1.level)*10)/10 .."%\n"
       elseif v=="气血上限" then
        str=str.."提升气血上限"..math.ceil(tb1.Attribute[v]*((1+tb1.step)^tb1.level)).."点\n"
       elseif v=="法力上限" then
        str=str.."提升法力上限"..math.ceil(tb1.Attribute[v]*((1+tb1.step)^tb1.level)).."点\n"
       else
        str=str.."提升"..v..math.ceil(tb1.Attribute[v]*((1+tb1.step)^tb1.level)).."点\n"
      end
    end
  end
  宠兽功法属性.Text = str
  local uibox = {}
  for k,v in pairs(tb1.data) do
    table.insert(uibox,{v[1],v[2],k})
  end
  table.sort(uibox,function(x,y)
    return x[2] < y[2]
  end)
  for k,v in pairs(uibox) do
    local file = "功法修炼至"..math.ceil(v[2]).."重"
    if v[3] == "增伤" or v[3] == "免伤" or v[3] == "物穿" or v[3] == "法穿" or v[3] == "反伤" or string.find(v[3],"基础") then
      file=file..",提升"..v[3]..v[1].."%"
     else
      file=file..",提升"..v[3]..v[1].."点"
    end
    if tb1.level >= v[2] then
      file=file.."[已达成]"
      local lt = {
        TextView;
        textSize=getsize(10);
        text=file;
        textColor="#000000";
      };
      宠兽功法特效.addView(loadlayout(lt))
     else
      file=file.."[未达成]"
      local lt = {
        TextView;
        textSize=getsize(10);
        text=file;
        textColor="#C6C6C6";
      };
      宠兽功法特效.addView(loadlayout(lt))
    end
  end
end

function GetGiftTable(a,b,c)
  local tb = {}
  for i=1,#Item do
    if(Item[i]["品质"] == a and Item[i].type >= b and Item[i].type <= c) then
      if not (string.find(Item[i].key,"丹") or string.find(Item[i].key,"礼盒") or string.find(Item[i].key,"宠兽")) then
        table.insert(tb,Item[i].key)
       elseif string.find(Item[i].key,"丹方") then
        table.insert(tb,Item[i].key)
      end
    end
  end
  return tb
end

function DeleteItemTable(this,num)
  local x = 1
  repeat
  if (SaveTable.Item[x].key == this.key and SaveTable.Item[x].float == this.float) then
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

function Item:GetTirggers(key)
  local x = 1
  local tb = {}
  repeat
  if key == self[x].key then
    if self[x].contidion then
      tb.condition=self[x].contidion
    end
    if self[x]["资源参数"] then
      tb["资源参数"]=self[x]["资源参数"]
    end
    break
   else
    x = x + 1
  end
  until x > #self
  return tb
end

function HasInskill(key)
  local x = 1
  local br = false
  if #SaveTable.owner.inskill ~= 0 then
    repeat
    if SaveTable.owner.inskill[x].key == key then
      br = true
      break
     else
      x = x + 1
    end
    until x > #SaveTable.owner.inskill
  end
  return br
end

function GetCondition(condition)
  local x = 1
  local br = true
  local str
  repeat
  local k,v = ConditionList(condition[x].key,condition[x].value)
  if not k then
    br = false
    str = v
    break
   else
    x = x + 1
  end
  until x > #condition
  return br,str
end

function HasSkill(key)
  local x = 1
  local br = false
  if #SaveTable.owner.skill ~= 0 then
    repeat
    if SaveTable.owner.skill[x].key == key then
      br = true
      break
     else
      x = x + 1
    end
    until x > #SaveTable.owner.skill
  end
  return br
end

function learndanfang(key)
  local br = true
  for k,v in pairs(SaveTable["炼丹"].learn) do
    if v.key == key then
      br = false
      break
    end
  end
  return br
end

function learnlqfang(key)
  local br = true
  for k,v in pairs(SaveTable["炼器"].learn) do
    if v.key == key then
      br = false
      break
    end
  end
  return br
end

function Item:tocontidion(this,menu)
  local atr = self:GetTirggers(this.key)
  if atr.condition then
    local br,str = GetCondition(atr.condition)
    if br then
      self:onResult(this,menu,atr)
     elseif str then
      menu.dismiss()
      MD提示(str)
    end
   else
    self:onResult(this,menu,atr)
  end
end

function ConditionList(key,value)
  local str
  if key == "level_more_then" then
    str = "境界达到"..境界[value]["境界"].."才能使用!"
    return SaveTable.owner.level >= value,str
  end
  if key == "level_less_then" then
    str = "境界低于"..境界[value]["境界"].."才能使用!"
    return SaveTable.owner.level < value,str
  end
  if key == "level_must" then
    str = "境界位于"..境界[value]["境界"].."的修士才能炼化药力!"
    return SaveTable.owner.level == value,str
  end
  if key == "use_number" then
    if SaveTable.owner.use[value[1]] == nil then
      SaveTable.owner.use[value[1]] = 0
    end
    str = "最多只能使用"..value[2].."个!"
    return SaveTable.owner.use[value[1]] < value[2],str
  end
end

function Item:onResult(this,menu,atr)
  if atr then
    if this.type == -1 then
      if SaveTable["炼丹"].eq.key == nil then
        local idx = SaveTableClone(this)
        local itb = table.clone(SaveTable.Item[idx])
        SaveTable["炼丹"].eq = itb
        table.remove(SaveTable.Item,idx)
        MD提示("丹炉装备成功!")
        SetUI()
        GetItemId()
        menu.dismiss()
       else
        local idx = SaveTableClone(this)
        local itb = table.clone(SaveTable.Item[idx])
        local itb1 = table.clone(SaveTable["炼丹"].eq)
        SaveTable["炼丹"].eq = itb
        table.remove(SaveTable.Item,idx)
        table.insert(SaveTable.Item,itb1)
        MD提示("丹炉更换成功!")
        SetUI()
        GetItemId()
        menu.dismiss()
      end
     elseif this.type == -2 then
      if SaveTable["炼器"].eq.key == nil then
        local idx = SaveTableClone(this)
        local itb = table.clone(SaveTable.Item[idx])
        SaveTable["炼器"].eq = itb
        table.remove(SaveTable.Item,idx)
        MD提示("器鼎装备成功!")
        SetUI()
        GetItemId()
        menu.dismiss()
       else
        local idx = SaveTableClone(this)
        local itb = table.clone(SaveTable.Item[idx])
        local itb1 = table.clone(SaveTable["炼器"].eq)
        SaveTable["炼器"].eq = itb
        table.remove(SaveTable.Item,idx)
        table.insert(SaveTable.Item,itb1)
        MD提示("器鼎更换成功!")
        SetUI()
        GetItemId()
        menu.dismiss()
      end
    end
    if this.type == 7 then
      if atr["资源参数"]["法术"] then
        if HasSkill(atr["资源参数"]["法术"]) then
          menu.dismiss()
          MD提示(Html.fromHtml("已经学习过"..Color:Get(atr["资源参数"]["法术"],this["品质"]).."，无法重复学习!"))
         elseif #SaveTable.owner.skill >= 15 then
          MD提示("最多只能学习15本法术")
         else
          table.insert(SaveTable.owner.skill,{key=atr["资源参数"]["法术"],exp=0,eq=1,level=1})
          DeleteItemTable(this,1)
          MD提示(Html.fromHtml("你学会了法术"..Color:Get(atr["资源参数"]["法术"],this["品质"])))
          SetUI()
          menu.dismiss()
        end
      end
      if atr["资源参数"]["功法"] then
        if HasInskill(atr["资源参数"]["功法"]) then
          MD提示(Html.fromHtml("已经学习过"..Color:Get(atr["资源参数"]["功法"],this["品质"]).."，无法重复学习!"))
         elseif #SaveTable.owner.inskill >= 9 then
          MD提示("最多只能学习9本功法")
         else
          table.insert(SaveTable.owner.inskill,{key=atr["资源参数"]["功法"],exp=0,level=1})
          MD提示(Html.fromHtml("你学会了功法"..Color:Get(atr["资源参数"]["功法"],this["品质"])))
          DeleteItemTable(this,1)
          SetUI()
        end
      end
      if atr["资源参数"]["丹方"] then
        if learndanfang(atr["资源参数"]["丹方"]) then
          table.insert(SaveTable["炼丹"].learn,{key=atr["资源参数"]["丹方"],exp=0,level=1})
          MD提示(Html.fromHtml("你学会了"..Color:Get(atr["资源参数"]["丹方"],this["品质"]).."的炼制法门"))
          DeleteItemTable(this,1)
          SetUI()
         else
          MD提示(Html.fromHtml(table.concat({"已经学习过"..Color:Get(atr["资源参数"]["丹方"],this["品质"]),"无法重复学习!"})))
        end
      end
      if atr["资源参数"]["图纸"] then
        if learnlqfang(atr["资源参数"]["图纸"]) then
          table.insert(SaveTable["炼器"].learn,{key=atr["资源参数"]["图纸"],exp=0,level=1})
          MD提示(Html.fromHtml("你学会了"..Color:Get(atr["资源参数"]["图纸"],this["品质"]).."的炼制法门"))
          DeleteItemTable(this,1)
          SetUI()
         else
          MD提示(Html.fromHtml(table.concat({"已经学习过"..Color:Get(atr["资源参数"]["图纸"],this["品质"]),"无法重复学习!"})))
        end
      end
      menu.dismiss()
    end
    if (this.type == 6 and this.number > 0) then
      local br = true
      if SaveTable.owner.use[this.key] ~= nil then
        SaveTable.owner.use[this.key] = SaveTable.owner.use[this.key] + 1
      end
      if atr["资源参数"]["buff"] then
        if SaveTable.owner.buff == nil then
          SaveTable.owner.buff = {}
        end
        SaveTable.owner.buff["转生"] = 21
        提示("好喝")
      end
      if atr["资源参数"]["衣"] ~= nil then
        SaveTable["新衣"] = 1
      end
      if atr["资源参数"]["修为"] then
        local num = 1
        if SaveTable["耐药性"] == nil then
          SaveTable["耐药性"] = {}
        end
        if SaveTable["耐药性"][this.key] == nil then
          SaveTable["耐药性"][this.key] = 1
         else
          num = num/(1+SaveTable["耐药性"][this.key]/100)
          SaveTable["耐药性"][this.key] = SaveTable["耐药性"][this.key] + 1
        end
        SaveTable.owner["修为"] = SaveTable.owner["修为"] + math.ceil(atr["资源参数"]["修为"]*num)
        MD提示("你的修为增加了"..math.ceil(atr["资源参数"]["修为"]*num).."点!")
      end
      if atr["资源参数"]["道心"] then
        local num = 1
        if atr["资源参数"]["耐药性"] ~= nil then
          if SaveTable["耐药性"] == nil then
            SaveTable["耐药性"] = {}
          end
          if SaveTable["耐药性"][this.key] == nil then
            SaveTable["耐药性"][this.key] = atr["资源参数"]["耐药性"]
           else
            num = num*(1-SaveTable["耐药性"][this.key]/100)
            if num < 0.1 then
              num = 0.1
            end
            SaveTable["耐药性"][this.key] = SaveTable["耐药性"][this.key] + atr["资源参数"]["耐药性"]
          end
        end
        SaveTable.owner["道心"] = SaveTable.owner["道心"] + math.ceil(atr["资源参数"]["道心"]*num)
        MD提示("你的道心增加了"..math.ceil(atr["资源参数"]["道心"]*num).."点!")
      end
      if atr["资源参数"]["体质"] then
        SaveTable.owner["体质"] = SaveTable.owner["体质"] + atr["资源参数"]["体质"]
        MD提示("你的体质增加了"..atr["资源参数"]["体质"].."点!")
      end
      if atr["资源参数"]["真元"] then
        SaveTable.owner["真元"] = SaveTable.owner["真元"] + atr["资源参数"]["真元"]
        MD提示("你的真元增加了"..atr["资源参数"]["真元"].."点!")
      end
      if atr["资源参数"]["身法"] then
        SaveTable.owner["身法"] = SaveTable.owner["身法"] + atr["资源参数"]["身法"]
        MD提示("你的身法增加了"..atr["资源参数"]["身法"].."点!")
      end
      if atr["资源参数"]["肉身"] then
        SaveTable.owner["肉身"] = SaveTable.owner["肉身"] + atr["资源参数"]["肉身"]
        MD提示("你的肉身增加了"..atr["资源参数"]["肉身"].."点!")
      end
      if atr["资源参数"]["寿元"] then
        SaveTable.owner["寿元"] = SaveTable.owner["寿元"] + atr["资源参数"]["寿元"]
        MD提示("你的寿元增加了"..atr["资源参数"]["寿元"].."年!")
      end
      if atr["资源参数"]["战斗回复"] then
        br = false
        menu.dismiss()
        MD提示("请在战斗中使用")
      end
      if atr["资源参数"]["回复"] then
        if SaveTable.owner.buff["回复"] == nil then
          SaveTable.owner.buff["回复"]={number={Hp={atr["资源参数"]["回复"][3],atr["资源参数"]["回复"][1][1]},Mp={atr["资源参数"]["回复"][3],atr["资源参数"]["回复"][1][2]}},time={os.time()+atr["资源参数"]["回复"][2],atr["资源参数"]["回复"][2]}}
          MD提示("使用成功!")
          menu.dismiss()
          br = true
         else
          menu.dismiss()
          br = false
          MD提示("已有此类丹药效果，重复使用会导致气血失调的!")
        end
      end
      if atr["资源参数"]["增伤"] then
        if SaveTable.owner.buff["增伤"] == nil then
          SaveTable.owner.buff["增伤"]={number={atr["资源参数"]["增伤"][3],atr["资源参数"]["增伤"][1]},time={os.time()+atr["资源参数"]["增伤"][2],atr["资源参数"]["增伤"][2]}}
          MD提示("使用成功!")
          menu.dismiss()
          br = true
         else
          br = false
          menu.dismiss()
          MD提示("已有此类丹药效果，重复使用会导致气血失调的!")
        end
      end
      if atr["资源参数"]["免伤"] then
        if SaveTable.owner.buff["免伤"] == nil then
          SaveTable.owner.buff["免伤"]={number={atr["资源参数"]["免伤"][3],atr["资源参数"]["免伤"][1]},time={os.time()+atr["资源参数"]["免伤"][2],atr["资源参数"]["免伤"][2]}}
          MD提示("使用成功!")
          menu.dismiss()
          br = true
         else
          br = false
          MD提示("已有此类丹药效果，重复使用会导致气血失调的!")
        end
      end
      if br then
        this.number = this.number - 1
        DeleteItemTable(this,1)
      end
      SetUI()
      if this.number <= 0 then
        menu.dismiss()
      end
     elseif this.number <= 0 then
      MD提示("物品数量不足!")
    end
    if (this.type == 8 and this.number > 0) then
      if atr["资源参数"]["获得秘籍"] then
        local tb = GetGiftTable(this["品质"],7,9)
        local sj = math.random(1,#tb)
        Item:Add(tb[sj],1)
        MD提示(Html.fromHtml("获得了物品"..SkillColor(tb[sj],this["品质"])))
      end
      if atr["资源参数"]["获得装备"] then
        local tb = GetGiftTable(this["品质"],0,5)
        local sj = math.random(1,#tb)
        Item:Add(tb[sj],1)
        MD提示(Html.fromHtml("获得了物品"..SkillColor(tb[sj],this["品质"])))
      end
      if atr["资源参数"]["获得物品"] then
        local str = ""
        for k,v in pairs(atr["资源参数"]["获得物品"].item) do
          str=table.concat({str,Color:Get(v.key,Item:GetTable(v.key)["品质"]),"*",v.number,","})
          Item:Add(v.key,v.number)
        end
        MD提示(Html.fromHtml("获得"..str))
      end
      if atr["资源参数"]["获得宠兽"] then
        addpet(atr["资源参数"]["获得宠兽"][1],atr["资源参数"]["获得宠兽"][2],nil,atr["资源参数"]["获得宠兽"][3])
      end
      if atr["资源参数"]["随机宠兽"] then
        addpet(nil,nil)
      end
      this.number = this.number - 1
      DeleteItemTable(this,1)
      SetUI()
      if this.number <= 0 then
        menu.dismiss()
      end
     elseif (this.type == 8 and this.number <= 0) then
      MD提示("物品数量不足!")
    end
    if this.type == 9 then
      if atr["资源参数"]["宠兽功法"] then
        local tbk = table.clone(ptinsk[atr["资源参数"]["宠兽功法"]])
        tbk.key = atr["资源参数"]["宠兽功法"]
        tbk.level = 10
        tbk.exp = 0
        预览功法(tbk)
       elseif atr["资源参数"]["宠兽法术"] then
        local tbk = table.clone(ptsk[atr["资源参数"]["宠兽法术"]])
        tbk.key = atr["资源参数"]["宠兽法术"]
        tbk.level = 10
        tbk.exp = 0
        预览法术(tbk)
       else
        MD提示("请在宠兽包裹内使用!")
      end
    end
  end
  GetItemId()
  loadsavewrite()
end