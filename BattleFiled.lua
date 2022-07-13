require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "BattleSprite"
import "getskill"
import "GetItem"
import "android.text.Html"
import "gundong"
import "commonHelper"
local text
local sp
local role,att
local act
local speed = 2000
local ky = import "keyao"
local pettt = import "petdata"
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
local zdinfo = {}
function zdinfo:getWindow(f,save,m)
  function fly(di,num)
    if di == nil then
      跳转地图("映日村",true,1)
     else
      跳转地图(di,true,1)
    end
  end
  if self.fp ~= nil then
    self.fp.dismiss()
  end
  local ft
  if f == "win" then
    ft = "战斗胜利"
   elseif f == "lose" and save == nil then
    ft = "战斗失败"
    SaveTable.map = nil
    loadsavewrite(0)
  end
  local str = table.concat({"杀敌数:",Color:Get(math.ceil(self["杀敌数"]),7),"<br>获得修为:",Color:Get(math.ceil(self["修为"]),1),"<br>获得灵石:",Color:Get(math.ceil(self.money),1)})
  local t = {"<br>获得物品:"}
  local Item = import "item"
  for k,v in pairs(self.drop) do
    table.insert(t,table.concat({Color:Get(k,Item:GetLevel(k)),"*",v,"<br>&emsp;&emsp;&emsp;&emsp;&nbsp;"}))
  end
  if #t > 1 then
    t=table.concat(t)
    str=table.concat({str,t})
  end
  t = {"<br>获得宠兽:"}
  for k,v in pairs(self.pet) do
    table.insert(t,table.concat({v,"<br>&emsp;&emsp;&emsp;&emsp;&nbsp;"}))
  end
  if #t > 1 then
    t=table.concat(t)
    str=Html.fromHtml(table.concat({str,t}))
   else
    str=Html.fromHtml(str)
  end
  self.fp=poppb(savelay.zdif)
  zdsha.onClick=function
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
          text="伤害";
          textColor="#FFFFFF";
          layout_gravity="center";
        };
      };
      {
        TextView;
        id="伤害";
      };
    };
    local num = 0
    for k,v in pairs(zdinfo.danmage) do
      num = num + v
    end
    local str = ""
    for k,v in pairs(zdinfo.danmage) do
      str=str..Color:Get(k,1).."造成伤害:"..Color:Get(math.ceil(v),7).."/(".."伤害占比:"..math.floor(v/num*10000)/100 .."%)<br>"
    end
    self.dp=AlertDialog.Builder(activity)
    .setView(loadlayout(m)).show()
    伤害.Text=Html.fromHtml(str)
  end
  zdqra.onClick=function
    SaveTable["重塑"]=os.time()
    self.fp.dismiss()
    if self.result == nil then
      SaveTable["重塑"]=nil
      loadsavewrite(0)
      fly(SaveTable.map,1)
     elseif self.result[f] ~= nil then
      if self.result[f].type == "story" then
        fly(SaveTable.map,1)
        文字动画(self.result[f].value,1)
       elseif self.result[f].type == "map" then
        fly(self.result[f].value,1)
       elseif self.result[f].type == "set_time" then
        SaveTable["刷新"][self.result[f].value.key] = {key=self.result[f].value.text,number={0,self.result[f].value.number}}
        if SaveTable.finish_story == nil then
          SaveTable.finish_story = {}
        end
        if self.result[f].value.key == "？？？" and SaveTable.finish_story["古战场一层"] == nil and SaveTable.owner.level <= 20 then
          文字动画("古战场一层",1)
        end
        loadsavewrite(0)
        fly(SaveTable.map,1)
      end
     elseif f == "lose" and save == nil then
      提示("战斗失败，已被系统强制传送至安全地点")
      fly(SaveTable.map,1)
     elseif f == "lose" and save ~= nil then
      activity.setContentView(MapUI()["死亡界面"])
     else
      fly(SaveTable.map,1)
    end
    if f == "win" then
      if save == nil then
        loadsavewrite(0)
        SaveTable["重塑"]=nil
      end
    end
    m.dismiss()
  end
  zdxxa.Text=str
end

function Color:Set(str,lv)
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
  return Html.fromHtml(table.concat(str))
end

local exp = import "skillexp"
local 境界 = import "tupo"
local ptjj = import "pettupo"
local Item = import "item"
local battle = import "battle"

