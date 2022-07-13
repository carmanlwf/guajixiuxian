require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "http"

local cjson=import "cjson"

local Skill = import "skill"
local Inskill = import "inskill"
local exp = import "skillexp"

function shulian(lv)
  local x,y
  if lv > 32 then
    x = "大乘期"
    y = 50
   elseif lv > 28 then
    x = "合体期"
    y = 30
   elseif lv > 24 then
    x = "化神期"
    y = 20
   elseif lv > 20 then
    x = "元婴期"
    y = 15
   elseif lv > 16 then
    x = "金丹期"
    y = 10
   elseif lv > 12 then
    x = "筑基期"
    y = 5
   else
    x = "炼气期"
    y = 2
  end
  return x,y
end

function GetInSkillLevel(key,inskilllist)
  local x = 1
  local lv
  local id
  local inskilllist = inskilllist or SaveTable.owner.inskill
  repeat
  if key == inskilllist[x].key then
    lv = inskilllist[x].level
    id = x
    break
   else
    x = x + 1
  end
  until x > #inskilllist
  return lv,id
end

function Skill:RollSkill(key,lv,e,eq)
  local x = 1
  local tab = {}
  repeat
  if key == self[x].key then
    for k,v in pairs(self[x]) do
      tab[k] = v
    end
    tab.level = lv
    tab.exp = e
    tab.eq = eq
    tab.Cd = 0
    break
   else
    x = x + 1
  end
  until x > #self
  return tab
end

function Skill:GetPinzhi(key)
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

function AddSkillExp(key,num,p,self)
  local x = 1
  local self = self or SaveTable.owner.skill
  p = p or Skill:GetPinzhi(key)
  repeat
  if key == self[x].key then
    self[x].exp = self[x].exp + num
    if tonumber(exp[p][self[x].level]) then
      while self[x].exp >= exp[p][self[x].level] do
        self[x].exp = self[x].exp - exp[p][self[x].level]
        self[x].level = self[x].level + 1
      end
    end
    break
   else
    x = x + 1
  end
  until x > #self
end

function Skill:GetSkillBox(skillbox)
  local t = {}
  for k,v in pairs(skillbox)
    local tb = self:RollSkill(v.key,v.level,v.exp,v.eq)
    table.insert(t,tb)
  end
  return t
end

function Inskill:RollinSkill(key,lv,e)
  local x = 1
  local tab = {}
  repeat
  if key == self[x].key then
    for k,v in pairs(self[x]) do
      tab[k] = v
    end
    if lv ~= nil then
      tab.level = lv
    end
    if e ~= nil then
      tab.exp = e
    end
    break
   else
    x = x + 1
  end
  until x > #self
  return tab
end

function Inskill:GetinSkillBox(inskillbox)
  local t = {}
  for k,v in pairs(inskillbox)
    local tb = self:RollinSkill(v.key,v.level,v.exp)
    table.insert(t,tb)
  end
  return t
end

