require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "GetItem"
local Item = import "item"

local 资源 = import "resource"
local sop1

function RemoveShopItem(key,num)
  for k,v in pairs(SaveTable.shopcs.item) do
    if v.key == key then
      if v.number <= num then
        table.remove(SaveTable.shopcs.item,k)
       else
        v.number = v.number - num
      end
    end
  end
end

function ShopEq(tb)
  local tab = {}
  local cs = {0.2,0.18,0.16,0.05,0.036,0.025,0.012,0.01,0.008,0.004,0,0,0}
  for k,v in pairs(tb)
    if probability(cs[v["品质"]]) then
      table.insert(tab,{key=v.key,price=v.price*2,number=1})
    end
  end
  return tab
end

function ShopDy(tb)
  local tab = {}
  local cs = {{pro=0.2,num={10,20}},{pro=0.18,num={8,15}},{pro=0.16,num={5,10}},{pro=0.12,num={3,5}},{pro=0.1,num={1,5}},{pro=0.08,num={1,3}},{pro=0.03,num={1,2}},{pro=0.025,num={1,2}},{pro=0.02,num={1,2}},{pro=0.01,num={1,1}},{pro=0,num={1,3}},{pro=0,num={1,3}},{pro=0,num={1,3}}}
  for k,v in pairs(tb)
    local gl,num = 1,math.random(cs[v["品质"]].num[1],cs[v["品质"]].num[2])
    if v.pro ~= nil then
      gl = v.pro
    end
    if v.num ~= nil then
      num = math.random(v.num[1],v.num[2])
    end
    if probability(cs[v["品质"]].pro*num) then
      table.insert(tab,{key=v.key,price=v.price*2,number=num})
    end
  end
  return tab
end

function ShopMj(tb)
  local tab = {}
  local cs = {0.06,0.04,0.015,0.01,0.008,0.0015,0.001,0.0008,0.0006,0.0002,0.00015,0.0001,0.00003}
  for k,v in pairs(tb)
    if probability(cs[v["品质"]]) then
      table.insert(tab,{key=v.key,price=v.price*2,number=1})
    end
  end
  return tab
end

function ShopTs(tb)
  local tab = {}
  local cs = {{pro=0.5,num={100,500}},{pro=0.4,num={80,400}},{pro=0.3,num={80,400}},{pro=0.2,num={50,200}},{pro=0.15,num={50,200}},{pro=0.12,num={50,200}},{pro=0.08,num={30,120}},{pro=0.07,num={30,120}},{pro=0.06,num={30,120}},{pro=0.04,num={20,80}},{pro=0,num={1,3}},{pro=0,num={1,3}},{pro=0,num={1,3}}}
  for k,v in pairs(tb)
    if probability(cs[v["品质"]].pro) then
      table.insert(tab,{key=v.key,price=v.price*2,number=math.random(cs[v["品质"]].num[1],cs[v["品质"]].num[2])})
    end
  end
  return tab
end

function GetShop(tb)
  local tab = {}
  local teq = ShopEq(tb.eq)
  for k,v in pairs(teq) do
    table.insert(tab,v)
  end
  local tdy = ShopDy(tb.dy)
  for k,v in pairs(tdy) do
    table.insert(tab,v)
  end
  local tmj = ShopMj(tb.mj)
  for k,v in pairs(tmj) do
    table.insert(tab,v)
  end
  local tts = ShopTs(tb.ts)
  for k,v in pairs(tts) do
    table.insert(tab,v)
  end
  return tab
end

