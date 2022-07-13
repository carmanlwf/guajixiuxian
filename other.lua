require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "commonHelper"
local Item = import "item"
local 境界 = import "tupo"
local Color = {hui="#C6C6C6",black="#000000",white="#FFFFFF",green="#008000",blue="#0000FF",red="#FF0000",orange="#FFA500",gold="#FFD700"}
local 品级 = {"黄阶下品","黄阶中品","黄阶上品","玄阶下品","玄阶中品","玄阶上品","地阶下品","地阶中品","地阶上品","天阶下品","天阶中品","天阶上品","仙品"}
local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中","神念消耗","材料消耗","成丹率","成功率","出丹率","评分提升","属性品质","获取经验"}

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

function yanse(str,ys)
  str="<font color="..ys..">"..str.."</font>"
  return Html.fromHtml(str)
end

function yansep(str,ys)
  str="<font color="..ys[1]..">"..str.."</font>"
  return str
end

function 获取颜色(tab,key)
  local data = tab["四维"]
  local num = data[1] + data[2] + data[3] + data[4]
  local tb = {{2000,"#808080","[资质:低劣]"},{2800,"#008000","[资质:普通]"},{3600,"#0000FF","[资质:优秀]"},{4400,"#FF0000","[资质:极品]"},{5200,"#FFA500","[资质:绝世]"},{666666,"#FFD700","[资质:仙资]"}}
  local cl
  for i=1,#tb do
    if num <= tb[i][1] then
      cl = {tb[i][2],tb[i][3],i}
      break
    end
  end
  return yansep(key,cl)
end

function cspz(tab,key)
  local data = tab["四维"]
  local num = data[1] + data[2] + data[3] + data[4]
  local tb = {{2000,"#808080","[资质:低劣]"},{2800,"#008000","[资质:普通]"},{3600,"#0000FF","[资质:优秀]"},{4400,"#FF0000","[资质:极品]"},{5200,"#FFA500","[资质:绝世]"},{666666,"#FFD700","[资质:仙资]"}}
  local cl
  for i=1,#tb do
    if num <= tb[i][1] then
      cl = {tb[i][2],tb[i][3],i}
      break
    end
  end
  if tab.eq ~= 1 then
    cl[2] = cl[2].."[未出战]"
   else
    cl[2] = cl[2].."[已出战]"
  end
  return yanse(key..cl[2],cl[1]),cl
end

function othershop(tbl)
  local its = {
    LinearLayout;
    layout_height="fill";
    layout_width="fill";
    {
      CardView;
      cardBackgroundColor="#FFF7F7F7";
      layout_gravity="center";
      layout_height="40dp";
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
          textSize=getsize(10);
          textColor="#333333";
          id="name";
        };
      };
    };
  };
  local wei = {
    LinearLayout;
    background='#ffffffff';
    layout_height="fill";
    orientation="vertical";
    layout_width="fill";
    {
      FrameLayout;
      layout_height="5%h";
      layout_width="match_parent";
      {
        TextView;
        id="myshop";
        text="我的摊位";
        layout_gravity="center";
        textColor="#000000";
      };
    };
    {
      CardView;
      layout_margin="2.5%w";
      layout_height="50%h";
      layout_width="fill";
      {
        ListView;
        id="我的摊位";
        layout_height="match_parent";
        layout_width="60%h";
      };
    };
    {
      TextView;
      id="收益";
      text="灵石收益:500000";
      textColor="#000000";
    };
  };
  local ww=PopupWindow(activity)--创建PopWindow
  ww.setContentView(loadlayout(wei))--设置布局
  ww.setWidth(activity.Width*0.96)--设置宽度
  ww.setHeight(-2)--设置高度
  ww.setFocusable(true)--设置可获得焦点
  ww.setTouchable(true)--设置可触摸
  ww.setOutsideTouchable(true)
  ww.showAtLocation(view,Gravity.CENTER,0,0)
  myshop.Text = table.concat({tbl.info,"[热度:",tbl.hot,"]"})
  收益.Text = "灵石:"..tbl.money
  local jjy = 加载框()
  hs("http://82.157.62.200/zm/dcd.php?id="..tbl.id,function(code,body)
    task(500,function jjy.dismiss() end)
    if code ~= -1 and code >= 200 and code <= 400 then
      local tb = cjson.decode(body)
      local data1 = {}
      local adp1=LuaAdapter(activity,data1,its)
      local no = #data1
      for i=1,no do
        table.remove(data1)
      end
      for k,v in pairs(tb) do
        tb[k].item = cjson.decode(v.item)
        local p = Item:GetTable(v.item.key)
        if p.type <= 5 then
          str = table.concat({v.item.key,"[",品级[p["品质"]],"][评分:",upeqdatas(v.item),"][数量:",math.ceil(v.number),"][单价:",math.ceil(v.price),"]"})
         else
          str = table.concat({v.item.key,"[",品级[p["品质"]],"][数量:",math.ceil(v.number),"][单价:",math.ceil(v.price),"]"})
        end
        if tonumber(v.type) == 1 then
          table.insert(data1,{name=Color:Set(table.concat({str,"[已上架]"}),p["品质"])})
         elseif tonumber(v.type) == 2 then
          table.insert(data1,{name=Color:Set(table.concat({str,"[被拒审]"}),p["品质"])})
         else
          table.insert(data1,{name=Color:Set(table.concat({str,"[待审核]"}),p["品质"])})
        end
      end
      if #data1 == 0 then
        table.insert(data1,{name="无商品"})
      end
      我的摊位.Adapter=adp1
      我的摊位.onItemClick=function(l,v,p,i)
        local e,q = ShowMenu(tb[i].item)
      end
     else
      提示("网络连接失败")
    end
  end)
