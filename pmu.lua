require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
local Item = import "item"

local e
local Color = {hui="#C6C6C6",black="#000000",white="#FFFFFF",green="#008000",blue="#0000FF",red="#FF0000",orange="#FFA500",gold="#FFD700"}
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
local 品级 = {"黄阶下品","黄阶中品","黄阶上品","玄阶下品","玄阶中品","玄阶上品","地阶下品","地阶中品","地阶上品","天阶下品","天阶中品","天阶上品","仙品"}
local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中","神念消耗","材料消耗","成丹率","成功率","出丹率","评分提升","属性品质","获取经验"}
function ShowMenu(tb)
  local t = Item:GetTable(tb.key)
  t["附加属性"] = tb["附加属性"]
  t.level = tb.level
  if e ~= nil then
    e.dismiss()
  end
  e=PopupWindow(activity)--创建PopWindow
  e.setContentView(loadlayout(MapUI()["拍卖信息"]))--设置布局
  e.setWidth(-2)--设置宽度
  e.setHeight(-2)--设置高度
  e.setFocusable(true)--设置可获得焦点
  e.setTouchable(true)--设置可触摸
  e.setOutsideTouchable(true)
  e.showAtLocation(view,Gravity.CENTER,0,0)
  物品名称.Text=Color:Set(EqLevel(t.key,t.level).."["..品级[t["品质"]].."]",t["品质"])
  物品介绍.Text=t.Info
  local f = ""
  for k,v in pairs(tab) do
    if tb[v] then
      if v == "会心伤害" or v == "会心免伤" or v == "最终伤害放大" or v == "最终伤害抵消" or string.find(v,"基础") then
        f=f..v..":"..math.ceil(tb[v]*t[v]*(1.1^tb.level)).."%\n"
       elseif v=="气血上限" then
        f=f.."气血上限:"..math.ceil(tb[v]*t[v]*(1.1^tb.level)).."\n"
       elseif v=="法力上限" then
        f=f.."法力上限:"..math.ceil(tb[v]*t[v]*(1.1^tb.level)).."\n"
       else
        f=f..v..":"..math.ceil(tb[v]*t[v]*(1.1^tb.level)).."\n"
      end
    end
  end
  if #f > 3 then
    拍卖信息.addView(loadlayout
    {
      TextView;
      text="物品属性:\n"..f;
    },3)
  end
  if (t["附加属性"] and #t["附加属性"] > 0 and t.type >= 0) then
    local num
    if t["品质"] > 9 then
      num = 7
     elseif t["品质"] > 6 then
      num = 5
     elseif t["品质"] > 3 then
      num = 3
     else
      num = 2
    end
    拍卖信息.addView(loadlayout{
      TextView;
      text=Html.fromHtml("附加属性("..#t["附加属性"].."/"..num.."):");
    },4)
    local num1 = 5
    local tx
    local Trigger = import "Trigger"
    for k,v in pairs(t["附加属性"]) do
      local sp = split(Trigger["属性"][t["品质"]][v[1]],"#")
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
      local co
      for g,h in pairs(tb) do
        if v[2] <= h[2] then
          co = "#"..h[4]
          break
        end
      end
      if v[1] == "会心伤害" or v[1] == "会心免伤" or v[1] == "最终伤害放大" or v[1] == "最终伤害抵消" or string.find(v[1],"基础") then
        tx = v[1]..":"..math.ceil(v[2]*(1.1^t.level)).."%"
       elseif v[1] == "气血上限" then
        tx = "气血上限:"..math.ceil(v[2]*(1.1^t.level))
       elseif v[1] == "法力上限" then
        tx = "法力上限:"..math.ceil(v[2]*(1.1^t.level))
       else
        tx = v[1]..":"..math.ceil(v[2]*(1.1^t.level))
      end
      拍卖信息.addView(loadlayout{
        TextView;
        text=Html.fromHtml(GetColor(tx,co));
      },num1)
      num1 = num1 + 1
    end
   elseif t["附加属性"] ~= nil then
    local str=""
    for k,v in pairs(t["附加属性"]) do
      if v.value[1] == "神念消耗" or v.value[1] == "材料消耗" then
        str=table.concat({str,"<br>",v.key,v.value[1],"降低:",v.value[2],"%"})
       elseif v.value[1] == "成丹率" or v.value[1] == "出丹率" or v.value[1] == "成功率" or v.value[1] == "评分提升" or v.value[1] == "属性品质" or v.value[1] == "获取经验" then
        str=table.concat({str,"<br>",v.key,v.value[1],"增加:",v.value[2],"%"})
      end
    end
    拍卖信息.addView(loadlayout{
      TextView;
      text=Html.fromHtml("附加属性:"..Color:Get(str,t["品质"]));
    },4)
  end
  if tp == 1 then
    拍卖信息.addView(loadlayout{
      TextView;
      text="\n上架修士:"..t.owner;
    })
    拍卖信息.addView(loadlayout {
      LinearLayout;
      {
        TextView;
        id="拍卖数量";
        layout_gravity="center";
        textColor="#000000";
        text="购买数量:1件";
      };
      {
        Button;
        onClick=function 购买数量() end;
        text="选择数量";
        layout_width="80dp";
        layout_gravity="center";
        textSize=getsize(12);
        layout_height="36dp";
      };
    })
    拍卖信息.addView(loadlayout{
      LinearLayout;
      layout_width="fill";
      layout_height="50dp";
      {
        Button;
        onClick=function 购买物品() end;
        layout_width="60dp";
        text="购买";
        layout_height="45dp";
      };
    })
   elseif tp == 2 then
  end
  return 拍卖信息,e
end