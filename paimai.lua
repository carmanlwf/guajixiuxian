require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "bmob"
import "android.text.InputType"
import "android.text.method.DigitsKeyListener"

local Color = {hui="#C6C6C6",black="#000000",white="#FFFFFF",green="#008000",blue="#0000FF",red="#FF0000",orange="#FFA500",gold="#FFD700"}
local 品级 = {"黄阶下品","黄阶中品","黄阶上品","玄阶下品","玄阶中品","玄阶上品","地阶下品","地阶中品","地阶上品","天阶下品","天阶中品","天阶上品","仙品"}
local e

function SkillColor(str,lv)
  if lv >= 13 then
    str="<font color="..Color.gold..">"..str.."</font>"
   elseif lv >= 10 then
    str="<font color="..Color.orange..">"..str.."</font>"
   elseif lv >= 7 then
    str="<font color="..Color.red..">"..str.."</font>"
   elseif lv >= 4 then
    str="<font color="..Color.blue..">"..str.."</font>"
   else
    str="<font color="..Color.green..">"..str.."</font>"
  end
  return str
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

local q
local r
local d

function 打开交易所(n,m)
  local data={}
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
  local id="7ae633a369a78cf8355607124387a410" --Application ID
  local key="1894793c3b32a52fe0059c82d4b9872c" --REST API Key
  local Item = import "item"
  local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中","神念消耗","材料消耗","成丹率","成功率","出丹率","评分提升","属性品质","获取经验"}
  local b=bmob(id,key)
  local adp=LuaAdapter(activity,data,its)
  local tlb
  local tb
  local tba
  function MyTable(tps,n,m)
    local t = tps[1]
    local p = tps[2]
    local no1 = #data
    for i=1,no1 do
      table.remove(data)
    end
    local tab1 = {}
    local tab2 = {}
    for i=1,#t do
      if (t[i].atr.number > 0 and t[i].type >= n and t[i].type <= m) then
        local v = t[i].atr
        table.insert(tab1,v)
        for k,v in pairs(t[i]) do
          if k ~= "atr" then
            tab1[#tab1][k] = v
          end
        end
        if t[i].type <= 5 then
          local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中","神念消耗","材料消耗","成丹率","成功率","出丹率","评分提升","属性品质","获取经验"}
          local pt = {}
          local itb = Item:GetTable(v.key)
          local num = 0
          for n,m in pairs(tab) do
            if v[m] ~= nil then
              num = num + v[m]/itb[m]
              table.insert(pt,itb[m])
            end
          end
          local point = math.floor(num/(#pt*2)*100)
          table.insert(data,{name=Color:Set(EqLevel(v.key,v.level).."["..品级[t[i]["品质"]].."]".."[单价:"..math.ceil(v.price).."]".."[数量:"..math.ceil(v.number).."][评分:"..point.."]",t[i]["品质"])})--添加数据进适配器，还有一种方法table.insert(data,{})
         else
          table.insert(data,{name=Color:Set(EqLevel(v.key,v.level).."["..品级[t[i]["品质"]].."]".."[单价:"..math.ceil(v.price).."]".."[数量:"..math.ceil(v.number).."]",t[i]["品质"]),id=v.id})
        end
      end
    end
    if math.floor(#tb/500) * 500 >= #tb/500 then
      table.insert(data,{name="下一页"})
    end
    adp.notifyDataSetChanged()
    return tab1,tab2
  end
  tb = 查询数据("chus").results
  tba = table.clone(tb)
  for i=1,#tb do
    for k,v in pairs(Item) do
      if tb[i].atr.key == v.key then
        for d,t in pairs(tab) do
          if v[t] then
            tb[i].atr[t] = math.ceil(v[t] * tb[i].atr[t])
          end
        end
        tb[i]["品质"] = v["品质"]
        tb[i].type = v.type
        tb[i].Info = v.Info
        break
      end
    end
  end
  tlb,tbl = MyTable({tb,tba},n,m)
  if #tlb == 0 then
    table.insert(data,{name="没有正在寄售的物品"})
  end
  function 查询分页()
    local tbt = 分页数据(#tb).results
    local tbt1 = table.clone(tbt)
    for i=1,#tbt do
      for k,v in pairs(Item) do
        if tbt[i].atr.key == v.key then
          for d,t in pairs(tab) do
            if v[t] then
              tbt[i].atr[t] = math.ceil(v[t] * tbt[i].atr[t])
            end
          end
          tbt[i]["品质"] = v["品质"]
          tbt[i].type = v.type
          tbt[i].Info = v.Info
          break
        end
      end
    end
    for k,v in pairs(tbt) do
      table.insert(tb,v)
    end
    for k,v in pairs(tbt1) do
      table.insert(tba,v)
    end
    tlb,tbl = MyTable({tb,tba},n,m)
  end
  function ShowMenu(tb,i,tp)
    if e ~= nil then
      e.dismiss()
    end
    e=AlertDialog.Builder(this).show()
    e.getWindow().setContentView(loadlayout(MapUI()["拍卖信息"]));
    local slit = tb[i]
    物品名称.Text=Color:Set(EqLevel(slit.key,slit.level).."["..品级[slit["品质"]].."]",slit["品质"])
    物品介绍.Text=tb[i].Info
    local f = ""
    for k,v in pairs(tab) do
      if slit[v] then
        if v == "会心伤害" or v == "会心免伤" or v == "最终伤害放大" or v == "最终伤害抵消" or string.find(v,"基础") then
          f=f..v..":"..math.ceil(slit[v]*(1.1^slit.level)).."%\n"
         elseif v=="气血上限" then
          f=f.."气血上限:"..math.ceil(slit[v]*(1.1^slit.level)).."\n"
         elseif v=="法力上限" then
          f=f.."法力上限:"..math.ceil(slit[v]*(1.1^slit.level)).."\n"
         else
          f=f..v..":"..math.ceil(slit[v]*(1.1^slit.level)).."\n"
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
    local t = slit
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
      拍卖信息.addView(loadlayout {
        LinearLayout;
        {
          TextView;
          id="上架数量";
          layout_gravity="center";
          textColor="#000000";
          text="上架数量:1件";
        };
        {
          Button;
          onClick=function 选择数量() end;
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
          onClick=function SalePost() end;
          layout_width="60dp";
          text="寄售";
          layout_height="45dp";
        };
      })
     else
      拍卖信息.addView(loadlayout{
        LinearLayout;
        layout_width="fill";
        layout_height="50dp";
        {
          Button;
          onClick=function SaleDelete() end;
          layout_width="60dp";
          text="下架";
          layout_height="45dp";
        };
      })
    end
    return e
  end
  拍卖.Adapter=adp
  if #tb ~= 0 then
    拍卖.onItemClick=function(l,v,p,i)
      if #data > i or data[i].name ~= "下一页" then
        local e = ShowMenu(tlb,i,1)
        local num = 1
        function 购买数量()
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
              hint="请输入你要购买的数量";
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
              if (tonumber(edit.Text) and tonumber(edit.Text) > 0) then
                if tonumber(edit.Text) > tlb[i].number then
                  num = tlb[i].number
                 else
                  num = tonumber(edit.Text)
                end
                拍卖数量.Text="购买数量:"..math.ceil(num).."件"
              end
          end})
          .setNegativeButton("取消",nil)
          .show()
          edit.setInputType(InputType.TYPE_CLASS_NUMBER)
          edit.setKeyListener(DigitsKeyListener.getInstance("0123456789"))
        end
        function 购买物品()
          local itb = tlb[i]
          local u
          if itb.number >= 1 then
            if SaveTable.owner.money >= itb.price*num then
              b:query("chus",itb.id,function(code,body)
                for k,v in pairs(tb) do
                  if itb.id == v.id then
                    u = k
                  end
                end
                if body.atr.number <= 0 then
                  MD提示("该商品已被其他修士购买!")
                 else
                  local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中","神念消耗","材料消耗","成丹率","成功率","出丹率","评分提升","属性品质","获取经验"}
                  local dt = {key=body.atr.key,level=body.atr.level,price=body.atr.price,number=body.atr.number-num,["附加属性"]=body.atr["附加属性"]}
                  for k,v in pairs(tab) do
                    if body.atr[v] ~= nil then
                      dt[v] = body.atr[v]
                    end
                  end
                  if body.atr.number <= num then
                    num = body.atr.number
                    table.remove(tlb,i)
                  end
                  tb[u].atr.number = tb[u].atr.number - num
                  b:update("chus",tb[u].id,{atr=dt,id=body.id},function() end)
                  dt.number = num
                  SaveTable.owner.money = math.ceil(SaveTable.owner.money - tb[u].atr.price*num)
                  local brr
                  if tb[u].type <= 5 then
                    dt.price = nil
                    table.insert(SaveTable.Item,dt)
                   else
                    for k,v in pairs(SaveTable.Item) do
                      if v.key == dt.key then
                        brr = k
                        break
                      end
                    end
                    if brr ~= nil then
                      SaveTable.Item[brr].number = SaveTable.Item[brr].number + num
                     else
                      dt.price = nil
                      table.insert(SaveTable.Item,dt)
                    end
                  end
                  if tb[u].atr.number <= 0 then
                    table.remove(tb,u)
                    table.remove(tba,u)
                  end
                  MD提示("物品购买成功！")
                end
                tlb,tbl = MyTable({tb,tba},n,m)
                loadsavewrite(0)
              end)
              e.dismiss()
             else
              MD提示("你的灵石不够!")
              e.dismiss()
            end
          end
        end
       else
        查询分页()
      end
    end
  end
  function SaleMenu()
    if r ~= nil then
      r.dismiss()
    end
    r=PopupWindow(activity)--创建PopWindow
    r.setContentView(loadlayout(MapUI()["寄售"]))--设置布局
    r.setWidth(activity.Width*0.92)--设置宽度
    r.setHeight(activity.Height*0.7)--设置高度
    r.setFocusable(true)--设置可获得焦点
    r.getBackground().setAlpha(0)
    r.setTouchable(true)--设置可触摸
    --设置点击外部区域是否可以消失
    r.setOutsideTouchable(false)
    --显示
    r.showAtLocation(view,Gravity.CENTER,0,0) local data1
    local sl = {}
    local slt = {}
    if (SaveTable.sale and tb) then
      for k,v in pairs(SaveTable.sale) do
        for t,b in pairs(tb) do
          if b.id == k then
            table.insert(sl,b)
            table.insert(slt,b)
            break
          end
        end
      end
    end
    function SetUI(sl)
      data1={}
      local adp1=LuaAdapter(activity,data1,its)
      for t,b in pairs(sl) do
        local v = SaveTable.sale[b.id]
        if b.atr.number < v then
          table.insert(data1,{name=Color:Set(EqLevel(b.atr.key,b.atr.level).."["..品级[b["品质"]].."]".."[数量:"..math.ceil(b.atr.number).."]".."[已售出:"..math.ceil(v-b.atr.number).."件]",b["品质"])})
         elseif b.atr.number <= 0 then
          table.insert(data1,{name=Color:Set(EqLevel(b.atr.key,b.atr.level).."["..品级[b["品质"]].."]".."[已售完]",b["品质"])})
         else
          table.insert(data1,{name=Color:Set(EqLevel(b.atr.key,b.atr.level).."["..品级[b["品质"]].."]".."[数量:"..math.ceil(b.atr.number).."]",b["品质"])})
        end
      end
      我的寄售.Adapter=adp1
    end
    我的寄售.onItemClick=function(l,v,p,i)
      if SaveTable.sale then
        if sl[i] ~= nil then
          if sl[i].atr.number <= 0 then
            local numa = SaveTable.sale[sl[i].id]
            local numb = numa * sl[i].atr.price
            SaveTable.owner.money = math.ceil(SaveTable.owner.money + numb)
            SaveTable.sale[sl[i].id] = nil
            b:delete("chus",sl[i].id,function()
              MD提示(Html.fromHtml("已售出物品"..SkillColor(EqLevel(sl[i].atr.key,sl[i].atr.level),sl[i]["品质"])..math.ceil(numa).."件,".."共获得灵石"..math.ceil(numb).."块!"))
              table.remove(sl,i)
              SetUI(sl)
              loadsavewrite(0)
            end)
           elseif SaveTable.sale[sl[i].id] > sl[i].atr.number then
            local numa = SaveTable.sale[sl[i].id] - sl[i].atr.number
            local numb = numa * sl[i].atr.price
            SaveTable.owner.money = math.ceil(SaveTable.owner.money + numb)
            SaveTable.sale[sl[i].id] = sl[i].atr.number
            MD提示(Html.fromHtml("已售出物品"..SkillColor(EqLevel(sl[i].atr.key,sl[i].atr.level),sl[i]["品质"])..math.ceil(numa).."件,".."共获得灵石"..math.ceil(numb).."块!"))
            SetUI(sl)
            loadsavewrite(0)
           else
            for k,v in pairs(sl[i].atr) do
              sl[i][k] = v
            end
            local e = ShowMenu(sl,i,3)
            function SaleDelete()
              local idx
              for k,v in pairs(tba) do
                if v.id == sl[i].id then
                  idx = k
                  break
                end
              end
              b:delete("chus",sl[i].id,function(code,json)
                if code ~= -1 then
                  local ltp = {key=sl[i].key,level=sl[i].level,number=sl[i].number,["附加属性"]=sl[i]["附加属性"]}
                  local ittb = Item:GetTable(sl[i].key)
                  local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中","神念消耗","材料消耗","成丹率","成功率","出丹率","评分提升","属性品质","获取经验"}
                  for k,v in pairs(tab) do
                    if tba[idx].atr[v] ~= nil then
                      ltp[v] = tba[idx].atr[v]
                    end
                  end
                  if sl[i].type <= 5 or sl[i].type < 0 then
                    table.insert(SaveTable.Item,ltp)
                   else
                    local br
                    for k,v in pairs(SaveTable.Item) do
                      if v.key == ltp.key then
                        br = true
                        v.number = v.number + ltp.number
                        break
                      end
                    end
                    if br ~= true then
                      br = false
                      table.insert(SaveTable.Item,ltp)
                    end
                  end
                  MD提示(Html.fromHtml("物品"..SkillColor(EqLevel(sl[i].key,sl[i].level),sl[i]["品质"]).."下架成功！"))
                  d.dismiss()
                  loadsavewrite(0)
                  table.remove(sl,i)
                  SetUI(sl)
                end
              end)
              e.dismiss()
            end
          end
        end
      end
    end
    SetUI(sl)
    if #data1 == 0 then
      table.insert(data1,{name="没有正在寄售中的物品!"})
    end
  end
  function PostItem(n,m)
    function TableClone(t)
      local tb = {}
      for k,v in pairs(t) do
        tb[k]=v
      end
      return tb
    end
    local num = 1
    if q ~= nil then
      q.dismiss()
    end
    q=AlertDialog.Builder(this).show()
    q.getWindow().setContentView(loadlayout(MapUI()["寄售选择"]));
    q.setCanceledOnTouchOutside(false)
    local it = SaveTable.Item
    local itm = {}
    for i=1,#it do
      for k,v in pairs(Item) do
        if it[i].key == v.key then
          table.insert(itm,{})
          for d,t in pairs(tab) do
            if v[t] then
              itm[i][t] = math.ceil(it[i][t] * v[t])
            end
          end
          itm[i].key = v.key
          itm[i]["品质"] = v["品质"]
          itm[i].type = v.type
          itm[i].Info = v.Info
          itm[i].level = it[i].level
          itm[i].number = it[i].number
          if it[i]["附加属性"] then
            itm[i]["附加属性"] = it[i]["附加属性"]
          end
          break
        end
      end
    end
    function listadp(n,m)
      local data2 = {}
      local adp2=LuaAdapter(activity,data2,its)
      for k,v in pairs(itm) do
        if (v.type >= n and v.type <= m) then
          table.insert(data2,{name=Color:Set(EqLevel(v.key,v.level).."["..品级[v["品质"]].."]".."[数量:"..math.ceil(v.number).."]",v["品质"]),id=k})
        end
      end
      寄售选择.Adapter=adp2
      if #itm > 0 then
        寄售选择.onItemClick=function(l,v,p,i)
          local index = data2[i].id
          local e = ShowMenu(itm,index,2)
          function 选择数量()
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
                hint="请输入你要上架的数量";
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
                if (tonumber(edit.Text) and tonumber(edit.Text) > 0) then
                  if tonumber(edit.Text) > itm[index].number then
                    num = itm[index].number
                   else
                    num = tonumber(edit.Text)
                  end
                end
                上架数量.Text="上架数量:"..math.ceil(num).."件"
            end})
            .setNegativeButton("取消",nil)
            .show()
            edit.setInputType(InputType.TYPE_CLASS_NUMBER)
            edit.setKeyListener(DigitsKeyListener.getInstance("0123456789"))
          end
          function SalePost()
            q.dismiss()
            r.dismiss()
            e.dismiss()
            local tbl = itm[index]
            local idx = SaveTableClone(tbl)
            local dt = {atr=table.clone(SaveTable.Item[idx])}
            local ttt = Item:GetTable(dt.atr.key).price
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
                text="请输入你要出售的单价:";
              };
              {
                EditText;
                hint="最大单价不得超过"..ttt*20;
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
                if (tonumber(edit.Text) and tonumber(edit.Text) > 0) then
                  dt.owner = SaveTable.owner.key
                  dt.atr.price=tonumber(edit.Text)
                  dt.atr.number = num
                  if tonumber(edit.Text) > ttt * 20 or tonumber(edit.Text) < 0 then
                    dt.atr.price = ttt * 20
                  end
                  b:insert("chus",dt,function(code,body)
                    if not SaveTable.sale then
                      SaveTable.sale = {}
                    end
                    SaveTable.sale[body.objectId]=num
                    dt.id = body.objectId
                    b:update("chus",dt.id,dt,function() end)
                    local br
                    local v = dt.atr
                    if num < SaveTable.Item[idx].number then
                      SaveTable.Item[idx].number = SaveTable.Item[idx].number - num
                     else
                      table.remove(SaveTable.Item,index)
                    end
                    MD提示("上架成功!")
                    d.dismiss()
                    e.dismiss()
                    q.dismiss()
                    r.dismiss()
                    br = true
                    if not br then
                      MD提示("上架失败，已经上架过该物品!")
                    end
                    loadsavewrite(0)
                  end)
                  e.dismiss()
                 else
                  MD提示("非法的输入!")
                end
            end})
            .setNegativeButton("取消",nil)
            .show()
            edit.setInputType(InputType.TYPE_CLASS_NUMBER)
            edit.setKeyListener(DigitsKeyListener.getInstance("0123456789"))
          end
        end
      end
    end
    listadp(n,m)
  end
  交易.setOnCheckedChangeListener{
    onCheckedChanged=function(g,c)
      l=g.findViewById(c)
      if l.Text == "全部" then
        tlb,tbl = MyTable({tb,tba},-5,100)
       elseif l.Text == "武器" then
        tlb,tbl = MyTable({tb,tba},0,0)
       elseif l.Text == "衣服" then
        tlb,tbl = MyTable({tb,tba},1,1)
       elseif l.Text == "帽子" then
        tlb,tbl = MyTable({tb,tba},2,2)
       elseif l.Text == "护手" then
        tlb,tbl = MyTable({tb,tba},3,3)
       elseif l.Text == "鞋子" then
        tlb,tbl = MyTable({tb,tba},4,4)
       elseif l.Text == "饰品" then
        tlb,tbl = MyTable({tb,tba},5,5)
       elseif l.Text == "丹药" then
        tlb,tbl = MyTable({tb,tba},6,6)
       elseif l.Text == "秘籍" then
        tlb,tbl = MyTable({tb,tba},7,7)
       elseif l.Text == "特殊" then
        tlb,tbl = MyTable({tb,tba},8,15)
       elseif l.Text == "副职" then
        tlb,tbl = MyTable({tb,tba},-5,-1)
      end
      if #tlb == 0 then
        table.insert(data,{name="没有正在寄售的物品"})
      end
  end}
end
function 交易所(n,m)
  if d ~= nil then
    d.dismiss()
  end
  d=PopupWindow(activity)--创建PopWindow
  d.setContentView(loadlayout(MapUI()["交易"]))--设置布局
  d.setWidth(activity.Width*0.92)--设置宽度
  d.setHeight(-2)--设置高度
  d.setFocusable(true)--设置可获得焦点
  d.getBackground().setAlpha(0)
  d.setTouchable(true)--设置可触摸
  --设置点击外部区域是否可以消失
  d.setOutsideTouchable(false)
  --显示
  d.showAtLocation(view,Gravity.CENTER,0,0)
  task(100,function 打开交易所(n,m) end)
end