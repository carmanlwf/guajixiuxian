require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

local bi
function openbody(tab)
  local function yanse(str,ys)
    str="<font color="..ys..">"..str.."</font>"
    return Html.fromHtml(str)
  end
  local function yansep(str,ys)
    str="<font color="..ys..">"..str.."</font>"
    return str
  end
  local ku = {
    {"外攻",{120,150,180,210,240,270,300}},
    {"内攻",{120,150,180,210,240,270,300}},
    {"外防",{100,125,150,175,200,225,250}},
    {"内防",{100,125,150,175,200,225,250}},
    {"命中",{80,100,120,140,160,180,200}},
    {"闪避",{80,100,120,140,160,180,200}},
    {"会心率",{80,100,120,140,160,180,200}},
    {"抗会心率",{80,100,120,140,160,180,200}},
    {"气血上限",{1200,1500,1800,2100,2400,2700,3000}},
    {"法力上限",{600,750,900,1050,1200,1350,1500}},
    {"会心伤害",{10,12.5,15,17.5,20,22.5,25}},
    {"会心免伤",{10,12.5,15,17.5,20,22.5,25}},
    {"最终伤害放大",{8,10,12,14,16,18,20}},
    {"最终伤害抵消",{8,10,12,14,16,18,20}},
  }
  local tb = tab.body
  local bd = {
    LinearLayout;
    backgroundColor="#ffffff";
    layout_width="match_parent";
    layout_height="match_parent";
    orientation="vertical";
    {
      LinearLayout;
      backgroundColor="#000000";
      layout_height="4%h";
      layout_width="match_parent";
      {
        TextView;
        text="妖 躯 面 板";
        textColor="#FFFFFF";
        textSize=getsize(18);
        layout_marginLeft="4%w";
      };
    };
    {
      LinearLayout;
      id="锁";
      layout_width="match_parent";
      layout_height="match_parent";
      layout_margin="3%h";
      orientation="vertical";
      {
        LinearLayout;
        layout_height="6%h";
        layout_width="match_parent";
        orientation="horizontal";
        {
          ImageButton;
          layout_marginLeft="1%h";
          background="res/ic_lock_outline_black_24dp.png";
        };
        {
          TextView;
          textSize=getsize(10);
          layout_width="30%w";
          layout_marginTop="0";
          text="未开启";
        };
      };
      {
        LinearLayout;
        layout_height="6%h";
        layout_width="match_parent";
        orientation="horizontal";
        {
          ImageButton;
          layout_marginLeft="1%h";
          background="res/ic_lock_outline_black_24dp.png";
        };
        {
          TextView;
          textSize=getsize(10);
          layout_width="30%w";
          layout_marginTop="0";
          text="未开启";
        };
      };
      {
        LinearLayout;
        layout_height="6%h";
        layout_width="match_parent";
        orientation="horizontal";
        {
          ImageButton;
          layout_marginLeft="1%h";
          background="res/ic_lock_outline_black_24dp.png";
        };
        {
          TextView;
          textSize=getsize(10);
          layout_width="30%w";
          layout_marginTop="0";
          text="未开启";
        };
      };
      {
        LinearLayout;
        layout_height="6%h";
        layout_width="match_parent";
        orientation="horizontal";
        {
          ImageButton;
          layout_marginLeft="1%h";
          background="res/ic_lock_outline_black_24dp.png";
        };
        {
          TextView;
          textSize=getsize(10);
          layout_width="30%w";
          layout_marginTop="0";
          text="未开启";
        };
      };
      {
        LinearLayout;
        layout_height="6%h";
        layout_width="match_parent";
        orientation="horizontal";
        {
          ImageButton;
          layout_marginLeft="1%h";
          background="res/ic_lock_outline_black_24dp.png";
        };
        {
          TextView;
          textSize=getsize(10);
          layout_width="30%w";
          layout_marginTop="0";
          text="未开启";
        };
      };
      {
        LinearLayout;
        layout_height="6%h";
        layout_width="match_parent";
        orientation="horizontal";
        {
          ImageButton;
          layout_marginLeft="1%h";
          background="res/ic_lock_outline_black_24dp.png";
        };
        {
          TextView;
          textSize=getsize(10);
          layout_width="30%w";
          layout_marginTop="0";
          text="未开启";
        };
      };
      {
        LinearLayout;
        layout_height="6%h";
        layout_width="match_parent";
        orientation="horizontal";
        {
          ImageButton;
          layout_marginLeft="1%h";
          background="res/ic_lock_outline_black_24dp.png";
        };
        {
          TextView;
          textSize=getsize(10);
          layout_width="30%w";
          layout_marginTop="0";
          text="未开启";
        };
      };
      {
        LinearLayout;
        layout_height="6%h";
        layout_width="match_parent";
        orientation="horizontal";
        {
          ImageButton;
          layout_marginLeft="1%h";
          background="res/ic_lock_outline_black_24dp.png";
        };
        {
          TextView;
          textSize=getsize(10);
          layout_width="30%w";
          layout_marginTop="0";
          text="未开启";
        };
      };
      {
        LinearLayout;
        layout_height="6%h";
        layout_width="match_parent";
        orientation="horizontal";
        {
          ImageButton;
          layout_marginLeft="1%h";
          background="res/ic_lock_outline_black_24dp.png";
        };
        {
          TextView;
          textSize=getsize(10);
          layout_width="30%w";
          layout_marginTop="0";
          text="未开启";
        };
      };
    };
  };
  local tbui = bd[3]
  local lvt = {1,5,9,13,17,21,25}
  function gettext(tb,i)
    local x
    for k,v in pairs(ku) do
      if tb[i].attribute[1] == v[1] then
        x = k
        break
      end
    end
    local str
    if tb[i].attribute[1] == "会心伤害" or tb[i].attribute[1] == "会心免伤" or tb[i].attribute[1] == "最终伤害放大" or tb[i].attribute[1] == "最终伤害抵消" then
      str=yanse("lv"..math.ceil(tb[i].level).."\t"..tb[i].attribute[1]..":"..math.ceil(tb[i].attribute[2]*(1.092^(tb[i].level-1))*10)/10 .."%(上限:"..math.ceil(ku[x][2][#ku[x][2]]*(1.092^(tb[i].level-1))*10)/10*2 .."%)",tb[i].Color)
     else
      str=yanse("lv"..math.ceil(tb[i].level).."\t"..tb[i].attribute[1]..":"..math.ceil(tb[i].attribute[2]*(1.092^(tb[i].level-1))).."(上限:"..math.ceil(ku[x][2][#ku[x][2]]*(1.092^(tb[i].level-1))*2)..")",tb[i].Color)
    end
    return str
  end
  for i=1,9 do
    if #tb >= i then
      tbui[i+1][2] = {
        ImageButton;
        layout_marginLeft="1%h";
        background="res/ic_lock_open_black_24dp.png";
      };
      tbui[i+1][3].text = gettext(tb,i)
      tbui[i+1][4] = {
        Button;
        onClick=function rollbody(i) end;
        text="重塑妖躯";
        layout_marginTop="0";
        layout_width="18%w";
        textSize=getsize(10);
        layout_height="4%h";
      };
      tbui[i+1][5] = {
        Button;
        onClick=function bodyup(i) end;
        text="升级";
        layout_marginTop="0";
        layout_width="18%w";
        textSize=getsize(10);
        layout_height="4%h";
      }
     elseif #tb >= i - 1 then
      tbui[i+1][4] = {
        Button;
        onClick=function rollbody(i) end;
        text="凝练妖躯";
        layout_marginTop="0";
        layout_width="18%w";
        textSize=getsize(10);
        layout_height="4%h";
      };
    end
  end
  if bi ~= nil then
    bi.dismiss()
  end
  bi=AlertDialog.Builder(this).show()
  bi.getWindow().setContentView(loadlayout(bd));
  local j

  function getlv(t)
    local num = 0
    local lv
    local tab = {2000,2800,3600,4400,5200,666666}
    for k,v in pairs(t) do
      num = num + v
    end
    for k,v in pairs(tab) do
      if num <= v then
        lv = k
        break
      end
    end
    return lv
  end

  function rollbody(idx)
    local cl = {"#C6C6C6","#008000","#0000FF","#FF0000","#FFA500","#FFD700"}
    function AttributeClone(key)
      local br = false
      for k,v in pairs(tb) do
        if key == v.attribute[1] then
          br = true
          break
        end
      end
      return br
    end
    if tb[idx] ~= nil then
      if tab.level < 0 then
        MD提示("该宠兽当前境界过低，还是到了妖王境界再开始重塑妖躯吧")
       else
        if j ~= nil then
          j.dismiss()
        end
        j = AlertDialog.Builder(this)
        .setTitle("确认")
        .setMessage(Html.fromHtml("确定消耗一颗"..yansep("塑体丹","#FF0000").."重塑妖躯吗？"))
        .setPositiveButton("取消",nil)
        .setNegativeButton("确认",function
          local br
          for k,v in pairs(SaveTable.Item) do
            if v.key == "塑体丹" then
              br = k
              break
            end
          end
          if type(br)=="number" then
            local lv = getlv(tab["四维"])
            local num = math.random(1,#ku)
            while AttributeClone(ku[num][1]) do
              num = math.random(1,#ku)
            end
            local num1 = math.random(1,lv)
            local num2
            if ku[num][1] == "会心伤害" or ku[num][1] == "会心免伤" or ku[num][1] == "最终伤害放大" or ku[num][1] == "最终伤害抵消" then
              num2 = math.random(ku[num][2][num1]*10,ku[num][2][num1+1]*10)/10
             else
              num2 = math.random(ku[num][2][num1],ku[num][2][num1+1])
            end
            tb[idx].attribute={ku[num][1],num2*2}
            tb[idx].Color=cl[num1]
            MD提示("重塑成功")
            loadsavewrite(0)
            锁.removeViews(idx-1,1)
            锁.addView(loadlayout{
              LinearLayout;
              layout_height="6%h";
              layout_width="match_parent";
              orientation="horizontal";
              {
                ImageButton;
                layout_marginLeft="1%h";
                background="res/ic_lock_open_black_24dp.png";
              };
              {
                TextView;
                textSize=getsize(10);
                layout_width="30%w";
                layout_marginTop="0";
                text=gettext(tb,idx)
              };
              {
                Button;
                onClick=function rollbody(idx) end;
                text="重塑妖躯";
                layout_marginTop="0";
                layout_width="18%w";
                textSize=getsize(10);
                layout_height="4%h";
              };
              {
                Button;
                onClick=function bodyup(idx) end;
                text="升级";
                layout_marginTop="0";
                layout_width="18%w";
                textSize=getsize(10);
                layout_height="4%h";
              };
            },idx-1)
            if SaveTable.Item[br].number > 1 then
              SaveTable.Item[br].number = SaveTable.Item[br].number - 1
             else
              table.remove(SaveTable.Item,br)
            end
           else
            MD提示(Html.fromHtml("你还没有"..yansep("塑体丹","#FF0000")))
          end
        end)
        .show();
      end
     else
      if j ~= nil then
        j.dismiss()
      end
      local xw = {10000,50000,300000,1000000,5000000,20000000,100000000,500000000,2000000000}
      j = AlertDialog.Builder(this)
      .setTitle("确认")
      .setMessage(Html.fromHtml("是否消耗"..xw[idx].."点修为凝练妖躯?"))
      .setPositiveButton("取消",nil)
      .setNegativeButton("确认",function
        if tab["修为"] >= xw[idx] then
          local lv = getlv(tab["四维"])
          local num = math.random(1,#ku)
          while AttributeClone(ku[num][1]) do
            num = math.random(1,#ku)
          end
          local num1 = math.random(1,lv)
          local num2
          if ku[num][1] == "会心伤害" or ku[num][1] == "会心免伤" or ku[num][1] == "最终伤害放大" or ku[num][1] == "最终伤害抵消" then
            num2 = math.random(ku[num][2][num1]*10,ku[num][2][num1+1]*10)/10
           else
            num2 = math.random(ku[num][2][num1],ku[num][2][num1+1])
          end table.insert(tb,{attribute={ku[num][1],num2*2},level=1,Color=cl[num1]})
          tab["修为"] = tab["修为"] - xw[idx]
          锁.removeViews(idx-1,1)
          锁.addView(loadlayout{
            LinearLayout;
            layout_height="6%h";
            layout_width="match_parent";
            orientation="horizontal";
            {
              ImageButton;
              layout_marginLeft="1%h";
              background="res/ic_lock_open_black_24dp.png";
            };
            {
              TextView;
              textSize=getsize(10);
              layout_width="30%w";
              layout_marginTop="0";
              text=gettext(tb,idx)
            };
            {
              Button;
              onClick=function rollbody(idx) end;
              text="重塑妖躯";
              layout_marginTop="0";
              layout_width="18%w";
              textSize=getsize(10);
              layout_height="4%h";
            };
            {
              Button;
              onClick=function bodyup(idx) end;
              text="升级";
              layout_marginTop="0";
              layout_width="18%w";
              textSize=getsize(10);
              layout_height="4%h";
            };
          },idx-1)
          if #tb < 9 then
            if tab.level >= 0 then
              local jjtx = {"妖兽境开启","妖将境开启","妖王境开启","妖君境开启","妖尊境开启","天妖境开启","大圣境开启"}
              锁.removeViews(idx,1)
              锁.addView(loadlayout{
                LinearLayout;
                layout_height="6%h";
                layout_width="match_parent";
                orientation="horizontal";
                {
                  ImageButton;
                  layout_marginLeft="1%h";
                  background="res/ic_lock_open_black_24dp.png";
                };
                {
                  TextView;
                  textSize=getsize(10);
                  layout_width="30%w";
                  layout_marginTop="0";
                  text="未开启";
                };
                {
                  Button;
                  onClick=function rollbody(idx+1) end;
                  text="凝练妖躯";
                  layout_marginTop="0";
                  layout_width="18%w";
                  textSize=getsize(10);
                  layout_height="4%h";
                };
              },idx)
            end
          end
          MD提示("凝练成功")
          loadsavewrite(0)
         else
          MD提示("修为不足，无法凝练")
        end
      end)
      .show();
    end
  end
  function bodyup(idx)
    if j ~= nil then
      j.dismiss()
    end
    local xw = math.ceil((1.1^(tb[idx].level-1))*(tb[idx].level^0.5)*1000)
    local cs = math.ceil((1.1^(tb[idx].level-1))*(tb[idx].level^0.5)*10)
    j = AlertDialog.Builder(this)
    .setTitle("确认")
    .setMessage(Html.fromHtml("是否消耗"..xw.."点修为,"..cs.."个"..yansep("淬石","#0000FF").."进行升级?"))
    .setPositiveButton("取消",nil)
    .setNegativeButton("确认",function
      local br
      for k,v in pairs(SaveTable.Item) do
        if (v.key == "淬石" and v.number >= cs) then
          br = k
          break
        end
      end
      if tab["修为"] >= xw then
        if type(br) == "number" then
          tb[idx].level = tb[idx].level + 1
          tab["修为"] = tab["修为"] - xw
          if SaveTable.Item[br].number <= cs then
            table.remove(SaveTable.Item,br)
           else
            SaveTable.Item[br].number = SaveTable.Item[br].number - cs
          end
          锁.removeViews(idx-1,1)
          锁.addView(loadlayout{
            LinearLayout;
            layout_height="6%h";
            layout_width="match_parent";
            orientation="horizontal";
            {
              ImageButton;
              layout_marginLeft="1%h";
              background="res/ic_lock_open_black_24dp.png";
            };
            {
              TextView;
              textSize=getsize(10);
              layout_width="30%w";
              layout_marginTop="0";
              text=gettext(tb,idx)
            };
            {
              Button;
              onClick=function rollbody(idx) end;
              text="重塑妖躯";
              layout_marginTop="0";
              layout_width="18%w";
              textSize=getsize(10);
              layout_height="4%h";
            };
            {
              Button;
              onClick=function bodyup(idx) end;
              text="升级";
              layout_marginTop="0";
              layout_width="18%w";
              textSize=getsize(10);
              layout_height="4%h";
            };
          },idx-1)
         else
          MD提示(Html.fromHtml(yansep("淬石","#0000FF").."数量不足"))
        end
       else
        MD提示("该宠兽修为不足"..xw.."点")
      end
    end)
    .show();
  end
end