function openbattlemap()
  local buju = {
    LinearLayout;
    backgroundColor="#000000";
    layout_height="fill";
    layout_width="fill";
    orientation="horizontal";
    {
      CardView;
      layout_margin="2%w";
      layout_height="fill";
      layout_width="fill";
      radius="10dp";
      {
        ListView;
        layout_width="fill";
        layout_height="fill";
        id="战斗地图";
      };
    };
  };

  local bt = popno(buju)
  local mps = {
    LinearLayout;
    backgroundColor="#000000";
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
          id="地图名";
        };
      };
    };
  };
  SaveTable.zt = 1
  local data={}
  local zdtb = {"寂静森林","战斗1","战斗2","战斗3","战斗4","战斗5","战斗6","战斗7","战斗8","战斗9","战斗10","战斗11","战斗12","战斗13","战斗14","战斗15","战斗16","战斗17","战斗18","战斗19","战斗20","战斗21"}
  local zdjj = {"[炼气一层]","[炼气初期]","[炼气中期]","[炼气后期]","[筑基初期]","[筑基中期]","[筑基后期]","[筑基大圆满]","[金丹初期]","[金丹中期]","[金丹后期]","[金丹大圆满]","[元婴初期]","[元婴中期]","[元婴后期]","[元婴大圆满]","[化神初期]","[化神中期]","[化神后期]","[化神大圆满]","[合体初期]","[合体中期]"}
  local adp=LuaAdapter(activity,data,mps)
  if SaveTable.sys == nil then
    SaveTable.sys = {level=1,shop=1,battle=1}
  end
  for k,v in pairs(zdtb) do
    if k <= SaveTable.sys.battle + 1 then
      data[#data+1]={地图名=v..zdjj[k]}
    end
  end
  战斗地图.Adapter=adp
  战斗地图.onItemClick=function(l,v,p,i)
    SaveTable.zt = nil
    bt.dismiss()
    BattleStart(zdtb[i])
  end
end

function BattleStart(key,phtb,cao,rt,save)
  local drop_tb = GetDrop()
  local shipei = SaveTable.shipei
  local battleui=savelay.bt[1]
  local btui = popno(battleui)
  插.removeAllViews()
  speed = 2000
  if SaveTable.speed == 1 then
    speed = 1000
   elseif SaveTable.speed == 2 then
    speed = 666
  end
  local function petAddSkillExp(key,num,p,id)
    local x = 1
    local self = SaveTable.pet[id].skill
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
  if save == nil then
    SaveTable["重塑"]=os.time()
    loadsavewrite(0)
  end
  if SaveTable["击杀"] == nil then
    SaveTable["击杀"] = {}
  end
  zdinfo["修为"]=0
  zdinfo["杀敌数"]=0
  zdinfo.money=0
  zdinfo.drop={}
  zdinfo.pet={}
  zdinfo.result=rt
  zdinfo.danmage={}
  if rt ~= nil and rt.set == true then
    if zdinfo.result["win"] ~= nil and zdinfo.result["win"].type == "set_time" then
      if SaveTable["刷新"] == nil then
        SaveTable["刷新"] = {}
      end
      SaveTable["刷新"][zdinfo.result["win"].value.key] = {key=zdinfo.result["win"].value.text,number={0,zdinfo.result["win"].value.number}}
      loadsavewrite(0)
    end
  end
  local zid
  local SpriteTable
  if phtb ~= nil then
    SpriteTable = phtb
   else
    SpriteTable = GetSpriteTable(key)
  end
  for k,v in pairs(SpriteTable) do
    if v.team == 1 then
      zdinfo.danmage[v.key] = 0
    end
  end
  function 更改挂机()
    if SaveTable.zid ~= nil then
      zid={
        CardView;
        onClick=function 更改挂机() end;
        layout_height="5%h";
        layout_width="20%w";
        backgroundColor="#000000";
        radius="1%h";
        {
          CardView;
          layout_height="match_parent";
          radius="0.8%h";
          layout_margin="0.4%w";
          layout_width="match_parent";
          {
            LinearLayout;
            layout_gravity="center";
            orientation="horizontal";
            layout_height="wrap_content";
            layout_width="wrap_content";
            {
              TextView;
              textColor="#000000";
              text="手动";
              textSize=getsize(16);
            };
          };
        };
      };
      SaveTable.zid = nil
      提示("已更改为手动攻击")
     else
      zid={
        CardView;
        onClick=function 更改挂机() end;
        layout_height="5%h";
        layout_width="20%w";
        backgroundColor="#000000";
        radius="1%h";
        {
          CardView;
          layout_height="match_parent";
          radius="0.8%h";
          layout_margin="0.4%w";
          layout_width="match_parent";
          {
            CardView;
            backgroundColor="#000000";
            layout_height="match_parent";
            radius="0.65%h";
            layout_margin="0.4%w";
            layout_width="match_parent";
            {
              TextView;
              layout_gravity="center";
              textColor="#FFFFFF";
              text="自动";
              textSize=getsize(16);
            };
          };
        };
      };
      SaveTable.zid = 1
      提示("已更改为自动操作")
    end
    自动.removeViews(0,1)
    自动.addView(loadlayout(zid))
  end
  function 加速()
    if SaveTable.speed == 2 then
      zid={
        CardView;
        onClick=function 加速() end;
        layout_height="5%h";
        layout_width="20%w";
        backgroundColor="#000000";
        radius="1%h";
        {
          CardView;
          layout_height="match_parent";
          radius="0.8%h";
          layout_margin="0.4%w";
          layout_width="match_parent";
          {
            LinearLayout;
            layout_gravity="center";
            orientation="horizontal";
            layout_height="wrap_content";
            layout_width="wrap_content";
            {
              TextView;
              textColor="#000000";
              text="加速";
              textSize=getsize(16);
            };
          };
        };
      };
      SaveTable.speed = nil
      if 战斗计时 ~= nil then
        战斗计时.Period=2000
      end
      提示("战斗加速已关闭")
     elseif SaveTable.speed == nil then
      zid={
        CardView;
        onClick=function 加速() end;
        layout_height="5%h";
        layout_width="20%w";
        backgroundColor="#000000";
        radius="1%h";
        {
          CardView;
          layout_height="match_parent";
          radius="0.8%h";
          layout_margin="0.4%w";
          layout_width="match_parent";
          {
            CardView;
            backgroundColor="#000000";
            layout_height="match_parent";
            radius="0.65%h";
            layout_margin="0.4%w";
            layout_width="match_parent";
            {
              TextView;
              layout_gravity="center";
              textColor="#FFFFFF";
              text="加速";
              textSize=getsize(16);
            };
          };
        };
      };
      SaveTable.speed = 1
      if 战斗计时 ~= nil then
        战斗计时.Period=1000
      end
      提示("战斗加速已开启！")
     elseif SaveTable.speed == 1 then
      zid={
        CardView;
        onClick=function 加速() end;
        layout_height="5%h";
        layout_width="20%w";
        backgroundColor="#000000";
        radius="1%h";
        {
          CardView;
          layout_height="match_parent";
          radius="0.8%h";
          layout_margin="0.4%w";
          layout_width="match_parent";
          {
            CardView;
            backgroundColor="#000000";
            layout_height="match_parent";
            radius="0.65%h";
            layout_margin="0.4%w";
            layout_width="match_parent";
            {
              TextView;
              layout_gravity="center";
              textColor="#FF0000";
              text="加速";
              textSize=getsize(16);
            };
          };
        };
      };
      SaveTable.speed = 2
      if 战斗计时 ~= nil then
        战斗计时.Period=666
      end
      提示("已开启超级加速！")
    end
    战斗加速.removeViews(0,1)
    战斗加速.addView(loadlayout(zid))
  end
  if true then
    local czt = {
      LinearLayout;
      orientation="vertical";
      layout_width="fill";
      layout_height="fill";
      {
        LinearLayout;
        id="行动";
        layout_width="22%w";
        layout_height="6%h";
      };
      {
        LinearLayout;
        id="自动";
        layout_width="22%w";
        layout_height="6%h";
      };
      {
        LinearLayout;
        id="战斗加速";
        layout_width="22%w";
        layout_height="6%h";
      };
      {
        LinearLayout;
        id="逃跑";
        layout_width="22%w";
        layout_height="6%h";
      };
    }
    插.addView(loadlayout(czt))
    if SaveTable.zid == nil then
      zid={
        CardView;
        onClick=function 更改挂机() end;
        layout_height="5%h";
        layout_width="20%w";
        backgroundColor="#000000";
        radius="1%h";
        {
          CardView;
          layout_height="match_parent";
          radius="0.8%h";
          layout_margin="0.4%w";
          layout_width="match_parent";
          {
            LinearLayout;
            layout_gravity="center";
            orientation="horizontal";
            layout_height="wrap_content";
            layout_width="wrap_content";
            {
              TextView;
              textColor="#000000";
              text="手动";
              textSize=getsize(16);
            };
          };
        };
      };
     else
      zid={
        CardView;
        onClick=function 更改挂机() end;
        layout_height="5%h";
        layout_width="20%w";
        backgroundColor="#000000";
        radius="1%h";
        {
          CardView;
          layout_height="match_parent";
          radius="0.8%h";
          layout_margin="0.4%w";
          layout_width="match_parent";
          {
            CardView;
            backgroundColor="#000000";
            layout_height="match_parent";
            radius="0.65%h";
            layout_margin="0.4%w";
            layout_width="match_parent";
            {
              TextView;
              layout_gravity="center";
              textColor="#FFFFFF";
              text="自动";
              textSize=getsize(16);
            };
          };
        };
      };
    end
    自动.addView(loadlayout(zid))
    if SaveTable.speed == nil then
      zid={
        CardView;
        onClick=function 加速() end;
        layout_height="5%h";
        layout_width="20%w";
        backgroundColor="#000000";
        radius="1%h";
        {
          CardView;
          layout_height="match_parent";
          radius="0.8%h";
          layout_margin="0.4%w";
          layout_width="match_parent";
          {
            LinearLayout;
            layout_gravity="center";
            orientation="horizontal";
            layout_height="wrap_content";
            layout_width="wrap_content";
            {
              TextView;
              textColor="#000000";
              text="加速";
              textSize=getsize(16);
            };
          };
        };
      };
     elseif SaveTable.speed == 1 then
      zid={
        CardView;
        onClick=function 加速() end;
        layout_height="5%h";
        layout_width="20%w";
        backgroundColor="#000000";
        radius="1%h";
        {
          CardView;
          layout_height="match_parent";
          radius="0.8%h";
          layout_margin="0.4%w";
          layout_width="match_parent";
          {
            CardView;
            backgroundColor="#000000";
            layout_height="match_parent";
            radius="0.65%h";
            layout_margin="0.4%w";
            layout_width="match_parent";
            {
              TextView;
              layout_gravity="center";
              textColor="#FFFFFF";
              text="加速";
              textSize=getsize(16);
            };
          };
        };
      };
     elseif SaveTable.speed == 2 then
      zid={
        CardView;
        onClick=function 加速() end;
        layout_height="5%h";
        layout_width="20%w";
        backgroundColor="#000000";
        radius="1%h";
        {
          CardView;
          layout_height="match_parent";
          radius="0.8%h";
          layout_margin="0.4%w";
          layout_width="match_parent";
          {
            CardView;
            backgroundColor="#000000";
            layout_height="match_parent";
            radius="0.65%h";
            layout_margin="0.4%w";
            layout_width="match_parent";
            {
              TextView;
              layout_gravity="center";
              textColor="#FF0000";
              text="加速";
              textSize=getsize(16);
            };
          };
        };
      };
    end
    战斗加速.addView(loadlayout(zid))
  end
  function 停止挂机()
    AlertDialog.Builder(this)
    .setTitle("确认")
    .setMessage("确定要停止挂机吗？")
    .setPositiveButton("取消",nil)
    .setNegativeButton("确认",function
      if cao == nil then
        SaveTable.gj = nil
        MD提示("已停止自动挂机，本场战斗结束后将自动退出")
       else
        MD提示("无法操作")
      end
    end)
    .show();
  end
  返回 = "弹窗战斗"
  function GetSp(tab)
    sp = 0
    for k,v in pairs(tab) do
      if type(v) == "table" then
        if v.Hp > 0 then
          local ss = 1
          if v["爆发行动"] ~= nil then
            ss = ss + v["爆发行动"][1]/100
          end
          if v["累进行动"] ~= nil then
            ss = ss + v["累进行动"][1]/100
          end
          sp = sp + v.sp * ss
        end
      end
    end
    return sp
  end
  function SpriteTable:GetEnemyTable(team)
    local EnemyTable = {}
    for i=1,#self do
      if team ~= self[i].team then
        table.insert(EnemyTable,self[i])
      end
    end
    return EnemyTable
  end
  local taby = SpriteTable:GetEnemyTable(2)
  local tabd = SpriteTable:GetEnemyTable(1)
  local data=savelay.bt[2]
  local data1=savelay.bt[4]
  local data5=savelay.bt[6]
  local adp=savelay.bt[3]
  adp.clear()
  local adp1=savelay.bt[5]
  adp1.clear()
  local adp5=savelay.bt[7]
  adp5.clear()
  for i=1,#SpriteTable do
    SpriteTable[i].sp = SpriteTable[i].sp + SpriteTable[i].hard
    SpriteTable[i].id = i
    if SpriteTable[i].team == 1 then
      if SpriteTable[i].ph ~= nil then
        table.insert(data,{名称境界=table.concat({SpriteTable[i].name,"\n",ptjj[SpriteTable[i].level]["境界"]}),
        血量显示=table.concat({math.ceil(SpriteTable[i].Hp),"/",math.ceil(SpriteTable[i].Attribute["气血上限"])}),法力显示=table.concat({math.ceil(SpriteTable[i].Mp),"/",math.ceil(SpriteTable[i].Attribute["法力上限"])}),id=i})
        local xt = math.ceil((SpriteTable[i].Hp/SpriteTable[i].Attribute["气血上限"])*shipei)
        local lt = math.ceil((SpriteTable[i].Mp/SpriteTable[i].Attribute["法力上限"])*shipei)
        local ostr=""
        local pstr=""
        for i=1,xt do
          ostr=table.concat({ostr," "})
        end
        data[#data].血条=ostr
        for i=1,lt do
          pstr=table.concat({pstr," "})
        end
        data[#data].蓝条=pstr
       else
        if SpriteTable[i].level ~= nil then
          table.insert(data,{名称境界=SpriteTable[i].key.."\n"..境界[SpriteTable[i].level]["境界"],
          血量显示=table.concat({math.ceil(SpriteTable[i].Hp),"/",math.ceil(SpriteTable[i].Attribute["气血上限"])}),法力显示=table.concat({math.ceil(SpriteTable[i].Mp),"/",math.ceil(SpriteTable[i].Attribute["法力上限"])}),id=i})
          local xt = math.ceil((SpriteTable[i].Hp/SpriteTable[i].Attribute["气血上限"])*shipei)
          local lt = math.ceil((SpriteTable[i].Mp/SpriteTable[i].Attribute["法力上限"])*shipei)
          local ostr=""
          local pstr=""
          for i=1,xt do
            ostr=table.concat({ostr," "})
          end
          data[#data].血条=ostr
          for i=1,lt do
            pstr=table.concat({pstr," "})
          end
          data[#data].蓝条=pstr
        end
      end
     elseif SpriteTable[i].ph ~= nil then
      table.insert(data1,{名称境界=table.concat({SpriteTable[i].name,"\n",ptjj[SpriteTable[i].level]["境界"]}),
      血量显示=table.concat({math.ceil(SpriteTable[i].Hp),"/",math.ceil(SpriteTable[i].Attribute["气血上限"])}),法力显示=table.concat({math.ceil(SpriteTable[i].Mp),"/",math.ceil(SpriteTable[i].Attribute["法力上限"])}),id=i})
      local xt = math.ceil((SpriteTable[i].Hp/SpriteTable[i].Attribute["气血上限"])*shipei)
      local lt = math.ceil((SpriteTable[i].Mp/SpriteTable[i].Attribute["法力上限"])*shipei)
      local ostr=""
      local pstr=""
      for i=1,xt do
        ostr=table.concat({ostr," "})
      end
      data1[#data1].血条=ostr
      for i=1,lt do
        pstr=table.concat({pstr," "})
      end
      data1[#data1].蓝条=pstr
     else
      table.insert(data1,{名称境界=SpriteTable[i].key.."\n"..境界[SpriteTable[i].level]["境界"],
      血量显示=table.concat({math.ceil(SpriteTable[i].Hp),"/",math.ceil(SpriteTable[i].Attribute["气血上限"])}),法力显示=table.concat({math.ceil(SpriteTable[i].Mp),"/",math.ceil(SpriteTable[i].Attribute["法力上限"])}),id=i})
      local xt = math.ceil((SpriteTable[i].Hp/SpriteTable[i].Attribute["气血上限"])*shipei)
      local lt = math.ceil((SpriteTable[i].Mp/SpriteTable[i].Attribute["法力上限"])*shipei)
      local ostr=""
      local pstr=""
      for i=1,xt do
        ostr=table.concat({ostr," "})
      end
      data1[#data1].血条=ostr
      for i=1,lt do
        pstr=table.concat({pstr," "})
      end
      data1[#data1].蓝条=pstr
    end
  end
  战斗信息.Adapter = nil
  战斗信息.Adapter=adp5
  敌方面板.Adapter = nil
  敌方面板.Adapter=adp1
  己方面板.Adapter = nil
  己方面板.Adapter=adp
  function 战斗开始()
    jincheng()
  end
  function 战斗重复()
    if SaveTable.gj ~= nil then
      loadsavewrite(0)
      adp5.clear()
      local tab = GetSpriteTable(key)
      sp=GetSp(tab)
      for k,v in pairs(tab) do
        SpriteTable[k] = v
      end
      local num = #data
      for i=1,num do
        table.remove(data)
      end
      local num1 = #data1
      for i=1,num1 do
        table.remove(data1)
      end
      for i=1,#SpriteTable do
        SpriteTable[i].id = i
        SpriteTable[i].sp = SpriteTable[i].sp + SpriteTable[i].hard
        if SpriteTable[i].team == 1 then
          if SpriteTable[i].ph ~= nil then
            table.insert(data,{名称境界=table.concat({SpriteTable[i].name,"\n",ptjj[SpriteTable[i].level]["境界"]}),
            血量显示=table.concat({math.ceil(SpriteTable[i].Hp),"/",math.ceil(SpriteTable[i].Attribute["气血上限"])}),法力显示=table.concat({math.ceil(SpriteTable[i].Mp),"/",math.ceil(SpriteTable[i].Attribute["法力上限"])}),id=i})
            local xt = math.ceil((SpriteTable[i].Hp/SpriteTable[i].Attribute["气血上限"])*shipei)
            local lt = math.ceil((SpriteTable[i].Mp/SpriteTable[i].Attribute["法力上限"])*shipei)
            local ostr=""
            local pstr=""
            for i=1,xt do
              ostr=table.concat({ostr," "})
            end
            data[#data].血条=ostr
            for i=1,lt do
              pstr=table.concat({pstr," "})
            end
            data[#data].蓝条=pstr
           else
            if SpriteTable[i].level ~= nil then
              table.insert(data,{名称境界=SpriteTable[i].key.."\n"..境界[SpriteTable[i].level]["境界"],
              血量显示=table.concat({math.ceil(SpriteTable[i].Hp),"/",math.ceil(SpriteTable[i].Attribute["气血上限"])}),法力显示=table.concat({math.ceil(SpriteTable[i].Mp),"/",math.ceil(SpriteTable[i].Attribute["法力上限"])}),id=i})
              local xt = math.ceil((SpriteTable[i].Hp/SpriteTable[i].Attribute["气血上限"])*shipei)
              local lt = math.ceil((SpriteTable[i].Mp/SpriteTable[i].Attribute["法力上限"])*shipei)
              local ostr=""
              local pstr=""
              for i=1,xt do
                ostr=table.concat({ostr," "})
              end
              data[#data].血条=ostr
              for i=1,lt do
                pstr=table.concat({pstr," "})
              end
              data[#data].蓝条=pstr
            end
          end
         else
          table.insert(data1,{名称境界=SpriteTable[i].key.."\n"..境界[SpriteTable[i].level]["境界"],
          血量显示=table.concat({math.ceil(SpriteTable[i].Hp),"/",math.ceil(SpriteTable[i].Attribute["气血上限"])}),法力显示=table.concat({math.ceil(SpriteTable[i].Mp),"/",math.ceil(SpriteTable[i].Attribute["法力上限"])}),id=i})
          local xt = math.ceil((SpriteTable[i].Hp/SpriteTable[i].Attribute["气血上限"])*shipei)
          local lt = math.ceil((SpriteTable[i].Mp/SpriteTable[i].Attribute["法力上限"])*shipei)
          local ostr=""
          local pstr=""
          for i=1,xt do
            ostr=table.concat({ostr," "})
          end
          data1[#data1].血条=ostr
          for i=1,lt do
            pstr=table.concat({pstr," "})
          end
          data1[#data1].蓝条=pstr
        end
      end
      adp1.notifyDataSetChanged()
      adp.notifyDataSetChanged()
      SpriteTable:SetUI(nil,"战斗开始!")
      if 战斗计时 == nil then
        战斗计时=Ticker()
        战斗计时.Period=speed
        战斗计时.onTick=function()
          战斗开始()
        end
      end
      战斗计时.start()
     else
      zdinfo:getWindow("win",save,btui)
    end
  end
  function SetNowSp(sp,num)
    local ss = 1
    if sp["爆发行动"] ~= nil then
      ss = ss + sp["爆发行动"][1]/100
      sp["爆发行动"][1] = sp["爆发行动"][1] - sp["爆发行动"][2]
      if sp["爆发行动"][1] <= 0 then
        sp["爆发行动"] = nil
      end
    end
    if sp["累进行动"] ~= nil then
      ss = ss + sp["累进行动"][1]/100
      sp["累进行动"][1] = sp["累进行动"][1] + sp["累进行动"][2]
      if sp["累进行动"][1] > sp["累进行动"][3] then
        sp["累进行动"][1] = sp["累进行动"][3]
      end
    end
    return probability(sp.sp*ss/num)
  end
  function SkillColor(str,lv)
    if lv >= 13 then
      str={"<font color=",Color.gold,">",str,"</font>"}
     elseif lv >= 10 then
      str={"<font color=",Color.orange,">",str,"</font>"}
     elseif lv >= 7 then
      str={"<font color=",Color.red,">",str,"</font>"}
     elseif lv >= 4 then
      str={"<font color=",Color.blue,">",str,"</font>"}
     else
      str={"<font color=",Color.green,">",str,"</font>"}
    end
    return table.concat(str)
  end

  function GetColor(str,co)
    str={"<font color=",co,">",tostring(str),"</font>"}
    return table.concat(str)
  end
  function SpriteTable:GetCurrent()
    if act == nil then
      local num = GetSp(self)
      local zd
      for i=1,#self do
        if self[i] then
          if SetNowSp(self[i],num) then
            self:Attack(self[i])
            break
           else
            num = num - self[i].sp
          end
        end
      end
     else
      local idx
      for k,v in pairs(self) do
        if type(v) == "table" then
          if act == v.id then
            idx = k
            break
          end
        end
      end
      self:Attack(self[idx])
      act = nil
    end
  end
  function jincheng()
    if 战斗计时 ~= nil then
      SpriteTable:GetCurrent()
    end
  end
  function SpriteTable:RollSkillTable(current)
    local skillbox = {}
    for k,v in pairs(current.skill) do
      if v.eq == 1 then
        table.insert(skillbox,v)
      end
    end
    return skillbox
  end

  function SpriteTable:Attack(current)
    if current.buff ~= nil then
      if current.buff["回复"] ~= nil then
        local hfx = math.ceil(current.buff["回复"].number.Hp[1] * current.Attribute["气血上限"]/100)
        local hff = math.ceil(current.buff["回复"].number.Mp[1] * current.Attribute["法力上限"]/100)
        if hfx > current.buff["回复"].number.Hp[2] then
          hfx = current.buff["回复"].number.Hp[2]
        end
        if hff > current.buff["回复"].number.Mp[2] then
          hff = current.buff["回复"].number.Mp[2]
        end
        if hfx + current.Hp > current.Attribute["气血上限"] then
          hfx = current.Attribute["气血上限"] - current.Hp
        end
        if hff + current.Mp > current.Attribute["法力上限"] then
          hff = current.Attribute["法力上限"] - current.Mp
        end
        if hfx ~= 0 or hff ~= 0 then
          current.Hp = current.Hp + hfx
          current.Mp = current.Mp + hff
          local str = table.concat({Color:Get("『"..current.key.."』",1),"回复了",Color:Get(math.ceil(hfx),7),"点气血,",Color:Get(math.ceil(hff),4),"点法力!<br>"})
          self:SetUI(current,str)
        end
      end
    end
    local skillbox = self:RollSkillTable(current)
    local EnemyTable = self:GetEnemyTable(current.team)
    local pow = 0
    local x
    function atknow()
      local num
      local skill
      if #EnemyTable ~= 0 then
        if x ~= nil then
          if #EnemyTable > skillbox[x]["战斗参数"].hit then
            num = skillbox[x]["战斗参数"].hit
            skill = skillbox[x]
           else
            num = #EnemyTable
            skill = skillbox[x]
          end
         else
          num = 1
          skill = {key="普通攻击",["战斗参数"]={outpow=0.5,inpow=0.5,cost=0,MaxCd=0,Cd=0,hit=1}}
        end
        skill["战斗参数"].Cd = skill["战斗参数"].Cd + skill["战斗参数"].MaxCd
        current.Mp = current.Mp - skill["战斗参数"].cost
        table.sort(EnemyTable,function(a,b)
          return a.Attribute["气血上限"] > b.Attribute["气血上限"]
        end)
        for i=1,num do
          local Result = {Hp=0,Mp=0,buff={},mingzhong=true,baoji=false}
          self:AttackResult(current,EnemyTable[i],skill,Result)
        end
        for k,v in pairs(skillbox) do
          if v["战斗参数"].Cd > 0 then
            skillbox[k]["战斗参数"].Cd = v["战斗参数"].Cd - 1
           else
            skillbox[k]["战斗参数"].Cd = 0
          end
        end
        if current["增伤"] ~= nil then
          current["增伤"] = nil
        end
        if current["爆发攻击"] ~= nil then
          current["爆发攻击"][1] = current["爆发攻击"][1] - current["爆发攻击"][2]
          if current["爆发攻击"][1] <= 0 then
            current["爆发攻击"] = nil
          end
        end
        if current["爆发防御"] ~= nil then
          current["爆发防御"][1] = current["爆发防御"][1] - current["爆发防御"][2]
          if current["爆发防御"][1] <= 0 then
            current["爆发防御"] = nil
          end
        end
        if current["累进攻击"] ~= nil then
          current["累进攻击"][1] = current["累进攻击"][1] + current["累进攻击"][2]
          if current["累进攻击"][1] >= current["累进攻击"][3] then
            current["累进攻击"][1] = current["累进攻击"][3]
          end
        end
        if current["累进防御"] ~= nil then
          current["累进防御"][1] = current["累进防御"][1] + current["累进防御"][2]
          if current["累进防御"][1] >= current["累进防御"][3] then
            current["累进防御"][1] = current["累进防御"][3]
          end
        end
        if current["战斗参数"]["连击"] ~= nil and current["战斗参数"]["连击"] > 0 then
          local cl = {0x006400,0xFF4500}
          if probability(current["战斗参数"]["连击"]) then
            act = current.id
            提示(Html.fromHtml(GetColor(table.concat({"〖",current.key,"〗"}),cl[current.team]).."发动了连击!"))
          end
        end
        self:SetUI(nil,text)
        text = nil
       elseif (current.team == 2 and 战斗计时 ~= nil) then
        if piu ~= nil then
          piu.dismiss()
        end
        战斗计时.stop()
        self:SetUI(current,"战斗失败!\n")
        zdinfo:getWindow("lose",save,btui)
       elseif (key ~= nil and 战斗计时 ~= nil) then
        战斗计时.stop()
        战斗计时=nil
        if piu ~= nil then
          piu.dismiss()
        end
        if SaveTable.gj ~= nil then
          self:SetUI(current,"正在打坐调息中…\n")
          task(3000,function 战斗重复(key) end)
         else
          if save == nil then
            if type(rt) == "table" and rt["win"] ~= nil and rt["win"].type == "set_time" then
              SaveTable["刷新"][rt["win"].value.key] = {key=rt["win"].value.text,number={0,rt[f].value.number}}
            end
            loadsavewrite(0)
            SaveTable["重塑"]=nil
          end
          zdinfo:getWindow("win",save,btui)
        end
       elseif 战斗计时 ~= nil then
        if save == nil then
          if rt~=nil and rt["win"] ~= nil and rt["win"].type == "set_time" then
            SaveTable["刷新"][rt["win"].value.key] = {key=rt["win"].value.text,number={0,rt["win"].value.number}}
          end
          loadsavewrite(0)
          SaveTable["重塑"]=nil
        end
        if piu ~= nil then
          piu.dismiss()
        end
        战斗计时.stop()
        战斗计时=nil
        zdinfo:getWindow("win",save,btui)
      end
    end
    if (current.team == 1 and #EnemyTable ~= 0 and SaveTable.zid == nil) then
      战斗计时.stop()
      战斗计时=nil
      local o
      local u
      function 角色行动()
        local zdck = {
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
                onClick=function pugong() end;
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
                      text="攻击";
                      textColor="#FFFFFF";
                      layout_gravity="center";
                    };
                  };
                };
              };
              {
                CardView;
                onClick=function skilllist() end;
                layout_width="13%w";
                layout_marginLeft="13.5%h";
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
                      text="法术";
                      textColor="#FFFFFF";
                      layout_gravity="center";
                    };
                  };
                };
              };
              {
                CardView;
                onClick=function
                  if u ~= nil then
                    u.dismiss()
                  end
                  local fslb = {
                    LinearLayout;
                    layout_height="fill";
                    layout_width="fill";
                    orientation="vertical";
                    backgroundColor="#ffffff";
                    {
                      CardView;
                      layout_height="5%h";
                      backgroundColor="#000000";
                      layout_width="fill";
                      {
                        TextView;
                        text="道具界面";
                        textColor="#FFFFFF";
                        textSize=getsize(18);
                        layout_margin="2%w";
                      };
                    };
                    {
                      LinearLayout;
                      layout_height="fill";
                      orientation="horizontal";
                      layout_width="fill";
                      {
                        ListView;
                        layout_height="fill";
                        id="道具列表";
                        layout_width="fill";
                      };
                    };
                  };
                  u=AlertDialog.Builder(this).show()
                  u.getWindow().setContentView(loadlayout(fslb));
                  local its2 = {
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
                          id="name4";
                        };
                      };
                    };
                  };
                  local 品阶 = {"黄阶下品","黄阶中品","黄阶上品","玄阶下品","玄阶中品","玄阶上品","地阶下品","地阶中品","地阶上品","天阶下品","天阶中品","天阶上品","仙品"}
                  local data3={}
                  local djbox = {}
                  local adp2=LuaAdapter(activity,data3,its2)
                  for k,v in pairs(SaveTable.Item) do
                    for i=1,#Item do
                      if Item[i].key == v.key then
                        if Item[i].bt ~= nil then
                          table.insert(djbox,Item[i])
                          table.insert(data3,{name4=Color:Set(v.key.."["..品阶[Item[i]["品质"]].."][数量:"..math.ceil(v.number).."]",Item[i]["品质"])})
                        end
                      end
                    end
                  end
                  道具列表.Adapter=adp2
                  local log
                  道具列表.onItemClick=function(l,v,p,i)
                    if log ~= nil then
                      log.dismiss()
                    end
                    log=AlertDialog.Builder(this)
                    .setTitle(Color:Set(djbox[i].key.."["..品阶[djbox[i]["品质"]].."]",djbox[i]["品质"]))
                    .setMessage(table.concat({"物品信息:",djbox[i].Info}))
                    .setPositiveButton("使用",{onClick=function(v)
                        local function DeleteItem(key,num)
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
                        if djbox[i]["资源参数"]["战斗回复"] then
                          local addx = math.ceil(current.Attribute["气血上限"] * djbox[i]["资源参数"]["战斗回复"][2]/100)
                          local addf = math.ceil(current.Attribute["法力上限"] * djbox[i]["资源参数"]["战斗回复"][2]/100)
                          if addx > djbox[i]["资源参数"]["战斗回复"][1][1] then
                            addx = djbox[i]["资源参数"]["战斗回复"][1][1]
                          end
                          if addf > djbox[i]["资源参数"]["战斗回复"][1][2] then
                            addf = djbox[i]["资源参数"]["战斗回复"][1][2]
                          end
                          if current.Hp + addx > current.Attribute["气血上限"] then
                            addx = current.Attribute["气血上限"] - current.Hp
                          end
                          if current.Mp + addf > current.Attribute["法力上限"] then
                            addf = current.Attribute["法力上限"] - current.Mp
                          end
                          current.Hp = current.Hp + addx
                          current.Mp = current.Mp + addf
                          local str = table.concat({Color:Get("『"..current.key.."』",1),"使用",Color:Get("["..djbox[i].key.."]",djbox[i]["品质"]),"回复了",Color:Get(math.ceil(addx),7),"点气血,",Color:Get(math.ceil(addf),4),"点法力!<br>"})
                          self:SetUI(current,str)
                        end
                        DeleteItem(djbox[i].key,1)
                        行动.removeViews(0,1)
                        o.dismiss()
                        u.dismiss()
                        战斗计时=Ticker()
                        战斗计时.Period=speed
                        战斗计时.onTick=function()
                          战斗开始()
                        end
                        战斗计时.start()
                    end})
                    .setNegativeButton("取消",nil)
                    .show()
                    log.create()
                  end
                end;
                layout_width="13%w";
                layout_marginLeft="13.5%h";
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
                      text="道具";
                      textColor="#FFFFFF";
                      layout_gravity="center";
                    };
                  };
                };
              };
            };
          };
        };
        local s
        function skilllist()
          local fslb = {
            LinearLayout;
            layout_height="fill";
            layout_width="fill";
            orientation="vertical";
            backgroundColor="#ffffff";
            {
              CardView;
              layout_height="5%h";
              backgroundColor="#000000";
              layout_width="fill";
              {
                TextView;
                text="法术界面";
                textColor="#FFFFFF";
                textSize=getsize(18);
                layout_margin="2%w";
              };
            };
            {
              LinearLayout;
              layout_height="fill";
              orientation="horizontal";
              layout_width="fill";
              {
                ListView;
                layout_height="fill";
                id="法术列表";
                layout_width="fill";
              };
            };
          };
          s=AlertDialog.Builder(this).show()
          s.getWindow().setContentView(loadlayout(fslb));
          local its2 = {
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
          local 品阶 = {"黄阶初级","黄阶中级","黄阶高级","玄阶初级","玄阶中级","玄阶高级","地阶初级","地阶中级","地阶高级","天阶初级","天阶中级","天阶高级","仙术"}
          local data3={}
          local adp2=LuaAdapter(activity,data3,its2)
          for k,v in pairs(skillbox) do
            if v["战斗参数"].Cd ~= 0 then
              table.insert(data3,{name=Color:Set(v.key.."["..品阶[v["战斗参数"]["品质"]].."][冷却剩余:"..math.ceil(v["战斗参数"].Cd).."回合]",v["战斗参数"]["品质"])})
             else
              table.insert(data3,{name=Color:Set(v.key.."["..品阶[v["战斗参数"]["品质"]].."]",v["战斗参数"]["品质"])})
            end
          end
          法术列表.Adapter=adp2
          local log
          法术列表.onItemClick=function(l,v,p,i)
            if skillbox[i]["战斗参数"].Cd == 0 then
              if log ~= nil then
                log.dismiss()
              end
              log=AlertDialog.Builder(this)
              .setTitle(Color:Set(skillbox[i].key.."["..品阶[skillbox[i]["战斗参数"]["品质"]].."]",skillbox[i]["战斗参数"]["品质"]))
              .setMessage(table.concat({"外攻伤害:",math.ceil(skillbox[i]["战斗参数"].outpow*100),"%\t   内攻伤害:",math.ceil(skillbox[i]["战斗参数"].inpow*100),"%\n法力消耗:",math.ceil(skillbox[i]["战斗参数"].cost),"\t   攻击范围:",math.ceil(skillbox[i]["战斗参数"].hit)}))
              .setPositiveButton("使用",{onClick=function(v)
                  if current.Mp >= skillbox[i]["战斗参数"].cost then
                    x=i
                    o.dismiss()
                    s.dismiss()
                    atknow()
                    战斗计时=Ticker()
                    战斗计时.Period=speed
                    战斗计时.onTick=function()
                      战斗开始()
                    end
                    战斗计时.start()
                    行动.removeViews(0,1)
                   else
                    提示("法力值不足")
                  end
              end})
              .setNegativeButton("取消",nil)
              .show()
              log.create()
             else
              MD提示("该法术还未冷却，无法选择")
            end
          end
        end
        function pugong()
          x=nil
          o.dismiss()
          行动.removeViews(0,1)
          atknow()
          战斗计时=Ticker()
          战斗计时.Period=speed
          战斗计时.onTick=function()
            战斗开始()
          end
          战斗计时.start()
        end
        if o ~= nil then
          o.dismiss()
        end
        o=AlertDialog.Builder(this).show()
        o.getWindow().setContentView(loadlayout(zdck));
        人物信息.Text=Html.fromHtml(table.concat({"当前行动:",Color:Get(current.key,1),"<br>当前血量:",Color:Get(table.concat({math.ceil(current.Hp),"/",math.ceil(current.Attribute["气血上限"])}),7),"<br>当前法力:",Color:Get(table.concat({math.ceil(current.Mp),"/",math.ceil(current.Attribute["法力上限"])}),4)}))
      end
      local xingd = {
        CardView;
        onClick=function 角色行动() end;
        layout_height="5%h";
        layout_width="20%w";
        backgroundColor="#000000";
        radius="1%h";
        {
          CardView;
          layout_height="match_parent";
          radius="0.8%h";
          layout_margin="0.4%w";
          layout_width="match_parent";
          {
            CardView;
            id="popx";
            backgroundColor="#000000";
            layout_height="match_parent";
            radius="0.65%h";
            layout_margin="0.4%w";
            layout_width="match_parent";
            {
              TextView;
              layout_gravity="center";
              textColor="#FFFFFF";
              text="行动";
              textSize=getsize(16);
            };
          };
        };
      };
      行动.addView(loadlayout(xingd))
      import "android.view.animation.AlphaAnimation"
      --设置动画的属性
      local 透明动画=AlphaAnimation(0,1)
      透明动画.setDuration(1000)--设置动画时间
      透明动画.setFillAfter(true)--设置动画后停留位置
      透明动画.setRepeatCount(-1)--设置无限循环
      --绑定动画
      popx.startAnimation(透明动画)
     elseif SaveTable.set["嗑药"]["恢复"] ~= nil and (current.Hp < current.Attribute["气血上限"]*SaveTable.set["嗑药"]["百分比"]/100 or current.Mp < current.Attribute["法力上限"]*SaveTable.set["嗑药"]["百分比"]/100) and current.team == 1 and Itnum(SaveTable.set["嗑药"]["恢复"]) > 0 and 应用方式(current.key) == true then
      local ltb = ky["恢复"][SaveTable.set["嗑药"]["恢复"]]
      local addx = math.ceil(current.Attribute["气血上限"] * ltb.value/100)
      local addf = math.ceil(current.Attribute["法力上限"] * ltb.value/100)
      if addx > ltb.number[1] then
        addx = ltb.number[1]
      end
      if addf > ltb.number[2] then
        addf = ltb.number[2]
      end
      if current.Hp + addx > current.Attribute["气血上限"] then
        addx = current.Attribute["气血上限"] - current.Hp
      end
      if current.Mp + addf > current.Attribute["法力上限"] then
        addf = current.Attribute["法力上限"] - current.Mp
      end
      current.Hp = current.Hp + addx
      current.Mp = current.Mp + addf
      删除物品(SaveTable.set["嗑药"]["恢复"],1)
      local str = table.concat({Color:Get("『"..current.key.."』",1),"使用",Color:Get("["..SaveTable.set["嗑药"]["恢复"].."]",ltb.level),"回复了",Color:Get(math.ceil(addx),7),"点气血,",Color:Get(math.ceil(addf),4),"点法力!<br>"})
      self:SetUI(current,str)
     else
      if SaveTable.set["嗑药"]["恢复"] ~= nil and Itnum(SaveTable.set["嗑药"]["恢复"]) < 1 then
        SaveTable.set["嗑药"]["恢复"] = nil
      end
      for k,v in pairs(skillbox) do
        local num1
        if #EnemyTable >= v["战斗参数"].hit then
          num1 = v["战斗参数"].hit
         else
          num1 = #EnemyTable
        end
        local num = (current.Attribute["内攻"] * skillbox[k]["战斗参数"].inpow + current.Attribute["外攻"] * skillbox[k]["战斗参数"].outpow)*num1
        if (v["战斗参数"].Cd == 0 and v["战斗参数"].cost <= current.Mp and num > pow) then
          pow = num
          x = k
        end
      end
      atknow()
    end
  end

  function Resultbaoji(m,s,a,b)
    local bj = m/(m + s)
    local num = bj^(2-bj)
    return probability(num+a/100-b/100)
  end

  function ResultMiss(m,s,a,b)
    local mz = m/(m + s)
    local num = mz^(1-mz)
    return probability(num+a/100-b/100)
  end

  function SpriteTable:AttackResult(Source,Target,skill,result)
    local yazhi = Source.hard / Target.hard
    if ResultMiss(Source.Attribute["命中"]*yazhi,Target.Attribute["闪避"]/yazhi,Source["战斗参数"]["绝对命中"]*yazhi,Target["战斗参数"]["绝对闪避"]/yazhi) then
      result.mingzhong = true
      local wuc = 1
      local fac = 1
      if Source.ph ~= nil then
        wuc = wuc + Source.Attribute["物穿"] * yazhi * yazhi/100
        fac = fac + Source.Attribute["法穿"] * yazhi * yazhi/100
      end
      local fyup = 1
      if Target["爆发防御"] ~= nil then
        fyup = fyup + Target["爆发防御"][1]/100
      end
      if Target["累进防御"] ~= nil then
        fyup = fyup + Target["累进防御"][1]/100
      end
      local indef = 1/(1+Target.Attribute["内防"]/500/yazhi*fac*fyup)
      local outdef = 1/(1+Target.Attribute["外防"]/500/yazhi*wuc*fyup)
      local fangda = 1+Source.Attribute["最终伤害放大"]*0.01/yazhi
      local dixiao = 1/(1+Target.Attribute["最终伤害抵消"]*0.01/yazhi)
      result.Hp = (Source.Attribute["内攻"] * skill["战斗参数"].inpow*indef*fangda*dixiao+Source.Attribute["外攻"] * skill["战斗参数"].outpow*outdef*fangda*dixiao) * 0.5
      if Resultbaoji(Source.Attribute["会心率"]*yazhi,Target.Attribute["抗会心率"]/yazhi,Source["战斗参数"]["绝对暴击"]*yazhi,Target["战斗参数"]["绝对免暴"]/yazhi) then
        local bs = ((Source.Attribute["会心伤害"]*yazhi)/(Target.Attribute["会心免伤"]/yazhi)) + 1
        result.Hp = result.Hp * bs
        if Source["战斗参数"]["暴击回复"] ~= nil and Source["战斗参数"]["暴击回复"] > 0 then
          Source.Hp = Source.Hp + Source.Attribute["气血上限"] * Source["战斗参数"]["暴击回复"]
          if Source.Hp > Source.Attribute["气血上限"] then
            Source.Hp = Source.Attribute["气血上限"]
          end
          Source.Mp = Source.Mp + Source.Attribute["法力上限"] * Source["战斗参数"]["暴击回复"]
          if Source.Mp > Source.Attribute["法力上限"] then
            Source.Mp = Source.Attribute["法力上限"]
          end
        end
        if Source["战斗参数"]["暴击伤害"] ~= nil and Source["战斗参数"]["暴击伤害"] > 0 then
          result.Hp = result.Hp * (1+Source["战斗参数"]["暴击伤害"]/100)
        end
        result.baoji = true
       else
        result.baoji = false
      end
     else
      if Target["战斗参数"]["闪避回复"] ~= nil and Target["战斗参数"]["闪避回复"] > 0 then
        Target.Hp = Target.Hp + Target.Attribute["气血上限"] * Target["战斗参数"]["闪避回复"]
        if Target.Hp > Target.Attribute["气血上限"] then
          Target.Hp = Target.Attribute["气血上限"]
        end
        Target.Mp = Target.Mp + Target.Attribute["法力上限"] * Target["战斗参数"]["闪避回复"]
        if Target.Mp > Target.Attribute["法力上限"] then
          Target.Mp = Target.Attribute["法力上限"]
        end
      end
      if Target["战斗参数"]["闪避增伤"] ~= nil and Target["战斗参数"]["闪避增伤"] > 0 then
        if Target["增伤"] == nil then
          Target["增伤"] = {value=Target["战斗参数"]["闪避增伤"],round=1}
         else
          Target["增伤"].value = Target["增伤"].value + Target["战斗参数"]["闪避增伤"]
        end
      end
      result.mingzhong = false
    end
    if Source.key1 ~= nil and skill.key ~= "普通攻击" then
      local ptsx = pettt[Source.ph][Source.key1]["属性"]
      for k,v in pairs(ptsx) do
        if skill["战斗参数"]["属性"][k] ~= nil then
          local sxzs = skill["战斗参数"]["属性"][k] * Source["战斗参数"][k]
          result.Hp = result.Hp * (1 + v * sxzs)
        end
      end
    end
    if result.Hp > 0 then
      result.Hp = math.ceil(math.random(math.ceil(result.Hp*0.8),math.ceil(result.Hp*1.2)) * (Source.hard/200))
      if Target.ph ~= nil then
        local mian = 1+Target.Attribute["免伤"]/100/yazhi/yazhi
        local jian = Target.Attribute["减伤"]/yazhi/yazhi
        local fan = Target.Attribute["反伤"]/yazhi/yazhi/100
        result.Hp = math.ceil(result.Hp/mian - jian)
        local faa = result.Hp
        if result.Hp > Target.Hp then
          faa = Target.Hp
        end
        if faa < 0 then
          faa = 0
        end
        Source.Hp = Source.Hp - (faa*fan)
        if Source.Hp <= 0 then
          Source.Hp = 1
        end
      end
      if Source.ph ~= nil then
        local zeng = 1+Source.Attribute["增伤"]/100*yazhi*yazhi
        local fu = Source.Attribute["附伤"]*yazhi*yazhi
        local hphf = Source.Attribute["气血回复"]
        local mphf = Source.Attribute["法力回复"]
        result.Hp = math.ceil(result.Hp * zeng + fu)
      end
    end
    if (Source.team == 1 and skill.key ~= "普通攻击") then
      if result.Hp > Target.Hp then
        if Source.ph ~= nil then
          petAddSkillExp(skill.key,math.ceil(Target.Hp * 0.01),skill["战斗参数"]["品质"],Source.pd)
         else
          AddSkillExp(skill.key,math.ceil(Target.Hp * 0.01),skill["战斗参数"]["品质"])
        end
       else
        if Source.ph ~= nil then
          petAddSkillExp(skill.key,math.ceil(result.Hp * 0.01),skill["战斗参数"]["品质"],Source.pd)
         else
          AddSkillExp(skill.key,math.ceil(result.Hp * 0.01),skill["战斗参数"]["品质"])
        end
      end
    end
    self:Battlesettlement(Source,Target,skill,result)
  end

  function SpriteTable:Battlesettlement(Source,Target,skill,result)
    if Source.buff ~= nil then
      if Source.buff["增伤"] ~= nil then
        local zjsh = math.ceil(result.Hp * Source.buff["增伤"].number[1] / 100)
        if zjsh > Source.buff["增伤"].number[2] then
          zjsh = Source.buff["增伤"].number[2]
        end
        result.Hp = result.Hp + zjsh
      end
    end
    if Target.buff ~= nil then
      if Target.buff["免伤"] ~= nil then
        local zjsh = math.ceil(result.Hp * Target.buff["免伤"].number[1] / 100)
        if zjsh > Target.buff["免伤"].number[2] then
          zjsh = Target.buff["免伤"].number[2]
        end
        result.Hp = result.Hp - zjsh
      end
    end
    if string.find(skill.key,"火") ~= nil and string.find(Target.key,"煞魔") ~= nil then
      result.Hp = math.ceil(result.Hp * 1.5)
    end
    if Source["增伤"] ~= nil then
      result.Hp = math.ceil(result.Hp*(1+Source["增伤"].value))
    end
    if result.Hp > 0 then
      if Source["战斗参数"]["绝境"] ~= nil then
        local zs = math.floor(((Source.Attribute["气血上限"] - Source.Hp)/Source.Attribute["气血上限"]/(Source["战斗参数"]["绝境"][1]/100)))*Source["战斗参数"]["绝境"][2]/100
        result.Hp = math.ceil(result.Hp * (1+zs))
      end
      if Target["战斗参数"]["逆境"] ~= nil then
        local zs = math.floor(((Target.Attribute["气血上限"] - Target.Hp)/Target.Attribute["气血上限"]/(Target["战斗参数"]["逆境"][1]/100)))*Target["战斗参数"]["逆境"][2]/100
        result.Hp = math.ceil(result.Hp * (1-zs))
      end
    end
    if Source["爆发攻击"] ~= nil then
      result.Hp = result.Hp * (1 + Source["爆发攻击"][1]/100)
    end
    if Source["累进攻击"] ~= nil then
      result.Hp = result.Hp * (1 + Source["累进攻击"][1]/100)
    end
    if result.Hp > Target.Hp then
      result.Hp = Target.Hp
    end
    local cl = {0x006400,0xFF4500}
    text=text or ""
    if skill.key == "圆月斩" then
      if probability(0.08*skill.level) then
        skill["战斗参数"].Cd = 0
      end
    end
    if Target["战斗参数"]["免伤"] ~= nil and Target["战斗参数"]["免伤"].value > 0 then
      if probability(Target["战斗参数"]["免伤"].value/100) then
        result.Hp = math.ceil(result.Hp * (1-Target["战斗参数"]["免伤"].value1/100))
      end
    end
    if result.mingzhong == true then
      if skill.key == "魔佛黑莲印" then
        Source.Hp = Source.Hp + math.ceil(result.Hp * 0.5)
        if Source.Hp > Source.Attribute["气血上限"] then
          Source.Hp = Source.Attribute["气血上限"]
        end
      end
      if Source["战斗参数"]["吸取生命"] ~= nil and Source["战斗参数"]["吸取生命"] > 0 then
        Source.Hp = Source.Hp + math.ceil(result.Hp * Source["战斗参数"]["吸取生命"].value/100)
        if Source.Hp > Source.Attribute["气血上限"] then
          Source.Hp = Source.Attribute["气血上限"]
        end
      end
      if Source["战斗参数"]["吸取法力"] ~= nil and Source["战斗参数"]["吸取法力"] > 0 then
        Source.Mp = Source.Mp + math.ceil(result.Hp * Source["战斗参数"]["吸取法力"].value/100)
        Target.Mp = Target.Mp - math.ceil(result.Hp * Source["战斗参数"]["吸取法力"].value/100)
        if Source.Mp > Source.Attribute["法力上限"] then
          Source.Mp = Source.Attribute["法力上限"]
        end
        if Target.Mp < 0 then
          Target.Mp = 0
        end
      end
      if result.baoji == true then
        if skill.key ~= "普通攻击" then
          if result.Hp > 0 then
            text = table.concat({"&nbsp;暴击!",GetColor(table.concat({"〖",Source.key,"〗"}),cl[Source.team]),"使用",SkillColor(table.concat({"『",skill.key,"』"}),skill["战斗参数"]["品质"]),"对",GetColor(table.concat({"〖",Target.key,"〗"}),cl[Target.team]),"造成",math.ceil(result.Hp),"点伤害!<br>",text})
           else
            result.Hp = 0
            text = table.concat({GetColor(table.concat({"〖",Source.key,"〗"}),cl[Source.team]),"使用",SkillColor(table.concat({"『",skill.key,"』"}),skill["战斗参数"]["品质"]),"但未能破开",GetColor(table.concat({"〖",Target.key,"〗"}),cl[Target.team]),"的防御!<br>",text})
          end
         else
          if result.Hp > 0 then
            text = table.concat({"&nbsp;暴击!",GetColor(table.concat({"〖",Source.key,"〗"}),cl[Source.team]),"使用",table.concat({"『",skill.key,"』"}),"对",GetColor(table.concat({"〖",Target.key,"〗"}),cl[Target.team]),"造成",math.ceil(result.Hp),"点伤害!<br>",text})
           else
            result.Hp = 0
            text = table.concat({GetColor(table.concat({"〖",Source.key,"〗"}),cl[Source.team]),"使用『",skill.key,"』但未能破开",GetColor(table.concat({"〖",Target.key,"〗"}),cl[Target.team]),"的防御!<br>",text})
          end
        end
       else
        if skill.key ~= "普通攻击" then
          if result.Hp > 0 then
            text = table.concat({GetColor(table.concat({"〖",Source.key,"〗"}),cl[Source.team]),"使用",SkillColor(table.concat({"『",skill.key,"』"}),skill["战斗参数"]["品质"]),"对",GetColor(table.concat({"〖",Target.key,"〗"}),cl[Target.team]),"造成",math.ceil(result.Hp),"点伤害!<br>",text})
           else
            result.Hp = 0
            text = table.concat({GetColor(table.concat({"〖",Source.key,"〗"}),cl[Source.team]),"使用",SkillColor(table.concat({"『",skill.key,"』"}),skill["战斗参数"]["品质"]),"但未能破开",GetColor(table.concat({"〖",Target.key,"〗"}),cl[Target.team]),"的防御!<br>",text})
          end
         else
          if result.Hp > 0 then
            text = table.concat({GetColor(table.concat({"〖",Source.key,"〗"}),cl[Source.team]),"使用",table.concat({"『",skill.key,"』"}),"对",GetColor(table.concat({"〖",Target.key,"〗"}),cl[Target.team]),"造成",math.ceil(result.Hp),"点伤害!<br>",text})
           else
            result.Hp = 0
            text = table.concat({GetColor(table.concat({"〖",Source.key,"〗"}),cl[Source.team]),"使用『",skill.key,"』但未能破开",GetColor(table.concat({"〖",Target.key,"〗"}),cl[Target.team]),"的防御!<br>",text})
          end
        end
      end
     elseif skill.key ~= "普通攻击" then
      text = table.concat({GetColor(table.concat({"〖",Target.key,"〗"}),cl[Target.team]),"闪避了",GetColor(table.concat({"〖",Source.key,"〗"}),cl[Source.team]),"的",SkillColor(table.concat({"『",skill.key,"』"}),skill["战斗参数"]["品质"]),"!<br>",text})
     else
      text = table.concat({GetColor(table.concat({"〖",Target.key,"〗"}),cl[Target.team]),"闪避了",GetColor(table.concat({"〖",Source.key,"〗"}),cl[Source.team]),"的",table.concat({"『",skill.key,"』"}),"!<br>",text})
    end
    Target.Hp = Target.Hp - result.Hp
    if result.Hp > 0 and Source["战斗参数"]["多重伤害"] ~= nil then
      while probability(Source["战斗参数"]["多重伤害"].value/100) == true and Target.Hp > 0 do
        local dcdm = math.ceil(Source["战斗参数"]["多重伤害"].value1*result.Hp*0.01)
        local dcsh = math.random(math.ceil(dcdm*0.8),math.ceil(dcdm*1.2))
        if dcsh > Target.Hp then
          dcsh = Target.Hp
        end
        text = table.concat({"多重攻击!",GetColor(table.concat({"〖",Source.key,"〗"}),cl[Source.team]),"使用",table.concat({"『",skill.key,"』"}),"对",GetColor(table.concat({"〖",Target.key,"〗"}),cl[Target.team]),"造成",math.ceil(dcsh),"点伤害!<br>",text})
        Target.Hp = Target.Hp - dcsh
      end
    end
    if Source.team == 1 then
      zdinfo.danmage[Source.key] = zdinfo.danmage[Source.key] + result.Hp
    end
    if Target.Hp <= 0 then
      if SaveTable["击杀"][Target.key] ~= nil then
        SaveTable["击杀"][Target.key] = SaveTable["击杀"][Target.key] + 1
      end
      if Target.team == 2 then
        zdinfo["杀敌数"]=zdinfo["杀敌数"]+1
      end
      Target.Hp = 0
      if Target["战斗参数"]["复活"] ~= nil and Target["战斗参数"]["复活"] > 0 and probability(Source["战斗参数"]["复活"].value/100) then
        Target.Hp = Target.Attribute["气血上限"]
        Target.Mp = Target.Attribute["法力上限"]
        提示(Html.fromHtml(GetColor(table.concat({"〖",Target.key,"〗"}),cl[Target.team]).."血量法力全部回复到满值!"))
       else
        for i=1,#self do
          if type(self[i]) == "table" then
            if Target.id == self[i].id then
              table.remove(self,i)
            end
          end
        end
        text="<br>"..text
      end
      local ewdl = 1
      if Source["战斗参数"]["额外掉落"] ~= nil and Source["战斗参数"]["额外掉落"] > 0 then
        ewdl = ewdl + Source["战斗参数"]["额外掉落"]/100
      end
      if Target.drop ~= nil then
        if Target.drop["随机材料"] ~= nil then
          for k,v in pairs(drop_tb[Target.drop["随机材料"][1]]) do
            local gl = Target.drop["随机材料"][3]
            if v.pro ~= nil then
              gl = gl * v.pro
            end
            if probability(gl*ewdl) then
              local num = math.random(Target.drop["随机材料"][2][1],Target.drop["随机材料"][2][2])
              Item:Add(v.key,num)
              if zdinfo.drop[v.key] ~= nil then
                zdinfo.drop[v.key] = zdinfo.drop[v.key] + num
               else
                zdinfo.drop[v.key] = num
              end
              text=table.concat({"&nbsp;掉落物品",Color:Get(v.key,Item:GetLevel(v.key)),"*",math.ceil(num),"!<br>",text})
            end
          end
        end
        if Target.drop["宠兽"] ~= nil then
          if probability(0.5) then
            local num = math.random(0,10000)
            for k,v in pairs(Target.drop["宠兽"]) do
              if num > v then
                local tb = {{"#808080"},{"#008000"},{"#0000FF"},{"#FF0000"},{"#FFA500"},{"#FFD700"}}
                if zdinfo.pet == nil then
                  zdinfo.pet={}
                end
                local key1
                if Target.key1 ~= nil then
                  key1 = Target.key1
                 else
                  key1 = Target.key
                end
                addpet(7-k,Target.ph,key1,key1)
                text=table.concat({"你获得了一只",yansep(Target.key,tb[7-k]),"幼崽!<br>",text})
                table.insert(zdinfo.pet,yansep(key1,tb[7-k]))
                break
              end
            end
          end
        end
        local numb = 1
        if SaveTable["新衣"] ~= nil then
          numb = 1.2
        end
        for k,v in pairs(Target.drop.item) do
          if probability(v.probability*numb*ewdl) then
            local num = 1
            if v.number ~= nil then
              num = v.number
            end
            Item:Add(v.drop,num)
            if zdinfo.drop[v.drop] ~= nil then
              zdinfo.drop[v.drop] = zdinfo.drop[v.drop] + num
             else
              zdinfo.drop[v.drop] = num
            end
            text=table.concat({"&nbsp;掉落物品",Color:Get(v.drop,Item:GetLevel(v.drop)),"*",num,"!<br>",text})
          end
        end
        SaveTable.owner.money = SaveTable.owner.money + math.ceil(Target.drop.money*numb*ewdl)
        zdinfo.money = zdinfo.money + math.ceil(Target.drop.money*numb)
        local jxw = math.ceil(Target.drop["修为"]*numb*ewdl)
        zdinfo["修为"] = zdinfo["修为"] + jxw
        SaveTable.owner["修为"] = SaveTable.owner["修为"] + jxw
        for k,v in pairs(SaveTable.pet) do
          if v.eq == 1 then
            v["修为"] = v["修为"] + jxw
          end
        end
        text=table.concat({"<br>",GetColor(table.concat({"〖",Target.key,"〗"}),cl[Target.team]),"已被",GetColor(table.concat({"〖",Source.key,"〗"}),cl[Source.team]),"击败!<br>&nbsp;掉落灵石",math.ceil(Target.drop.money*numb*ewdl),"个!<br>&nbsp;全体获得修为",math.ceil(jxw),"点!<br>",text})
       else
        text=table.concat({GetColor(table.concat({"〖",Target.key,"〗"}),cl[Target.team]),"已被",GetColor(table.concat({"〖",Source.key,"〗"}),cl[Source.team]),"击败!<br>",text})
      end
    end
    self:SetUI(Source,nil)
    self:SetUI(Target,nil)
  end


  function 战斗功法面板()
    OpenSkillMenu("功法面板",role.inskill,role.skill,true)
  end

  local function GetEquipmentShow(ltb)
    local x = 1
    local tb
   -- local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中"}
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

  local function EquipmentShow(eq)
    local t = {}
    for k,v in pairs(eq) do
      t[#t+1] = GetEquipmentShow(v)
      t[k]["附加属性"] = v["附加属性"]
    end
    return t
  end

  function SpriteTable:SetUI(sprite,text)
    if sprite ~= nil then
      if sprite.team == 1 then
        for k,v in pairs(data)
          if v.id == sprite.id then
            if sprite.Hp == 0 then
              table.remove(data,k)
             else
              local xt = math.ceil((sprite.Hp/sprite.Attribute["气血上限"])*shipei)
              local lt = math.ceil((sprite.Mp/sprite.Attribute["法力上限"])*shipei)
              local ostr=""
              local pstr=""
              for i=1,xt do
                ostr=table.concat({ostr," "})
              end
              v.血条=ostr
              for i=1,lt do
                pstr=table.concat({pstr," "})
              end
              v.蓝条=pstr
              v.血量显示=math.ceil(sprite.Hp).."/"..math.ceil(sprite.Attribute["气血上限"])
              v.法力显示=math.ceil(sprite.Mp).."/"..math.ceil(sprite.Attribute["法力上限"])
            end
          end
        end
       else
        for k,v in pairs(data1)
          if v.id == sprite.id then
            if sprite.Hp == 0 then
              table.remove(data1,k)
             else
              local xt = math.ceil((sprite.Hp/sprite.Attribute["气血上限"])*shipei)
              local lt = math.ceil((sprite.Mp/sprite.Attribute["法力上限"])*shipei)
              local ostr=""
              local pstr=""
              for i=1,xt do
                ostr=table.concat({ostr," "})
              end
              v.血条=ostr
              for i=1,lt do
                pstr=table.concat({pstr," "})
              end
              v.蓝条=pstr
              v.血量显示=math.ceil(sprite.Hp).."/"..math.ceil(sprite.Attribute["气血上限"])
              v.法力显示=math.ceil(sprite.Mp).."/"..math.ceil(sprite.Attribute["法力上限"])
            end
          end
        end
      end
    end
    adp1.notifyDataSetChanged()
    adp.notifyDataSetChanged()
    local 品级 = {"黄阶下品","黄阶中品","黄阶上品","玄阶下品","玄阶中品","玄阶上品","地阶下品","地阶中品","地阶上品","天阶下品","天阶中品","天阶上品","仙品"}
    敌方面板.onItemClick=function(l,v,p,i)
      local emtb = {}
      for k,v in pairs(self) do
        if type(v) == "table" then
          if v.team == 2 then
            table.insert(emtb,v)
          end
        end
      end
      role = emtb[i]
      att = role.Attribute
      a=PopupWindow(activity)--创建PopWindow
      a.setContentView(loadlayout(MapUI()["战斗面板"]))--设置布局
      a.setWidth(activity.Width*0.92)--设置宽度
      a.setHeight(-2)--设置高度
      a.setFocusable(true)--设置可获得焦点
      a.getBackground().setAlpha(0)
      a.setTouchable(true)--设置可触摸
      --设置点击外部区域是否可以消失
      a.setOutsideTouchable(false)
      --显示
      a.showAtLocation(view,Gravity.CENTER,0,0)
      战斗姓名.Text=战斗姓名.Text..role.key
      if role.ph ~= nil then
        战斗境界.Text=战斗境界.Text..ptjj[role.level]["境界"]
       else
        战斗境界.Text=战斗境界.Text..境界[role.level]["境界"]
        local kj = {
          LinearLayout;
          layout_height="7%h";
          layout_width="fill";
          {
            Button;
            onClick=function OpenEquipment(role.eq) end;
            text="装备";
          };
          {
            Button;
            onClick=function 战斗功法面板() end;
            text="功法";
          };
          {
            Button;
            text="暂无";
          };
          {
            Button;
            text="暂无";
          };
        };
        战斗面板.addView(loadlayout(kj))
      end
      战斗体质.Text=战斗体质.Text..math.ceil(att["体质"])
      战斗真元.Text=战斗真元.Text..math.ceil(att["真元"])
      战斗身法.Text=战斗身法.Text..math.ceil(att["身法"])
      战斗肉身.Text=战斗肉身.Text..math.ceil(att["肉身"])
      战斗内攻.Text=战斗内攻.Text..att["内攻"]
      战斗外攻.Text=战斗外攻.Text..att["外攻"]
      战斗法力.Text=战斗法力.Text..att["法力上限"]
      战斗血量.Text=战斗血量.Text..att["气血上限"]
      战斗内防.Text=战斗内防.Text..att["内防"]
      战斗外防.Text=战斗外防.Text..att["外防"]
      战斗命中.Text=战斗命中.Text..att["命中"]
      战斗闪避.Text=战斗闪避.Text..att["闪避"]
      战斗会心率.Text=战斗会心率.Text..att["会心率"]
      战斗抗会心率.Text=战斗抗会心率.Text..att["抗会心率"]
      战斗会心伤害.Text=战斗会心伤害.Text..att["会心伤害"].."%"
      战斗会心免伤.Text=战斗会心免伤.Text..att["会心免伤"].."%"
      战斗最终伤害放大.Text=战斗最终伤害放大.Text..att["最终伤害放大"].."%"
      战斗最终伤害抵消.Text=战斗最终伤害抵消.Text..att["最终伤害抵消"].."%"
      fight.Text = "战斗力:"..math.ceil(att["内攻"]*2+att["外攻"]*2+att["内防"]*2.5+att["外防"]*2.5+att["气血上限"]*0.2+att["法力上限"]*0.1+att["会心率"]*2+att["抗会心率"]*2+att["闪避"]*2.5+att["命中"]*2.5+att["会心伤害"]*20+att["会心免伤"]*20+att["最终伤害放大"]*30+att["最终伤害抵消"]*30)
      function OpenEquipment(eq)
        eq = eq or role.eq
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
          --local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中"}
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
    end
    己方面板.onItemClick=function(l,v,p,i)
      local emtb = {}
      for k,v in pairs(self) do
        if type(v) == "table" then
          if v.team == 1 then
            table.insert(emtb,v)
          end
        end
      end
      role = emtb[i]
      att = role.Attribute
      local a=PopupWindow(activity)--创建PopWindow
      a.setContentView(loadlayout(MapUI()["战斗面板"]))--设置布局
      a.setWidth(activity.Width*0.92)--设置宽度
      a.setHeight(-2)--设置高度
      a.setFocusable(true)--设置可获得焦点
      a.getBackground().setAlpha(0)
      a.setTouchable(true)--设置可触摸
      --设置点击外部区域是否可以消失
      a.setOutsideTouchable(false)
      --显示
      a.showAtLocation(view,Gravity.CENTER,0,0)
      --设置点击外部区域是否可以消失
      战斗姓名.Text=战斗姓名.Text..role.key
      if role.ph ~= nil then
        战斗境界.Text=战斗境界.Text..ptjj[role.level]["境界"]
       else
        local kj = {
          LinearLayout;
          layout_height="7%h";
          layout_width="fill";
          {
            Button;
            onClick=function OpenEquipment(role.eq) end;
            text="装备";
          };
          {
            Button;
            onClick=function 战斗功法面板() end;
            text="功法";
          };
          {
            Button;
            text="暂无";
          };
          {
            Button;
            text="暂无";
          };
        };
        战斗面板.addView(loadlayout(kj))
        战斗境界.Text=战斗境界.Text..境界[role.level]["境界"]
      end
      战斗体质.Text=战斗体质.Text..math.ceil(att["体质"])
      战斗真元.Text=战斗真元.Text..math.ceil(att["真元"])
      战斗身法.Text=战斗身法.Text..math.ceil(att["身法"])
      战斗肉身.Text=战斗肉身.Text..math.ceil(att["肉身"])
      战斗内攻.Text=战斗内攻.Text..att["内攻"]
      战斗外攻.Text=战斗外攻.Text..att["外攻"]
      战斗法力.Text=战斗法力.Text..att["法力上限"]
      战斗血量.Text=战斗血量.Text..att["气血上限"]
      战斗内防.Text=战斗内防.Text..att["内防"]
      战斗外防.Text=战斗外防.Text..att["外防"]
      战斗命中.Text=战斗命中.Text..att["命中"]
      战斗闪避.Text=战斗闪避.Text..att["闪避"]
      战斗会心率.Text=战斗会心率.Text..att["会心率"]
      战斗抗会心率.Text=战斗抗会心率.Text..att["抗会心率"]
      战斗会心伤害.Text=战斗会心伤害.Text..att["会心伤害"].."%"
      战斗会心免伤.Text=战斗会心免伤.Text..att["会心免伤"].."%"
      战斗最终伤害放大.Text=战斗最终伤害放大.Text..att["最终伤害放大"].."%"
      战斗最终伤害抵消.Text=战斗最终伤害抵消.Text..att["最终伤害抵消"].."%"
      fight.Text = "战斗力:"..math.ceil(att["内攻"]*2+att["外攻"]*2+att["内防"]*2.5+att["外防"]*2.5+att["气血上限"]*0.2+att["法力上限"]*0.1+att["会心率"]*2+att["抗会心率"]*2+att["闪避"]*2.5+att["命中"]*2.5+att["会心伤害"]*20+att["会心免伤"]*20+att["最终伤害放大"]*30+att["最终伤害抵消"]*30)
      function OpenEquipment(eq)
        eq = eq or role.eq
        local EqTable = EquipmentShow(eq)
        import"android.graphics.drawable.ColorDrawable"
        local a=AlertDialog.Builder(this).show()
        a.getWindow().setContentView(loadlayout(MapUI()["装备面板"]));--点击阴影部分不会关闭弹窗
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
            物品名称.Text = Color:Set(EqLevel(t.key,t.float).."["..品级[t["品质"]].."]",t["品质"])
            物品介绍.Text = 物品介绍.Text..":\n"..t.Info
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
    end
    if text then
      adp5.insert(0,{
        zdxx=Html.fromHtml(text)
      })
    end
  end
  SpriteTable:SetUI(SpriteTable[#SpriteTable],"战斗开始!")
  sp=GetSp(SpriteTable)
  if 战斗计时 == nil then
    SaveTable.gj = 1
    战斗计时=Ticker()
    战斗计时.Period=speed
    战斗计时.onTick=function()
      战斗开始()
    end
    战斗计时.start()
   else
    战斗计时.stop()
    战斗计时=Ticker()
    战斗计时.Period=speed
    战斗计时.onTick=function()
      战斗开始()
    end
    战斗计时.start()
  end
end