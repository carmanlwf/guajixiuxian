require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "commonHelper"
local Item = import "item"
local ky = import "keyao"
--local 品级 = {"黄阶下品","黄阶中品","黄阶上品","玄阶下品","玄阶中品","玄阶上品","地阶下品","地阶中品","地阶上品","天阶下品","天阶中品","天阶上品","仙品"}
-- local Color = {hui="#C6C6C6",black="#000000",white="#FFFFFF",green="#008000",blue="#0000FF",red="#FF0000",orange="#FFA500",gold="#FFD700"}



function 应用方式(key)
  local br = false
  if SaveTable.set["嗑药"]["应用"] ~= nil then
    br = true
   elseif key == SaveTable.owner.key then
    br = true
  end
  return br
end

function 一键出售(tb)
  local price = {}
  local num = 0
  local tbn = #tb
  for i=1,tbn do
    local tab = SaveTable.Item[tb[i]-num]
    table.insert(price,Item:GetTable(tab.key).price)
    table.remove(SaveTable.Item,tb[i]-num)
    num = num + 1
  end
  local num1 = #price
  local num2 = 0
  for k,v in pairs(price) do
    num2 = num2 + v
  end
  SaveTable.owner.money = SaveTable.owner.money + num2
  loadsavewrite(0)
  提示("共计售出装备"..math.ceil(num1).."件,获得灵石"..math.ceil(num2).."块!")
end

function 一键分解(tb)
  local sl = {
    {["黄晶"]={3,10,1},["淬石"]={1,3,4}},
    {["黄晶"]={5,12,1},["淬石"]={1,5,4}},
    {["黄晶"]={8,15,1},["淬石"]={2,6,4}},
    {["玄晶"]={3,12,4},["淬石"]={3,10,4}},
    {["玄晶"]={5,15,4},["淬石"]={5,12,4}},
    {["玄晶"]={8,20,4},["淬石"]={6,15,4}},
    {["地晶"]={5,15,7},["淬石"]={10,25,4}},
    {["地晶"]={8,20,7},["淬石"]={15,32,4}},
    {["地晶"]={10,25,7},["淬石"]={20,42,4}},
    {["天晶"]={8,20,10},["淬石"]={30,72,4}},
    {["天晶"]={10,25,10},["淬石"]={40,90,4}},
    {["天晶"]={12,32,10},["淬石"]={50,108,4}},
    {["仙晶"]={8,25,13},["淬石"]={100,300,4}},
  }
  local num = 0
  local itb = {}
  local tbn = #tb
  for i=1,tbn do
    local tab = SaveTable.Item[tb[i]-num]
    local pz = Item:GetTable(tab.key)["品质"]
    for k,v in pairs(sl[pz]) do
      if itb[k] == nil then
        itb[k] = math.random(v[1],v[2])
       else
        itb[k] = itb[k] + math.random(v[1],v[2])
      end
    end
    table.remove(SaveTable.Item,tb[i]-num)
    num = num + 1
  end
  local str="分解成功,获得"
  for k,v in pairs(itb) do
    str=table.concat({str,Color:Get(k,Item:GetTable(k)["品质"]),"*",v,","})
    Item:Add(k,v)
  end
  str=str.."共分解了"..tbn.."件装备!"
  loadsavewrite(0)
  提示(Html.fromHtml(str))
end

