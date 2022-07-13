require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "commonHelper"
local cjson = import "cjson"
local 境界 = import "tupo"
local npc = import "npc"
local map = import "map"
local Item = import "item"
local mapnpc = import "mapnpc"
local mst = import "mst"
local ptjj = import "pettupo"
local ptskill = import "petskill"
local ptinskill = import "petinskill"
local st = import "story"
local hd

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

function GetTalent(tb)
  local talent = import "talent"
  local sxtb = {["金"]=1,["木"]=1,["水"]=1,["火"]=1,["土"]=1,["风"]=1,["雷"]=1,["绝对暴击"]=0,["绝对闪避"]=0,["绝对命中"]=0,["绝对免暴"]=0,["暴击伤害"]=0,["闪避增伤"]=0,["连击"]=0,["暴击回复"]=0,["闪避回复"]=0,["额外掉落"]=0,["吸取生命"]=0,["吸取法力"]=0,["复活"]=0,["连续攻击"]=0}
  tb.talent={["特性"]={}}
  if tb.key1 ~= nil and talent[tb.key1] ~= nil then
    for k,v in pairs(talent[tb.key1].effect) do
      table.insert(tb.talent["特性"],v)
      if sxtb[v.key] ~= nil then
        if v.type == 1 then
          sxtb[v.key] = sxtb[v.key] + v.value/100
         else
          sxtb[v.key] = v
        end
      end
    end
  end
  tb.战斗参数 = sxtb
  if sxtb["爆发攻击"] ~= nil then
    tb["爆发攻击"] = {sxtb["爆发攻击"].value,sxtb["爆发攻击"].value1}
  end
  if sxtb["爆发防御"] ~= nil then
    tb["爆发防御"] = {sxtb["爆发防御"].value,sxtb["爆发防御"].value1}
  end
  if sxtb["爆发行动"] ~= nil then
    tb["爆发行动"] = {sxtb["爆发行动"].value,sxtb["爆发行动"].value1}
  end
  if sxtb["累进攻击"] ~= nil then
    tb["累进攻击"] = {sxtb["累进攻击"].value,sxtb["累进攻击"].value1,sxtb["累进攻击"].value2}
  end
  if sxtb["累进防御"] ~= nil then
    tb["累进防御"] = {sxtb["累进防御"].value,sxtb["累进防御"].value1,sxtb["累进防御"].value2}
  end
end

