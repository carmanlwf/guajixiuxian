require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"


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

function shopshow(key)
  local 品级 = {"黄阶下品","黄阶中品","黄阶上品","玄阶下品","玄阶中品","玄阶上品","地阶下品","地阶中品","地阶上品","天阶下品","天阶中品","天阶上品","仙品"}
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
  local Item = import "item"
  local bj = {
    FrameLayout;
    layout_height="fill";
    backgroundColor="#000000";
    layout_width="fill";
    {
      LinearLayout;
      layout_height="match_parent";
      layout_margin="1%w";
      backgroundColor="#FFFFFF";
      layout_width="match_parent";
      orientation="vertical";
      {
        ListView;
        id="商店";
        layout_width="match_parent";
        layout_height="60%h";
      };
      {
        FrameLayout;
        layout_width="match_parent";
        {
          TextView;
          id="战功";
          text="战功:";
          textColor="#000000";
        };
        {
          TextView;
          id="灵石";
          textColor="#000000";
          text="灵石:";
          layout_gravity="end";
        };
      };
    };
  };
  local danfan=PopupWindow(activity)--创建PopWindow
  danfan.setContentView(loadlayout(bj))--设置布局
  danfan.setWidth(activity.Width*0.9)--设置宽度
  --danfan.setHeight(activity.Width*1.08)--设置高度
  danfan.setFocusable(true)--设置可获得焦点
  danfan.setTouchable(true)--设置可触摸
  danfan.setOutsideTouchable(true)
  danfan.showAtLocation(view,Gravity.CENTER,0,0)
  local data = {}
  local tb = import "shopitem"[key]
  table.sort(tb,function(a,b)
    return Item:GetLevel(a.key) < Item:GetLevel(b.key)
  end)
  for k,v in pairs(tb) do
    if v.type == 1 then
      table.insert(data,{tz=Color:Set(table.concat({v.key,"[",品级[Item:GetLevel(v.key)],"]","[价格:",v.price,"灵石]"}),Item:GetLevel(v.key))})
     elseif v.type == 2 and SaveTable["库存"][key][v.key] ~= -1 then
      table.insert(data,{tz=Color:Set(table.concat({v.key,"[",品级[Item:GetLevel(v.key)],"]","[价格:",v.price,"战功]","[库存:",math.ceil(SaveTable["库存"][key][v.key]),"]"}),Item:GetLevel(v.key))})
     else
      table.insert(data,{tz=Color:Set(table.concat({v.key,"[",品级[Item:GetLevel(v.key)],"]","[价格:",v.price,"战功]"}),Item:GetLevel(v.key))})
    end
  end
  local adp=LuaAdapter(activity,data,item)
  商店.Adapter=adp
  灵石.Text="灵石:"..math.ceil(SaveTable.owner.money)
  战功.Text="战功:"..math.ceil(SaveTable["战功"])
  local lp
  商店.onItemClick=function(l,v,p,i)
    if SaveTable["库存"][key][tb[i].key] ~= 0 then
      local lx = {"武器","衣服","帽子","护手","鞋子","饰品","丹药","秘籍","特殊","特殊","特殊","特殊","特殊","特殊","特殊"}
      if lp ~= nil then
        lp.dismiss()
      end
      lp=PopupWindow(activity)--创建PopWindow
      lp.setContentView(loadlayout(MapUI()["购买框"]))--设置布局
      lp.setWidth(activity.Width*0.9)--设置宽度
      --danfan.setHeight(activity.Width*1.08)--设置高度
      lp.setFocusable(true)--设置可获得焦点
      lp.setTouchable(true)--设置可触摸
      lp.setOutsideTouchable(true)
      lp.showAtLocation(view,Gravity.CENTER,0,0)
      local thisbox = Item:GetTable(tb[i].key)
      shopname.Text = Color:Set(tb[i].key,thisbox["品质"])
      local file = "商品类型:"..lx[thisbox.type+1].."\n商品介绍:"..thisbox.Info.."\n\n"
      if thisbox.type < 6 then
        file=file.."物品属性:\n"
        local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中"}
        for k,v in pairs(tab) do
          if thisbox[v] then
            if v=="会心伤害" or v=="会心免伤" or v=="最终伤害放大" or v=="最终伤害抵消" or string.find(v,"基础") then
              file=file..v..":"..thisbox[v].."%\n"
             else
              file=file..v..":"..thisbox[v].."\n"
            end
          end
        end
       else
        local 资源 = import "resource"
        file=file.."使用效果\n"
        if thisbox["资源参数"] then
          for k,v in pairs(thisbox["资源参数"]) do
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
      local nb = 1
      if thisbox.type > 5 then
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
                if SaveTable["库存"][key][tb[i].key] == -1 then
                  nb = tonumber(shuru.Text)
                 elseif SaveTable["库存"][key][tb[i].key] > tonumber(shuru.Text) then
                  nb = tonumber(shuru.Text)
                 else
                  nb = SaveTable["库存"][key][tb[i].key]
                end
                if nb < 1 then
                  nb = 1
                end
                购买数量.Text="购买数量:"..math.ceil(nb).."个"
              end
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
        if tb[i].type == 1 then
          local num = tb[i].price * nb
          if SaveTable.owner.money >= num then
            Item:Add(tb[i].key,nb)
            SaveTable.owner.money = SaveTable.owner.money - num
            灵石.Text="灵石:"..math.ceil(SaveTable.owner.money)
            lp.dismiss()
            loadsavewrite(0)
            MD提示(Html.fromHtml("购买成功,获得物品"..Color:Get(thisbox.key,thisbox["品质"]).."*"..nb))
            if SaveTable["库存"][key][tb[i].key] ~= -1 then
              SaveTable["库存"][key][tb[i].key] = SaveTable["库存"][key][tb[i].key] - nb
              data[i]={tz=Color:Set(table.concat({tb[i].key,"[",品级[Item:GetLevel(tb[i].key)],"]","[价格:",tb[i].price,"灵石]","[库存:",math.ceil(SaveTable["库存"][key][tb[i].key]),"]"}),Item:GetLevel(tb[i].key))}
              adp.notifyDataSetChanged()
            end
           else
            lp.dismiss()
            MD提示("灵石不足,无法购买")
          end
         elseif tb[i].type == 2 then
          local num = tb[i].price * nb
          if SaveTable["战功"] >= num then
            Item:Add(tb[i].key,nb)
            SaveTable["战功"] = SaveTable["战功"] - num
            战功.Text="战功:"..math.ceil(SaveTable["战功"])
            lp.dismiss()
            loadsavewrite(0)
            MD提示(Html.fromHtml("购买成功,获得物品"..Color:Get(thisbox.key,thisbox["品质"]).."*"..math.ceil(nb)))
            if SaveTable["库存"][key][tb[i].key] ~= -1 then
              SaveTable["库存"][key][tb[i].key] = SaveTable["库存"][key][tb[i].key] - nb
              data[i]={tz=Color:Set(table.concat({tb[i].key,"[",品级[Item:GetLevel(tb[i].key)],"]","[价格:",tb[i].price,"战功]","[库存:",math.ceil(SaveTable["库存"][key][tb[i].key]),"]"}),Item:GetLevel(tb[i].key))}
              adp.notifyDataSetChanged()
            end
           else
            lp.dismiss()
            MD提示("战功不足,无法购买")
          end
        end
        loadsavewrite()
      end
      function 关闭购买()
        lp.dismiss()
      end
     else
      提示("物品库存不足")
    end
  end
end