function 批量操作()
  local p
  local idx
  local function GetMyTable(n)
    local tab = {}
    local tb = {黄阶,玄阶,地阶,天阶,仙阶}
    for i=1,#tb do
      if tb[i].checked then
        table.insert(tab,{(i-1)*3+1,i*3})
      end
    end

    local function 品质筛选(t)
      local br = false
      for i=1,#tab do
        if t["品质"] >= tab[i][1] and t["品质"] <= tab[i][2] then
          br = true
          break
        end
      end
      return br
    end

    local function 评分筛选(t)
      local br = false
      local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中","神念消耗","材料消耗","成丹率","成功率","出丹率","评分提升","属性品质","获取经验"}
      local pt = {}
      local num = 0
      for k,v in pairs(tab) do
        if t[v] ~= nil then
          num = num + t[v]
          table.insert(pt,num)
        end
      end
      local num1 = math.floor((num/(#pt*2))*100)
      if num1 > 120 then
        num1 = 120
      end
      if num1 < p then
        br = true
      end
      return br
    end

    local function 属性筛选(tap,t)
      local br = true
      for k,v in pairs(tap) do
        local tb = TriggerTable(v,t)
        if tb[idx+1] ~= nil and v[2] > tb[idx+1][1] then
          br = false
          break
        end
      end
      return br
    end

    local trigger = import "Trigger"
    local Itb = {}
    for k,v in pairs(SaveTable.Item) do
      local t = Item:GetTable(v.key)
      if t.type >= 0 and t.type <= 5 then
        if 品质筛选(t) == true and 评分筛选(v) == true and 属性筛选(v["附加属性"],t) == true then
          table.insert(Itb,k)
        end
      end
    end
    if n == 1 then
      一键出售(Itb)
     else
      一键分解(Itb)
    end
  end

  local d
  local pl = {
    LinearLayout;
    background='#ffffffff';
    layout_height="fill";
    orientation="vertical";
    layout_width="fill";
    {
      TextView;
      textColor="#000000";
      text="选择需要进行出售/分解的装备品阶:";
    };
    {
      CheckBox;
      text="黄阶";
      id="黄阶";
    };
    {
      CheckBox;
      text="玄阶";
      id="玄阶";
    };
    {
      CheckBox;
      text="地阶";
      id="地阶";
    };
    {
      CheckBox;
      text="天阶";
      id="天阶";
    };
    {
      CheckBox;
      text="仙阶";
      id="仙阶";
    };
    {
      TextView;
      textColor="#000000";
      text="选择需要进行出售/分解的装备(多少评分以下):";
    };
    {
      RadioGroup;
      id="评分";
      {
        RadioButton;
        text="80分";
      };
      {
        RadioButton;
        text="90分";
      };
      {
        RadioButton;
        text="100分";
      };
      {
        RadioButton;
        text="110分";
      };
      {
        RadioButton;
        text="120分";
      };
    };
    {
      TextView;
      textColor="#000000";
      text="选择需要进行分解/出售的装备(附带属性条品质):";
    };
    {
      RadioGroup;
      id="属性条";
      {
        RadioButton;
        text="金色及以下";
      };
      {
        RadioButton;
        text="橙色及以下";
      };
      {
        RadioButton;
        text="粉色及以下";
      };
      {
        RadioButton;
        text="紫色及以下";
      };
      {
        RadioButton;
        text="蓝色及以下";
      };
      {
        RadioButton;
        text="绿色及以下";
      };
    };
    {
      LinearLayout;
      layout_width="match_parent";
      {
        Button;
        onClick=function
          GetMyTable(1)
        end;
        text="一键出售";
      };
      {
        Button;
        onClick=function
          GetMyTable(2)
        end;
        text="一键分解";
      };
      {
        Button;
        onClick=function
          d.dismiss()
        end;
        text="取消";
      };
    };
  };
  d=PopupWindow(activity)--创建PopWindow
  d.setContentView(loadlayout(pl))--设置布局
  d.setWidth(activity.Width*0.9)--设置宽度
  d.setHeight(-2)--设置高度
  d.setFocusable(true)--设置可获得焦点
  d.getBackground().setAlpha(0)
  d.setTouchable(true)--设置可触摸
  --设置点击外部区域是否可以消失
  d.setOutsideTouchable(false)
  --显示
  d.showAtLocation(view,Gravity.CENTER,0,0)
  评分.setOnCheckedChangeListener{
    onCheckedChanged=function(g,c)
      local l=g.findViewById(c)
      p=tonumber(l.text:match("(.+)分"))
  end}

  属性条.setOnCheckedChangeListener{
    onCheckedChanged=function(g,c)
      local l=g.findViewById(c).text
      local stb = {"绿色及以下","蓝色及以下","紫色及以下","粉色及以下","橙色及以下","金色及以下"}
      for k,v in pairs(stb) do
        if l == v then
          idx = k + 1
          break
        end
      end
  end}
end

function 设置()
  if SaveTable.set["嗑药"]["百分比"] == nil then
    SaveTable.set["嗑药"]["百分比"] = 50
  end
  local list = {
    LinearLayout;
    orientation="vertical";
    backgroundColor="#FFFFFF";
    layout_width="fill";
    layout_height="fill";
    {
      ListView;
      id="药品";
      layout_width="match_parent";
      layout_height="match_parent";
    };
  };
  local item = {
    FrameLayout;
    layout_height="6%h";
    layout_width="fill";
    {
      CardView;
      layout_width="match_parent";
      layout_margin="1%w";
      layout_height="match_parent";
      radius="1.2%h";
      CardElevation="0";
      backgroundColor=721420288;
      {
        TextView;
        id="tz";
        layout_gravity="center";
      };
    };
  };
  local scf
  local ui = {
    LinearLayout;
    layout_height="fill";
    layout_width="fill";
    backgroundColor="#FFFFFF";
    orientation="vertical";
    {
      FrameLayout;
      layout_width="match_parent";
      backgroundColor="#000000";
      layout_height="4%h";
      {
        TextView;
        text="设置";
        textColor="#FFFFFF";
        layout_gravity="center";
      };
    };
    {
      TextView;
      text="自动嗑药:";
      textColor="#000000";
    };
    {
      LinearLayout;
      orientation="horizontal";
      layout_width="match_parent";
      {
        TextView;
        id="恢复";
        text="持续恢复类:";
        textColor="#000000";
      };
      {
        Button;
        onClick=function
          if scf ~= nil then
            scf.dismiss()
          end
          scf=AlertDialog.Builder(this).show()
          scf.getWindow().setContentView(loadlayout(list))
          local data={}
          --创建适配器
          local adp=LuaAdapter(activity,data,item)
          --添加数据
          local tb = {}
          for k,v in pairs(SaveTable.Item) do
            if ky["回复"][v.key] ~= nil then
              table.insert(tb,v.key)
              table.insert(data,{tz=Html.fromHtml(Color:Get(v.key.."["..品级[ky["回复"][v.key].level].."]",ky["回复"][v.key].level))})
            end
          end
          --设置适配器
          药品.Adapter=adp
          if #data == 0 then
            table.insert(data,{tz="无物品"})
           else
            table.insert(data,{tz="清除"})
            药品.onItemClick=function(l,v,p,i)
              if i < #data then
                SaveTable.set["嗑药"]["回复"] = tb[i]
                恢复.Text = Html.fromHtml("持续恢复类:"..Color:Get(SaveTable.set["嗑药"]["回复"],ky["回复"][SaveTable.set["嗑药"]["回复"]].level))
                提示("设置成功")
               else
                SaveTable.set["嗑药"]["回复"] = nil
                恢复.Text = "持续恢复类:无"
                提示("清除成功")
              end
              scf.dismiss()
            end
          end
        end;
        text="选择";
      };
    };
    {
      LinearLayout;
      orientation="horizontal";
      layout_width="match_parent";
      {
        TextView;
        id="增伤";
        text="战斗增伤类:";
        textColor="#000000";
      };
      {
        Button;
        onClick=function
          if scf ~= nil then
            scf.dismiss()
          end
          scf=AlertDialog.Builder(this).show()
          scf.getWindow().setContentView(loadlayout(list))
          local data={}
          --创建适配器
          local adp=LuaAdapter(activity,data,item)
          --添加数据
          local tb = {}
          for k,v in pairs(SaveTable.Item) do
            if ky["增伤"][v.key] ~= nil then
              table.insert(tb,v.key)
              table.insert(data,{tz=Html.fromHtml(Color:Get(v.key.."["..品级[ky["增伤"][v.key].level].."]",ky["增伤"][v.key].level))})
            end
          end
          --设置适配器
          药品.Adapter=adp
          if #data == 0 then
            table.insert(data,{tz="无物品"})
           else
            table.insert(data,{tz="清除"})
            药品.onItemClick=function(l,v,p,i)
              if i < #data then
                SaveTable.set["嗑药"]["增伤"] = tb[i]
                增伤.Text = Html.fromHtml("战斗增伤类:"..Color:Get(SaveTable.set["嗑药"]["增伤"],ky["增伤"][SaveTable.set["嗑药"]["增伤"]].level))
                提示("设置成功")
               else
                SaveTable.set["嗑药"]["增伤"] = nil
                增伤.Text = "战斗增伤类:无"
                提示("清除成功")
              end
              scf.dismiss()
            end
          end
        end;
        text="选择";
      };
    };
    {
      LinearLayout;
      orientation="horizontal";
      layout_width="match_parent";
      {
        TextView;
        id="减伤";
        text="战斗减伤类:";
        textColor="#000000";
      };
      {
        Button;
        onClick=function
          if scf ~= nil then
            scf.dismiss()
          end
          scf=AlertDialog.Builder(this).show()
          scf.getWindow().setContentView(loadlayout(list))
          local data={}
          --创建适配器
          local adp=LuaAdapter(activity,data,item)
          --添加数据
          local tb = {}
          for k,v in pairs(SaveTable.Item) do
            if ky["减伤"][v.key] ~= nil then
              table.insert(tb,v.key)
              table.insert(data,{tz=Html.fromHtml(Color:Get(v.key.."["..品级[ky["减伤"][v.key].level].."]",ky["减伤"][v.key].level))})
            end
          end
          --设置适配器
          药品.Adapter=adp
          if #data == 0 then
            table.insert(data,{tz="无物品"})
           else
            table.insert(data,{tz="清除"})
            药品.onItemClick=function(l,v,p,i)
              if i < #data then
                SaveTable.set["嗑药"]["减伤"] = tb[i]
                减伤.Text = Html.fromHtml("战斗减伤类:"..Color:Get(SaveTable.set["嗑药"]["减伤"],ky["减伤"][SaveTable.set["嗑药"]["减伤"]].level))
                提示("设置成功")
               else
                SaveTable.set["嗑药"]["减伤"] = nil
                减伤.Text = "战斗减伤类:无"
                提示("清除成功")
              end
              scf.dismiss()
            end
          end
        end;
        text="选择";
      };
    };
    {
      LinearLayout;
      orientation="horizontal";
      layout_width="match_parent";
      {
        TextView;
        id="回复";
        text="战斗恢复类:";
        textColor="#000000";
      };
      {
        Button;
        onClick=function
          if scf ~= nil then
            scf.dismiss()
          end
          scf=AlertDialog.Builder(this).show()
          scf.getWindow().setContentView(loadlayout(list))
          local data={}
          --创建适配器
          local adp=LuaAdapter(activity,data,item)
          --添加数据
          local tb = {}
          for k,v in pairs(SaveTable.Item) do
            if ky["恢复"][v.key] ~= nil then
              table.insert(tb,v.key)
              table.insert(data,{tz=Html.fromHtml(Color:Get(v.key.."["..品级[ky["恢复"][v.key].level].."]",ky["恢复"][v.key].level))})
            end
          end
          --设置适配器
          药品.Adapter=adp
          if #data == 0 then
            table.insert(data,{tz="无物品"})
           else
            table.insert(data,{tz="清除"})
            药品.onItemClick=function(l,v,p,i)
              if i < #data then
                SaveTable.set["嗑药"]["恢复"] = tb[i]
                回复.Text = Html.fromHtml("战斗恢复类:"..Color:Get(SaveTable.set["嗑药"]["恢复"],ky["恢复"][SaveTable.set["嗑药"]["恢复"]].level))
                提示("设置成功")
               else
                SaveTable.set["嗑药"]["恢复"] = nil
                回复.Text = "战斗恢复类:无"
                提示("清除成功")
              end
              scf.dismiss()
            end
          end
        end;
        text="选择";
      };
    };
    {
      TextView;
      id="百分比";
      text="气血或法力低于50%自动使用";
      textColor="#000000";
    };
    {
      Button;
      onClick=function
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
            hint="请输入";
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
              SaveTable.set["嗑药"]["百分比"] = tonumber(edit.Text)
              if SaveTable.set["嗑药"]["百分比"] > 100 then
                SaveTable.set["嗑药"]["百分比"] = 100
              end
              百分比.Text="气血或法力低于"..SaveTable.set["嗑药"]["百分比"].."%自动使用"
            end
        end})
        .setNegativeButton("取消",nil)
        .show()
        edit.setInputType(InputType.TYPE_CLASS_NUMBER)
        edit.setKeyListener(DigitsKeyListener.getInstance("0123456789"))
      end;
      text="设置百分比";
    };
    {
      Button;
      id="yinyong";
      text="应用";
    };
    {
      Button;
      onClick=function 批量操作()
      end;
      text="批量出售/分解";
    };
    {
      Button;
      onClick=function huode()
      end;
      text="金手指";
    };
  };
  local danfan=PopupWindow(activity)--创建PopWindow
  danfan.setContentView(loadlayout(ui))--设置布局
  danfan.setWidth(activity.Width*0.96)--设置宽度
  danfan.setHeight(-2)--设置高度
  danfan.setFocusable(true)--设置可获得焦点
  danfan.setTouchable(true)--设置可触摸
  danfan.setOutsideTouchable(true)
  danfan.showAtLocation(view,Gravity.CENTER,0,0)
  if SaveTable.set["嗑药"]["回复"] ~= nil then
    local tlb = ky["回复"][SaveTable.set["嗑药"]["回复"]]
    恢复.Text = Html.fromHtml("持续恢复类:"..Color:Get(SaveTable.set["嗑药"]["回复"],tlb.level))
   else
    恢复.Text = "持续恢复类:无"
  end
  if SaveTable.set["嗑药"]["增伤"] ~= nil then
    local tlb = ky["增伤"][SaveTable.set["嗑药"]["增伤"]]
    增伤.Text = Html.fromHtml("战斗增伤类:"..Color:Get(SaveTable.set["嗑药"]["增伤"],tlb.level))
   else
    增伤.Text = "战斗增伤类:无"
  end
  if SaveTable.set["嗑药"]["减伤"] ~= nil then
    local tlb = ky["减伤"][SaveTable.set["嗑药"]["减伤"]]
    减伤.Text = Html.fromHtml("战斗减伤类:"..Color:Get(SaveTable.set["嗑药"]["减伤"],tlb.level))
   else
    减伤.Text = "战斗减伤类:无"
  end
  if SaveTable.set["嗑药"]["恢复"] ~= nil then
    local tlb = ky["恢复"][SaveTable.set["嗑药"]["恢复"]]
    回复.Text = Html.fromHtml("战斗恢复类:"..Color:Get(SaveTable.set["嗑药"]["恢复"],tlb.level))
   else
    回复.Text = "战斗恢复类:无"
  end
  百分比.Text="气血或法力低于"..SaveTable.set["嗑药"]["百分比"].."%自动使用"
  if SaveTable.set["嗑药"]["应用"] == nil then
    yinyong.Text="只应用于自身"
   else
    yinyong.Text="应用于所有出战目标"
  end
  yinyong.onClick=function
    if SaveTable.set["嗑药"]["应用"] ~= nil then
      SaveTable.set["嗑药"]["应用"] = nil
      yinyong.Text="只应用于自身"
      提示("自动嗑药只对自身生效")
     else
      SaveTable.set["嗑药"]["应用"] = 1
      yinyong.Text="应用于所有出战目标"
      提示("自动嗑药已对所有出战目标生效")
    end
  end
end