end

local d
function otherpet(tb)
  local its = {
    LinearLayout;
    layout_height="fill";
    layout_width="fill";
    {
      CardView;
      cardBackgroundColor="#FFF7F7F7";
      layout_gravity="center";
      layout_height="6%h";
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
  local data = {}
  if d ~= nil then
    d.dismiss()
  end
  d=PopupWindow(activity)--创建PopWindow
  d.setContentView(loadlayout(MapUI()["宠兽列表"]))--设置布局
  d.setWidth(activity.Width*0.92)--设置宽度
  d.setHeight(-2)--设置高度
  d.setFocusable(true)--设置可获得焦点
  d.getBackground().setAlpha(0)
  d.setTouchable(true)--设置可触摸
  --设置点击外部区域是否可以消失
  d.setOutsideTouchable(false)
  --显示
  d.showAtLocation(view,Gravity.CENTER,0,0)
  local adp=LuaAdapter(activity,data,its)
  if #tb > 0 then
    for k,v in pairs(tb) do
      local a,b = cspz(v,v.name)
      if v.body == nil then
        rollpet(v,b[3],v.bh)
        v.body = {}
      end
      table.insert(data,{name=a,id=v.id})
    end
   else
    table.insert(data,{name="没有宠兽"})
  end
  宠兽.Adapter=adp
end

function otherbag(tb)
  table.sort(tb,function(a,b)
    return Item:GetTable(a.key)["品质"] < Item:GetTable(b.key)["品质"]
  end)
  local ky = {
    LinearLayout;
    background='#ffffffff',
    layout_width="fill";
    layout_height="fill";
    orientation="vertical";
    {
      FrameLayout;
      layout_height="6%h";
      layout_width="match_parent";
      {
        TextView;
        layout_gravity="center";
        textSize="24sp";
        text="背包";
        textColor="#000000";
      };
    };
    {
      LinearLayout;
      layout_width="match_parent";
      layout_height="50%h";
      orientation="horizontal";
      {
        RadioGroup;
        id="bbb";
        {
          RadioButton;
          text="全部";
        };
        {
          RadioButton;
          text="武器";
        };
        {
          RadioButton;
          text="衣服";
        };
        {
          RadioButton;
          text="帽子";
        };
        {
          RadioButton;
          text="护腕";
        };
        {
          RadioButton;
          text="鞋子";
        };
        {
          RadioButton;
          text="饰品";
        };
        {
          RadioButton;
          text="丹药";
        };
        {
          RadioButton;
          text="秘籍";
        };
        {
          RadioButton;
          text="特殊";
        };
        {
          RadioButton;
          text="副职";
        };
      };
      {
        ListView;
        layout_width="match_parent";
        layout_height="match_parent";
        id="bei";
      };
    };
  };
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
  local bag = PopupWindow(activity)--创建PopWindow
  bag.setContentView(loadlayout(ky))--设置布局
  bag.setWidth(activity.Width*0.92)--设置宽度
  bag.setHeight(activity.Height*0.6)--设置高度
  bag.setFocusable(true)--设置可获得焦点
  bag.getBackground().setAlpha(0)
  bag.setTouchable(true)--设置可触摸
  --设置点击外部区域是否可以消失
  bag.setOutsideTouchable(false)
  --显示
  bag.showAtLocation(view,Gravity.CENTER,0,0)
  local data={}
  local adp=LuaAdapter(activity,data,its)
  bei.Adapter=adp
  function itsz(tb,n,m)
    local tlb = {}
    local num = #data
    for i=1,num do
      table.remove(data)
    end
    for k,v in pairs(tb) do
      local t = Item:GetTable(v.key)
      if t.type >= n and t.type <= m then
        table.insert(tlb,v)
      end
    end
    for k,v in pairs(tlb) do
      local t = Item:GetTable(v.key)
      if t.type <= 5 then
        table.insert(data,{name=Color:Set(v.key.."["..品级[t["品质"]].."]".."[数量:"..math.ceil(v.number).."][评分:"..upeqdatas(v).."]",t["品质"])})--添加数据进适配器，还有一种方法table.insert(data,{})
       else
        table.insert(data,{name=Color:Set(v.key.."["..品级[t["品质"]].."]".."[数量:"..math.ceil(v.number).."]",t["品质"])})--添加数据进适配器，还有一种方法table.insert(data,{})
      end
    end
    adp.notifyDataSetChanged()
    bei.onItemClick=function(l,v,p,i)
      ShowMenu(tlb[i])
    end
  end
  bbb.setOnCheckedChangeListener{
    onCheckedChanged=function(g,c)
      l=g.findViewById(c)
      if l.Text == "全部" then
        itsz(tb,-5,100)
       elseif l.Text == "武器" then
        itsz(tb,0,0)
       elseif l.Text == "衣服" then
        itsz(tb,1,1)
       elseif l.Text == "帽子" then
        itsz(tb,2,2)
       elseif l.Text == "护腕" then
        itsz(tb,3,3)
       elseif l.Text == "鞋子" then
        itsz(tb,4,4)
       elseif l.Text == "饰品" then
        itsz(tb,5,5)
       elseif l.Text == "丹药" then
        itsz(tb,6,6)
       elseif l.Text == "秘籍" then
        itsz(tb,7,7)
       elseif l.Text == "特殊" then
        itsz(tb,8,15)
       elseif l.Text == "副职" then
        itsz(tb,-5,-1)
      end
  end}
  itsz(tb,-5,100)
end

function 属性面板(prole)
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
  local a
  if tab ~= nil then
    att = Item:GetTirgger(prole)
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
    local _role = table.clone(SaveTable.owner)
    _role.hard = 境界[_role.level].hard
    if _role.buff ~= nil then
      if _role.buff["转生"] ~= nil then
        if _role.buff["转生"] > _role.level then
          _role.hard = _role.hard + 境界[_role.buff["转生"]].hard * 0.2
        end
        if _role.hard > 境界[_role.buff["转生"]].hard then
          _role.hard = 境界[_role.buff["转生"]].hard
        end
      end
    end
    _role.Attribute = Item:GetTirgger(_role)
    _role.Hp = _role.Attribute["气血上限"]
    _role.Mp = _role.Attribute["法力上限"]
    GetTalent(_role)
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
    GetTalent(prole)
    local skill = import "skill"
    for k,v in pairs(prole.skill) do
      if v.eq == 1 then
        prole.skill[k]["战斗参数"] = skill:GetTable(v.key,v.level)
      end
    end
    for k,v in pairs(_role.skill) do
      if v.eq == 1 then
        _role.skill[k]["战斗参数"] = skill:GetTable(v.key,v.level)
      end
    end
    local jt = _role
    jt.team = 1
    local et = prole
    prole.team = 2
    local spt = {jt,et}
    a.dismiss()
    _role.sp = (_role.Attribute["身法"]+_role.hard*2)*_role.hard/10
    prole.sp = (prole.Attribute["身法"]+prole.hard*2)*prole.hard/10
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