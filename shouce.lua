require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.text.InputType"
import "android.text.method.DigitsKeyListener"
import "commonHelper"
local Item = import "item"
local exp = import "skillexp"
local Inskill = import "inskill"
local Skill = import "skill"
local Color = {hui="#C6C6C6",black="#000000",white="#FFFFFF",green="#008000",blue="#0000FF",red="#FF0000",orange="#FFA500",gold="#FFD700"}

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

function shouce()
  SaveTable.owner.Attribute = Item:GetTirgger(SaveTable.owner)
  function tizhi()
    AlertDialog.Builder(this)
    .setTitle("体质介绍")
    .setMessage("体质是四类基础属性之一，每一点体质可提升50点气血，3.2的外攻，2.4的内防，3.2的外防,2.4的抗会心率，0.12%的会心免伤及0.2%的最终伤害抵消")
    .setPositiveButton("确认",nil)
    .show()
  end
  function zhenyuan()
    AlertDialog.Builder(this)
    .setTitle("真元介绍")
    .setMessage("真元是四类基础属性之一，每一点真元可提升16点气血，40点法力，8点内攻，2.4的内防，0.8的外防,0.8的会心率，0.16%的会心伤害，1.6的命中及0.16%的最终伤害放大")
    .setPositiveButton("确认",nil)
    .show()
  end
  function shenfa()
    AlertDialog.Builder(this)
    .setTitle("身法介绍")
    .setMessage("身法是四类基础属性之一，每一点身法可提升0.8外攻，4点会心率，4点闪避，2.4的命中，0.24%的会心伤害,0.24%的最终伤害放大以及提升战斗内的行动速度")
    .setPositiveButton("确认",nil)
    .show()
  end
  function roushen()
    AlertDialog.Builder(this)
    .setTitle("肉身介绍")
    .setMessage("肉身是四类基础属性之一，每一点肉身可提升16点气血，4点外攻，3.2的内防，4点外防，2.4的抗会心率,0.08%的会心伤害，0.24%的会心免伤0.24%的最终伤害抵消")
    .setPositiveButton("确认",nil)
    .show()
  end
  function neigong()
    AlertDialog.Builder(this)
    .setTitle("内攻介绍")
    .setMessage("提升内攻攻击伤害，对应法术的内攻伤害进行加成，内防对内攻伤害进行减免")
    .setPositiveButton("确认",nil)
    .show()
  end
  function waigong()
    AlertDialog.Builder(this)
    .setTitle("外攻介绍")
    .setMessage("提升外攻攻攻击伤害，对应法术的外攻伤害进行加成，外防对外攻伤害进行减免")
    .setPositiveButton("确认",nil)
    .show()
  end
  function neifang()
    local xs = (1-1/(1+SaveTable.owner.Attribute["内防"]/500))*100
    AlertDialog.Builder(this)
    .setTitle("内防介绍")
    .setMessage("降低受到的内攻伤害，当前的减免系数为"..upeqdata(xs).."%")
    .setPositiveButton("确认",nil)
    .show()
  end
  function waifang()
    local xs = (1-1/(1+SaveTable.owner.Attribute["外防"]/500))*100
    AlertDialog.Builder(this)
    .setTitle("外防介绍")
    .setMessage("降低受到的外攻伤害，当前的减免系数为"..upeqdata(xs).."%")
    .setPositiveButton("确认",nil)
    .show()
  end
  function huixin()
    AlertDialog.Builder(this)
    .setTitle("会心率介绍")
    .setMessage("影响打出暴击的概率，攻方会心率越高，守方抗会心率越低，暴击率越高")
    .setPositiveButton("确认",nil)
    .show()
  end
  function kanghuixin()
    AlertDialog.Builder(this)
    .setTitle("抗会心率介绍")
    .setMessage("减少被暴击的几率")
    .setPositiveButton("确认",nil)
    .show()
  end
  function mingzhong()
    AlertDialog.Builder(this)
    .setTitle("命中介绍")
    .setMessage("影响攻击命中敌方的概率，攻方命中越高，守方闪避越低，越容易命中")
    .setPositiveButton("确认",nil)
    .show()
  end
  function shanbi()
    AlertDialog.Builder(this)
    .setTitle("闪避介绍")
    .setMessage("影响闪避敌方攻击的概率，守方闪避越高，攻方命中越低，越容易闪避")
    .setPositiveButton("确认",nil)
    .show()
  end
  function hxsh()
    AlertDialog.Builder(this)
    .setTitle("会心伤害介绍")
    .setMessage("影响暴击后造成的额外伤害")
    .setPositiveButton("确认",nil)
    .show()
  end
  function hxms()
    AlertDialog.Builder(this)
    .setTitle("会心免伤介绍")
    .setMessage("降低被暴击后产生的伤害")
    .setPositiveButton("确认",nil)
    .show()
  end
  function fangda()
    AlertDialog.Builder(this)
    .setTitle("最终伤害放大介绍")
    .setMessage("造成的伤害进行百分比增幅")
    .setPositiveButton("确认",nil)
    .show()
  end
  function dixiao()
    AlertDialog.Builder(this)
    .setTitle("最终伤害抵消介绍")
    .setMessage("受到的伤害进行一定百分比减免")
    .setPositiveButton("确认",nil)
    .show()
  end
  function jichu()
    AlertDialog.Builder(this)
    .setTitle("基础属性介绍")
    .setMessage("四类基础属性增加属性总和，比如基础生命，体质，真元，肉身增加生命值，如果基础生命为10000，基础生命10%，则增加1000点生命;而基础攻击，基础防御则分为内外攻防，分别增加。")
    .setPositiveButton("确认",nil)
    .show()
  end
  local sx = loadlayout{
    LinearLayout;
    layout_height="match_parent";
    backgroundColor="#C6C6C6";
    layout_width="match_parent";
    orientation="vertical";
    {
      LinearLayout;
      layout_height="8%h";
      layout_width="match_parent";
      {
        Button;
        onClick=function tizhi() end;
        text="体质";
        layout_width="20%w";
        layout_height="7%h";
      };
      {
        Button;
        onClick=function zhenyuan() end;
        text="真元";
        layout_width="20%w";
        layout_height="7%h";
      };
      {
        Button;
        onClick=function shenfa() end;
        text="身法";
        layout_width="20%w";
        layout_height="7%h";
      };
      {
        Button;
        onClick=function roushen() end;
        text="肉身";
        layout_width="20%w";
        layout_height="7%h";
      };
    };
    {
      LinearLayout;
      layout_height="8%h";
      layout_width="match_parent";
      {
        Button;
        text="内攻";
        onClick=function neigong() end;
        layout_width="20%w";
        layout_height="7%h";
      };
      {
        Button;
        onClick=function waigong() end;
        text="外攻";
        layout_width="20%w";
        layout_height="7%h";
      };
      {
        Button;
        onClick=function neifang() end;
        text="内防";
        layout_width="20%w";
        layout_height="7%h";
      };
      {
        Button;
        onClick=function waifang() end;
        text="外防";
        layout_width="20%w";
        layout_height="7%h";
      };
    };
    {
      LinearLayout;
      layout_height="7%h";
      layout_width="match_parent";
      {
        Button;
        onClick=function huixin() end;
        text="会心率";
        layout_width="20%w";
        layout_height="7%h";
      };
      {
        Button;
        onClick=function kanghuixin() end;
        text="抗会心率";
        textSize=getsize(12);
        layout_width="20%w";
        layout_height="7%h";
      };
      {
        Button;
        onClick=function mingzhong() end;
        text="命中";
        layout_width="20%w";
        layout_height="7%h";
      };
      {
        Button;
        onClick=function shanbi() end;
        text="闪避";
        layout_width="20%w";
        layout_height="7%h";
      };
    };
    {
      LinearLayout;
      layout_height="8%h";
      layout_width="match_parent";
      {
        Button;
        onClick=function hxsh() end;
        text="会心伤害";
        textSize=getsize(12);
        layout_width="20%w";
        layout_height="7%h";
      };
      {
        Button;
        onClick=function hxms() end;
        text="会心免伤";
        textSize=getsize(12);
        layout_width="20%w";
        layout_height="7%h";
      };
      {
        Button;
        onClick=function fangda() end;
        text="最终伤害放大";
        textSize=getsize(9);
        layout_width="20%w";
        layout_height="7%h";
      };
      {
        Button;
        onClick=function dixiao() end;
        text="最终伤害抵消";
        layout_width="20%w";
        layout_height="7%h";
        textSize=getsize(9);
      };
    };
    {
      LinearLayout;
      layout_width="match_parent";
      layout_height="7%h";
      {
        Button;
        onClick=function jichu() end;
        text="基础类属性";
        textSize=getsize(10);
        layout_width="20%w";
        layout_height="7%h";
      };
    };
  };
  local d=AlertDialog.Builder(this).show()
  d.getWindow().setContentView(loadlayout(MapUI()["手册"]));
  手册.addView(sx)
  function shuxing()
    d.dismiss()
    d=AlertDialog.Builder(this).show()
    d.getWindow().setContentView(loadlayout(MapUI()["手册"]));
    sx=loadlayout{
      LinearLayout;
      layout_height="match_parent";
      backgroundColor="#C6C6C6";
      layout_width="match_parent";
      orientation="vertical";
      {
        LinearLayout;
        layout_height="8%h";
        layout_width="match_parent";
        {
          Button;
          text="体质";
          onClick=function tizhi() end;
          layout_width="20%w";
          layout_height="7%h";
        };
        {
          Button;
          onClick=function zhenyuan() end;
          text="真元";
          layout_width="20%w";
          layout_height="7%h";
        };
        {
          Button;
          onClick=function shenfa() end;
          text="身法";
          layout_width="20%w";
          layout_height="7%h";
        };
        {
          Button;
          onClick=function roushen() end;
          text="肉身";
          layout_width="20%w";
          layout_height="7%h";
        };
      };
      {
        LinearLayout;
        layout_height="8%h";
        layout_width="match_parent";
        {
          Button;
          onClick=function neigong() end;
          text="内攻";
          layout_width="20%w";
          layout_height="7%h";
        };
        {
          Button;
          onClick=function waigong() end;
          text="外攻";
          layout_width="20%w";
          layout_height="7%h";
        };
        {
          Button;
          onClick=function neifang() end;
          text="内防";
          layout_width="20%w";
          layout_height="7%h";
        };
        {
          Button;
          onClick=function waifang() end;
          text="外防";
          layout_width="20%w";
          layout_height="7%h";
        };
      };
      {
        LinearLayout;
        layout_height="7%h";
        layout_width="match_parent";
        {
          Button;
          onClick=function huixin() end;
          text="会心率";
          layout_width="20%w";
          layout_height="7%h";
        };
        {
          Button;
          onClick=function kanghuixin() end;
          text="抗会心率";
          textSize=getsize(12);
          layout_width="20%w";
          layout_height="7%h";
        };
        {
          Button;
          onClick=function mingzhong() end;
          text="命中";
          layout_width="20%w";
          layout_height="7%h";
        };
        {
          Button;
          onClick=function shanbi() end;
          text="闪避";
          layout_width="20%w";
          layout_height="7%h";
        };
      };
      {
        LinearLayout;
        layout_height="8%h";
        layout_width="match_parent";
        {
          Button;
          onClick=function hxsh() end;
          text="会心伤害";
          textSize=getsize(12);
          layout_width="20%w";
          layout_height="7%h";
        };
        {
          Button;
          onClick=function hxms() end;
          text="会心免伤";
          textSize=getsize(12);
          layout_width="20%w";
          layout_height="7%h";
        };
        {
          Button;
          onClick=function fangda() end;
          text="最终伤害放大";
          textSize=getsize(9);
          layout_width="20%w";
          layout_height="7%h";
        };
        {
          Button;
          onClick=function dixiao() end;
          text="最终伤害抵消";
          layout_width="20%w";
          layout_height="7%h";
          textSize=getsize(9);
        };
      };
      {
        LinearLayout;
        layout_width="match_parent";
        layout_height="7%h";
        {
          Button;
          onClick=function jichu() end;
          text="基础类属性";
          textSize=getsize(10);
          layout_width="20%w";
          layout_height="7%h";
        };
      };
    }
    手册.addView(sx)
  end
  function tujian(m,n)
    function gongfa()
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
            id="功法选择";
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
      local tlb
      local g =AlertDialog.Builder(this).show()
      g.getWindow().setContentView(loadlayout(MapUI()["功法图鉴"]));
      local 品阶 = {"黄阶初级","黄阶中级","黄阶高级","玄阶初级","玄阶中级","玄阶高级","地阶初级","地阶中级","地阶高级","天阶初级","天阶中级","天阶高级","仙经"}
      local data={}
      local adp=LuaAdapter(activity,data,its)
      功法库.Adapter=adp
      local tb = {}
      table.sort(Inskill,function(a,b)
        return a["品质"] < b["品质"]
      end)
      for i=1,#Inskill do
        Inskill[i].level = 10
        Inskill[i].exp = 0
        table.insert(tb,Inskill[i])
        table.insert(data,{name=Color:Set(Inskill[i].key.."["..品阶[Inskill[i]["品质"]].."]",Inskill[i]["品质"])})
      end
      功法库.onItemClick=function(l,v,p,i)
        local b=AlertDialog.Builder(this).show()
        b.getWindow().setContentView(loadlayout(MapUI()["功法面板"]));
      end
      function MyTable(t,n,m)
        local no1 = #data
        for i=1,no1 do
          table.remove(data)
        end
        local tab = {}
        for i=1,#t do
          if (t[i]["品质"] >= n and t[i]["品质"] <= m) then
            local v = t[i]
            table.insert(tab,v)
            table.insert(data,{name=Color:Set(Inskill[i].key.."["..品阶[Inskill[i]["品质"]].."]",Inskill[i]["品质"])})
          end
        end
        return tab
      end
      gftj.setOnCheckedChangeListener{
        onCheckedChanged=function(g,c)
          l=g.findViewById(c)
          if l.Text == "全部" then
            tlb = MyTable(tb,0,100)
           elseif l.Text == "仙经" then
            tlb = MyTable(tb,13,13)
           elseif l.Text == "天阶" then
            tlb = MyTable(tb,10,12)
           elseif l.Text == "地阶" then
            tlb = MyTable(tb,7,9)
           elseif l.Text == "玄阶" then
            tlb = MyTable(tb,4,6)
           elseif l.Text == "黄阶" then
            tlb = MyTable(tb,1,3)
          end
          if #data == 0 then
            table.insert(data,{name="无"})
          end
          adp.notifyDataSetChanged()
        end}
      功法库.onItemClick=function(l,v,p,i)
        local b=AlertDialog.Builder(this).show()
        b.getWindow().setContentView(loadlayout(MapUI()["功法面板"]));
        功法修炼.removeAllViews()
        功法修炼.addView(loadlayout{
          LinearLayout;
          id="功法特效";
          orientation="vertical";
          layout_height="fill";
          layout_width="fill";
          {
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
          };
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
        })
        功法修炼.addView(loadlayout{
          LinearLayout;
          id="功法面板";
          orientation="horizontal";
          layout_height="fill";
          layout_width="fill";
        })
        local inSkillBox
        if tlb ~= nil then
          inSkillBox = tlb
         else
          inSkillBox = tb
        end
        --local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中"}
        功法名称.Text=Color:Set(inSkillBox[i].key.."["..品阶[inSkillBox[i]["品质"]].."]",inSkillBox[i]["品质"])
        功法效率.Text=Color:Set("修炼效率:"..math.ceil(inSkillBox[i]["修炼效率"]*((1+inSkillBox[i].step)^(inSkillBox[i].level-1))*1000)/10 .."%",inSkillBox[i]["品质"])
        功法熟练.Text=Color:Set("当前熟练度:"..math.ceil(inSkillBox[i].exp).."/"..exp[inSkillBox[i]["品质"]][inSkillBox[i].level],inSkillBox[i]["品质"])
        功法等级.Text=Color:Set("当前已修炼至第"..math.ceil(inSkillBox[i].level).."重",inSkillBox[i]["品质"])
        功法介绍.Text=inSkillBox[i].Info.."\n"
        local str = "功法属性:\n"
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
      end
    end
    function fashu()
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
            id="功法选择";
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
      local tlb
      local g =AlertDialog.Builder(this).show()
      g.getWindow().setContentView(loadlayout(MapUI()["法术图鉴"]));
      local 品阶 = {"黄阶初级","黄阶中级","黄阶高级","玄阶初级","玄阶中级","玄阶高级","地阶初级","地阶中级","地阶高级","天阶初级","天阶中级","天阶高级","仙经"}
      local data={}
      local adp=LuaAdapter(activity,data,its)
      法术库.Adapter=adp
      local tb = {}
      table.sort(Skill,function(a,b)
        return a["品质"] < b["品质"]
      end)
      for i=1,#Skill do
        Skill[i].level = 10
        Skill[i].exp = 0
        Skill[i].Cd = 0
        table.insert(tb,Skill[i])
        table.insert(data,{name=Color:Set(Skill[i].key.."["..品阶[Skill[i]["品质"]].."]",Skill[i]["品质"])})
      end
      function MyTable(t,n,m)
        local no1 = #data
        for i=1,no1 do
          table.remove(data)
        end
        local tab = {}
        for i=1,#t do
          if (t[i]["品质"] >= n and t[i]["品质"] <= m) then
            local v = t[i]
            table.insert(tab,v)
            table.insert(data,{name=Color:Set(skill[i].key.."["..品阶[skill[i]["品质"]].."]",skill[i]["品质"])})
          end
        end
        return tab
      end
      fstj.setOnCheckedChangeListener{
        onCheckedChanged=function(g,c)
          l=g.findViewById(c)
          if l.Text == "全部" then
            tlb = MyTable(tb,0,100)
           elseif l.Text == "仙术" then
            tlb = MyTable(tb,13,13)
           elseif l.Text == "天阶" then
            tlb = MyTable(tb,10,12)
           elseif l.Text == "地阶" then
            tlb = MyTable(tb,7,9)
           elseif l.Text == "玄阶" then
            tlb = MyTable(tb,4,6)
           elseif l.Text == "黄阶" then
            tlb = MyTable(tb,1,3)
          end
          if #data == 0 then
            table.insert(data,{name="无"})
          end
          adp.notifyDataSetChanged()
        end}
      法术库.onItemClick=function(l,v,p,i)
        local SkillBox
        if tlb ~= nil then
          SkillBox = tlb
         else
          SkillBox = tb
        end
        local b=AlertDialog.Builder(this).show()
        b.getWindow().setContentView(loadlayout(MapUI()["法术面板"]));
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
        --local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中"}
        法术名称.Text=Color:Set(SkillBox[i].key.."["..品阶[SkillBox[i]["品质"]].."]",SkillBox[i]["品质"])
        法术消耗.Text=Color:Set("法力消耗:"..math.ceil(SkillBox[i].cost * ((SkillBox[i].step + 1) ^ SkillBox[i].level)),SkillBox[i]["品质"])
        法术熟练.Text=Color:Set("当前熟练度:"..math.ceil(SkillBox[i].exp).."/"..exp[SkillBox[i]["品质"]][SkillBox[i].level],SkillBox[i]["品质"])
        法术等级.Text=Color:Set("当前已修炼至第"..math.ceil(SkillBox[i].level).."重",SkillBox[i]["品质"])
        法术介绍.Text=SkillBox[i].Info.."\n"
        法术参数.Text="外攻伤害:"..SkillBox[i].outpow*((1+SkillBox[i].step)^SkillBox[i].level)*100 .."%  \t内攻伤害:"..SkillBox[i].inpow*((1+SkillBox[i].step)^SkillBox[i].level)*100 .."%\n攻击范围:"..SkillBox[i].hit.."\t  CD:"..SkillBox[i].Cd.."/"..SkillBox[i].MaxCd
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
      end
    end
    function zhuangbei()
    end
    d.dismiss()
    d=AlertDialog.Builder(this).show()
    d.getWindow().setContentView(loadlayout(MapUI()["手册"]));
    sx=loadlayout{
      LinearLayout;
      layout_height="match_parent";
      backgroundColor="#C6C6C6";
      layout_width="match_parent";
      orientation="vertical";
      {
        LinearLayout;
        layout_height="8%h";
        layout_width="match_parent";
        {
          Button;
          text="功法图鉴";
          onClick=function gongfa(1,13) end;
          layout_width="26%w";
          layout_height="7%h";
        };
        {
          Button;
          onClick=function fashu() end;
          text="法术图鉴";
          layout_width="26%w";
          layout_height="7%h";
        };
        {
          Button;
          onClick=function zhuangbei() end;
          text="装备图鉴";
          layout_width="26%w";
          layout_height="7%h";
        };
      };
    }
    手册.addView(sx)
  end
end