function OpenSkillMenu(menu,inskilllist,skilllist,blar)
  import"android.graphics.drawable.ColorDrawable"
  local a=AlertDialog.Builder(this).show()
  a.getWindow().setContentView(loadlayout(MapUI()["功法菜单"]));

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
  function SkillMenuShow(menu,inskilllist,skilllist)
    local its = {
      LinearLayout;
      layout_height="fill";
      layout_width="fill";
      {
        CardView;
        cardBackgroundColor="#FFF7F7F7";
        layout_gravity="center";
        layout_height="45dp";
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
    a.dismiss()
    a=PopupWindow(activity)--创建PopWindow
    a.setContentView(loadlayout(MapUI()["法术菜单"]))--设置布局
    a.setWidth(activity.Width*0.92)--设置宽度
    a.setHeight(-2)--设置高度
    a.setFocusable(true)--设置可获得焦点
    a.getBackground().setAlpha(0)
    a.setTouchable(true)--设置可触摸
    --设置点击外部区域是否可以消失
    a.setOutsideTouchable(false)
    --显示
    a.showAtLocation(view,Gravity.CENTER,0,0)
    local data1
    local 品阶 = {"黄阶初级","黄阶中级","黄阶高级","玄阶初级","玄阶中级","玄阶高级","地阶初级","地阶中级","地阶高级","天阶初级","天阶中级","天阶高级","仙术"}
    local data={}
    local adp=LuaAdapter(activity,data,its)
    法术列表.Adapter=adp
    local skilllist = skilllist or SaveTable.owner.skill
    local SkillBox = Skill:GetSkillBox(skilllist)
    local f
    for k,v in pairs(SkillBox) do
      if v.eq == 1 then
        table.insert(data,{name=Color:Set(v.key.."["..品阶[v["品质"]].."][已装备]",v["品质"])})
       else
        table.insert(data,{name=Color:Set(v.key.."["..品阶[v["品质"]].."][未装备]",v["品质"])})
      end
    end
    if #SkillBox == 0 then
      table.insert(data,{name="未修习法术"})
    end
    法术.onClick=function SkillMenuShow("法术面板",inskilllist,skilllist) end
    功法.onClick=function InSkillMenuShow("功法面板",inskilllist,skilllist) end
    if #SkillBox > 0 then
      法术列表.onItemClick=function(l,v,p,i)
        local jm = {}
        for k,v in pairs(MapUI()["法术面板"]) do
          jm[k] = v
        end
        local b=AlertDialog.Builder(this).show()
        b.getWindow().setContentView(loadlayout(jm));
        for k,v in pairs(SkillBox[i].updata) do
          local file = "法术修炼至"..math.ceil(v.level).."重"
          for n,m in pairs(v.Attribute) do
            if n == "会心伤害" or n == "会心免伤" or n == "最终伤害放大" or n == "最终伤害抵消" or string.find(n,"基础") then
              file=file..",提升"..n..m.."%"
             elseif n=="气血上限" then
              file=file..",提升气血上限"..m
             elseif n=="法力上限" then
              file=file..",提升法力上限"..m
             else
              file=file..",提升"..n..m.."点"
            end
          end
          if SkillBox[i].level >= v.level then
            file=file.."[已达成]"
            local lt = {
              TextView;
              textSize=getsize(10);
              text=file;
              textColor="#000000";
            };
            法术特效.addView(loadlayout(lt))
           else
            file=file.."[未达成]"
            local lt = {
              TextView;
              textSize=getsize(10);
              text=file;
              textColor="#C6C6C6";
            };
            法术特效.addView(loadlayout(lt))
          end
        end
        if not blar then
          法术面板.addView(loadlayout{
            LinearLayout;
            orientation="vertical";
            layout_height="fill";
            layout_width="fill";
            {
              Button;
              text="装备";
              id="装备法术";
            };
            {
              Button;
              text="修炼";
              id="修炼法术";
              onClick=function 修炼法术() end;
            };
            {
              Button;
              text="遗忘";
              id="遗忘法术";
              onClick=function 遗忘法术() end;
            };
          })
          if (SaveTable.owner["修炼法术"] ~= nil and SaveTable.owner["修炼法术"].key == SkillBox[i].key) then
            修炼法术.Text="结束"
          end
        end
        local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中"}
        法术名称.Text=Color:Set(SkillBox[i].key.."["..品阶[SkillBox[i]["品质"]].."]",SkillBox[i]["品质"])
        法术消耗.Text=Color:Set("法力消耗:"..math.ceil(SkillBox[i].cost * ((SkillBox[i].step + 1) ^ SkillBox[i].level)),SkillBox[i]["品质"])
        法术等级.Text=Color:Get("当前已修炼至第"..math.ceil(SkillBox[i].level).."重",SkillBox[i]["品质"])
        if SkillBox[i].level >= 10 then
          法术特效.removeViews(3,1)
          法术等级.Text=法术等级.Text..Color:Get("(已满级)",SkillBox[i]["品质"])
         else
          法术熟练.Text=Color:Set("当前熟练度:"..math.ceil(SkillBox[i].exp).."/"..exp[SkillBox[i]["品质"]][SkillBox[i].level],SkillBox[i]["品质"])
        end
        法术等级.Text=Html.fromHtml(法术等级.Text)
        法术介绍.Text=SkillBox[i].Info.."\n"
        法术参数.Text="外攻伤害:"..SkillBox[i].outpow*((1+SkillBox[i].step)^SkillBox[i].level)*100 .."%  \t内攻伤害:"..SkillBox[i].inpow*((1+SkillBox[i].step)^SkillBox[i].level)*100 .."%\n攻击范围:"..SkillBox[i].hit.."\t  CD:"..SkillBox[i].Cd.."/"..SkillBox[i].MaxCd
        if (SkillBox[i].eq == 0 and not blar) then
          装备法术.Text="装备"
         elseif (战斗停止 and 装备法术 ~= nil) then
          装备法术.Text="卸下"
        end
        local str = "法术属性:\n"
        for k,v in pairs(tab) do
          if SkillBox[i][v] then
            if v == "会心伤害" or v == "会心免伤" or v == "最终伤害放大" or v == "最终伤害抵消" or string.find(v,"基础") then
              str=str.."提升"..v..math.ceil(SkillBox[i][v]*((1+SkillBox[i].step)^SkillBox[i].level)).."%\n"
             elseif v=="气血上限" then
              str=str.."提升气血上限"..math.ceil(inSkillBox[i][v]*((1+inSkillBox[i].step)^inSkillBox[i].level)).."点\n"
             elseif v=="法力上限" then
              str=str.."提升法力上限"..math.ceil(inSkillBox[i][v]*((1+inSkillBox[i].step)^inSkillBox[i].level)).."点\n"
             else
              str=str.."提升"..v..math.ceil(SkillBox[i][v]*((1+SkillBox[i].step)^SkillBox[i].level)).."点\n"
            end
          end
        end
        法术属性.Text = str
        if skilllist == SaveTable.owner.skill and not blar then
          function 装备法术.onClick()
            if SkillBox[i].eq == 1 then
              SaveTable.owner.skill[i].eq = 0
              b.dismiss()
              a.dismiss()
              SkillMenuShow()
              MD提示(SkillBox[i].key.."已被卸下!")
             else
              SaveTable.owner.skill[i].eq = 1
              b.dismiss()
              a.dismiss()
              SkillMenuShow()
              MD提示(SkillBox[i].key.."已装备!")
            end
          end
        end
        function 遗忘法术()
          AlertDialog.Builder(this)
          .setTitle("确认")
          .setMessage("确定要遗忘该法术吗？")
          .setPositiveButton("取消",nil)
          .setNegativeButton("确认",function table.remove(SaveTable.owner.skill,i) a.dismiss()
          b.dismiss() loadsavewrite() MD提示(Html.fromHtml(Color:Get(SkillBox[i].key,SkillBox[i]["品质"]).."已被移除!")) end)
          .show();
        end
        function 修炼法术()
          if SaveTable.owner["修炼法术"] == nil or HasSkill(SaveTable.owner["修炼法术"].key) == false then
            Http.get("http://api.k780.com/?app=life.time&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json",nil,nil,nil,function(q,w,e,r)
              local time = cjson.decode(w)["result"]["timestamp"]
              local x,y = shulian(SaveTable.owner.level)
              SaveTable.owner["修炼法术"] = {key=SkillBox[i].key,t=time}
              MD提示(Html.fromHtml("成功修炼"..Color:Get(SkillBox[i].key,SkillBox[i]["品质"]).."，当前为"..x..",每秒获取熟练度"..y.."点!"))
              b.dismiss()
              loadsavewrite()
            end)
           elseif SaveTable.owner["修炼法术"].key == SkillBox[i].key then
            Http.get("http://api.k780.com/?app=life.time&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json",nil,nil,nil,function(q,w,e,r)
              if SaveTable.owner["修炼法术"] ~= nil then
                local time = cjson.decode(w)["result"]["timestamp"] - SaveTable.owner["修炼法术"].t
                local x,y = shulian(SaveTable.owner.level)
                local ts = math.ceil(y * time)
                AddSkillExp(SaveTable.owner["修炼法术"].key,ts)
                MD提示(Html.fromHtml("修炼结束，"..Color:Get(SkillBox[i].key,SkillBox[i]["品质"]).."熟练值增加"..ts.."点!"))
                SaveTable.owner["修炼法术"] = nil
                a.dismiss()
                b.dismiss()
                loadsavewrite()
              end
            end)
           else
            local pz = Skill:GetPinzhi(SaveTable.owner["修炼法术"].key)
            MD提示(Html.fromHtml("请先结束"..Color:Get(SaveTable.owner["修炼法术"].key,pz).."的修炼!"))
          end
        end
      end
    end
  end

  function InSkillMenuShow(menu,inskilllist,skilllist)
    local its = {
      LinearLayout;
      layout_height="fill";
      layout_width="fill";
      {
        CardView;
        cardBackgroundColor="#FFF7F7F7";
        layout_gravity="center";
        layout_height="45dp";
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
    a.dismiss()
    a=PopupWindow(activity)--创建PopWindow
    a.setContentView(loadlayout(MapUI()["功法菜单"]))--设置布局
    a.setWidth(activity.Width*0.92)--设置宽度
    a.setHeight(-2)--设置高度
    a.setFocusable(true)--设置可获得焦点
    a.getBackground().setAlpha(0)
    a.setTouchable(true)--设置可触摸
    --设置点击外部区域是否可以消失
    a.setOutsideTouchable(false)
    --显示
    a.showAtLocation(view,Gravity.CENTER,0,0)
    local 品阶 = {"黄阶初级","黄阶中级","黄阶高级","玄阶初级","玄阶中级","玄阶高级","地阶初级","地阶中级","地阶高级","天阶初级","天阶中级","天阶高级","仙经"}
    local data={}
    local adp=LuaAdapter(activity,data,its)
    功法列表.Adapter=adp
    local inskilllist = inskilllist or SaveTable.owner.inskill
    local inSkillBox = Inskill:GetinSkillBox(inskilllist)
    for k,v in pairs(inSkillBox) do
      table.insert(data,{name=Color:Set(v.key.."["..品阶[v["品质"]].."]",v["品质"])})
    end
    if #data == 0 then
      table.insert(data,{name="未修习心法"})
    end
    法术.onClick=function SkillMenuShow("法术面板",inskilllist,skilllist) end
    功法.onClick=function InSkillMenuShow("功法面板",inskilllist,skilllist) end
    local menu = menu or "功法面板"
    if #inSkillBox > 0 then
      功法列表.onItemClick=function(l,v,p,i)
        local jm = {}
        for k,v in pairs(MapUI()[menu]) do
          jm[k] = v
        end
        local b=AlertDialog.Builder(this).show()
        b.getWindow().setContentView(loadlayout(jm));
        function 功法UI()
          功法修炼.removeAllViews()
          功法修炼.addView(loadlayout {
            CardView;
            backgroundColor="#000000";
            layout_height="5%h";
            layout_width="fill";
            {
              TextView;
              text="功法面板";
              textSize=getsize(18);
              textColor="#FFFFFF";
            };
          })
          功法修炼.addView(loadlayout
          {
            LinearLayout;
            id="功法面板";
            orientation="horizontal";
            layout_height="fill";
            layout_width="fill";
            {
              LinearLayout;
              id="功法特效";
              orientation="vertical";
              layout_height="fill";
              layout_width="70%w";
              {
                TextView;
                text="功法名称";
                textSize=getsize(10);
                id="功法名称";
              };
              {
                TextView;
                text="功法等级";
                textSize=getsize(10);
                id="功法等级";
              };
              {
                TextView;
                text="功法熟练";
                textSize=getsize(10);
                id="功法熟练";
              };
              {
                TextView;
                text="功法效率";
                textSize=getsize(10);
                id="功法效率";
              };
              {
                TextView;
                text="功法介绍";
                textSize=getsize(10);
                id="功法介绍";
              };
              {
                TextView;
                text="功法属性";
                textSize=getsize(10);
                id="功法属性";
                textColor="#000000";
              };
              {
                TextView;
                text="功法特性:";
                textSize=getsize(10);
                id="功法特性";
                textColor="#000000";
              };
            };
          })
          for k,v in pairs(inSkillBox[i].updata) do
            local file = "功法修炼至"..math.ceil(v.level).."重"
            for n,m in pairs(v.Attribute) do
              if n == "会心伤害" or n == "会心免伤" or n == "最终伤害放大" or n == "最终伤害抵消" or string.find(n,"基础") then
                file=file..",提升"..n..m.."%"
               elseif n=="气血上限" then
                file=file..",提升气血上限"..m
               elseif n=="法力上限" then
                file=file..",提升法力上限"..m
               else
                file=file..",提升"..n..m.."点"
              end
            end
            if inSkillBox[i].level >= v.level then
              file=file.."[已达成]"
              local lt = {
                TextView;
                textSize=getsize(10);
                text=file;
                textColor="#000000";
              };
              功法特效.addView(loadlayout(lt))
             else
              file=file.."[未达成]"
              local lt = {
                TextView;
                textSize=getsize(10);
                text=file;
                textColor="#C6C6C6";
              };
              功法特效.addView(loadlayout(lt))
            end
          end
          if not blar then
            功法面板.addView(loadlayout{
              LinearLayout;
              orientation="vertical";
              layout_height="fill";
              layout_width="fill";
              {
                Button;
                text="升级";
                onClick=function 修炼功法() end;
              };
              {
                Button;
                text="遗忘";
                onClick=function 遗忘功法() end;
              };
            })
          end
          --local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中"}
          功法名称.Text=Color:Set(inSkillBox[i].key.."["..品阶[inSkillBox[i]["品质"]].."]",inSkillBox[i]["品质"])
          功法效率.Text=Color:Set("修炼效率:"..math.ceil(inSkillBox[i]["修炼效率"]*((1+inSkillBox[i].step)^(inSkillBox[i].level-1))*1000)/10 .."%",inSkillBox[i]["品质"])
          功法等级.Text=Color:Get("当前已修炼至第"..math.ceil(inSkillBox[i].level).."重",inSkillBox[i]["品质"])
          if inSkillBox[i].level >= 10 then
            功法等级.Text=功法等级.Text..Color:Get("(已满级)",inSkillBox[i]["品质"])
            功法特效.removeViews(2,1)
           else
            功法熟练.Text=Color:Set("当前熟练度:"..math.ceil(inSkillBox[i].exp).."/"..exp[inSkillBox[i]["品质"]][inSkillBox[i].level],inSkillBox[i]["品质"])
          end
          功法等级.Text=Html.fromHtml(功法等级.Text)
          功法介绍.Text=inSkillBox[i].Info.."\n"
          local str = "功法属性:\n"
          for k,v in pairs(tab) do
            if inSkillBox[i][v] then
              if v == "会心伤害" or v == "会心免伤" or v == "最终伤害放大" or v == "最终伤害抵消" or string.find(v,"基础") then
                str=str.."提升"..v..math.ceil(inSkillBox[i][v]*((1+inSkillBox[i].step)^inSkillBox[i].level)).."%\n"
               elseif v=="气血上限" then
                str=str.."提升气血上限"..math.ceil(inSkillBox[i][v]*((1+inSkillBox[i].step)^inSkillBox[i].level)).."点\n"
               elseif v=="法力上限" then
                str=str.."提升法力上限"..math.ceil(inSkillBox[i][v]*((1+inSkillBox[i].step)^inSkillBox[i].level)).."点\n"
               else
                str=str.."提升"..v..math.ceil(inSkillBox[i][v]*((1+inSkillBox[i].step)^inSkillBox[i].level)).."点\n"
              end
            end
          end
          功法属性.Text = str
          local hj
          function 遗忘功法()
            if hj ~= nil then
              hj.dismiss()
            end
            hj = AlertDialog.Builder(this)
            .setTitle("确认")
            .setMessage("确定要遗忘该功法吗？")
            .setPositiveButton("取消",nil)
            .setNegativeButton("确认",function table.remove(SaveTable.owner.inskill,i) a.dismiss()
            b.dismiss() loadsavewrite() MD提示(Html.fromHtml(Color:Get(inSkillBox[i].key,inSkillBox[i]["品质"]).."已被移除!")) end)
            .show();
          end
          function 修炼功法()
            local cost = math.abs(inSkillBox[i].exp - tonumber(exp[inSkillBox[i]["品质"]][inSkillBox[i].level]))
            if cost <= SaveTable.owner["修为"] then
              SaveTable.owner["修为"] = SaveTable.owner["修为"] - cost
              SaveTable.owner.inskill[i].level = SaveTable.owner.inskill[i].level + 1
              SaveTable.owner.inskill[i].exp = 0
              inSkillBox[i].exp = 0
              inSkillBox[i].level = inSkillBox[i].level + 1
              MD提示(Html.fromHtml("消耗修为"..math.ceil(cost).."点,"..Color:Get(inSkillBox[i].key,inSkillBox[i]["品质"]).."提升至第"..math.ceil(SaveTable.owner.inskill[i].level).."重"))
              loadsavewrite()
             else
              MD提示("修为不足"..math.ceil(cost).."点,无法提升!")
            end
            功法UI()
          end
        end
        功法UI()
      end
    end
  end
  InSkillMenuShow(menu,inskilllist,skilllist)
end