require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "bmob"
import "GetItem"
local id="7ae633a369a78cf8355607124387a410" --Application ID
local key="4a2f4b51681f7ca185b828f949b49bba" --REST API Key
local b=bmob(id,key)
local 品级 = {"黄阶下品","黄阶中品","黄阶上品","玄阶下品","玄阶中品","玄阶上品","地阶下品","地阶中品","地阶上品","天阶下品","天阶中品","天阶上品","仙品"}
local Color = {hui="#C6C6C6",black="#000000",white="#FFFFFF",green="#008000",blue="#0000FF",red="#FF0000",orange="#FFA500",gold="#FFD700"}
local Item = import "item"
local fwq = {["测试服"]={["排行榜"]="savetable",["邮件"]="Email"},["正式服"]={["排行榜"]="zsb",["邮件"]="youjian"}}
local 资源 = import "resource"
local chuans

function 收回物品()
  if SaveTable.yj ~= nil then
    for k,v in pairs(SaveTable.yj) do
      if v.level ~= nil then
        table.insert(SaveTable.Item,v)
       else
        Item:Add(v.key,v.number)
      end
      SaveTable.yj = nil
    end
  end
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
function 飞剑传书()
  function 发送()
    local tbs={}
    local scf
    function 上传附件()
      local function GetEquipmentShow(ltb)
        local x = 1
        local tb
        local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中","神念消耗","材料消耗","成丹率","成功率","出丹率","评分提升","属性品质","获取经验"}
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

      function EquipmentId(key)
        local t
        for k,v in pairs(SaveTable.owner.eq) do
          if v.key == key then
            t = k
            break
          end
        end
        return t
      end
      --生成物品的table表
      local function EquipmentShow(eq1)
        local tb = {}
        for k,v in pairs(eq1) do
          tb[#tb+1] = GetEquipmentShow(v)
        end
        return tb
      end
      if scf ~= nil then
        scf.dismiss()
      end
      scf=PopupWindow(activity)--创建PopWindow
      scf.setContentView(loadlayout(MapUI()["附件列表"]))--设置布局
      scf.setWidth(-2)--设置宽度
      scf.setHeight(-2)--设置高度
      scf.setFocusable(true)--设置可获得焦点
      scf.getBackground().setAlpha(0)
      scf.setTouchable(true)--设置可触摸
      --设置点击外部区域是否可以消失
      scf.setOutsideTouchable(false)
      --显示
      scf.showAtLocation(view,Gravity.CENTER,0,0)
      local data2={}
      local its1 = {
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
              id="name1";
            };
          };
        };
      };
      local adp2=LuaAdapter(activity,data2,its1)
      function MyTable(t,n,m)
        local no1 = #data2
        for i=1,no1 do
          table.remove(data2)
        end
        local tab = {}
        for i=1,#t do
          if (t[i].number > 0 and t[i].type >= n and t[i].type <= m) then
            local v = t[i]
            table.insert(tab,v)
            if v.type < 5 then
              table.insert(data2,{name1=Color:Set(EqLevel(v.key,v.level).."["..品级[v["品质"]].."]".."[数量:"..math.ceil(v.number).."][评分:"..upeqdata(v),v["品质"])})
             else
              table.insert(data2,{name1=Color:Set(EqLevel(v.key,v.level).."["..品级[v["品质"]].."]".."[数量:"..math.ceil(v.number).."]",v["品质"])})
            end
          end
        end
        adp2.notifyDataSetChanged()
        return tab
      end
      local tb = EquipmentShow(SaveTable.Item)
      local tlb = MyTable(tb,-5,100)
      附件.Adapter=adp2
      附件筛子.setOnCheckedChangeListener{
        onCheckedChanged=function(g,c)
          l=g.findViewById(c)
          if l.Text == "全部" then
            tlb = MyTable(tb,-5,100)
           elseif l.Text == "法器" then
            tlb = MyTable(tb,0,5)
           elseif l.Text == "丹药" then
            tlb = MyTable(tb,6,6)
           elseif l.Text == "秘籍" then
            tlb = MyTable(tb,7,7)
           elseif l.Text == "特殊" then
            tlb = MyTable(tb,8,8)
           elseif l.Text == "宠兽" then
            tlb = MyTable(tb,9,9)
           elseif l.Text == "材[丹]" then
            tlb = MyTable(tb,10,10)
           elseif l.Text == "材[器]" then
            tlb = MyTable(tb,11,11)
           elseif l.Text == "材[杂]" then
            tlb = MyTable(tb,14,100)
           elseif l.Text == "副职" then
            tlb = MyTable(tb,-5,-1)
          end
          if #tlb == 0 then
            table.insert(data2,{name1="无"})
          end
      end}
      local wp
      附件.onItemClick=function(l,v,p,i)
        function sendup(t)
          local idx = SaveTableClone(t)
          local tbl = SaveTable.Item
          if tbl[idx].number == 1 then
            table.insert(tbs,tbl[idx])
            table.remove(data2,i)
            table.remove(tbl,idx)
            table.remove(tb,idx)
            if SaveTable.yj == nil then
              SaveTable.yj = {}
            end
            table.insert(SaveTable.yj,tbs[#tbs])
            MD提示("物品上传成功")
            uiss()
           else
            local num = 1
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
                hint="请输入你要上传的数量";
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
                  SaveTable.Item[idx].number = tbl[idx].number - num
                  tb[idx].number = tb[idx].number - num
                  tlb[i].number = tlb[i].number - num
                  if tb[idx].type < 5 then
                    data2[i] = {name1=Color:Set(EqLevel(tb[idx].key,tb[idx].level).."["..品级[tb[idx]["品质"]].."]".."[数量:"..math.ceil(tb[idx].number).."][评分:"..upeqdata(tb[idx]),tb[idx]["品质"])}
                   else
                    data2[i] = {name1=Color:Set(EqLevel(tb[idx].key,tb[idx].level).."["..品级[tb[idx]["品质"]].."]".."[数量:"..math.ceil(tb[idx].number).."]",tb[idx]["品质"])}
                  end
                  table.insert(tbs,table.clone(tbl[idx]))
                  tbs[#tbs].number = num
                  if SaveTable.yj == nil then
                    SaveTable.yj = {}
                  end
                  table.insert(SaveTable.yj,tbs[#tbs])
                  if SaveTable.Item[idx].number == 0 then
                    table.remove(data2,i)
                    table.remove(SaveTable.Item,idx)
                    table.remove(tb,idx)
                  end
                  uiss()
                  MD提示("上传成功")
                end
            end})
            .setNegativeButton("取消",nil)
            .show()
            edit.setInputType(InputType.TYPE_CLASS_NUMBER)
            edit.setKeyListener(DigitsKeyListener.getInstance("0123456789"))
          end
          wp.dismiss()
          scf.dismiss()
          adp2.notifyDataSetChanged()
        end
        if #tlb > 0 then
          local e
          local t = tlb[i]
          local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中","神念消耗","材料消耗","成丹率","成功率","出丹率","评分提升","属性品质","获取经验"}
          import"android.graphics.drawable.ColorDrawable"
          if wp ~= nil then
            wp.dismiss()
          end
          wp=PopupWindow(activity)--创建PopWindow
          wp.setContentView(loadlayout(MapUI()["物品面板"]))--设置布局
          wp.setWidth(-2)--设置宽度
          wp.setHeight(-2)--设置高度
          wp.setFocusable(true)--设置可获得焦点
          wp.getBackground().setAlpha(0)
          wp.setTouchable(true)--设置可触摸
          --设置点击外部区域是否可以消失
          wp.setOutsideTouchable(false)
          --显示
          wp.showAtLocation(view,Gravity.CENTER,0,0)
          物品名称.Text = Color:Set(EqLevel(t.key,t.level).."["..品级[t["品质"]].."]",t["品质"])
          物品介绍.Text = 物品介绍.Text..":\n"..t.Info.."\n"
          物品框.removeViews(3,1)
          物品框.addView(loadlayout{
            LinearLayout;
            layout_height="6%h";
            layout_width="match_parent";
            orientation="horizontal";
            {
              Button;
              onClick=function sendup(t) end;
              text="上传";
              layout_marginTop="0";
              layout_width="12%w";
              textSize=getsize(10);
              layout_height="5%h";
            };
            {
              Button;
              onClick=function() wp.dismiss() end;
              text="取消";
              layout_marginTop="0";
              layout_width="12%w";
              textSize=getsize(10);
              layout_height="5%h";
            };
          })
          if t["资源参数"] then
            local f = ""
            for k,v in pairs(t["资源参数"]) do
              if leixin(v) == "table" then
                f=f..资源["资源参数"][k][1]..v[#v]..资源["资源参数"][k][2]
               else
                f=f..资源["资源参数"][k][1]..v..资源["资源参数"][k][2]
              end
            end
            物品框.addView(loadlayout
            {
              TextView;
              text="使用效果:\n"..f;
            },3)
           else
            local f = ""
            for k,v in pairs(tab) do
              if t[v] then
                if v == "会心伤害" or v == "会心免伤" or v == "最终伤害放大" or v == "最终伤害抵消" or string.find(v,"基础") then
                  f=f..v..":"..math.ceil(t[v]*(1.1^t.level)).."%\n"
                 elseif v=="气血上限" then
                  f=f.."气血上限:"..math.ceil(t[v]*(1.1^t.level)).."\n"
                 elseif v=="法力上限" then
                  f=f.."法力上限:"..math.ceil(t[v]*(1.1^t.level)).."\n"
                 else
                  f=f..v..":"..math.ceil(t[v]*(1.1^t.level)).."\n"
                end
              end
            end
            if #f > 3 then
              物品框.addView(loadlayout
              {
                TextView;
                text="物品属性:\n"..f;
              },3)
              物品框.addView(loadlayout
              {
                TextView;
                text="评分:"..upeqdata(t).."\n";
              },3)
            end
            if t["附加属性"] and t.type >= 0 then
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
                物品框.addView(loadlayout{
                  TextView;
                  text=Html.fromHtml("附加属性("..#t["附加属性"].."/"..num.."):");
                },5)
                local num1 = 6
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
                  物品框.addView(loadlayout{
                    TextView;
                    text=Html.fromHtml(GetColor(tx,co));
                  },num1)
                  num1 = num1 + 1
                end
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
              物品框.addView(loadlayout{
                TextView;
                text=Html.fromHtml("附加属性:"..Color:Get(str,t["品质"]));
              },5)
            end
          end
        end
      end
    end
    function SendEmail()
      fs.dismiss()
      chuans.dismiss()
      local mima = math.random(100000000,999999999)
      if fstext.Text == "" then
        if #tbs > 0 then
          fstext.Text="我给你准备了"
          for k,v in pairs(tbs) do
            fstext.Text=fstext.Text..Color:Get(v.key,Item:GetLevel(v.key)).."*"..math.ceil(v.number)..","
          end
          fstext.Text=fstext.Text.."希望你能喜欢"
        end
      end
      if #fstext.Text >= 3 then
        local cs = fstext.Text
        local csid = fsid.Text
        local jzk = 加载框()
        if csid ~= 解密("role/zh") then
          local cjson = import "cjson"
          local tpa = {id=csid,name=SaveTable.owner.key,info=fstext.Text,item=cjson.encode(tbs)}
          if 付费.Text ~= nil and 付费.Text ~= "" then
            tpa.price = 付费.Text
          end
          tpa.user = 解密("role/zh")
          tpa.type = "0"
          tpa.key = tmkey()
          fp("http://82.157.62.200/zm/emf.php?",tpa,function(code,body)
            jzk.dismiss()
            if body == "400" then
              MD提示("发送成功")
              SaveTable.yj = nil
              loadsavewrite(0)
             elseif body == "403" then
              收回物品()
              MD提示("无法给宗门外成员发送传书")
             else
              收回物品()
              MD提示("网络连接失败")
            end
          end)
         else
          jzk.dismiss()
          MD提示("不能给自己发送传书")
        end
       else
        MD提示("请编辑传书内容或添加附件")
      end
    end
    function 关闭传书()
      fs.dismiss()
      收回物品()
    end
    if fs ~= nil then
      fs.dismiss()
    end
    收回物品()
    fs=PopupWindow(activity)--创建PopWindow
    fs.setContentView(loadlayout(MapUI()["发送传书"]))--设置布局
    fs.setWidth(-2)--设置宽度
    fs.setHeight(-2)--设置高度
    fs.setFocusable(true)--设置可获得焦点
    fs.setTouchable(true)--设置可触摸
    --设置点击外部区域是否可以消失
    fs.setOutsideTouchable(false)
    --显示
    fs.showAtLocation(view,Gravity.CENTER,0,0)
    付费.setInputType(InputType.TYPE_CLASS_NUMBER)
    付费.setKeyListener(DigitsKeyListener.getInstance("0123456789"))
    local data3={}
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
            id="name2";
          };
        };
      };
    }
    local adp3=LuaAdapter(activity,data3,its2)
    fj.Adapter=adp3
    function uiss()
      local num = #data3
      for i=1,num do
        table.remove(data3)
      end
      for k,v in pairs(tbs) do
        table.insert(data3,{name2=Color:Set(EqLevel(v.key,v.level).."["..品级[Item:GetLevel(v.key)].."]".."[数量:"..math.ceil(v.number).."]",Item:GetLevel(v.key))})
      end
      fj.Adapter.notifyDataSetChanged()
    end
    uiss()
  end
  if chuans ~= nil then
    chuans.dismiss()
  end
  收回物品()
  chuans=PopupWindow(activity)--创建PopWindow
  chuans.setContentView(loadlayout(MapUI()["飞剑传书"]))--设置布局
  chuans.setWidth(activity.Width*0.92)--设置宽度
  chuans.setHeight(-2)--设置高度
  chuans.setFocusable(true)--设置可获得焦点
  chuans.getBackground().setAlpha(0)
  chuans.setTouchable(true)--设置可触摸
  --设置点击外部区域是否可以消失
  chuans.setOutsideTouchable(false)
  --显示
  chuans.showAtLocation(view,Gravity.CENTER,0,0)
  hs("http://82.157.62.200/zm/emc.php?id="..解密("role/zh").."&type=1",function(code,body)
    local tb = cjson.decode(unicode2utf8(body))
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
    local adp=LuaAdapter(activity,data,its)
    for k,v in pairs(tb) do
      table.insert(data,{name=table.concat({"发件人:",v.name,"(点击阅读)"})})
    end
    if #data == 0 then
      table.insert(data,{name="无传书"})
    end
    传书.Adapter=adp
    local nr
    传书.onItemClick=function(l,v,p,i)
      local sc
      function 删除附件()
        function decs()
          chuans.dismiss()
          nr.dismiss()
          hs("http://82.157.62.200/zm/ems.php?id="..解密("role/zh").."&uid="..tb[i].uid.."&name="..SaveTable.owner.key.."&key="..tmkey(),function(code,body)
            if body == "400" then
              提示("传书删除成功")
             elseif body == "403" then
              提示("该传书不存在")
             else
              提示("网络连接失败，请保持网络通畅")
            end
          end)
        end
        if #cjson.decode(tb[i].item) > 0 then
          if sc ~= nil then
            sc.dismiss()
          end
          sc = AlertDialog.Builder(this)
          .setTitle("删除传书")
          .setMessage("该传书还有待提取的附件，确定要删除吗?")
          .setPositiveButton("确定",{onClick=function(v)
              decs()
          end})
          .setNegativeButton("取消",nil)
          .show()
         else
          decs()
        end
      end
      local qd
      function 提取附件()
        local function 开始提取(price,tb,uid)
          local item = ""
          if price ~= nil then
            item = cjson.encode({{key="灵石",number=tonumber(price)}})
          end
          local jjk = 加载框()
          hs("http://82.157.62.200/zm/emt.php?id="..解密("role/zh").."&uid="..uid.."&item="..item.."&key="..tmkey().."&name="..SaveTable.owner.key,function(code,body)
            if body == "400" then
              if price ~= nil then
                SaveTable.owner.money = SaveTable.owner.money - tonumber(price)
              end
              for k,v in pairs(tb) do
                if v.level ~= nil then
                  table.insert(SaveTable.Item,v)
                 elseif v.key == "灵石" then
                  SaveTable.owner.money = SaveTable.owner.money + v.number
                 else
                  Item:Add(v.key,v.number)
                end
              end
              SaveTable.wl = nil
              loadsavewrite(0)
              MD提示("成功提取附件")
             else
              SaveTable.wl = nil
              MD提示("网络连接失败，请保持网络通畅")
            end
            jjk.dismiss()
          end)
        end
        if #cjson.decode(tb[i].item) > 0 then
          chuans.dismiss()
          nr.dismiss()
          if tb[i].price ~= "" then
            if qd ~= nil then
              qd.dismiss()
            end
            qd = AlertDialog.Builder(this)
            .setTitle("确认")
            .setMessage("该附件需要付费"..tb[i].price.."灵石才能提取，确定要提取附件吗？")
            .setPositiveButton("取消",{onClick=function(v)
                SaveTable.wl=nil
            end})
            .setNegativeButton("确认",function
              if SaveTable.owner.money >= tonumber(tb[i].price) then
                开始提取(tonumber(tb[i].price),cjson.decode(tb[i].item),tb[i].uid)
               else
                提示("你的灵石不够!")
              end
            end)
            .show()
            qd.setCanceledOnTouchOutside(false)
            qd.setCancelable(false)
           else
            开始提取(nil,cjson.decode(tb[i].item),tb[i].uid)
          end
        end
      end
      if tb ~= nil and #tb[1] ~= 1 then
        if nr ~= nil then
          nr.dismiss()
        end
        nr=AlertDialog.Builder(this).show()
        nr.getWindow().setContentView(loadlayout(MapUI()["传书内容"]));
        传书内容.Text=Html.fromHtml(tb[i].info)
        local data4={}
        local its4 = {
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
                id="name4";
              };
            };
          };
        };
        local adp4=LuaAdapter(activity,data4,its4)
        for k,v in pairs(cjson.decode(tb[i].item)) do
          table.insert(data4,{name4=Color:Set(EqLevel(v.key,v.level).."["..品级[Item:GetLevel(v.key)].."]".."[数量:"..math.ceil(v.number).."]",Item:GetLevel(v.key))})
        end
        传书附件.Adapter=adp4
        local wp
        local tlbt = cjson.decode(tb[i].item)
        传书附件.onItemClick=function(l,v,p,i)
          local t = ShowMenu(tlbt[i])
        end
      end
    end
  end)
end