function loadsx(prole)
  local 品级 = {"黄阶下品","黄阶中品","黄阶上品","玄阶下品","玄阶中品","玄阶上品","地阶下品","地阶中品","地阶上品","天阶下品","天阶中品","天阶上品","仙品"}

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
  function npc功法面板()
    OpenSkillMenu("功法面板",prole.inskill,prole.skill,true)
  end
  function nOpenEquipment(eq)
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
    local function EquipmentShow(eq1)
      local tb = {}
      for k,v in pairs(eq1) do
        tb[#tb+1] = GetEquipmentShow(v)
      end
      return tb
    end
    eq = eq or prole.eq
    local EqTable = EquipmentShow(eq)
    import"android.graphics.drawable.ColorDrawable"
    local a=AlertDialog.Builder(this).show()
    a.getWindow().setContentView(loadlayout(MapUI()["装备面板"]));
    a.setCanceledOnTouchOutside(false)--点击阴影部分不会关闭弹窗
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
     -- local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中"}
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
        a.setCanceledOnTouchOutside(false)
        物品名称.Text = Color:Set(EqLevel(t.key,t.level).."["..品级[t["品质"]].."]",t["品质"])
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
        if t["附加属性"] ~= nil and #t["附加属性"] > 0 then
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
            })
          end
        end
       else
        MD提示("无装备!")
      end
    end
  end
  hd.dismiss()
  local npcmb = {
    LinearLayout;
    backgroundColor="#000000";
    layout_height="fill";
    layout_width="fill";
    orientation="vertical";
    {
      LinearLayout;
      layout_height="5%h";
      layout_width="fill";
      {
        CardView;
        layout_height="fill";
        layout_width="fill";
        backgroundColor="#000000";
        {
          TextView;
          text="人物属性";
          textColor="#FFFFFF";
          textSize=getsize(18);
        };
      };
    };
    {
      LinearLayout;
      layout_height="36%h";
      layout_width="fill";
      {
        LinearLayout;
        layout_height="fill";
        layout_width="45%w";
        orientation="vertical";
        {
          TextView;
          id="排行姓名";
          text="姓名:";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
        {
          TextView;
          id="排行体质";
          text="体质:";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
        {
          TextView;
          id="排行身法";
          text="身法:";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
        {
          TextView;
          id="排行血量";
          text="气血:";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
        {
          TextView;
          id="排行内攻";
          text="内攻:";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
        {
          TextView;
          id="排行内防";
          text="内防:";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
        {
          TextView;
          id="排行会心率";
          text="会心率:";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
        {
          TextView;
          id="排行命中";
          text="命中:";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
        {
          TextView;
          id="排行会心伤害";
          text="会心伤害:";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
        {
          TextView;
          id="排行最终伤害放大";
          text="最终伤害放大:";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
        {
          TextView;
          text="暂无";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
      };
      {
        LinearLayout;
        layout_height="fill";
        layout_width="50%w";
        orientation="vertical";
        {
          TextView;
          id="排行境界";
          text="境界:";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
        {
          TextView;
          id="排行真元";
          text="真元:";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
        {
          TextView;
          id="排行肉身";
          text="肉身:";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
        {
          TextView;
          id="排行法力";
          text="法力:";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
        {
          TextView;
          id="排行外攻";
          text="外攻:";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
        {
          TextView;
          id="排行外防";
          text="外防:";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
        {
          TextView;
          id="排行抗会心率";
          text="抗会心率:";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
        {
          TextView;
          id="排行闪避";
          text="闪避:";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
        {
          TextView;
          id="排行会心免伤";
          text="会心免伤:";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
        {
          TextView;
          id="排行最终伤害抵消";
          text="最终伤害抵消:";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
        {
          TextView;
          id="phfight";
          text="战斗力:";
          layout_marginBottom="0.5%w";
          layout_marginLeft="0.5%w";
          backgroundColor="#FFFFFF";
          layout_width="50%w";
          textColor="#000000";
          layout_height="3%h";
        };
      };
    };
    {
      LinearLayout;
      backgroundColor="#FFFFFF";
      layout_height="6%h";
      layout_width="fill";
      {
        Button;
        onClick=function nOpenEquipment(role.eq) end;
        text="装备";
      };
      {
        Button;
        onClick=function npc功法面板() end;
        text="功法";
      };
      {
        Button;
        onClick=function npc切磋() end;
        text="切磋";
      };
      {
        Button;
        text="暂无";
      };
    };
  };
  local att = prole.Attribute
  local a=PopupWindow(activity)--创建PopWindow
  a.setContentView(loadlayout(npcmb))--设置布局
  a.setWidth(activity.Width*0.92)--设置宽度
  a.setHeight(activity.Height*0.48)--设置高度
  a.setFocusable(true)--设置可获得焦点
  a.getBackground().setAlpha(0)
  a.setTouchable(true)--设置可触摸
  --设置点击外部区域是否可以消失
  a.setOutsideTouchable(false)
  --显示
  a.showAtLocation(view,Gravity.CENTER,0,0)
  排行姓名.Text=排行姓名.Text..prole.name
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
  function npc切磋()
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
    prole.Attribute = att
    prole.key = prole.name
    prole.Hp = prole.Attribute["气血上限"]
    prole.Mp = prole.Attribute["法力上限"]
    local jt = SaveTable.owner
    jt.team = 1
    local et = prole
    prole.team = 2
    local spt = {jt,et}
    a.dismiss()
    hd.dismiss()
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
    SaveTable.owner.sp = (SaveTable.owner.Attribute["身法"]+SaveTable.owner.hard*2)*SaveTable.owner.hard/10
    prole.sp = (prole.Attribute["身法"]+prole.hard*2)*prole.hard/10
    prole.NowSp = 0
    local MaxSp = SaveTable.owner.sp + prole.sp
    SaveTable.owner.NowSp = 0
    BattleStart(nil,spt,1)
  end
end

function 载入战斗(key,save)
  function npc:GetTable(key,num)
    local role = self[key]
    for k,v in pairs(role.skill) do
      if v.eq == 1 then
        if role.type == 1 then
          role.skill[k]["战斗参数"] = skill:GetTable(v.key,v.level)
         else
          role.skill[k]["战斗参数"] = ptskill:GetTable(v.key,v.level)
        end
      end
    end
    return role
  end
  local tb = {}
  local btb = table.clone(SaveTable.owner)
  btb.hard = 境界[SaveTable.owner.level].hard
  if btb.buff ~= nil then
    if btb.buff["转生"] ~= nil then
      if btb.buff["转生"] > btb.level then
        btb.hard = btb.hard + 境界[btb.buff["转生"]].hard * 0.2
      end
      if btb.hard > 境界[btb.buff["转生"]].hard then
        btb.hard = 境界[btb.buff["转生"]].hard
      end
    end
  end
  btb.Attribute = Item:GetTirgger(btb)
  btb.Hp = btb.Attribute["气血上限"]
  btb.Mp = btb.Attribute["法力上限"]
  GetTalent(btb)
  btb.team = 1
  local skill = import "skill"
  for k,v in pairs(btb.skill) do
    if v.eq == 1 then
      btb.skill[k]["战斗参数"] = skill:GetTable(v.key,v.level)
    end
  end
  btb.sp = (btb.Attribute["身法"]+btb.hard*2)*btb.hard/10
  table.insert(tb,btb)
  for k,v in pairs(SaveTable.pet) do
    if v.eq == 1 then
      local ptb = {}
      ptb.team = 1
      ptb.buff = v.buff
      ptb.name = v.name
      ptb.key = ptb.name
      ptb.level = v.level
      ptb.ph = v.bh
      ptb.key1 = v.key1
      ptb.pd = k
      ptb.skill = v.skill
      ptb.inskill = v.inskill
      GetTalent(ptb)
      ptb.Attribute = petat(v)
      ptb.Hp = ptb.Attribute["气血上限"]
      ptb.Mp = ptb.Attribute["法力上限"]
      ptb.hard = ptjj[v.level].hard
      for n,m in pairs(v.skill) do
        if m.eq == 1 then
          ptb.skill[n]["战斗参数"] = ptskill:GetTable(m.key,m.level)
        end
      end
      ptb.sp = (ptb.Attribute["身法"]+ptb.hard*2)*ptb.hard/10
      table.insert(tb,ptb)
    end
  end
  local num = math.random(1,#mst[key].data)
  for k,v in pairs(mst[key].data[num]) do
    local role = npc:GetTable(v.key)
    if npc[v.key].type == 1 then
      for i=1,v.number do
        local _role = {}
        for k,v in pairs(role) do
          _role[k] = v
        end
        _role.hard = 境界[_role.level].hard
        _role.team = v.team
        _role.Attribute = Item:GetTirgger(_role)
        _role.Hp = _role.Attribute["气血上限"]
        _role.Mp = _role.Attribute["法力上限"]
        _role.sp = _role.Attribute["身法"]*_role.hard/10
        GetTalent(_role)
        table.insert(tb,_role)
      end
     else
      for i=1,v.number do
        local _role = {}
        for k,v in pairs(role) do
          _role[k] = v
        end
        _role.bh = role.id
        _role.ph = role.id
        if role.key1 ~= nil then
          _role.key1 = role.key1
         else
          _role.key1 = role.name
        end
        _role.key = role.name
        _role.hard = ptjj[_role.level].hard
        _role.team = v.team
        _role.Attribute = petat(_role,_role.bh)
        _role.Hp = _role.Attribute["气血上限"]
        _role.Mp = _role.Attribute["法力上限"]
        _role.sp = (_role.Attribute["身法"]+_role.hard*2)*_role.hard/10
        GetTalent(_role)
        table.insert(tb,_role)
      end
    end
  end
  BattleStart(nil,tb,1,mst[key].result,save)
end

local function con(tb)
  local br = true
  if tb ~= nil then
    for k,v in pairs(tb) do
      if key == "level_more_then" then
        if SaveTable.owner.level < value then
          br = false
          break
        end
       elseif key == "level_less_then" then
        if SaveTable.owner.level > value then
          br = false
          break
        end
      end
    end
  end
  return true
end

local a1
local tuzh
function 文字动画(key,num)
  if SaveTable.finish_story == nil then
    SaveTable.finish_story = {}
  end
  local tb = st[key]
  if tb.cun == true then
    SaveTable.cun = 1
   elseif tb.cun == false then
    SaveTable.cun = nil
  end
  if tb.set then
    if SaveTable.finish_story[key] == nil then
      SaveTable.finish_story[key] = 1
     else
      SaveTable.finish_story[key] = SaveTable.finish_story[key] + 1
    end
  end
  if a1 ~= nil then
    a1.dismiss()
  end
  local lay={
    LinearLayout;
    id="yy";
    BackgroundColor="#000000";
    layout_width="match_parent";
    layout_height="match_parent";
    orientation="vertical";
  };
  local jx
  if tb[num].change ~= nil then
    jx = loadlayout{
      LinearLayout;
      orientation="vertical";
      layout_width="fill";
      layout_height="fill";
    }
    for k,v in pairs(tb[num].change) do
      if v.type == "show" then
        local buu = loadlayout{
          FrameLayout;
          layout_width="match_parent";
          {
            CardView;
            onClick=function
              if tuzh ~= nil then
                tuzh.dismiss()
              end
              tuch=AlertDialog.Builder(this).show()
              tuch.getWindow().setContentView(loadlayout(MapUI()[v.key]))
              if v.key == "加点面板" then
                rolemenu(true)
              end
            end;
            radius="1.8%h";
            layout_height="5.5%h";
            layout_margin="1%h";
            layout_gravity="end";
            layout_width="20%w";
            {
              CardView;
              radius="1.6%h";
              layout_height="match_parent";
              layout_margin="0.4%w";
              backgroundColor="#000000";
              layout_width="match_parent";
              {
                TextView;
                textSize=getsize(16);
                textColor="#FFFFFF";
                text=v.text;
                layout_gravity="center";
              };
            };
          };
        }
        jx.addView(buu)
       elseif v.type == "story" then
        local buu = loadlayout{
          FrameLayout;
          layout_width="match_parent";
          {
            CardView;
            onClick=function
              a1.dismiss()
              文字动画(v.key,1)
            end;
            radius="1.8%h";
            layout_height="5.5%h";
            layout_margin="1%h";
            layout_gravity="end";
            layout_width="20%w";
            {
              CardView;
              radius="1.6%h";
              layout_height="match_parent";
              layout_margin="0.4%w";
              backgroundColor="#000000";
              layout_width="match_parent";
              {
                TextView;
                textSize=getsize(16);
                textColor="#FFFFFF";
                text=v.text;
                layout_gravity="center";
              };
            };
          };
        }
        jx.addView(buu)
       elseif v.type == "battle" then
        local buu = loadlayout{
          FrameLayout;
          layout_width="match_parent";
          {
            CardView;
            onClick=function
              载入战斗(v.key,1)
              a1.dismiss()
            end;
            radius="1.8%h";
            layout_height="5.5%h";
            layout_margin="1%h";
            layout_gravity="end";
            layout_width="20%w";
            {
              CardView;
              radius="1.6%h";
              layout_height="match_parent";
              layout_margin="0.4%w";
              backgroundColor="#000000";
              layout_width="match_parent";
              {
                TextView;
                textSize=getsize(16);
                textColor="#FFFFFF";
                text=v.text;
                layout_gravity="center";
              };
            };
          };
        }
        jx.addView(buu)
      end
    end
   else
    jx = loadlayout{
      FrameLayout;
      layout_width="match_parent";
      {
        CardView;
        onClick=function
          if tb[num+1] ~= nil then
            文字动画(key,num+1)
           else
            a1.dismiss()
          end
          if tb[num].battle ~= nil then
            载入战斗(tb[num].battle)
            a1.dismiss()
          end
          if tb[num].item ~= nil then
            for k,v in pairs(tb[num].item) do
              Item:Add(v.key,v.number)
              提示(Html.fromHtml("获得"..Color:Get(v.key,Item:GetLevel(v.key)).."*"..v.number))
            end
          end
          if tb[num]["道心"] ~= nil then
            SaveTable.owner["道心"] = SaveTable.owner["道心"] + tb[num]["道心"]
            if tb[num]["道心"] > 0 then
              提示("你的道心增加了"..tb[num]["道心"].."点")
             else
              提示("你的道心减少了"..math.ceil(0-tb[num]["道心"]).."点")
            end
          end
          if tb[num]["战功"] ~= nil then
            SaveTable["战功"] = SaveTable["战功"] + tb[num]["战功"]
            提示("你获得了"..tb[num]["战功"].."点战功")
          end
          if tb[num]["神念上限"] ~= nil then
            SaveTable.owner["神念上限"] = SaveTable.owner["神念上限"] + tb[num]["神念上限"]
            SaveTable.owner["神念"] = SaveTable.owner["神念上限"]
            提示("神念上限提升"..tb[num]["神念上限"].."点，神念已全部恢复!")
          end
          if tb.change == nil and tb[num+1] == nil then
            loadsavewrite(0)
          end
        end;
        radius="1.8%h";
        layout_height="5.5%h";
        layout_margin="1%h";
        layout_gravity="end";
        layout_width="20%w";
        {
          CardView;
          radius="1.6%h";
          layout_height="match_parent";
          layout_margin="0.4%w";
          backgroundColor="#000000";
          layout_width="match_parent";
          {
            TextView;
            textSize=getsize(16);
            textColor="#FFFFFF";
            text="继续";
            layout_gravity="center";
          };
        };
      };
    }
  end
  a1=PopupWindow(activity)--创建PopWindow
  a1.setContentView(loadlayout(lay))--设置布局
  a1.setWidth(activity.Width)--设置宽度
  a1.setHeight(activity.Height)
  a1.setFocusable(false)--设置可获得焦点
  a1.getBackground().setAlpha(0)
  a1.setTouchable(true)--设置可触摸
  --设置点击外部区域是否可以消失
  a1.setOutsideTouchable(false)
  --显示
  a1.showAtLocation(view,Gravity.CENTER,0,0)
  local i = 0
  local ti=Ticker()
  ti.Period=1000
  ti.onTick=function()
    import "android.view.animation.TranslateAnimation"
    i=i+1
    if tb[num][i] ~= nil then
      local down_top=TranslateAnimation(0, 0, activity.Height*0.03, 0)
      down_top.setDuration(500)
      down_top.setFillAfter(true)
      local str = tb[num][i]
      if string.find(str,"&主角") ~= nil then
        local c,d=string.find(str,"&主角")
        str = table.concat({str:sub(0,c-1),SaveTable.owner.key,str:sub(d+1,#str)})
      end
      local bot1 = loadlayout(
      {
        TextView;
        textColor="#FFFFFF";
        textSize=getsize(18);
        text=str;
      })
      yy.addView(bot1)
      bot1.startAnimation(down_top)
     else
      yy.addView(jx)
      ti.stop()
    end
  end
  ti.start()
end

function 跳转地图(key,bl,story)
  local qw
  function 载入地图()
    local x
    local y = 0
    local function yanse(str,ys)
      str="<font color="..ys..">"..str.."</font>"
      return Html.fromHtml(str)
    end
    dtjs.Text=map[key].info
    项目1.removeAllViews()
    项目2.removeAllViews()
    项目3.removeAllViews()
    位置.Text=table.concat({"当前位置:[",key,"]"});
    for i=1,3 do
      savelay.bj[i].removeAllViews()
    end
    local sy = savelay
    local bj = sy.bj[1]
    local bj1 = sy.bj[2]
    local bj2 = sy.bj[3]
    local num = 1
    for k,v in pairs(map[key].go) do
      if savelay.kj[num] == nil then
        savelay.kj[num] = {}
        savelay.kj[num].key = loadlayout(
        {
          FrameLayout;
          {
            RelativeLayout,--按钮控件otton;
            id="框架";
            layout_margin="0.7%w";
            background="img/dtk.png";
            layout_width="16%w";
            layout_height="5%h";
            gravity="center";
          }
        })
        savelay.kj[num].value = loadlayout(
        {
          TextView;
        }
        )
        框架.addView(savelay.kj[num].value)
      end
      savelay.kj[num].key.setVisibility(View.VISIBLE)
      if StoryCondition(v.Condition) then
        local co = 0xffffffff
        if v.co ~= nil then
          co = v.co
        end
        savelay.kj[num].value.Text = v.text
        savelay.kj[num].value.TextColor = co
        savelay.kj[num].key.onClick=function 跳转地图(v.key,v.tos,v.story) end;
        local kj = savelay.kj[num].key
        if getwh(bj) < activity.getWidth()*0.7 then
          bj.addView(kj)
         elseif getwh(bj1) < activity.getWidth()*0.7 then
          bj1.addView(kj)
         else
          bj2.addView(kj)
        end
      end
      num = num + 1
    end
    if mapnpc[key] ~= nil then
      for k,v in pairs(mapnpc[key]) do
        if probability(v.probability) then
          if StoryCondition(v.Condition) then
            local kj
            if v.type == 1 then
              if savelay.kj[num] == nil then
                savelay.kj[num] = {}
                savelay.kj[num].key = loadlayout(
                {
                  FrameLayout;
                  {
                    RelativeLayout,--按钮控件otton;
                    id="框架";
                    layout_margin="0.7%w";
                    background="img/dtk.png";
                    layout_width="16%w";
                    layout_height="5%h";
                    gravity="center";
                  }
                })
                savelay.kj[num].value = loadlayout(
                {
                  TextView;
                }
                )
                框架.addView(savelay.kj[num].value)
              end
              savelay.kj[num].key.setVisibility(View.VISIBLE)
              savelay.kj[num].value.Text = v.text
              savelay.kj[num].value.TextColor = 0xFF00FF00
              kj = savelay.kj[num].key
              kj.onClick=function npc交互(v.key) end;
             elseif v.type == 2 then
              if savelay.kj[num] == nil then
                savelay.kj[num] = {}
                savelay.kj[num].key = loadlayout(
                {
                  FrameLayout;
                  {
                    RelativeLayout,--按钮控件otton;
                    id="框架";
                    layout_margin="0.7%w";
                    background="img/dtk.png";
                    layout_width="16%w";
                    layout_height="5%h";
                    gravity="center";
                  }
                })
                savelay.kj[num].value = loadlayout(
                {
                  TextView;
                }
                )
                框架.addView(savelay.kj[num].value)
              end
              savelay.kj[num].key.setVisibility(View.VISIBLE)
              savelay.kj[num].value.Text = v.text
              savelay.kj[num].value.TextColor = 0xFFFF0000
              kj = savelay.kj[num].key
              kj.onClick=function 怪物信息(v.key,kj) end;
             elseif v.type == 3 then
              if savelay.kj[num] == nil then
                savelay.kj[num] = {}
                savelay.kj[num].key = loadlayout(
                {
                  FrameLayout;
                  {
                    RelativeLayout,--按钮控件otton;
                    id="框架";
                    layout_margin="0.7%w";
                    background="img/dtk.png";
                    layout_width="16%w";
                    layout_height="5%h";
                    gravity="center";
                  }
                })
                savelay.kj[num].value = loadlayout(
                {
                  TextView;
                }
                )
                框架.addView(savelay.kj[num].value)
              end
              savelay.kj[num].key.setVisibility(View.VISIBLE)
              savelay.kj[num].value.Text = v.text
              savelay.kj[num].value.TextColor = 0xFF00FFFF
              kj = savelay.kj[num].key
              kj.onClick=function 采集信息(v.key,v.level,v.number,kj,v.price) end
            end
            if getwh(bj) < activity.getWidth()*0.7 then
              bj.addView(kj)
             elseif getwh(bj1) < activity.getWidth()*0.7 then
              bj1.addView(kj)
             else
              bj2.addView(kj)
            end
            num = num + 1
          end
        end
      end
    end
    if probability(0.01) then
      hs("http://82.157.62.200/qy.php?map="..key,function(code,body)
        local tb = cjson.decode(unicode2utf8(body))
        for k,v in pairs(tb) do
          if probability(tonumber(v.probability)) then
            if v.tj == nil or v.tj == "" or StoryCondition(cjson.decode(v.tj)) == true then
              hs("http://82.157.62.200/shanqi.php?id="..v.id,function(code,body)
                if code >= 200 and code <= 400 and body == "400" then
                  local kj
                  if v.type == "3" then
                    local hud
                    kj = loadlayout
                    {
                      FrameLayout;
                      {
                        FrameLayout,--按钮控件otton;
                        layout_margin="0.7%w";
                        background="img/dtk.png";
                        onClick=function
                          if hud ~= nil then
                            hud.dismiss()
                          end
                          local hudong ={
                            LinearLayout;
                            orientation="vertical";
                            layout_width="fill";
                            layout_height="fill";
                            {
                              LinearLayout;
                              orientation="vertical";
                              layout_width="match_parent";
                              layout_height="match_parent";
                              backgroundColor="#FFFFFF";
                              {
                                LinearLayout;
                                layout_width="match_parent";
                                layout_height="4%h";
                                backgroundColor="#000000";
                                {
                                  TextView;
                                  textSize=getsize(15);
                                  textColor="#FFFFFF";
                                  text="采集面板";
                                };
                              };
                              {
                                LinearLayout;
                                layout_width="match_parent";
                                layout_height="20%h";
                                {
                                  TextView;
                                  text="信息";
                                  textColor="#000000";
                                  id="信息";
                                };
                              };
                              {
                                LinearLayout;
                                orientation="horizontal";
                                layout_width="match_parent";
                                {
                                  CardView;
                                  onClick=function
                                    Item:Add(v.value,tonumber(v.number))
                                    kj.setVisibility(View.GONE)
                                    hud.dismiss()
                                    提示(Html.fromHtml("获得"..Color:Get(v.value,Item:GetLevel(v.value)).."*"..math.ceil(tonumber(v.number))))
                                  end;
                                  layout_width="13%w";
                                  layout_marginLeft="1%h";
                                  layout_height="4.5%h";
                                  backgroundColor="#000000";
                                  {
                                    LinearLayout;
                                    layout_width="match_parent";
                                    layout_height="match_parent";
                                    backgroundColor="#FFFFFF";
                                    layout_margin="0.4%w";
                                    {
                                      CardView;
                                      layout_width="match_parent";
                                      layout_height="match_parent";
                                      backgroundColor="#000000";
                                      layout_margin="0.4%w";
                                      {
                                        TextView;
                                        text="拾取";
                                        textColor="#FFFFFF";
                                        layout_gravity="center";
                                      };
                                    };
                                  };
                                };
                                {
                                  CardView;
                                  onClick=function hud.dismiss() end;
                                  layout_width="13%w";
                                  layout_marginLeft="33%h";
                                  layout_height="4.5%h";
                                  backgroundColor="#000000";
                                  {
                                    LinearLayout;
                                    layout_width="match_parent";
                                    layout_height="match_parent";
                                    backgroundColor="#FFFFFF";
                                    layout_margin="0.4%w";
                                    {
                                      CardView;
                                      layout_width="match_parent";
                                      layout_height="match_parent";
                                      backgroundColor="#000000";
                                      layout_margin="0.4%w";
                                      {
                                        TextView;
                                        text="离开";
                                        textColor="#FFFFFF";
                                        layout_gravity="center";
                                      };
                                    };
                                  };
                                };
                              };
                            };
                          };
                          hud = AlertDialog.Builder(this).show()
                          hud.getWindow().setContentView(loadlayout(hudong));
                          信息.Text=v.info
                        end;
                        layout_width="16%w";
                        layout_height="5%h";
                        {
                          TextView;
                          layout_gravity="center";
                          text=Html.fromHtml(Color:Get(v.text,Item:GetLevel(v.value)));
                        };
                      };
                    }
                   elseif v.type == "4" then
                    local hud
                    kj = loadlayout
                    {
                      FrameLayout;
                      {
                        FrameLayout,--按钮控件otton;
                        layout_margin="0.7%w";
                        background="img/dtk.png";
                        onClick=function
                          if hud ~= nil then
                            hud.dismiss()
                          end
                          local hudong ={
                            LinearLayout;
                            orientation="vertical";
                            layout_width="fill";
                            layout_height="fill";
                            {
                              LinearLayout;
                              orientation="vertical";
                              layout_width="match_parent";
                              layout_height="match_parent";
                              backgroundColor="#FFFFFF";
                              {
                                LinearLayout;
                                layout_width="match_parent";
                                layout_height="4%h";
                                backgroundColor="#000000";
                                {
                                  TextView;
                                  textSize=getsize(15);
                                  textColor="#FFFFFF";
                                  text="采集面板";
                                };
                              };
                              {
                                LinearLayout;
                                layout_width="match_parent";
                                layout_height="20%h";
                                {
                                  TextView;
                                  text="信息";
                                  textColor="#000000";
                                  id="信息";
                                };
                              };
                              {
                                LinearLayout;
                                orientation="horizontal";
                                layout_width="match_parent";
                                {
                                  CardView;
                                  onClick=function
                                    if type(v.data) == "string" then
                                      v.data = cjson.decode(v.data)
                                    end
                                    table.insert(SaveTable.Item,v.data)
                                    kj.setVisibility(View.GONE)
                                    hud.dismiss()
                                    提示(Html.fromHtml("获得"..Color:Get(v.data.key,Item:GetLevel(v.data.key)).."*"..math.ceil(tonumber(v.number))))
                                  end;
                                  layout_width="13%w";
                                  layout_marginLeft="1%h";
                                  layout_height="4.5%h";
                                  backgroundColor="#000000";
                                  {
                                    LinearLayout;
                                    layout_width="match_parent";
                                    layout_height="match_parent";
                                    backgroundColor="#FFFFFF";
                                    layout_margin="0.4%w";
                                    {
                                      CardView;
                                      layout_width="match_parent";
                                      layout_height="match_parent";
                                      backgroundColor="#000000";
                                      layout_margin="0.4%w";
                                      {
                                        TextView;
                                        text="拾取";
                                        textColor="#FFFFFF";
                                        layout_gravity="center";
                                      };
                                    };
                                  };
                                };
                                {
                                  CardView;
                                  onClick=function hud.dismiss() end;
                                  layout_width="13%w";
                                  layout_marginLeft="33%h";
                                  layout_height="4.5%h";
                                  backgroundColor="#000000";
                                  {
                                    LinearLayout;
                                    layout_width="match_parent";
                                    layout_height="match_parent";
                                    backgroundColor="#FFFFFF";
                                    layout_margin="0.4%w";
                                    {
                                      CardView;
                                      layout_width="match_parent";
                                      layout_height="match_parent";
                                      backgroundColor="#000000";
                                      layout_margin="0.4%w";
                                      {
                                        TextView;
                                        text="离开";
                                        textColor="#FFFFFF";
                                        layout_gravity="center";
                                      };
                                    };
                                  };
                                };
                              };
                            };
                          };
                          hud = AlertDialog.Builder(this).show()
                          hud.getWindow().setContentView(loadlayout(hudong));
                          信息.Text=v.info
                        end;
                        layout_width="16%w";
                        layout_height="5%h";
                        {
                          TextView;
                          layout_gravity="center";
                          text=Html.fromHtml(Color:Get(v.text,Item:GetLevel(v.value)));
                        };
                      };
                    }
                  end
                  if getwh(bj) < activity.getWidth()*0.7 then
                    bj.addView(kj)
                   elseif getwh(bj1) < activity.getWidth()*0.7 then
                    bj1.addView(kj)
                   else
                    bj2.addView(kj)
                  end
                end
              end)
            end
          end
        end
      end)
    end
    项目1.addView(bj)
    项目2.addView(bj1)
    项目3.addView(bj2)
    SaveTable.map = key
    if type(story) == "table" then
      if story.round == -1 then
        文字动画(story.key,1)
      end
    end
  end
  local index
  if map[key].battle ~= nil then
    for k,v in pairs(map[key].battle) do
      if probability(v) then
        index = k
        break
      end
    end
  end
  if bl ~= true then
    local str
    loadsavewrite(0)
    if index ~= nil then
      载入战斗(index)
      MD提示("遭遇怪物袭击。")
     else
      载入地图()
    end
   else
    if index ~= nil then
      if story == 1 then
        载入地图()
       elseif story == nil then
        载入战斗(index)
        MD提示("遭遇怪物袭击。")
       else
        载入地图()
      end
     else
      载入地图()
    end
  end
end

function 采集信息(key,level,num,Id,price)
  if hd ~= nil then
    hd.dismiss()
  end
  local str
  if key == "药草" then
    str = "这里有一些药草"
   elseif key == "矿产" then
    str = "这里有一些矿产"
   elseif key == "灵泉" then
    str = "这里有一些灵泉，饮用后可以回复少许神念"
   elseif key == "杂物" then
    local tab = {{}}
    str = "这里有一个储物袋，似乎是某位修士的遗物..."
   else
    str = Html.fromHtml("这里有一些"..Color:Get(key,Item:GetLevel(key)))
  end
  local hudong ={
    LinearLayout;
    orientation="vertical";
    layout_width="fill";
    layout_height="fill";
    {
      LinearLayout;
      orientation="vertical";
      layout_width="match_parent";
      layout_height="match_parent";
      backgroundColor="#FFFFFF";
      {
        LinearLayout;
        layout_width="match_parent";
        layout_height="4%h";
        backgroundColor="#000000";
        {
          TextView;
          textSize=getsize(15);
          textColor="#FFFFFF";
          text="采集面板";
        };
      };
      {
        LinearLayout;
        layout_width="match_parent";
        layout_height="20%h";
        {
          TextView;
          text="人物信息";
          textColor="#000000";
          id="人物信息";
        };
      };
      {
        LinearLayout;
        orientation="horizontal";
        layout_width="match_parent";
        {
          CardView;
          onClick=function
            hd.dismiss()
            if key == "药草" then
              local tb = {}
              for k,v in pairs(Item) do
                if type(v) == "table" then
                  if v.type == 10 and v["品质"] == level then
                    if v.pro ~= nil then
                      if probability(v.pro) then
                        table.insert(tb,v.key)
                      end
                     else
                      table.insert(tb,v.key)
                    end
                  end
                end
              end
              local num1 = math.random(num[1],num[2])
              local num2 = math.random(1,#tb)
              Item:Add(tb[num2],num1)
              MD提示(Html.fromHtml("获得物品"..Color:Get(tb[num2],Item:GetLevel(tb[num2])).."*"..math.ceil(num1)))
             elseif key == "杂物" then
              local tab = {{type={-1,-2,0,0,1,1,2,2,3,3,4,4,5,5},number=7000},{type={6},number=9000},{type={7,9},number=10000}}
              local num = math.random(1,10000)
              local idx
              for k,v in pairs(tab) do
                if num < v.number then
                  idx = v.type
                  break
                end
              end
              local num1 = idx[math.random(1,#idx)]
              local tap = {}
              for k,v in pairs(Item) do
                if type(v) == "table" then
                  if v.type == num1 and v["品质"] == level then
                    if v.pro ~= nil then
                      if probability(v.pro) then
                        table.insert(tap,v)
                      end
                     else
                      table.insert(tap,v)
                    end
                  end
                end
              end
              local key1 = tap[math.random(1,#tap)]
              local num2 = 1
              if num1 <= 5 then
                Item:Add(key1.key,1,{30,120})
               elseif num1 == 6 then
                num2 = math.floor(price/key1.price)
                if num2 < 1 then
                  num2 = 1
                end
                Item:Add(key1.key,num2)
               else
                Item:Add(key1.key,num2)
              end
              MD提示(Html.fromHtml("获得物品"..Color:Get(key1.key,key1["品质"]).."*"..num2))
             elseif key == "矿产" then
              local tb = {}
              for k,v in pairs(Item) do
                if type(v) == "table" then
                  if v.type == 11 and v["品质"] == level then
                    if v.pro ~= nil then
                      if probability(v.pro) then
                        table.insert(tb,v.key)
                      end
                     else
                      table.insert(tb,v.key)
                    end
                  end
                end
              end
              local num1 = math.random(num[1],num[2])
              local num2 = math.random(1,#tb)
              Item:Add(tb[num2],num1)
              MD提示(Html.fromHtml("获得物品"..Color:Get(tb[num2],Item:GetLevel(tb[num2])).."*"..math.ceil(num1)))
             elseif key == "灵泉" then
              local num1 = math.random(num[1],num[2])
              SaveTable.owner["神念"] = SaveTable.owner["神念"] + num1
              if SaveTable.owner["神念"] > SaveTable.owner["神念上限"] then
                SaveTable.owner["神念"] = SaveTable.owner["神念上限"]
              end
              MD提示("神念回复了"..math.ceil(num1).."点")
             else
              local num1 = math.random(num[1],num[2])
              Item:Add(key,num1)
              MD提示(Html.fromHtml("获得物品"..Color:Get(key,Item:GetLevel(key)).."*"..math.ceil(num1)))
            end
            Id.setVisibility(View.GONE)
            loadsavewrite(0)
          end;
          layout_width="13%w";
          layout_marginLeft="1%h";
          layout_height="4.5%h";
          backgroundColor="#000000";
          {
            LinearLayout;
            layout_width="match_parent";
            layout_height="match_parent";
            backgroundColor="#FFFFFF";
            layout_margin="0.4%w";
            {
              CardView;
              layout_width="match_parent";
              layout_height="match_parent";
              backgroundColor="#000000";
              layout_margin="0.4%w";
              {
                TextView;
                text="采集";
                textColor="#FFFFFF";
                layout_gravity="center";
              };
            };
          };
        };
        {
          CardView;
          onClick=function hd.dismiss() end;
          layout_width="13%w";
          layout_marginLeft="33%h";
          layout_height="4.5%h";
          backgroundColor="#000000";
          {
            LinearLayout;
            layout_width="match_parent";
            layout_height="match_parent";
            backgroundColor="#FFFFFF";
            layout_margin="0.4%w";
            {
              CardView;
              layout_width="match_parent";
              layout_height="match_parent";
              backgroundColor="#000000";
              layout_margin="0.4%w";
              {
                TextView;
                text="离开";
                textColor="#FFFFFF";
                layout_gravity="center";
              };
            };
          };
        };
      };
    };
  };
  hd = AlertDialog.Builder(this).show()
  hd.getWindow().setContentView(loadlayout(hudong));
  人物信息.Text=str
end

function 怪物信息(key,Id)
  if hd ~= nil then
    hd.dismiss()
  end
  local hudong = savelay.gw
  hd = popyes(hudong)
  gwxin.Text=mst[key].info
  zrzd.onClick=function
    Id.setVisibility(View.GONE)
    hd.dismiss()
    载入战斗(key,nil)
  end
  gwlk.onClick=function hd.dismiss() end;
end

function npc交互(key)
  if hd ~= nil then
    hd.dismiss()
  end
  function npcatt()
    local tb = npc[key]
    tb.Attribute=Item:GetTirgger(tb)
    loadsx(tb)
  end
  local rw
  function 接取任务()
    if SaveTable.Task == nil then
      SaveTable.Task = {}
    end
    local Task = import "Task"
    hd.dismiss()
    local function hastask()
      local tb = {}
      for k,v in pairs(npc[key].Task) do
        if con(v["条件"]) == true then
          if v.round == -1 then
            table.insert(tb,v)
           elseif SaveTable.finishtask == nil or SaveTable.finishtask[v.key] == nil or SaveTable.finishtask[v.key] < v.round then
            table.insert(tb,v)
          end
        end
      end
      return tb
    end
    local function 更新任务面板(tb,n)
      任务取消.onClick=function
        rw.dismiss()
      end
      local tsk = Task[tb[n].key]
      任务内容.Text="任务内容:"..tsk.info
      local str="任务目标:<br>"
      local br = true
      for k,v in pairs(tsk["任务目标"]) do
        if v.type == 0 then
          if SaveTable["击杀"] == nil then
            SaveTable["击杀"] = {}
          end
          if SaveTable["击杀"][v.key] == nil then
            SaveTable["击杀"][v.key] = 0
          end
          local num = math.ceil(SaveTable["击杀"][v.key])
          if num < v.number then
            br=false
            num = Color:Get(math.ceil(num),7)
          end
          str=table.concat({str,v.key,":",num,"/",v.number,"<br>"})
         elseif v.type == 1 then
          local num = math.ceil(Itnum(v.key))
          if num < v.number then
            br=false
            num = Color:Get(math.ceil(num),7)
          end
          str=table.concat({str,"收集",Color:Get(v.key,Item:GetLevel(v.key)),":",num,"/",v.number,"<br>"})
        end
      end
      任务目标.Text=Html.fromHtml(str)
      str="任务奖励:<br>"
      local Item = import "item"
      for k,v in pairs(tsk["任务奖励"].item) do
        str=table.concat({str,Color:Get(v.key,Item:GetLevel(v.key)),"*",v.number,"<br>"})
      end
      if tsk["任务奖励"]["修为"] ~= nil then
        str=table.concat({str,"修为*",tsk["任务奖励"]["修为"],"<br>"})
      end
      if tsk["任务奖励"]["money"] ~= nil then
        str=table.concat({str,"灵石*",tsk["任务奖励"]["money"],"<br>"})
      end
      if tsk["任务奖励"]["战功"] ~= nil then
        str=table.concat({str,"战功*",tsk["任务奖励"]["战功"],"<br>"})
      end
      任务奖励.Text=Html.fromHtml(str)
      if SaveTable.Task[tb[n].key] ~= nil then
        if br == true then
          任务接取.Text="完成"
          任务接取.onClick=function
            if SaveTable.finishtask == nil then
              SaveTable.finishtask = {}
            end
            if SaveTable.finishtask[tb[n].key] ~= nil then
              SaveTable.finishtask[tb[n].key] = SaveTable.finishtask[tb[n].key] + 1
             else
              SaveTable.finishtask[tb[n].key] = 1
            end
            for k,v in pairs(tsk["任务奖励"].item) do
              Item:Add(v.key,v.number)
              提示(Html.fromHtml("获得"..Color:Get(v.key,Item:GetLevel(v.key)).."*"..v.number))
            end
            if tsk["任务奖励"]["修为"] ~= nil then
              SaveTable.owner["修为"] = SaveTable.owner["修为"] + tsk["任务奖励"]["修为"]
              提示("修为提升"..tsk["任务奖励"]["修为"].."点")
            end
            if tsk["任务奖励"]["money"] ~= nil then
              SaveTable.owner["money"] = SaveTable.owner["money"] + tsk["任务奖励"]["money"]
              提示("获得灵石"..tsk["任务奖励"]["money"].."块")
            end
            if tsk["任务奖励"]["战功"] ~= nil then
              SaveTable["战功"] = SaveTable["战功"] + tsk["任务奖励"]["战功"]
              提示("获得战功"..tsk["任务奖励"]["战功"])
            end
            for k,v in pairs(tsk["任务目标"]) do
              if v.type == 0 then
                SaveTable["击杀"][v.key]=SaveTable["击杀"][v.key]-v.number
                if tb[n].round ~= -1 then
                  if SaveTable.finishtask[tb[n].key] >= tb[n].round then
                    SaveTable["击杀"][v.key] = nil
                  end
                end
               elseif v.type == 1 then
                删除物品(v.key,v.number)
              end
            end
            SaveTable.Task[tb[n].key]=nil
            提示("任务已完成")
            if tb[n].story ~= nil then
              if tb[n].story.finish ~= nil then
                文字动画(tb[n].story.finish,1)
              end
            end
            更新任务面板(tb,n)
            if tb[n].round ~= -1 then
              if SaveTable.finishtask[tb[n].key] >= tb[n].round then
                rw.dismiss()
              end
            end
            loadsavewrite()
          end
         else
          任务接取.onClick=function
            SaveTable.Task[tb[n].key]=nil
            MD提示("任务已放弃")
            更新任务面板(tb,n)
          end
          任务接取.Text="放弃"
        end
       else
        任务接取.Text="接取"
        任务接取.onClick=function
          SaveTable.Task[tb[n].key]=true
          if tb[n].story ~= nil then
            if tb[n].story.get ~= nil then
              文字动画(tb[n].story.get,1)
            end
          end
          MD提示("成功接取任务")
          更新任务面板(tb,n)
        end
      end
    end
    if npc[key].Task ~= nil and #hastask() ~= 0 then
      if rw ~= nil then
        rw.dismiss()
      end
      rw=PopupWindow(activity)--创建PopWindow
      rw.setContentView(loadlayout(MapUI()["任务面板"]))--设置布局
      rw.setWidth(activity.Width*0.9)--设置宽度
      rw.setHeight(-2)--设置高度
      rw.setFocusable(true)--设置可获得焦点
      rw.getBackground().setAlpha(0)
      rw.setTouchable(true)--设置可触摸
      --设置点击外部区域是否可以消失
      rw.setOutsideTouchable(false)
      --显示
      rw.showAtLocation(view,Gravity.CENTER,0,0)
      local item= {
        FrameLayout;
        layout_height="3.5%h";
        layout_width="match_parent";
        {
          FrameLayout;
          layout_height="match_parent";
          layout_width="match_parent";
          layout_margin="0.4%w";
          backgroundColor="#000000";
          {
            FrameLayout;
            layout_height="match_parent";
            layout_width="match_parent";
            layout_margin="0.4%w";
            backgroundColor="#FFFFFF";
            {
              TextView;
              layout_gravity="center";
              id="text";
            };
          };
        };
      };
      local data = {}
      local adapter=LuaAdapter(activity,data,item)
      for k,v in pairs(hastask()) do
        adapter.add({text=v.key})
      end
      任务.Adapter=adapter
      发布人.Text="发布人:"..key
      更新任务面板(hastask(),1)
      任务.onItemClick=function(l,v,p,i)
        更新任务面板(hastask(),i)
      end
     else
      MD提示("没有可接取的任务")
    end
  end
  local hudong ={
    LinearLayout;
    orientation="vertical";
    layout_width="fill";
    layout_height="fill";
    {
      LinearLayout;
      orientation="vertical";
      layout_width="match_parent";
      layout_height="match_parent";
      backgroundColor="#FFFFFF";
      {
        LinearLayout;
        layout_width="match_parent";
        layout_height="4%h";
        backgroundColor="#000000";
        {
          TextView;
          textSize=getsize(15);
          textColor="#FFFFFF";
          text="交互面板";
        };
      };
      {
        LinearLayout;
        layout_width="match_parent";
        layout_height="20%h";
        {
          TextView;
          text="人物信息";
          textColor="#000000";
          id="人物信息";
        };
      };
      {
        LinearLayout;
        orientation="horizontal";
        layout_width="match_parent";
        {
          CardView;
          layout_width="13%w";
          layout_marginLeft="1%h";
          layout_height="4.5%h";
          backgroundColor="#000000";
          {
            LinearLayout;
            layout_width="match_parent";
            layout_height="match_parent";
            backgroundColor="#FFFFFF";
            layout_margin="0.4%w";
            {
              CardView;
              layout_width="match_parent";
              layout_height="match_parent";
              backgroundColor="#000000";
              layout_margin="0.4%w";
              {
                TextView;
                id="交互";
                text="交流";
                textColor="#FFFFFF";
                layout_gravity="center";
              };
            };
          };
        };
        {
          CardView;
          onClick=function npcatt(tb) end;
          layout_width="13%w";
          layout_marginLeft="13.2%h";
          layout_height="4.5%h";
          backgroundColor="#000000";
          {
            LinearLayout;
            layout_width="match_parent";
            layout_height="match_parent";
            backgroundColor="#FFFFFF";
            layout_margin="0.4%w";
            {
              CardView;
              layout_width="match_parent";
              layout_height="match_parent";
              backgroundColor="#000000";
              layout_margin="0.4%w";
              {
                TextView;
                text="信息";
                textColor="#FFFFFF";
                layout_gravity="center";
              };
            };
          };
        };
        {
          CardView;
          onClick=function 接取任务() end;
          layout_width="13%w";
          layout_marginLeft="13.2%h";
          layout_height="4.5%h";
          backgroundColor="#000000";
          {
            LinearLayout;
            layout_width="match_parent";
            layout_height="match_parent";
            backgroundColor="#FFFFFF";
            layout_margin="0.4%w";
            {
              CardView;
              layout_width="match_parent";
              layout_height="match_parent";
              backgroundColor="#000000";
              layout_margin="0.4%w";
              {
                TextView;
                text="任务";
                textColor="#FFFFFF";
                layout_gravity="center";
              };
            };
          };
        };
      };
    };
  };
  hd = AlertDialog.Builder(this).show()
  hd.getWindow().setContentView(loadlayout(hudong));
  人物信息.Text=npc[key].info
  if npc[key].shop ~= nil then
    交互.Text="购买"
    交互.onClick=function
      shopshow(npc[key].shop)
      hd.dismiss()
    end
  end
end