function ShopItem(a,time)
  if SaveTable.sys == nil then
    SaveTable.sys = {level=1,shop=1,battle=1}
  end
  if a.shopcs == nil or tonumber(a.shopcs.time) <= tonumber(time) - 14400 then
    local it = {eq={},dy={},mj={},ts={}}
    for i=1,#Item do
      if Item[i].type <= 5 and Item[i]["品质"] <= SaveTable.sys.shop then
        table.insert(it.eq,Item[i])
       elseif Item[i].type == 6 and Item[i]["品质"] <= SaveTable.sys.shop then
        table.insert(it.dy,Item[i])
       elseif ((Item[i].type == 7 or Item[i].type == 9) and Item[i]["品质"] <= SaveTable.sys.shop) then
        table.insert(it.mj,Item[i])
       elseif Item[i].type >= 10 and Item[i]["品质"] <= SaveTable.sys.shop then
        table.insert(it.ts,Item[i])
      end
    end
    local tab = GetShop(it)
    a.shopcs = {time=time,item=tab}
    loadsavewrite(0)
    return tab
   else
    return a.shopcs.item
  end
end

function ShopItemShow(a,b)
  if sop1 ~= nil then
    sop1.dismiss()
    sop1=nil
  end
  if SaveTable.owner.level >= 0 then
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

    function GetItemBox(key)
      local x = 1
      local tb
      repeat
      if Item[x].key == key then
        tb = Item[x]
        break
       else
        x = x + 1
      end
      until x > #Item
      return tb
    end
    if sop1 == nil then
      sop1=PopupWindow(activity)--创建PopWindow
      sop1.setContentView(loadlayout(MapUI()["坊市"]))--设置布局
      sop1.setWidth(activity.Width*0.92)--设置宽度
      sop1.setHeight(activity.Height*0.65)--设置高度
      sop1.setFocusable(true)--设置可获得焦点
      sop1.getBackground().setAlpha(0)
      sop1.setTouchable(true)--设置可触摸
      --设置点击外部区域是否可以消失
      sop1.setOutsideTouchable(false)
      --显示
      sop1.showAtLocation(view,Gravity.CENTER,0,0)
      灵石.Text="灵石: "..math.ceil(SaveTable.owner.money)
    end
    local sp = {
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
            id="商品名";
          };
        };
      };
    };
    local data={}
    local l
    local adp=LuaAdapter(activity,data,sp)
    商品列表.Adapter=adp
    local 品级 = {"黄阶下品","黄阶中品","黄阶上品","玄阶下品","玄阶中品","玄阶上品","地阶下品","地阶中品","地阶上品","天阶下品","天阶中品","天阶上品","仙品"}
    local thisbox = {}
    Http.get("http://api.k780.com/?app=life.time&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json",nil,nil,nil,function(q,w,e,r)
      local time = cjson.decode(w)["result"]["timestamp"]
      local shop = ShopItem(SaveTable,time)
      local sj = SaveTable.shopcs.time - time + 14400
      时间.Text = "   剩余刷新时间: "..NetTime(sj)
      for k,v in pairs(shop) do
        local itembox = GetItemBox(v.key)
        itembox["价格"]=v.price
        itembox.number=v.number
        if (itembox.type >= a and itembox.type <= b )
          table.insert(thisbox,itembox)
          table.insert(data,{商品名=Color:Set(v.key.."["..品级[itembox["品质"]].."]".."[价格:"..math.ceil(v.price).."]".."[数量:"..math.ceil(shop[k].number).."]",itembox["品质"])})
        end
      end
      adp.notifyDataSetChanged()
      商品列表.onItemClick=function(l,v,p,i)
        if lp ~= nil then
          lp.dismiss()
        end
        lp=AlertDialog.Builder(this).show()
        lp.getWindow().setContentView(loadlayout(MapUI()["购买框"]))
        local nb = 1
        local t = thisbox[i]
        if t.number > 1 then
          goumai.addView(loadlayout
          {
            LinearLayout;
            layout_width="fill";
            orientation="horizontal";
            layout_height="fill";
            {
              TextView;
              text="购";
              textSize=getsize(14);
              textColor="#333333";
              id="购买数量";
            };
            {
              Button;
              id="输入";
              layout_height="5%h";
              text="点击输入数量";
            };
          })
          购买数量.Text="购买数量:"..math.ceil(nb).."个"
          输入.onClick=function()
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
                hint="请输入需要购买的数量";
                layout_marginTop="5dp";
                layout_marginLeft="10dp",
                layout_marginRight="10dp",
                layout_width="match_parent";
                layout_gravity="center",
                id="shuru";
              };
            };

            AlertDialog.Builder(this)
            .setTitle("请输入")
            .setView(loadlayout(InputLayout))
            .setPositiveButton("确定",{onClick=function(v)
                if tonumber(shuru.Text) then
                  if tonumber(shuru.Text) > t.number then
                    nb = t.number
                   elseif tonumber(shuru.Text) == 0 then
                    nb = 1
                   else
                    nb = tonumber(shuru.Text)
                  end
                end
                购买数量.Text="购买数量:"..math.ceil(nb).."个"
            end})
            .setNegativeButton("取消",nil)
            .show()
            import "android.view.View$OnFocusChangeListener"
            import "android.text.InputType"
            import "android.text.method.DigitsKeyListener"
            shuru.setInputType(InputType.TYPE_CLASS_NUMBER)
            shuru.setKeyListener(DigitsKeyListener.getInstance("0123456789"))
            shuru.setOnFocusChangeListener(OnFocusChangeListener{
              onFocusChange=function(v,hasFocus)
                if hasFocus then
                  Prompt.setTextColor(0xFD009688)
                end
            end})
          end
        end
        function 购买物品()
          if SaveTable.owner.money >= thisbox[i]["价格"]*nb then
            SaveTable.owner.money = SaveTable.owner.money - thisbox[i]["价格"] * nb
            Item:Add(thisbox[i].key,nb)
            MD提示(Html.fromHtml("购买成功!获得"..SkillColor(thisbox[i].key,thisbox[i]["品质"]).."*"..math.ceil(nb)))
            灵石.Text="灵石: "..math.ceil(SaveTable.owner.money).."   "
            RemoveShopItem(thisbox[i].key,nb)
            if thisbox[i].number <= nb then
              table.remove(thisbox,i)
              adp.remove(i-1)
             else
              thisbox[i].number = thisbox[i].number - nb
              data[i]={商品名=Color:Set(thisbox[i].key.."["..品级[thisbox[i]["品质"]].."]".."[价格:"..math.ceil(thisbox[i]["价格"]).."]".."[数量:"..math.ceil(thisbox[i].number).."]",thisbox[i]["品质"])}
            end
            adp.notifyDataSetChanged()
            loadsavewrite()
            lp.dismiss()
           else
            MD提示("灵石不足!")
            lp.dismiss()
          end
        end
        function 关闭购买()
          lp.dismiss()
        end
        local lx = {"武器","衣服","帽子","护手","鞋子","饰品","丹药","秘籍","特殊","特殊","特殊","特殊","特殊","特殊","特殊"}
        shopname.Text = Color:Set(thisbox[i].key,thisbox[i]["品质"])
        local file = "商品类型:"..lx[thisbox[i].type+1].."\n商品介绍:"..thisbox[i].Info.."\n\n"
        if thisbox[i].type < 6 then
          file=file.."物品属性:\n"
          --local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中"}
          for k,v in pairs(tab) do
            if thisbox[i][v] then
              if v=="会心伤害" or v=="会心免伤" or v=="最终伤害放大" or v=="最终伤害抵消" or string.find(v,"基础") then
                file=file..v..":"..thisbox[i][v].."%\n"
               else
                file=file..v..":"..thisbox[i][v].."\n"
              end
            end
          end
         else
          file=file.."使用效果\n"
          if thisbox[i]["资源参数"] then
            for k,v in pairs(thisbox[i]["资源参数"]) do
              if k ~= "耐药性" then
                if type(v) == "table" then
                  file=file..资源["资源参数"][k][1]..v[#v]..资源["资源参数"][k][2]
                 else
                  file=file..资源["资源参数"][k][1]..v..资源["资源参数"][k][2]
                end
              end
            end
          end
        end
        商品内容.Text=file
      end
    end)
   else
    MD提示("炼气五层后开启坊市")
  end
end