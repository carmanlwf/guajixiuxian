require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "GetAttribute"
import "BattleFiled"
import "bmob"
import "yun"
import "commonHelper"
local 境界 = import "tupo"
local Item = import "item"
local cjson=import "cjson"
local 品级 = {"黄阶下品","黄阶中品","黄阶上品","玄阶下品","玄阶中品","玄阶上品","地阶下品","地阶中品","地阶上品","天阶下品","天阶中品","天阶上品","仙品"}
local pw

local d
local cjson=import "cjson"
local prole,att
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

function allmoney()
  local num = SaveTable.owner.money
  for k,v in pairs(SaveTable.Item) do
    num = num + Item:GetTable(v.key).price * v.number
  end
  return math.ceil(num)
end

local function GetEquipmentShow(ltb)
  local x = 1
  local tb
  --local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中"}
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
function 排行功法面板()
  OpenSkillMenu("功法面板",prole.inskill,prole.skill,true)
end
local function EquipmentShow(eq)
  local t = {}
  for k,v in pairs(eq) do
    t[#t+1] = GetEquipmentShow(v)
    t[k]["附加属性"] = v["附加属性"]
  end
  return t
end

function phkey()
  local key
  if SaveTable.owner.level >= 33 then
    key = {33,36}
   elseif SaveTable.owner.level >= 29 then
    key = {29,32}
   elseif SaveTable.owner.level >= 25 then
    key = {25,28}
   elseif SaveTable.owner.level >= 21 then
    key = {21,24}
   elseif SaveTable.owner.level >= 17 then
    key = {17,20}
   elseif SaveTable.owner.level >= 13 then
    key = {13,16}
   else
    key = {1,12}
  end
  return key
end

function 打开排行榜()
  SaveTable.owner.Attribute = Item:GetTirgger(SaveTable.owner)
  SaveTable.owner.fight = math.ceil(SaveTable.owner.Attribute["内攻"]*2+SaveTable.owner.Attribute["外攻"]*2+SaveTable.owner.Attribute["内防"]*2.5+SaveTable.owner.Attribute["外防"]*2.5+SaveTable.owner.Attribute["气血上限"]*0.2+SaveTable.owner.Attribute["法力上限"]*0.1+SaveTable.owner.Attribute["会心率"]*2+SaveTable.owner.Attribute["抗会心率"]*2+SaveTable.owner.Attribute["闪避"]*2.5+SaveTable.owner.Attribute["命中"]*2.5+SaveTable.owner.Attribute["会心伤害"]*20+SaveTable.owner.Attribute["会心免伤"]*20+SaveTable.owner.Attribute["最终伤害放大"]*30+SaveTable.owner.Attribute["最终伤害抵消"]*30)

  function 排行榜上传()
    if SaveTable.owner.level >= 0 then
      local pop = {
        LinearLayout;
        gravity="center";
        layout_height="fill";
        layout_width="fill";
        orientation="vertical";
        {
          TextView;
          text="加载中..";
        };
      };
      pw = PopupWindow(activity)--创建PopWindow
      pw.setContentView(loadlayout(pop))--设置布局
      pw.setWidth(activity.Width)--设置宽度
      pw.setHeight(activity.Height)--设置高度
      pw.setFocusable(false)--设置可获得焦点
      pw.getBackground().setAlpha(0)
      pw.setTouchable(true)--设置可触摸
      --设置点击外部区域是否可以消失
      pw.setOutsideTouchable(false)
      --显示
      pw.showAtLocation(view,Gravity.CENTER,0,0)
      hs("http://82.157.62.200/cha.php?id="..解密("role/zh").."&owner="..cjson.encode(SaveTable.owner).."&money="..allmoney().."&liandan="..SaveTable["炼丹"].level.."&lianqi="..SaveTable["炼器"].level,function(code,body)
        if code ~= -1 and code >= 200 and code <= 400 then
          hs("http://82.157.62.200/paihang.php?id="..解密("role/zh").."&fight="..SaveTable.owner.fight.."&money="..allmoney().."&liandan="..SaveTable["炼丹"].level.."&lianqi="..SaveTable["炼器"].level.."&level="..SaveTable.owner.level.."&key="..SaveTable.owner.key,function(code,body)
            if code ~= -1 and code >= 200 and code <= 400 then
              pw.dismiss()
              提示("上传成功")
             else
              提示("网络连接失败")
            end
          end)
         else
          提示("网络连接失败")
        end
      end)
     else
      提示("炼气五层以上开启排行榜上传")
    end
  end
  local tb
  local its = {
    LinearLayout;
    layout_height="fill";
    layout_width="fill";
    {
      CardView;
      cardBackgroundColor="#FFF7F7F7";
      layout_gravity="center";
      layout_height="24%h";
      elevation="0dp";
      layout_margin="2%w";
      layout_width="fill";
      radius="5dp";
      {
        LinearLayout;
        id="";
        layout_width="fill";
        layout_height="fill";
        layout_margin="0dp";
        gravity="center";
        {
          TextView;
          text="name";
          textSize=getsize(14);
          textColor="#333333";
          id="name";
        };
      };
    };
  };
  local data1={}
  local adp=LuaAdapter(activity,data1,its)
  hs("http://82.157.62.200/pcha.php?min="..phkey()[1].."&max="..phkey()[2],function(code,body)
    if code ~= -1 and code >= 200 and code <= 400 then
      local tb = cjson.decode(body)
      if tb == nil then
        tb = {}
      end
      if #tb >= 2 then
        table.sort(tb,function(a,b)
          return tonumber(a.fight) > tonumber(b.fight)
        end)
      end
      for k,v in pairs(tb) do
        table.insert(data1,{name="No."..k.."\n".."道号:"..v.name.."\n境界:"..境界[tonumber(v.level)]["境界"].."\n战斗力:"..math.ceil(tonumber(v.fight)).."\n财富值:"..math.ceil(tonumber(v.money)).."\n炼丹等阶:"..品级[math.ceil(tonumber(v.liandan))].."\n炼器等阶:"..品级[math.ceil(tonumber(v.lianqi))],id=v.id})
      end
      loadsavewrite(0)
      排行.Adapter=adp
      排行.onItemClick=function(l,v,p,i)
        hs("http://82.157.62.200/pca.php?id="..tb[i].id,function(code,body)
          local tab = cjson.decode(body)
          tab.owner=cjson.decode(urlDecode(tab.owner))
          local a
          if tab ~= nil then
            prole = tab.owner
            att = Item:GetTirgger(tab.owner)
            a=PopupWindow(activity)--创建PopWindow
            a.setContentView(loadlayout(MapUI()["排行面板"]))--设置布局
            a.setWidth(activity.Width*0.92)--设置宽度
            a.setHeight(activity.Height*0.48)--设置高度
            a.setFocusable(true)--设置可获得焦点
            a.getBackground().setAlpha(0)
            a.setTouchable(true)--设置可触摸
            --设置点击外部区域是否可以消失
            a.setOutsideTouchable(false)
            --显示
            a.showAtLocation(view,Gravity.CENTER,0,0)
            排行姓名.Text=排行姓名.Text..prole.key
            排行境界.Text=排行境界.Text..境界[prole.level]["境界"]
            排行体质.Text=排行体质.Text..math.ceil(att["体质"])
            排行真元.Text=排行真元.Text..math.ceil(att["真元"])
            排行身法.Text=排行身法.Text..math.ceil(att["身法"])
            排行肉身.Text=排行肉身.Text..math.ceil(att["肉身"])
            排行内攻.Text=排行内攻.Text..att["内攻"]
            排行外攻.Text=排行外攻.Text..att["外攻"]
            排行法力.Text=排行法力.Text..att["法力上限"]
            排行血量.Text=排行血量.Text..att["气血上限"]
            排行内防.Text=排行内防.Text..att["内防"]
            排行外防.Text=排行外防.Text..att["外防"]
            排行命中.Text=排行命中.Text..att["命中"]
            排行闪避.Text=排行闪避.Text..att["闪避"]
            排行会心率.Text=排行会心率.Text..att["会心率"]
            排行抗会心率.Text=排行抗会心率.Text..att["抗会心率"]
            排行会心伤害.Text=排行会心伤害.Text..att["会心伤害"].."%"
            排行会心免伤.Text=排行会心免伤.Text..att["会心免伤"].."%"
            排行最终伤害放大.Text=排行最终伤害放大.Text..att["最终伤害放大"].."%"
            排行最终伤害抵消.Text=排行最终伤害抵消.Text..att["最终伤害抵消"].."%"
            phfight.Text = "战斗力:"..math.ceil(att["内攻"]*2+att["外攻"]*2+att["内防"]*2.5+att["外防"]*2.5+att["气血上限"]*0.2+att["法力上限"]*0.1+att["会心率"]*2+att["抗会心率"]*2+att["闪避"]*2.5+att["命中"]*2.5+att["会心伤害"]*20+att["会心免伤"]*20+att["最终伤害放大"]*30+att["最终伤害抵消"]*30)
          end
          --function 封禁()
          --b:insert("cheak",{key=tb[i].id},function(code,body)
          --end)
          --end
          function 排行切磋()
            SaveTable.owner.hard = 境界[SaveTable.owner.level].hard
            if SaveTable.owner.buff ~= nil then
              if SaveTable.owner.buff["转生"] ~= nil then
                if SaveTable.owner.buff["转生"] > SaveTable.owner.level then
                  SaveTable.owner.hard = SaveTable.owner.hard + 境界[SaveTable.owner.buff["转生"]].hard * 0.2
                end
                if SaveTable.owner.hard > 境界[SaveTable.owner.buff["转生"]].hard then
                  SaveTable.owner.hard = 境界[SaveTable.owner.buff["转生"]].hard
                end
              end
            end
            SaveTable.owner.Attribute = Item:GetTirgger(SaveTable.owner)
            SaveTable.owner.Hp = SaveTable.owner.Attribute["气血上限"]
            SaveTable.owner.Mp = SaveTable.owner.Attribute["法力上限"]
            prole.hard = 境界[prole.level].hard
            if prole.buff ~= nil then
              if prole.buff["转生"] ~= nil then
                if prole.buff["转生"] > prole.level then
                  prole.hard = prole.hard + 境界[prole.buff["转生"]].hard * 0.2
                end
                if prole.hard > 境界[prole.buff["转生"]].hard then
                  prole.hard = 境界[prole.buff["转生"]].hard
                end
              end
            end
            prole.Attribute = att
            prole.Hp = prole.Attribute["气血上限"]
            prole.Mp = prole.Attribute["法力上限"]
            local skill = import "skill"
            for k,v in pairs(prole.skill) do
              if v.eq == 1 then
                prole.skill[k]["战斗参数"] = skill:GetTable(v.key,v.level)
              end
            end
            for k,v in pairs(SaveTable.owner.skill) do
              if v.eq == 1 then
                SaveTable.owner.skill[k]["战斗参数"] = skill:GetTable(v.key,v.level)
              end
            end
            local jt = SaveTable.owner
            jt.team = 1
            local et = prole
            prole.team = 2
            local spt = {jt,et}
            a.dismiss()
            d.dismiss()
            local MaxSp = SaveTable.owner.Attribute["身法"] + prole.Attribute["身法"]
            SaveTable.owner.sp = (SaveTable.owner.Attribute["身法"]+SaveTable.owner.hard*2)*SaveTable.owner.hard/10
            prole.sp = (prole.Attribute["身法"]+prole.hard*2)*prole.hard/10
            prole.NowSp = 0
            SaveTable.owner.NowSp = 0
            BattleStart(nil,spt,1)
          end
          function OpenEquipment(eq)
            eq = eq or prole.eq
            local EqTable = EquipmentShow(eq)
            import"android.graphics.drawable.ColorDrawable"
            local a=AlertDialog.Builder(this).show()
            a.getWindow().setContentView(loadlayout(MapUI()["装备面板"]));
            --点击阴影部分不会关闭弹窗
            for k,v in pairs(EqTable) do
              if v.type == 0 then
                武器.Text = Color:Set(EqLevel(v.key,v.level),v["品质"])
               elseif v.type == 1 then
                衣服.Text = Color:Set(EqLevel(v.key,v.level),v["品质"])
               elseif v.type == 2 then
                帽子.Text = Color:Set(EqLevel(v.key,v.level),v["品质"])
               elseif v.type == 3 then
                护手.Text = Color:Set(EqLevel(v.key,v.level),v["品质"])
               elseif v.type == 4 then
                鞋子.Text = Color:Set(EqLevel(v.key,v.level),v["品质"])
               elseif v.type == 5 then
                首饰.Text = Color:Set(EqLevel(v.key,v.level),v["品质"])
              end
            end
            function EquipmentShowMenu(type)
            --  local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中"}
              local x = 1
              local t
              if #EqTable ~= 0 then
                repeat
                if type == EqTable[x].type then
                  t = EqTable[x]
                  break
                 else
                  x = x + 1
                end
                until x > #EqTable
              end
              if t ~= nil then
                import"android.graphics.drawable.ColorDrawable"
                a=AlertDialog.Builder(this).show()
                a.getWindow().setContentView(loadlayout(MapUI()["战斗装备数据"]));
                物品名称.Text = Color:Set(EqLevel(t.key,t.float).."["..品级[t["品质"]].."]",t["品质"])
                物品介绍.Text = 物品介绍.Text..":\n"..t.Info.."\n"
                local f = ""
                for k,v in pairs(tab) do
                  if t[v] then
                    if v == "会心伤害" or v == "会心免伤" or v == "最终伤害放大" or v == "最终伤害抵消" then
                      f=f..v..":"..math.ceil(t[v]*(1.1^t.level)).."%\n"
                     elseif v=="气血上限" then
                      f=f.."气血上限:"..math.ceil(t[v]*(1.1^t.level)).."\n"
                     elseif v=="法力上限" then
                      f=f.."法力上限"..math.ceil(t[v]*(1.1^t.level)).."\n"
                     else
                      f=f..v..":"..math.ceil(t[v]*(1.1^t.level)).."\n"
                    end
                  end
                end
                物品属性.Text = 物品属性.Text..":\n"..f
                if #t["附加属性"] > 0 then
                  local num
                  if t["品质"] >= 13 then
                    num = 10
                   elseif t["品质"] > 9 then
                    num = 7
                   elseif t["品质"] > 6 then
                    num = 5
                   elseif t["品质"] > 3 then
                    num = 3
                   else
                    num = 2
                  end
                  战斗装备框.addView(loadlayout{
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
                    战斗装备框.addView(loadlayout{
                      TextView;
                      text=Html.fromHtml(GetColor(tx,co));
                    },num1)
                    num1 = num1 + 1
                  end
                  local z = math.floor(t.level/5)
                  local djp
                  if #eq >= 6 then
                    for k,v in pairs(EqTable) do
                      if djp == nil then
                        djp = v["品质"]
                       elseif v["品质"] < djp then
                        djp = v["品质"]
                      end
                      local fl = math.floor(v.level/5)
                      if z > fl then
                        z = fl
                      end
                    end
                    local stri,numi
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
                    if z > 0 then
                      战斗装备框.addView(loadlayout{
                        TextView;
                        text=Color:Set("<br>"..stri..math.ceil(z*5).."转:<br>基础生命:"..numi.."%<br>基础法力:"..numi.."%<br>基础攻击:"..numi.."%<br>基础防御:"..numi.."%<br>基础命中:"..numi.."%<br>基础闪避:"..numi.."%<br>基础会心:"..numi.."%",djp);
                      },num1)
                    end
                  end
                end
               else
                MD提示("无装备!")
              end
            end
          end
        end)
      end
    end
  end)
end

function 排行榜()
  d=PopupWindow(activity)--创建PopWindow
  d.setContentView(loadlayout(MapUI()["排行榜"]))--设置布局
  d.setWidth(activity.Width*0.92)--设置宽度
  d.setHeight(activity.Height*0.6)--设置高度
  d.setFocusable(true)--设置可获得焦点
  d.getBackground().setAlpha(0)
  d.setTouchable(true)--设置可触摸
  --设置点击外部区域是否可以消失
  d.setOutsideTouchable(false)
  --显示
  d.showAtLocation(view,Gravity.CENTER,0,0)

  task(100,function 打开排行榜() end)
end