local 品级 = {"黄阶下品","黄阶中品","黄阶上品","玄阶下品","玄阶中品","玄阶上品","地阶下品","地阶中品","地阶上品","天阶下品","天阶中品","天阶上品","仙品"}
local Color = {hui="#C6C6C6",black="#000000",white="#FFFFFF",green="#008000",blue="#0000FF",red="#FF0000",orange="#FFA500",gold="#FFD700"}
local Item = import "item"

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

local lblb
function 礼包()
  local function hassdk(n)
    local br = false
    if SaveTable.SDK == nil then
      SaveTable.SDK = {}
    end
    for k,v in pairs(SaveTable.SDK) do
      if n == v then
        br = true
        break
      end
    end
    return br
  end
  local lbb = {
    LinearLayout;
    background='#ffffffff',
    layout_height="fill";
    orientation="vertical";
    layout_width="fill";
    {
      FrameLayout;
      layout_height="5%h";
      layout_width="match_parent";
      {
        TextView;
        text="礼包";
        layout_gravity="center";
        textColor="#000000";
      };
    };
    {
      ListView;
      id="lba";
      layout_height="match_parent";
      layout_width="match_parent";
    };
  };
  if lblb ~= nil then
    lblb.dismiss()
  end
  lblb=PopupWindow(activity)--创建PopWindow
  lblb.setContentView(loadlayout(lbb))--设置布局
  lblb.setWidth(activity.Width*0.96)--设置宽度
  lblb.getBackground().setAlpha(0)
  lblb.setHeight(-2)--设置高度
  lblb.setFocusable(true)--设置可获得焦点
  lblb.setTouchable(true)--设置可触摸
  lblb.setOutsideTouchable(true)
  lblb.showAtLocation(view,Gravity.CENTER,0,0)
  local data={}
  local its = {
    LinearLayout;
    background='#ffffffff',
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
  hs("http://82.157.62.200/zm/clb.php?key="..SaveTable.savetime,function(code,body)
    local tb = cjson.decode(unicode2utf8(body))
    local num = #tb
    local num1 = 0
    for i=1,num do
      if hassdk(tb[i-num1].id) then
        table.remove(tb,i-num1)
        num1 = num1 + 1
      end
    end
    for k,v in pairs(tb) do
      table.insert(data,{name=v.name})
    end
    if #data == 0 then
      table.insert(data,{name="无礼包"})
    end
    lba.Adapter=adp
    local lbj
    lba.onItemClick=function(l,v,p,i)
      if lbj ~= nil then
        lbj.dismiss()
      end
      local str="附件:<br>"
      local it = cjson.decode(tb[i].item)
      for k,v in pairs(it) do
        str=table.concat({str,Color:Get(v.key,Item:GetTable(v.key)["品质"]),"*",math.ceil(tonumber(v.number)),"<br>"})
      end
      local llb = {
        LinearLayout;
        background='#ffffffff',
        layout_height="fill";
        gravity="center";
        layout_width="fill";
        orientation="vertical";
        {
          TextView;
          text="内容:"..tb[i].info;
          textColor="#000000";
        };
        {
          TextView;
          text=Html.fromHtml(str);
        };
        {
          LinearLayout;
          {
            Button;
            onClick=function
              lbj.dismiss()
              if hassdk(tb[i].id) then
                提示("这个礼包已经领取过了")
               else
                table.insert(SaveTable.SDK,tb[i].id)
                table.remove(data,i)
                table.remove(tb,i)
                for k,v in pairs(it) do
                  if v.key == "灵石" then
                    SaveTable.owner.money = SaveTable.owner.money + tonumber(v.number)
                   else
                    Item:Add(v.key,tonumber(v.number))
                  end
                end
                adp.notifyDataSetChanged()
                loadsavewrite(0)
                提示("领取成功")
              end
            end;
            text="领取礼包";
          };
          {
            Button;
            onClick=function
              lbj.dismiss()
            end;
            text="关闭界面";
          };
        };
      };
      lbj=PopupWindow(activity)--创建PopWindow
      lbj.setContentView(loadlayout(llb))--设置布局
      lbj.setWidth(activity.Width*0.96)--设置宽度
      lbj.setHeight(-2)--设置高度
      lbj.setFocusable(true)--设置可获得焦点
      lbj.setTouchable(true)--设置可触摸
      lbj.setOutsideTouchable(true)
      lbj.showAtLocation(view,Gravity.CENTER,0,0)
    end
  end)
end