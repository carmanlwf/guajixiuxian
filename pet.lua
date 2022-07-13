require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "petatt"
import "body"
import "commonHelper"
local Item = import "item"
local cjson = import "cjson"
local inskill = import "petinskill"
local skill = import "petskill"
local pet = import "petdata"
local tp = import "pettupo"

local exp = import "skillexp"
local 资源 = import "resource"
local Color = {hui="#C6C6C6",black="#000000",white="#FFFFFF",green="#008000",blue="#0000FF",red="#FF0000",orange="#FFA500",gold="#FFD700"}
local 品级 = {"黄阶下品","黄阶中品","黄阶上品","玄阶下品","玄阶中品","玄阶上品","地阶下品","地阶中品","地阶上品","天阶下品","天阶中品","天阶上品","仙品"}

function 生成种族(idx)
  local tab = pet[idx]
  local tap = {}
  for k,v in pairs(tab) do
    if type(v) == "table" and v.roll then
      table.insert(tap,k)
    end
  end
  return tap[math.random(1,#tap)]
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

function sjlv()
  local pz
  local tb = {6000,9000,9850,9990,9999,10000}
  local num = math.random(1,10000)
  for k,v in pairs(tb) do
    if num <= v then
      pz = k
      break
    end
  end
  return pz
end

import "android.content.Context"

function getinskillbox(tb)
  for i=1,#tb do
    for k,v in pairs (inskill[tb[i].key]) do
      tb[i][k] = v
    end
  end
  return tb
end

function getskillbox(tb)
  for i=1,#tb do
    for k,v in pairs (skill[tb[i].key]) do
      tb[i][k] = v
    end
  end
  return tb
end

function learninskill(d,Key)
  table.insert(SaveTable.pet[#SaveTable.pet].inskill,{id=d,key=Key,eq=1,level=1,exp=0})
end

function learnskill(d,Key)
  table.insert(SaveTable.pet[#SaveTable.pet].skill,{id=d,key=Key,eq=1,level=1,exp=0})
end

function getwh(view)
  view.measure(View.MeasureSpec.makeMeasureSpec(0,View.MeasureSpec.UNSPECIFIED),View.MeasureSpec.makeMeasureSpec(0,View.MeasureSpec.UNSPECIFIED));
  height =view.getMeasuredHeight();
  width =view.getMeasuredWidth();
  return width,height
end

function findpet(id)
  local tb,i
  for k,v in pairs(SaveTable.pet) do
    if v.id == id then
      tb = v
      i = k
      break
    end
  end
  return tb,i
end

function rollpet(tb,lv,id,key)
  local br = false
  local tab = {1600,2000,2400,2800,3200,3600,4000}
  repeat
  for k,v in pairs(pet[id][key]["四维"]) do
    local num = math.random(80,200)/100
    local num1 = math.floor(v * num)
    tb["四维"][k] = num1
  end
  local t = 0
  for k,v in pairs(tb["四维"]) do
    t = t + v
  end
  br = (t > tab[lv] and t < tab[lv+1])
  until br
end

function addpet(lv,id,name,key)
  if SaveTable.pet == nil then
    SaveTable.pet = {}
  end
  local br = false
  local zz
  lv = lv or sjlv()
  id = id or math.random(1,#pet)
  key = key or 生成种族(id)
  local tb = {1600,2000,2800,3600,4400,5200,6000}
  repeat
  zz = {}
  for k,v in pairs(pet[id][key]["四维"]) do
    local num = math.random(80,200)/100
    local num1 = math.floor(v * num)
    table.insert(zz,num1)
  end
  local t = 0
  for k,v in pairs(zz) do
    t = t + v
  end
  br = (t > tb[lv] and t < tb[lv+1])
  until br
  local nm = name or key
  local tab = {bh=id,key=pet[id].key,key1=key,["四维"]=zz,name=nm,level=0,inskill={},skill={},eq=0,["修为"]=0,body={},buff={}}
  if name == nil then
    local InputLayout={
      LinearLayout;
      orientation="vertical";
      Focusable=true,
      FocusableInTouchMode=true,
      {
        TextView;
        id="Prompt",
        textSize=getsize(15),
        layout_marginTop="10dp";
        layout_marginLeft="10dp",
        layout_marginRight="10dp",
        layout_width="match_parent";
        layout_gravity="center",
        text="输入:";
      };
      {
        EditText;
        hint="恭喜获得一只"..key..",请给它取个名字吧!";
        layout_marginTop="5dp";
        layout_marginLeft="10dp",
        layout_marginRight="10dp",
        layout_width="match_parent";
        layout_gravity="center",
        id="edit";
      };
    };
    AlertDialog.Builder(this)
    .setTitle("请输入")
    .setView(loadlayout(InputLayout))
    .setPositiveButton("确定",{onClick=function(v)
        tab.name = badword(edit.Text)
    end})
    .setNegativeButton("取消",nil)
    .show()
  end
  table.insert(SaveTable.pet,tab)
  for k,v in pairs(SaveTable.pet) do
    v.id = k
  end
  local cs = lv * 2 +1
  for k,v in pairs (inskill) do
    local pro = 0.1/(v["品质"] +1)
    if (cs >= v["品质"] and probability(pro)) then
      if v.type == nil then
        learninskill(#SaveTable.pet,k)
       elseif v.type[key] then
        learninskill(#SaveTable.pet,k)
      end
    end
    if #SaveTable.pet[#SaveTable.pet].inskill >= 3 then
      break
    end
  end
  for k,v in pairs (skill) do
    if type(v) == "table"
      local pro = 0.1/(v["品质"] +1)
      if (cs >= v["品质"] and probability(pro)) then
        if v.type == nil then
          learnskill(#SaveTable.pet,k)
         elseif v.type[key] then
          learnskill(#SaveTable.pet,k)
        end
      end
      if #SaveTable.pet[#SaveTable.pet].skill >= 5 then
        break
      end
    end
  end
  loadsavewrite()
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

local d
function chongshou()
  if SaveTable.owner.level >= 0 then
    if SaveTable.pet == nil then
      SaveTable.pet = {}
    end
    for i=1,#SaveTable.pet do
      SaveTable.pet[i].id=i
      if SaveTable.pet[i].key1 == nil then
        local num = 0
        for k,v in pairs(SaveTable.pet[i]["四维"]) do
          num = num + v
        end
        SaveTable.pet[i].key1 = 生成种族(SaveTable.pet[i].bh)
        if SaveTable.pet[i].name == nil then
          SaveTable.pet[i].name = SaveTable.pet[i].key1
        end
        local sw = {0,0,0,0}
        while num == sw[1] + sw[2] + sw[3] + sw[4] do
          for k,v in pairs(sw) do
            sw[i] = math.random(math.ceil(pet[SaveTable.pet[i].bh][SaveTable.pet[i].key1][k]*0.8),pet[SaveTable.pet[i].bh][SaveTable.pet[i].key1][k]*2)
          end
        end
      end
      for k,v in pairs(pet[SaveTable.pet[i].bh][SaveTable.pet[i].key1]["四维"]) do
        if SaveTable.pet[i]["四维"][k] > v*2 then
          SaveTable.pet[i]["四维"][k] = v*2
        end
      end
      if SaveTable.pet[i].level == nil then
        SaveTable.pet[i].level = 1
      end
    end
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
    if #SaveTable.pet > 0 then
      for k,v in pairs(SaveTable.pet) do
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
    local e
    宠兽.onItemClick=function(l,v,p,i)
      local tb,idx = findpet(data[i].id)
      if e ~= nil then
        e.dismiss()
      end
      e=PopupWindow(activity)--创建PopWindow
      e.setContentView(loadlayout(MapUI()["宠兽面板"]))--设置布局
      e.setWidth(activity.Width*0.95)--设置宽度
      e.setHeight(-2)--设置高度
      e.setFocusable(true)--设置可获得焦点
      e.getBackground().setAlpha(0)
      e.setTouchable(true)--设置可触摸
      --设置点击外部区域是否可以消失
      e.setOutsideTouchable(false)
      --显示
      e.showAtLocation(view,Gravity.CENTER,0,0)
      local sz,pz = cspz(tb,tb.name)
      csname.Text = sz
      csname.onClick=function
        local InputLayout={
          LinearLayout;
          orientation="vertical";
          Focusable=true,
          FocusableInTouchMode=true,
          {
            TextView;
            id="Prompt",
            textSize=getsize(15),
            layout_marginTop="10dp";
            layout_marginLeft="10dp",
            layout_marginRight="10dp",
            layout_width="match_parent";
            layout_gravity="center",
            text="输入:";
          };
          {
            EditText;
            hint="请输入新更改的名字!";
            layout_marginTop="5dp";
            layout_marginLeft="10dp",
            layout_marginRight="10dp",
            layout_width="match_parent";
            layout_gravity="center",
            id="edit";
          };
        };

        AlertDialog.Builder(this)
        .setTitle("请输入")
        .setView(loadlayout(InputLayout))
        .setPositiveButton("确定",{onClick=function(v)
            tb.name = badword(edit.Text)
            csname.Text = cspz(tb,tb.name)
            data[i]={name=cspz(tb,tb.name),id=tb.id}
            adp.notifyDataSetChanged()
        end})
        .setNegativeButton("取消",nil)
        .show()
      end
      种族.Text = "种族:"..tb.key1.."["..pet[tb.bh].key.."]"
      local ostr = ""
      local num = 0
      for k,v in pairs(pet[tb.bh][tb.key1]["属性"]) do
        num = num + 1
        if num > 1 then
          ostr=ostr.."、"..k
         else
          ostr=ostr..k
        end
      end
      宠兽属性.text = "属性灵根:"..ostr
      宠兽境界.Text = "境界:"..tp[tb.level]["境界"]
      宠兽修为.Text = "修为:"..math.ceil(tb["修为"]).."/"..tp[tb.level].cost
      local tz = (tb["四维"][1] / pet[tb.bh][tb.key1]["四维"][1])/2
      体质数值.Text=math.ceil(tb["四维"][1]).."/"..pet[tb.bh][tb.key1]["四维"][1]*2
      妖力数值.Text=math.ceil(tb["四维"][2]).."/"..pet[tb.bh][tb.key1]["四维"][2]*2
      身法数值.Text=math.ceil(tb["四维"][3]).."/"..pet[tb.bh][tb.key1]["四维"][3]*2
      妖体数值.Text=math.ceil(tb["四维"][4]).."/"..pet[tb.bh][tb.key1]["四维"][4]*2
      local tzc = 体质资质.getLayoutParams()
      tzc.width = tz*0.75*activity.width
      体质资质.setLayoutParams(tzc)
      local yl = (tb["四维"][2] / pet[tb.bh][tb.key1]["四维"][2])/2
      local ylc = 妖力资质.getLayoutParams()
      ylc.width = yl*0.75*activity.width
      妖力资质.setLayoutParams(ylc)
      local sf = (tb["四维"][3] / pet[tb.bh][tb.key1]["四维"][3])/2
      local sfc = 身法资质.getLayoutParams()
      sfc.width = sf*0.75*activity.width
      身法资质.setLayoutParams(sfc)
      local yt = (tb["四维"][4] / pet[tb.bh][tb.key1]["四维"][4])/2
      local ytc = 妖体资质.getLayoutParams()
      ytc.width = yt*0.75*activity.width
      妖体资质.setLayoutParams(ytc)
      属性详情.onClick=function
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
        for k,v in pairs(pet[tb.bh][tb.key1]["属性"]) do
          str=str..k..":"..yansea(v*100,tap[k]).."%(按比例增幅带有"..yansea(k,tap[k]).."属性的法术伤害)<br>"
        end
        local xq=AlertDialog.Builder(activity)
        .setView(loadlayout(m)).show()
        灵根属性.Text=Html.fromHtml(str)
      end
      妖躯.onClick=function(v)
        openbody(tb)
      end
      if tb.eq ~= 1 then
        cz.Text = "出战"
       else
        cz.Text = "召回"
      end
      local r
      function petbag()
        if r ~= nil then
          r.dismiss()
        end
        local its1 = {
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
                id="name1";
              };
            };
          };
        };
        local data1 = {}
        r=PopupWindow(activity)--创建PopWindow
        r.setContentView(loadlayout(MapUI()["宠兽背包"]))--设置布局
        r.setWidth(activity.Width*0.92)--设置宽度
        r.setHeight(-2)--设置高度
        r.setFocusable(true)--设置可获得焦点
        r.getBackground().setAlpha(0)
        r.setTouchable(true)--设置可触摸
        --设置点击外部区域是否可以消失
        r.setOutsideTouchable(false)
        --显示
        r.showAtLocation(view,Gravity.CENTER,0,0)
        local adp1=LuaAdapter(activity,data1,its1)
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
        local function EquipmentShowpet()
          local t = {}
          local tp = type or {9,9}
          for k,v in pairs(SaveTable.Item) do
            t[k] = GetEquipmentShow(v)
            t[k]["附加属性"]=v["附加属性"]
          end
          return t
        end
        local ItemTable = EquipmentShowpet(SaveTable.Item)
        local patable = {}
        for k,v in pairs(ItemTable) do
          if v.type == 9 or v.pet == true then
            table.insert(patable,v)
          end
        end
        table.sort(patable,function(x,y)
          return x["品质"] < y["品质"]
        end)
        if #patable ~= 0 then
          for k,v in pairs(patable) do
            table.insert(data1,{name1=Color:Set(v.key.."["..品级[v["品质"]].."]".."[数量:"..math.ceil(v.number).."]",v["品质"])})--添加数据进适配器，还有一种方法table.insert(data,{})
          end
         else
          table.insert(data1,{name1="无物品"})
        end
        local e
        宠兽包裹.Adapter=adp1
        if #patable ~= 0 then
          宠兽包裹.onItemClick=function(l,v,p,i)
            function 关闭面板()
              e.dismiss()
            end
            local t = patable[i]
            if e ~= nil then
              e.dismiss()
            end
            e=AlertDialog.Builder(this).show()
            e.getWindow().setContentView(loadlayout(MapUI()["宠兽物品面板"]));
            宠兽物品名称.Text = Color:Set(EqLevel(t.key,t.float).."["..品级[t["品质"]].."]",t["品质"])
            宠兽物品介绍.Text = 宠兽物品介绍.Text..":\n"..t.Info.."\n"
            if t["资源参数"] ~= nil then
              local f = ""
              for k,v in pairs(t["资源参数"]) do
                if type(v) == "table" then
                  f=f..资源["资源参数"][k][1]..v[#v]..资源["资源参数"][k][2]
                 else
                  f=f..资源["资源参数"][k][1]..v..资源["资源参数"][k][2]
                end
              end
              宠兽物品参数.Text = f
              if (t["资源参数"]["宠兽功法"] ~= nil or t["资源参数"]["宠兽法术"] ~= nil) then
                宠兽使用物品.Text = "学习"
              end
             else
              宠兽物品参数.Text=""
            end
            local dll
            function petUseItem()
              if t["资源参数"] ~= nil then
                if t["资源参数"]["回复"] then
                  if tb.buff["回复"] == nil then
                    tb.buff["回复"]={number={Hp={t["资源参数"]["回复"][3],t["资源参数"]["回复"][1][1]},Mp={t["资源参数"]["回复"][3],t["资源参数"]["回复"][1][2]}},time={os.time()+t["资源参数"]["回复"][2],t["资源参数"]["回复"][2]}}
                    MD提示("使用成功!")
                    DeleteItemTable(t,1)
                    if t.number > 1 then
                      t.number = t.number - 1
                      data1[i] = {name1=Color:Set(t.key.."["..品级[t["品质"]].."]".."[数量:"..math.ceil(t.number).."]",t["品质"])}
                     else
                      table.remove(patable,i)
                      table.remove(data1,i)
                    end
                    宠兽包裹.Adapter.notifyDataSetChanged()
                   else
                    MD提示("已有此类丹药效果，重复使用会导致气血失调的!")
                  end
                  e.dismiss()
                end
                if t["资源参数"]["增伤"] then
                  if tb.buff["增伤"] == nil then
                    tb.buff["增伤"]={number={t["资源参数"]["增伤"][3],t["资源参数"]["增伤"][1]},time={os.time()+t["资源参数"]["增伤"][2],t["资源参数"]["增伤"][2]}}
                    MD提示("使用成功!")
                    DeleteItemTable(t,1)
                    if t.number > 1 then
                      t.number = t.number - 1
                      data1[i] = {name1=Color:Set(t.key.."["..品级[t["品质"]].."]".."[数量:"..math.ceil(t.number).."]",t["品质"])}
                     else
                      table.remove(patable,i)
                      table.remove(data1,i)
                    end
                    宠兽包裹.Adapter.notifyDataSetChanged()
                   else
                    MD提示("已有此类丹药效果，重复使用会导致气血失调的!")
                  end
                  e.dismiss()
                end
                if t["资源参数"]["免伤"] then
                  if tb.buff["免伤"] == nil then
                    tb.buff["免伤"]={number={t["资源参数"]["免伤"][3],t["资源参数"]["免伤"][1]},time={os.time()+t["资源参数"]["免伤"][2],t["资源参数"]["免伤"][2]}}
                    MD提示("使用成功!")
                    DeleteItemTable(t,1)
                    if t.number > 1 then
                      t.number = t.number - 1
                      data1[i] = {name1=Color:Set(t.key.."["..品级[t["品质"]].."]".."[数量:"..math.ceil(t.number).."]",t["品质"])}
                     else
                      table.remove(patable,i)
                      table.remove(data1,i)
                    end
                    宠兽包裹.Adapter.notifyDataSetChanged()
                   else
                    MD提示("已有此类丹药效果，重复使用会导致气血失调的!")
                  end
                  e.dismiss()
                end
                if t["资源参数"]["宠兽功法"] ~= nil then
                  if #tb.inskill >= 9 then
                    MD提示("最大学习心法数量不得超过九本")
                    e.dismiss()
                   else
                    local br = true
                    for k,v in pairs(tb.inskill) do
                      if t["资源参数"]["宠兽功法"] == v.key then
                        br = false
                      end
                    end
                    if br then
                      if inskill[t["资源参数"]["宠兽功法"]].type == nil then
                        table.insert(tb.inskill,{key=t["资源参数"]["宠兽功法"],level=1,eq=1,exp=0})
                        MD提示(tb.name.."学会了"..t["资源参数"]["宠兽功法"])
                        DeleteItemTable(t,1)
                        if t.number > 1 then
                          t.number = t.number - 1
                          data1[i] = {name1=Color:Set(t.key.."["..品级[t["品质"]].."]".."[数量:"..math.ceil(t.number).."]",t["品质"])}
                         else
                          table.remove(patable,i)
                          table.remove(data1,i)
                        end
                       elseif inskill[t["资源参数"]["宠兽功法"]].type[tb.key] then
                        table.insert(tb.inskill,{key=t["资源参数"]["宠兽功法"],level=1,eq=1,exp=0})
                        DeleteItemTable(t,1)
                        if t.number > 1 then
                          t.number = t.number - 1
                          data1[i] = {name1=Color:Set(t.key.."["..品级[t["品质"]].."]".."[数量:"..math.ceil(t.number).."]",t["品质"])}
                         else
                          table.remove(patable,i)
                          table.remove(data1,i)
                        end
                        MD提示(tb.name.."学会了"..t["资源参数"]["宠兽功法"])
                       else
                        local str = ""
                        for k,v in pairs(inskill[t["资源参数"]["宠兽功法"]].type) do
                          str=str..k.."族,"
                        end
                        MD提示("只有"..str.."妖兽才能学习"..t["资源参数"]["宠兽功法"])
                      end
                      宠兽包裹.Adapter.notifyDataSetChanged()
                      e.dismiss()
                     else
                      MD提示(tb.name.."已经学习过"..t["资源参数"]["宠兽功法"]..",无法重复学习")
                      e.dismiss()
                    end
                  end
                end
                if t["资源参数"]["宠兽法术"] ~= nil then
                  if #tb.skill >= 15 then
                    MD提示("最大学习法术数量不得超过十五本")
                    e.dismiss()
                   else
                    local br = true
                    for k,v in pairs(tb.skill) do
                      if t["资源参数"]["宠兽法术"] == v.key then
                        br = false
                      end
                    end
                    if br then
                      if skill[t["资源参数"]["宠兽法术"]].type == nil then
                        table.insert(tb.skill,{key=t["资源参数"]["宠兽法术"],level=1,eq=1,exp=0})
                        MD提示(tb.name.."学会了"..t["资源参数"]["宠兽法术"])
                        DeleteItemTable(t,1)
                        if t.number > 1 then
                          t.number = t.number - 1
                          data1[i] = {name1=Color:Set(t.key.."["..品级[t["品质"]].."]".."[数量:"..math.ceil(t.number).."]",t["品质"])}
                         else
                          table.remove(patable,i)
                          table.remove(data1,i)
                        end
                       elseif skill[t["资源参数"]["宠兽法术"]].type[tb.key] then
                        table.insert(tb.skill,{key=t["资源参数"]["宠兽法术"],level=1,eq=1,exp=0})
                        MD提示(tb.name.."学会了"..t["资源参数"]["宠兽法术"])
                        DeleteItemTable(t,1)
                        if t.number > 1 then
                          t.number = t.number - 1
                          data1[i] = {name1=Color:Set(t.key.."["..品级[t["品质"]].."]".."[数量:"..math.ceil(t.number).."]",t["品质"])}
                         else
                          table.remove(patable,i)
                          table.remove(data1,i)
                        end
                       else
                        local str = ""
                        for k,v in pairs(skill[t["资源参数"]["宠兽法术"]].type) do
                          str=str..k.."族,"
                        end
                        MD提示("只有"..str.."妖兽才能学习"..t["资源参数"]["宠兽法术"])
                      end
                      宠兽包裹.Adapter.notifyDataSetChanged()
                      e.dismiss()
                     else
                      MD提示(tb.name.."已经学习过"..t["资源参数"]["宠兽法术"]..",无法重复学习")
                      e.dismiss()
                    end
                  end
                end
                if t["资源参数"]["提升资质"] ~= nil then
                  if dll ~= nil then
                    dll.dismiss()
                  end
                  local layout2={
                    LinearLayout;
                    orientation="vertical";
                    {
                      TextView;
                      text=Html.fromHtml("请选择"..yansep(tb.name,pz).."的一项资质进行提升");
                      id="xz";
                      layout_marginTop="16dp";
                      textColor="#ff000000";
                      textSize=getsize(16);
                      layout_margin="15dp";
                    };
                    {
                      LinearLayout;
                      layout_marginRight="18dp";
                      layout_marginTop="10dp";
                      layout_gravity="end";
                      {
                        TextView;
                        textSize=getsize(14);
                        layout_width="50dp";
                        id="tzts";
                        gravity="center";
                        layout_marginRight="15dp";
                        textColor="#009688";
                        layout_height="30dp";
                        text="体质";
                      };
                      {
                        TextView;
                        textSize=getsize(14);
                        layout_width="50dp";
                        id="ylts";
                        gravity="center";
                        layout_marginRight="15dp";
                        textColor="#009688";
                        layout_height="30dp";
                        text="妖力";
                      };
                      {
                        TextView;
                        textSize=getsize(14);
                        layout_width="50dp";
                        id="sfts";
                        gravity="center";
                        layout_marginRight="15dp";
                        textColor="#009688";
                        layout_height="30dp";
                        text="身法";
                      };
                      {
                        TextView;
                        layout_width="50dp";
                        id="ytts";
                        gravity="center";
                        text="妖体";
                        textColor="#009688";
                        layout_height="30dp";
                        textSize=getsize(14);
                      };
                    };
                    {
                      TextView;
                      layout_height="18dp";
                      layout_width="fill";
                    };
                  };

                  local dl=AlertDialog.Builder(activity)
                  .setView(loadlayout(layout2))
                  dll=dl.show()
                  function pecen()
                    local num = 0
                    for k,v in pairs(pet[tb.bh][tb.key1]["四维"]) do
                      num = num + v
                    end
                    return 3000/num
                  end
                  function tzts.onClick()
                    if tb["四维"][1] < math.ceil(pet[tb.bh][tb.key1]["四维"][1] * t["资源参数"]["提升资质"][1]*pecen()) then
                      tb["四维"][1] = tb["四维"][1] + t["资源参数"]["提升资质"][2]
                      MD提示(Html.fromHtml(yansep(tb.name,pz).."的体质资质提升了!"))
                      if tb["四维"][1] > math.ceil(pet[tb.bh][tb.key1]["四维"][1] * t["资源参数"]["提升资质"][1]*pecen()) then
                        tb["四维"][1] = math.ceil(pet[tb.bh][tb.key1]["四维"][1] * t["资源参数"]["提升资质"][1]*pecen())
                        MD提示(Html.fromHtml("当前"..yansep(tb.name,pz).."的体质资质已无法使用"..Color:Get(t.key,t["品质"]).."继续提升!"))
                      end
                      DeleteItemTable(t,1)
                      if t.number > 1 then
                        t.number = t.number - 1
                        data1[i] = {name1=Color:Set(t.key.."["..品级[t["品质"]].."]".."[数量:"..math.ceil(t.number).."]",t["品质"])}
                       elseif t.number == 1 then
                        e.dismiss()
                        table.remove(patable,i)
                        table.remove(data1,i)
                       else
                        MD提示("物品数量不足")
                      end
                      宠兽包裹.Adapter.notifyDataSetChanged()
                     else
                      MD提示(Html.fromHtml("当前"..yansep(tb.name,pz).."的体质资质已无法使用"..Color:Get(t.key,t["品质"]).."继续提升!"))
                    end
                    dll.dismiss()
                    体质数值.Text=math.ceil(tb["四维"][1]).."/"..pet[tb.bh][tb.key1]["四维"][1]*2
                    local tz = (tb["四维"][1] / pet[tb.bh][tb.key1]["四维"][1])/2
                    local tzc = 体质资质.getLayoutParams()
                    tzc.width = tz*0.75*activity.width
                    体质资质.setLayoutParams(tzc)
                    sz,pz = cspz(tb,tb.name)
                    csname.Text = sz
                    data[idx]={name=sz,id=tb.id}
                    adp.notifyDataSetChanged()
                  end
                  function ylts.onClick()
                    if tb["四维"][2] < math.ceil(pet[tb.bh][tb.key1]["四维"][2] * t["资源参数"]["提升资质"][1] * pecen()) then
                      tb["四维"][2] = tb["四维"][2] + t["资源参数"]["提升资质"][2]
                      MD提示(Html.fromHtml(yansep(tb.name,pz).."的妖力资质提升了!"))
                      if tb["四维"][2] > math.ceil(pet[tb.bh][tb.key1]["四维"][2] * t["资源参数"]["提升资质"][1]*pecen()) then
                        tb["四维"][2] = math.ceil(pet[tb.bh][tb.key1]["四维"][2] * t["资源参数"]["提升资质"][1]*pecen())
                        MD提示(Html.fromHtml("当前"..yansep(tb.name,pz).."的妖力资质已无法继续使用"..Color:Get(t.key,t["品质"]).."继续提升!"))
                      end
                      DeleteItemTable(t,1)
                      if t.number > 1 then
                        t.number = t.number - 1
                        data1[i] = {name1=Color:Set(t.key.."["..品级[t["品质"]].."]".."[数量:"..math.ceil(t.number).."]",t["品质"])}
                       elseif t.number == 1 then
                        e.dismiss()
                        table.remove(patable,i)
                        table.remove(data1,i)
                       else
                        MD提示("物品数量不足")
                      end
                      宠兽包裹.Adapter.notifyDataSetChanged()
                     else
                      MD提示(Html.fromHtml("当前"..yansep(tb.name,pz).."的妖力资质已无法使用"..Color:Get(t.key,t["品质"]).."继续提升!"))
                    end
                    dll.dismiss()
                    妖力数值.Text=math.ceil(tb["四维"][2]).."/"..pet[tb.bh][tb.key1]["四维"][2]*2
                    local tz = (tb["四维"][2] / pet[tb.bh][tb.key1]["四维"][2])/2
                    local tzc = 妖力资质.getLayoutParams()
                    tzc.width = tz*0.75*activity.width
                    妖力资质.setLayoutParams(tzc)
                    data[idx]={name=cspz(tb,tb.name),id=tb.id}
                    adp.notifyDataSetChanged()
                  end
                  function sfts.onClick()
                    if tb["四维"][3] < math.ceil(pet[tb.bh][tb.key1]["四维"][3] * t["资源参数"]["提升资质"][1] * pecen()) then
                      tb["四维"][3] = tb["四维"][3] + t["资源参数"]["提升资质"][2]
                      MD提示(Html.fromHtml(yansep(tb.name,pz).."的身法资质提升了!"))
                      if tb["四维"][3] > math.ceil(pet[tb.bh][tb.key1]["四维"][3] * t["资源参数"]["提升资质"][1]*pecen()) then
                        tb["四维"][3] = math.ceil(pet[tb.bh][tb.key1]["四维"][3] * t["资源参数"]["提升资质"][1]*pecen())
                        MD提示(Html.fromHtml("当前"..yansep(tb.name,pz).."的身法资质已无法继续使用"..Color:Get(t.key,t["品质"]).."继续提升!"))
                      end
                      DeleteItemTable(t,1)
                      if t.number > 1 then
                        t.number = t.number - 1
                        data1[i] = {name1=Color:Set(t.key.."["..品级[t["品质"]].."]".."[数量:"..math.ceil(t.number).."]",t["品质"])}
                       elseif t.number == 1 then
                        e.dismiss()
                        table.remove(patable,i)
                        table.remove(data1,i)
                       else
                        MD提示("物品数量不足")
                      end
                      宠兽包裹.Adapter.notifyDataSetChanged()
                     else
                      MD提示(Html.fromHtml("当前"..yansep(tb.name,pz).."的身法资质已无法使用"..Color:Get(t.key,t["品质"]).."继续提升!"))
                    end
                    dll.dismiss()
                    身法数值.Text=math.ceil(tb["四维"][3]).."/"..pet[tb.bh][tb.key1]["四维"][3]*2
                    local tz = (tb["四维"][3] / pet[tb.bh][tb.key1]["四维"][3])/2
                    local tzc = 身法资质.getLayoutParams()
                    tzc.width = tz*0.75*activity.width
                    身法资质.setLayoutParams(tzc)
                    sz,pz = cspz(tb,tb.name)
                    csname.Text = sz
                    data[idx]={name=sz,id=tb.id}
                    adp.notifyDataSetChanged()
                  end
                  function ytts.onClick()
                    if tb["四维"][4] < math.ceil(pet[tb.bh][tb.key1]["四维"][4] * t["资源参数"]["提升资质"][1] * pecen()) then
                      tb["四维"][4] = tb["四维"][4] + t["资源参数"]["提升资质"][2]
                      MD提示(Html.fromHtml(yansep(tb.name,pz).."的妖体资质提升了!"))
                      if tb["四维"][4] > math.ceil(pet[tb.bh][tb.key1]["四维"][4] * t["资源参数"]["提升资质"][1]*pecen()) then
                        tb["四维"][4] = math.ceil(pet[tb.bh][tb.key1]["四维"][4] * t["资源参数"]["提升资质"][1]*pecen())
                        MD提示(Html.fromHtml("当前"..yansep(tb.name,pz).."的妖体资质已无法继续使用"..Color:Get(t.key,t["品质"]).."继续提升!"))
                      end
                      DeleteItemTable(t,1)
                      if t.number > 1 then
                        t.number = t.number - 1
                        data1[i] = {name1=Color:Set(t.key.."["..品级[t["品质"]].."]".."[数量:"..math.ceil(t.number).."]",t["品质"])}
                       elseif t.number == 1 then
                        e.dismiss()
                        table.remove(patable,i)
                        table.remove(data1,i)
                       else
                        MD提示("物品数量不足")
                      end
                      宠兽包裹.Adapter.notifyDataSetChanged()
                     else
                      MD提示(Html.fromHtml("当前"..yansep(tb.name,pz).."的妖体资质已无法使用"..Color:Get(t.key,t["品质"]).."继续提升!"))
                    end
                    dll.dismiss()
                    妖体数值.Text=math.ceil(tb["四维"][4]).."/"..pet[tb.bh][tb.key1]["四维"][4]*2
                    local tz = (tb["四维"][4] / pet[tb.bh][tb.key1]["四维"][4])/2
                    local tzc = 妖体资质.getLayoutParams()
                    tzc.width = tz*0.75*activity.width
                    妖体资质.setLayoutParams(tzc)
                    sz,pz = cspz(tb,tb.name)
                    csname.Text = sz
                    data[idx]={name=sz,id=tb.id}
                    adp.notifyDataSetChanged()
                  end
                end
                loadsavewrite(0)
              end
            end
          end
         else
          提示("无法使用")
        end
      end
      local j
      function csfs()
        if j ~= nil then
          j.dismiss()
        end
        j = AlertDialog.Builder(this)
        .setTitle("确认")
        .setMessage(Html.fromHtml("确定要放生"..yansep(tb.name,pz).."吗？"))
        .setPositiveButton("取消",nil)
        .setNegativeButton("确认",function
          for k,v in pairs(SaveTable.pet) do
            if v.id == tb.id then
              table.remove(SaveTable.pet,k)
              table.remove(data,k)
              break
            end
          end
          for k,v in pairs(SaveTable.pet) do
            v.id = k
            data[k].id = k
          end
          e.dismiss()
          adp.notifyDataSetChanged()
          MD提示(Html.fromHtml(yansep(tb.name,pz).."已被放生!")) end)
        .show();
      end
      function chuzhan()
        if tb.eq ~= 1 then
          e.dismiss()
          tb.eq = 1
          data[idx]={name=cspz(SaveTable.pet[idx],SaveTable.pet[idx].name),id=SaveTable.pet[idx].id}
          adp.notifyDataSetChanged()
          MD提示("出战成功!")
         else
          e.dismiss()
          tb.eq = 0
          data[idx]={name=cspz(SaveTable.pet[idx],SaveTable.pet[idx].name),id=SaveTable.pet[idx].id}
          adp.notifyDataSetChanged()
          MD提示("召回成功!")
        end
        local num = 0
        for k,v in pairs(SaveTable.pet) do
          if v.eq == 1 then
            num = num + 1
          end
        end
        SaveTable.eqpet = num
      end
      local tfpop
      function tianfu()
        local tf = {
          LinearLayout;
          background='#ffffffff',
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
              layout_gravity="center";
              text="种族天赋";
              textColor="#FFFFFF";
            };
          };
          {
            TextView;
            id="种族特性";
            textColor="#000000";
            text="固定特性:";
          };
        };
        if tfpop ~= nil then
          tfpop.dismiss()
        end
        tfpop = popyes(tf)
        local talent = import "talent"
        if talent["特性"][tb.key1] ~= nil then
          种族特性.Text="种族特性:"..talent["特性"][tb.key1].info
         else
          种族特性.Text="种族特性:无"
        end
      end
      local jhwd
      function jinhua()
        if pet[tb.bh][tb.key1]["进化"] ~= nil then
          local tlb = pet[tb.bh][tb.key1]["进化"]
          local br = true
          local jh = {
            LinearLayout;
            orientation="vertical";
            layout_height="fill";
            layout_width="fill";
            {
              LinearLayout;
              backgroundColor="#FFFFFF";
              orientation="vertical";
              layout_height="match_parent";
              layout_width="match_parent";
              {
                FrameLayout;
                backgroundColor="#000000";
                layout_height="4%h";
                layout_width="match_parent";
                {
                  TextView;
                  layout_gravity="center";
                  text="进化面板";
                  textSize=getsize(15);
                  textColor="#FFFFFF";
                };
              };
              {
                LinearLayout;
                orientation="vertical";
                layout_height="wrap";
                layout_width="match_parent";
                {
                  TextView;
                  textSize=getsize(15);
                  text=tb.key1..">-"..tlb.key1;
                };
                {
                  TextView;
                  id="jhcl";
                  textColor="#000000";
                  textSize=getsize(12);
                };
              };
              {
                LinearLayout;
                orientation="horizontal";
                layout_width="match_parent";
                {
                  FrameLayout;
                  onClick=function
                    if br == true then
                      弹框("确定要进化该宠兽吗？","确定",function
                        for k,v in pairs(tlb.item) do
                          DeleteItem(v.key,math.ceil(v.number))
                        end
                        tb.bh = tlb.id
                        tb.key = tlb.key
                        tb.key1 = tlb.key1
                        tb.name = tlb.key1
                        jhwd.dismiss()
                        e.dismiss()
                        d.dismiss()
                        loadsavewrite(0)
                        提示("进化成功")
                      end)
                     else
                      提示("物品材料不足")
                    end
                  end;
                  backgroundColor="#000000";
                  layout_height="4.5%h";
                  layout_width="13%w";
                  {
                    FrameLayout;
                    backgroundColor="#FFFFFF";
                    layout_width="match_parent";
                    layout_height="match_parent";
                    layout_margin="0.4%w";
                    {
                      FrameLayout;
                      backgroundColor="#000000";
                      layout_width="match_parent";
                      layout_height="match_parent";
                      layout_margin="0.4%w";
                      {
                        TextView;
                        text="进化";
                        layout_gravity="center";
                        textColor="#FFFFFF";
                      };
                    };
                  };
                };
                {
                  FrameLayout;
                  onClick=function jhwd.dismiss() end;
                  layout_marginLeft="32%h";
                  backgroundColor="#000000";
                  layout_height="4.5%h";
                  layout_width="13%w";
                  {
                    FrameLayout;
                    backgroundColor="#FFFFFF";
                    layout_width="match_parent";
                    layout_height="match_parent";
                    layout_margin="0.4%w";
                    {
                      CardView;
                      backgroundColor="#000000";
                      layout_width="match_parent";
                      layout_height="match_parent";
                      layout_margin="0.4%w";
                      {
                        TextView;
                        text="取消";
                        layout_gravity="center";
                        textColor="#FFFFFF";
                      };
                    };
                  };
                };
              };
            };
          };
          if jhwd ~= nil then
            jhwd.dismiss()
          end
          jhwd = popyes(jh)
          local str="<br>进化需求:<br>"
          for k,v in pairs(tlb.item) do
            local num = math.ceil(gnum(v.key))
            local num1 = math.ceil(v.number)
            if num1 > num then
              num = Color:Get(tostring(num),7)
              br = false
            end
            str=table.concat({str,Color:Get(v.key,Item:GetLevel(v.key)),":",num,"/",num1,"<br>"})
          end
          jhcl.Text=Html.fromHtml(str)
         else
          提示("无法进化")
        end
      end
      local g
      function csgf()
        local its1 = {
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
                id="name1";
              };
            };
          };
        };
        local data1 = {}
        if g ~= nil then
          g.dismiss()
        end
        g = PopupWindow(activity)--创建PopWindow
        g.setContentView(loadlayout(MapUI()["宠兽功法"]))--设置布局
        g.setWidth(activity.Width*0.92)--设置宽度
        g.setHeight(-2)--设置高度
        g.setFocusable(true)--设置可获得焦点
        g.getBackground().setAlpha(0)
        g.setTouchable(true)--设置可触摸
        --设置点击外部区域是否可以消失
        g.setOutsideTouchable(false)
        --显示
        g.showAtLocation(view,Gravity.CENTER,0,0)
        function gffc()
          local 品阶 = {"黄阶初级","黄阶中级","黄阶高级","玄阶初级","玄阶中级","玄阶高级","地阶初级","地阶中级","地阶高级","天阶初级","天阶中级","天阶高级","仙经"}
          local adpt=LuaAdapter(activity,data1,its1)
          adpt.clear()
          local inskillbox = getinskillbox(tb.inskill)
          if #tb.inskill ~= 0 then
            for k,v in pairs(inskillbox) do
              table.insert(data1,{name1=Color:Set(v.key.."["..品阶[v["品质"]].."]",v["品质"])})
            end
           else
            table.insert(data1,{name1="未修习心法"})
          end
          宠兽功法.Adapter=adpt
          local h
          宠兽功法.onItemClick=function(l,v,p,i)
            if #tb.inskill ~= 0 then
              if h ~= nil then
                h.dismiss()
              end
              h = AlertDialog.Builder(this).show()
              h.getWindow().setContentView(loadlayout(MapUI()["宠兽功法面板"]));
              宠兽功法名称.Text=Color:Set(inskillbox[i].key.."["..品阶[inskillbox[i]["品质"]].."]",inskillbox[i]["品质"])
              宠兽修炼效率.Text=Color:Set("修炼效率:"..math.ceil(inskillbox[i]["修炼效率"]*((1+inskillbox[i].step)^inskillbox[i].level)) .."%",inskillbox[i]["品质"])
              宠兽功法等级.Text=Color:Get("当前已修炼至第"..math.ceil(inskillbox[i].level).."重",inskillbox[i]["品质"])
              if inskillbox[i].level >= 10 then
                宠兽功法特效.removeViews(2,1)
                宠兽功法等级.Text=宠兽功法等级.Text..Color:Get("(已满级)",inskillbox[i]["品质"])
               else
                宠兽功法熟练.Text=Color:Set("当前熟练度:"..math.ceil(inskillbox[i].exp).."/"..exp[inskillbox[i]["品质"]][inskillbox[i].level],inskillbox[i]["品质"])
              end
              宠兽功法等级.Text=Html.fromHtml(宠兽功法等级.Text)
              宠兽功法介绍.Text=inskillbox[i].info.."\n"
              --local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中"}
              local str = "功法属性:\n"
              for k,v in pairs(tab) do
                if inskillbox[i].Attribute[v] then
                  if v == "会心伤害" or v == "会心免伤" or v == "最终伤害放大" or v == "最终伤害抵消" or string.find(v,"基础") then
                    str=str.."提升"..v..math.ceil(inskillbox[i].Attribute[v]*((1+inskillbox[i].step)^inskillbox[i].level)*10)/10 .."%\n"
                   elseif v=="气血上限" then
                    str=str.."提升气血上限"..math.ceil(inskillbox[i].Attribute[v]*((1+inskillbox[i].step)^inskillbox[i].level)).."点\n"
                   elseif v=="法力上限" then
                    str=str.."提升法力上限"..math.ceil(inskillbox[i].Attribute[v]*((1+inskillbox[i].step)^inskillbox[i].level)).."点\n"
                   else
                    str=str.."提升"..v..math.ceil(inskillbox[i].Attribute[v]*((1+inskillbox[i].step)^inskillbox[i].level)).."点\n"
                  end
                end
              end
              宠兽功法属性.Text = str
              local uibox = {}
              for k,v in pairs(inskillbox[i].data) do
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
                if inskillbox[i].level >= v[2] then
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
              petgf.addView(loadlayout{
                LinearLayout;
                orientation="horizontal";
                layout_height="fill";
                layout_width="fill";
                {
                  Button;
                  text="遗忘";
                  onClick=function 遗忘功法() end;
                };
              })
              local hj
              function 遗忘功法()
                if hj ~= nil then
                  hj.dismiss()
                end
                hj = AlertDialog.Builder(this)
                .setTitle("确认")
                .setMessage("确定要遗忘该功法吗？")
                .setPositiveButton("取消",nil)
                .setNegativeButton("确认",function h.dismiss()
                  g.dismiss() loadsavewrite() MD提示(Html.fromHtml(yansep(tb.name,pz).."的"..Color:Get(inskillbox[i].key,inskillbox[i]["品质"]).."已被移除!"))
                  table.remove(tb.inskill,i)
                end)
                .show();
              end
            end
          end
        end
        function fsfc()
          local 品阶 = {"黄阶初级","黄阶中级","黄阶高级","玄阶初级","玄阶中级","玄阶高级","地阶初级","地阶中级","地阶高级","天阶初级","天阶中级","天阶高级","仙术"}
          local adpt=LuaAdapter(activity,data1,its1)
          adpt.clear()
          local skillbox = getskillbox(tb.skill)
          if #tb.skill ~= 0 then
            for k,v in pairs(skillbox) do
              table.insert(data1,{name1=Color:Set(v.key.."["..品阶[v["品质"]].."]",v["品质"])})
            end
           else
            table.insert(data1,{name1="未修习法术"})
          end
          宠兽功法.Adapter=adpt
          local h
          宠兽功法.onItemClick=function(l,v,p,i)
            if #tb.skill ~= 0 then
              if h ~= nil then
                h.dismiss()
              end
              h = AlertDialog.Builder(this).show()
              h.getWindow().setContentView(loadlayout(MapUI()["宠兽法术面板"]));
             -- local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中"}
              local ostr = ""
              local num = 0
              for k,v in pairs(skillbox[i]["属性"]) do
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
                for k,v in pairs(skillbox[i]["属性"]) do
                  str=str..k..":"..yansea(v*100,tap[k]).."%(带有"..yansea(k,tap[k]).."属性的宠兽对法术伤害的增幅强度)<br>"
                end
                local xq=AlertDialog.Builder(activity)
                .setView(loadlayout(m)).show()
                灵根属性.Text=Html.fromHtml(str)
              end
              宠兽法术名称.Text=Color:Set(skillbox[i].key.."["..品阶[skillbox[i]["品质"]].."]",skillbox[i]["品质"])
              宠兽法术消耗.Text=Color:Set("法力消耗:"..math.ceil(skillbox[i].cost * ((skillbox[i].step + 1) ^ skillbox[i].level)),skillbox[i]["品质"])
              宠兽法术等级.Text=Color:Get("当前已修炼至第"..math.ceil(skillbox[i].level).."重",skillbox[i]["品质"])
              if skillbox[i].level >= 10 then
                宠兽法术特效.removeViews(3,1)
                宠兽法术等级.Text=宠兽法术等级.Text..Color:Get("(已满级)",skillbox[i]["品质"])
               else
                宠兽法术熟练.Text=Color:Set("当前熟练度:"..math.ceil(skillbox[i].exp).."/"..exp[skillbox[i]["品质"]][skillbox[i].level],skillbox[i]["品质"])
              end
              宠兽法术等级.Text=Html.fromHtml(宠兽法术等级.Text)
              宠兽法术介绍.Text=skillbox[i].info.."\n"
              宠兽法术参数.Text="外攻伤害:"..skillbox[i].outpow*((1+skillbox[i].step)^skillbox[i].level)*100 .."%  \t内攻伤害:"..skillbox[i].inpow*((1+skillbox[i].step)^skillbox[i].level)*100 .."%\n攻击范围:"..skillbox[i].hit.."\t  冷却回合:"..skillbox[i].MaxCd
              local str = "法术属性:\n"
              for k,v in pairs(tab) do
                if skillbox[i][v] then
                  if v == "会心伤害" or v == "会心免伤" or v == "最终伤害放大" or v == "最终伤害抵消" or string.find(v,"基础") then
                    str=str.."提升"..v..math.ceil(skillbox[i][v]*((1+skillbox[i].step)^skillbox[i].level)*10)/10 .."%\n"
                   else
                    str=str.."提升"..v..math.ceil(skillbox[i][v]*((1+skillbox[i].step)^skillbox[i].level)).."点\n"
                  end
                end
              end
              宠兽法术属性.Text = str
              local uibox = {}
              for k,v in pairs(skillbox[i].data) do
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
                if skillbox[i].level >= v[2] then
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
              宠兽法术.addView(loadlayout{
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
                  id="修炼妖法";
                  onClick=function 修炼法术() end;
                };
                {
                  Button;
                  text="遗忘";
                  id="遗忘法术";
                  onClick=function 遗忘法术() end;
                };
              })
              if tb.skill[i].eq == 1 then
                装备法术.Text = "卸下"
              end
              装备法术.onClick=function
                if tb.skill[i].eq == 1 then
                  tb.skill[i].eq = 0
                  装备法术.Text = "装备"
                  MD提示(Html.fromHtml(yansep(tb.name,pz).."的"..Color:Get(skillbox[i].key,skillbox[i]["品质"]).."已被卸下!"))
                 else
                  tb.skill[i].eq = 1
                  装备法术.Text = "卸下"
                  MD提示(Html.fromHtml(yansep(tb.name,pz).."的"..Color:Get(skillbox[i].key,skillbox[i]["品质"]).."装备成功!"))
                end
              end
              if (tb["修炼法术"] ~= nil and tb["修炼法术"].key == skillbox[i].key) then
                修炼妖法.Text="结束"
              end
              function 修炼法术()
                local function petAddSkillExp(key,num,p,id)
                  local x = 1
                  local skb = SaveTable.pet[id].skill
                  repeat
                  if key == skb[x].key then
                    skb[x].exp = skb[x].exp + num
                    if tonumber(exp[p][skb[x].level]) then
                      while skb[x].exp >= exp[p][skb[x].level] do
                        skb[x].exp = skb[x].exp - exp[p][skb[x].level]
                        skb[x].level = skb[x].level + 1
                      end
                    end
                    break
                   else
                    x = x + 1
                  end
                  until x > #skb
                end
                local x,y
                if tb.level > 24 then
                  y = 50
                  x = "妖族大圣"
                 elseif tb.level > 20 then
                  y = 30
                  x = "天妖境"
                 elseif tb.level > 16 then
                  y = 20
                  x = "妖尊境"
                 elseif tb.level > 12 then
                  y = 15
                  x = "妖君境"
                 elseif tb.level > 8 then
                  y = 10
                  x = "妖王境"
                 elseif tb.level > 4 then
                  y = 5
                  x = "妖将境"
                 else
                  y = 2
                  x = "妖兽境"
                end
                local br = true
                if tb["修炼法术"] ~= nil then
                  for k,v in pairs(tb.skill) do
                    if tb["修炼法术"].key == v.key then
                      br = false
                    end
                  end
                end
                if tb["修炼法术"] == nil or br == true then
                  Http.get("http://api.k780.com/?app=life.time&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json",nil,nil,nil,function(q,w,e,r)
                    if q ~= -1 then
                      local time = cjson.decode(w)["result"]["timestamp"]
                      tb["修炼法术"] = {key=skillbox[i].key,t=time}
                      MD提示(Html.fromHtml("成功修炼"..Color:Get(skillbox[i].key,skillbox[i]["品质"]).."，当前为"..x..",每秒获取熟练度"..y.."点!"))
                      h.dismiss()
                      loadsavewrite()
                    end
                  end)
                 elseif tb["修炼法术"].key == skillbox[i].key then
                  Http.get("http://api.k780.com/?app=life.time&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json",nil,nil,nil,function(q,w,e,r)
                    if tb["修炼法术"] ~= nil then
                      if q ~= -1 then
                        local time = cjson.decode(w)["result"]["timestamp"] - tb["修炼法术"].t
                        local ts = math.ceil(y * time)
                        petAddSkillExp(tb["修炼法术"].key,ts,skillbox[i]["品质"],tb.id)
                        MD提示(Html.fromHtml("修炼结束，"..Color:Get(skillbox[i].key,skillbox[i]["品质"]).."熟练值增加"..ts.."点!"))
                        h.dismiss()
                        tb["修炼法术"] = nil
                        loadsavewrite()
                      end
                    end
                  end)
                 else
                  local pz = skill[tb["修炼法术"].key]["品质"]
                  MD提示(Html.fromHtml("请先结束"..Color:Get(tb["修炼法术"].key,pz).."的修炼!"))
                end
              end
              function 遗忘法术()
                AlertDialog.Builder(this)
                .setTitle("确认")
                .setMessage("确定要遗忘该法术吗？")
                .setPositiveButton("取消",nil)
                .setNegativeButton("确认",function h.dismiss()
                g.dismiss() loadsavewrite() MD提示(Html.fromHtml(yansep(tb.name,pz).."的"..Color:Get(skillbox[i].key,skillbox[i]["品质"]).."已被移除!")) table.remove(tb.skill,i) end)
                .show();
              end
            end
          end
        end
        gffc()
      end
      local l
      function petshuxing()
        if tb.inskill == nil then
          tb.inskill = {}
        end
        if tb.skill == nil then
          tb.skill = {}
        end
        petat(tb,tb.bh)
        if l ~= nil then
          l.dismiss()
        end
        l=AlertDialog.Builder(this).show()
        l.getWindow().setContentView(loadlayout(MapUI()["宠兽属性"]));
        宠兽姓名.Text=宠兽姓名.Text..tb.name
        pet境界.Text=pet境界.Text..tp[tb.level]["境界"]
        宠兽体质.Text=宠兽体质.Text..tb.attribute["体质"]
        宠兽真元.Text=宠兽真元.Text..tb.attribute["真元"]
        宠兽身法.Text=宠兽身法.Text..tb.attribute["身法"]
        宠兽肉身.Text=宠兽肉身.Text..tb.attribute["肉身"]
        宠兽内攻.Text=宠兽内攻.Text..tb.attribute["内攻"]
        宠兽外攻.Text=宠兽外攻.Text..tb.attribute["外攻"]
        宠兽外防.Text=宠兽外防.Text..tb.attribute["外防"]
        宠兽内防.Text=宠兽内防.Text..tb.attribute["内防"]
        宠兽会心率.Text=宠兽会心率.Text..tb.attribute["会心率"]
        宠兽抗会心率.Text=宠兽抗会心率.Text..tb.attribute["抗会心率"]
        宠兽命中.Text=宠兽命中.Text..tb.attribute["命中"]
        宠兽闪避.Text=宠兽闪避.Text..tb.attribute["闪避"]
        宠兽会心伤害.Text=宠兽会心伤害.Text..tb.attribute["会心伤害"].."%"
        宠兽血量.Text=宠兽血量.Text..tb.attribute["气血上限"]
        宠兽法力.Text=宠兽法力.Text..tb.attribute["法力上限"]
        宠兽会心免伤.Text=宠兽会心免伤.Text..tb.attribute["会心免伤"].."%"
        宠兽最终伤害放大.Text=宠兽最终伤害放大.Text..tb.attribute["最终伤害放大"].."%"
        宠兽最终伤害抵消.Text=宠兽最终伤害抵消.Text..tb.attribute["最终伤害抵消"].."%"
        csfight.Text = "战斗力:"..math.ceil(tb.attribute["内攻"]*2+tb.attribute["外攻"]*2+tb.attribute["内防"]*2.5+tb.attribute["外防"]*2.5+tb.attribute["气血上限"]*0.2+tb.attribute["法力上限"]*0.1+tb.attribute["会心率"]*2+tb.attribute["抗会心率"]*2+tb.attribute["闪避"]*2.5+tb.attribute["命中"]*2.5+tb.attribute["会心伤害"]*20+tb.attribute["会心免伤"]*20+tb.attribute["最终伤害放大"]*30+tb.attribute["最终伤害抵消"]*30)
      end
    end
   else
    MD提示("炼气五层后开启宠兽!")
  end
end