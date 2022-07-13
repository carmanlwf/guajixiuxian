require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

local danfang = import "danfang"
local cdcs
local madedan
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

function getdfbox(key)
  local x
  for k,v in pairs(SaveTable["炼丹"].learn) do
    if key == v.key then
      x = v
      break
    end
  end
  return x
end

function 炼丹()
  local danfan
  local 品级 = {
    {key="黄阶下品",
      ["成丹率"]=25,
      ["出丹率"]=10,
      exp=1000},
    {key="黄阶中品",
      ["成丹率"]=40,
      ["出丹率"]=15,
      exp=2000,},
    {key="黄阶上品",
      ["成丹率"]=60,
      ["出丹率"]=20,
      exp=5000,},
    {key="玄阶下品",
      ["成丹率"]=100,
      ["出丹率"]=30,
      exp=10000},
    {key="玄阶中品",
      ["成丹率"]=150,
      ["出丹率"]=40,
      exp=20000},
    {key="玄阶上品",
      ["成丹率"]=200,
      ["出丹率"]=50,
      exp=50000},
    {key="地阶下品",
      ["成丹率"]=300,
      ["出丹率"]=70,
      exp=100000},
    {key="地阶中品",
      ["成丹率"]=400,
      ["出丹率"]=85,
      exp=200000},
    {key="地阶上品",
      ["成丹率"]=500,
      ["出丹率"]=100,
      exp=500000},
    {key="天阶下品",
      ["成丹率"]=700,
      ["出丹率"]=130,
      exp=1000000},
    {key="天阶中品",
      ["成丹率"]=850,
      ["出丹率"]=150,
      exp=2000000},
    {key="天阶上品",
      ["成丹率"]=1000,
      ["出丹率"]=170,
      exp=5000000},
    {key="仙品",
      ["成丹率"]=1500,
      ["出丹率"]=200}}
  function 提升炼丹经验(key,num)
    SaveTable["炼丹"].exp = SaveTable["炼丹"].exp + num
    while 品级[SaveTable["炼丹"].level].exp ~= nil and SaveTable["炼丹"].exp >= 品级[SaveTable["炼丹"].level].exp do
      SaveTable["炼丹"].exp = SaveTable["炼丹"].exp - 品级[SaveTable["炼丹"].level].exp
      SaveTable["炼丹"].level = SaveTable["炼丹"].level + 1
    end
    for k,v in pairs(SaveTable["炼丹"].learn) do
      if v.key == key then
        v.exp = v.exp + num
        while v.level < 5 and v.exp >= danfang[key].maxexp *(2^(v.level - 1)) do
          v.exp = v.exp - danfang[key].maxexp *(2^(v.level - 1))
          v.level = v.level + 1
        end
        break
      end
    end
  end
  local Item = import "item"
  local tbt = Item:GetTable(SaveTable["炼丹"].eq.key)
  cdcs={["成丹率"]=品级[SaveTable["炼丹"].level]["成丹率"],["出丹率"]=品级[SaveTable["炼丹"].level]["出丹率"],["神念消耗"]=1,["获取经验"]=1,["材料消耗"]=1}
  for k,v in pairs(SaveTable["炼丹"].eq) do
    for n,m in pairs(cdcs) do
      if k == n then
        if k ~= "神念消耗" and k ~= "获取经验" and k ~= "材料消耗" then
          cdcs[n] = m + v * tbt[k]
         else
          cdcs[n] = m + v * tbt[k]/100
        end
      end
    end
  end
  function 选择丹方()
    if danfan ~= nil then
      danfan.dismiss()
    end
    danfan=PopupWindow(activity)--创建PopWindow
    danfan.setContentView(loadlayout(MapUI()["炼丹"]))--设置布局
    danfan.setWidth(activity.Width*0.96)--设置宽度
    danfan.setHeight(activity.Width*1.08)--设置高度
    danfan.setFocusable(true)--设置可获得焦点
    danfan.setTouchable(true)--设置可触摸
    danfan.setOutsideTouchable(true)
    danfan.showAtLocation(view,Gravity.CENTER,0,0)
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
          id="df";
          layout_gravity="center";
        };
      };
    };
    local data = {}
    local adp=LuaAdapter(activity,data,item)
    madan.Adapter=adp
    local wds
    function 丹方筛子(num)
      local dt = {"黄阶丹方","玄阶丹方","地阶丹方","天阶丹方","仙阶丹方"}
      local buju = {
        LinearLayout;
        layout_height="match_parent";
        layout_width="match_parent";
        orientation="vertical";
        {
          FrameLayout;
          onClick=function 丹方筛子(1) end;
          layout_height="5%h";
          backgroundColor="#000000";
          layout_width="18%w";
          layout_margin="1%h";
          {
            FrameLayout;
            layout_height="match_parent";
            layout_margin="0.5%w";
            layout_width="match_parent";
            backgroundColor="#FFFFFF";
            {
              FrameLayout;
              layout_height="match_parent";
              layout_margin="0.5%w";
              layout_width="match_parent";
              backgroundColor="#000000";
              {
                TextView;
                textColor="#FFFFFF";
                text="黄阶丹方";
                layout_gravity="center";
              };
            };
          };
        };
        {
          FrameLayout;
          onClick=function 丹方筛子(2) end;
          layout_height="5%h";
          layout_margin="1%h";
          layout_width="18%w";
          backgroundColor="#000000";
          {
            FrameLayout;
            layout_height="match_parent";
            layout_margin="0.5%w";
            layout_width="match_parent";
            backgroundColor="#FFFFFF";
            {
              FrameLayout;
              layout_height="match_parent";
              layout_margin="0.5%w";
              layout_width="match_parent";
              backgroundColor="#000000";
              {
                TextView;
                textColor="#FFFFFF";
                text="玄阶丹方";
                layout_gravity="center";
              };
            };
          };
        };
        {
          FrameLayout;
          onClick=function 丹方筛子(3) end;
          layout_height="5%h";
          layout_margin="1%h";
          layout_width="18%w";
          backgroundColor="#000000";
          {
            FrameLayout;
            layout_height="match_parent";
            layout_margin="0.5%w";
            layout_width="match_parent";
            backgroundColor="#FFFFFF";
            {
              FrameLayout;
              layout_height="match_parent";
              layout_margin="0.5%w";
              layout_width="match_parent";
              backgroundColor="#000000";
              {
                TextView;
                textColor="#FFFFFF";
                text="地阶丹方";
                layout_gravity="center";
              };
            };
          };
        };
        {
          FrameLayout;
          onClick=function 丹方筛子(4) end;
          layout_height="5%h";
          layout_margin="1%h";
          layout_width="18%w";
          backgroundColor="#000000";
          {
            FrameLayout;
            layout_height="match_parent";
            layout_margin="0.5%w";
            layout_width="match_parent";
            backgroundColor="#FFFFFF";
            {
              FrameLayout;
              layout_height="match_parent";
              layout_margin="0.5%w";
              layout_width="match_parent";
              backgroundColor="#000000";
              {
                TextView;
                textColor="#FFFFFF";
                text="天阶丹方";
                layout_gravity="center";
              };
            };
          };
        };
        {
          FrameLayout;
          onClick=function 丹方筛子(5) end;
          layout_height="5%h";
          layout_margin="1%h";
          layout_width="18%w";
          backgroundColor="#000000";
          {
            FrameLayout;
            layout_height="match_parent";
            layout_margin="0.5%w";
            layout_width="match_parent";
            backgroundColor="#FFFFFF";
            {
              FrameLayout;
              layout_height="match_parent";
              layout_margin="0.5%w";
              layout_width="match_parent";
              backgroundColor="#000000";
              {
                TextView;
                textColor="#FFFFFF";
                text="仙阶丹方";
                layout_gravity="center";
              };
            };
          };
        };
      };
      local tab = {
        FrameLayout;
        onClick= function 丹方筛子(num) end;
        backgroundColor="#000000";
        layout_margin="1%h";
        layout_height="5%h";
        layout_width="18%w";
        {
          FrameLayout;
          backgroundColor="#FFFFFF";
          layout_margin="0.5%w";
          layout_height="match_parent";
          layout_width="match_parent";
          {
            TextView;
            text=dt[num];
            textColor="#000000";
            layout_gravity="center";
          };
        };
      };
      buju[num+1] = tab
      kj.removeAllViews()
      kj.addView(loadlayout(buju))
      if #wds[num] > 0 then
       else
        MD提示(table.concat({"你还未习得",dt[num]}))
      end
      adp.clear()
      local 熟练 = {"初学","娴熟","精通","大师","宗师"}
      for k,v in pairs(wds[num]) do
        adp.add({df=Color:Set(table.concat({v,"[",品级[danfang[v]["品质"]].key,"][熟练:",熟练[getdfbox(v).level],"]"}),danfang[v]["品质"])})
      end
      adp.notifyDataSetChanged()
      local lz
      madan.onItemClick=function(l,v,p,i)
        local dfbox = getdfbox(wds[num][i])
        local Item = import "item"
        function 更新炼丹()
          adp.remove(i-1)
          adp.insert(i-1,{df=Color:Set(table.concat({dfbox.key,"[",品级[danfang[dfbox.key]["品质"]].key,"][熟练:",熟练[getdfbox(dfbox.key).level],"]"}),danfang[dfbox.key]["品质"])})
          cdcs={["成丹率"]=品级[SaveTable["炼丹"].level]["成丹率"],["出丹率"]=品级[SaveTable["炼丹"].level]["出丹率"],["神念消耗"]=1,["获取经验"]=1,["材料消耗"]=1}
          for k,v in pairs(SaveTable["炼丹"].eq) do
            for n,m in pairs(cdcs) do
              if k == n then
                if k ~= "神念消耗" and k ~= "获取经验" and k ~= "材料消耗" then
                  cdcs[n] = m + v * tbt[k]
                 else
                  cdcs[n] = m + v * tbt[k]/100
                end
              end
            end
          end
          if SaveTable["炼丹"].level >= 13 then
            ldexp.Text="已满级"
           else
            ldexp.Text=table.concat({math.ceil(SaveTable["炼丹"].exp),"/",品级[SaveTable["炼丹"].level].exp});
          end
          ldcdl.Text="出丹率:"..cdcs["出丹率"].."%";
          lddsdj.Text=table.concat({"丹师等级:",品级[SaveTable["炼丹"].level].key});
          ldsn.Text=table.concat({"神念:",math.ceil(SaveTable.owner["神念"]),"/",math.ceil(SaveTable.owner["神念上限"])});
          ldcgl.Text="成丹率:"..cdcs["成丹率"].."%";
          local dfcs = 1
          local dfcd = 1
          for i=1,dfbox.level-1 do
            dfcs = dfcs + i * 0.1
            dfcd = dfcd + i * 0.05
          end
          dfbox["成丹率"]=cdcs["成丹率"]
          dfbox["出丹率"]=cdcs["出丹率"]
          dfbox["神念消耗"]=cdcs["神念消耗"]
          dfbox["获取经验"]=cdcs["获取经验"]
          dfbox["材料消耗"]=cdcs["材料消耗"]
          if SaveTable["炼丹"].eq["附加属性"] ~= nil then
            for k,v in pairs(SaveTable["炼丹"].eq["附加属性"]) do
              if dfbox[v.value[1]] ~= nil and dfbox.key == v.key then
                if v.value[1] =="成丹率" or v.value[1] =="出丹率" then
                  dfbox[v.value[1]] = dfbox[v.value[1]] + v.value[2]
                 else
                  dfbox[v.value[1]] = dfbox[v.value[1]] + v.value[2]/100
                end
              end
            end
          end
          dfbox["神念消耗"]=math.ceil(danfang[dfbox.key].mp/dfbox["神念消耗"])
          local str=table.concat({"<br>神念消耗:",math.ceil(dfbox["神念消耗"]),"<br>"})
          str = table.concat({str,"<br>需求材料:<br>"})
          for k,v in pairs(danfang[dfbox.key].cost) do
            local num = math.ceil(gnum(v[1]))
            local num1 = math.ceil(v[2]/dfbox["材料消耗"])
            if num1 > num then
              num = Color:Get(tostring(num),7)
            end
            str=table.concat({str,Color:Get(v[1],Item:GetLevel(v[1])),":",num,"/",num1,"<br>"})
          end
          dfbox["出丹率"] = {math.floor(danfang[dfbox.key].number[1]*(1 + dfbox["出丹率"]/100) * dfcd),math.floor(danfang[dfbox.key].number[2]*(1 + dfbox["出丹率"]/100) * dfcd)}
          dfbox["成丹率"] = math.ceil((danfang[dfbox.key].probability*(1.5^(SaveTable["炼丹"].level-danfang[dfbox.key]["品质"]))*(1+dfbox["成丹率"]/100)*dfcs)*100)
          if dfbox["成丹率"] > 100 then
            dfbox["成丹率"] = 100
          end
          str=table.concat({str,"<br>成功率:",dfbox["成丹率"],"%<br>"})
          str=table.concat({str,"预计成丹数量:",dfbox["出丹率"][1],"~",dfbox["出丹率"][2],"<br>"})
          if 熟练[dfbox.level+1] ~= nil then
            --print(熟练[dfbox.level],dfbox.exp,math.ceil(danfang[dfbox.key].maxexp*(2^(dfbox.level-1))),danfang[dfbox.key]["品质"])
            str=table.concat({Color:Get(table.concat({熟练[dfbox.level],":",math.ceil(dfbox.exp),"/",math.ceil(danfang[dfbox.key].maxexp*(2^(dfbox.level-1)))}),danfang[dfbox.key]["品质"]),"<br>物品介绍:",Item:GetInfo(dfbox.key),str})
           else
            str=table.concat({Color:Get(table.concat({熟练[dfbox.level],"[已满级]"}),danfang[dfbox.key]["品质"]),"<br>物品介绍:",Item:GetInfo(dfbox.key),str})
          end
          ldcs.Text=Html.fromHtml(str)
        end
        local mb = {
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
                text="炼制面板";
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
                text=Color:Set(table.concat({dfbox.key,"[",品级[danfang[dfbox.key]["品质"]].key,"]"}),danfang[dfbox.key]["品质"]);
              };
              {
                TextView;
                id="ldcs";
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
                  local br = true
                  for k,v in pairs(danfang[dfbox.key].cost) do
                    local num = gnum(v[1])
                    local num1 = math.ceil(v[2]/dfbox["材料消耗"])
                    if num1 > num then
                      br = false
                      break
                    end
                  end
                  if br then
                    if dfbox["神念消耗"] <= SaveTable.owner["神念"] then
                      for k,v in pairs(danfang[dfbox.key].cost) do
                        DeleteItem(v[1],math.ceil(v[2]/dfbox["材料消耗"]))
                      end
                      SaveTable.owner["神念"] = SaveTable.owner["神念"] - dfbox["神念消耗"]
                      if probability(dfbox["成丹率"]/100) then
                        local num2 = math.random(dfbox["出丹率"][1],dfbox["出丹率"][2])
                        提升炼丹经验(dfbox.key,math.ceil(danfang[dfbox.key].exp*dfbox["获取经验"]))
                        Item:Add(dfbox.key,num2)
                        MD提示(Html.fromHtml(table.concat({"炼制成功,获得",Color:Get(dfbox.key,danfang[dfbox.key]["品质"]),"*",num2})))
                        更新炼丹()
                       else
                        提示("炼制失败")
                        更新炼丹()
                      end
                     else
                      提示("神念不足无法炼制")
                    end
                   else
                    提示("材料不足无法炼制")
                  end
                  loadsavewrite(0)
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
                      text="炼制";
                      layout_gravity="center";
                      textColor="#FFFFFF";
                    };
                  };
                };
              };
              {
                FrameLayout;
                onClick=function lz.dismiss() end;
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
        if lz ~= nil then
          lz.dismiss()
        end
        lz=PopupWindow(activity)--创建PopWindow
        lz.setContentView(loadlayout(mb))--设置布局
        lz.setFocusable(true)--设置可获得焦点
        lz.setTouchable(true)--设置可触摸
        lz.setOutsideTouchable(true)
        lz.showAtLocation(view,Gravity.CENTER,0,0)
        更新炼丹()
      end
    end
    wds={{},{},{},{},{}}
    for k,v in pairs(SaveTable["炼丹"].learn) do
      if danfang[v.key]["品质"] >= 13 then
        table.insert(wds[5],v.key)
       elseif danfang[v.key]["品质"] >= 10 then
        table.insert(wds[4],v.key)
       elseif danfang[v.key]["品质"] >= 7 then
        table.insert(wds[3],v.key)
       elseif danfang[v.key]["品质"] >= 4 then
        table.insert(wds[2],v.key)
       else
        table.insert(wds[1],v.key)
      end
    end
  end
  local dl = "无"
  if SaveTable["炼丹"].eq.key ~= nil then
    dl = SaveTable["炼丹"].eq.key
    dl = Color:Get(dl,Item:GetLevel(dl))
  end
  local ldmb = {
    LinearLayout;
    layout_height="fill";
    backgroundColor="#000000";
    layout_width="fill";
    orientation="vertical";
    {
      CardView;
      layout_height="4%h";
      backgroundColor="#000000";
      layout_width="match_parent";
      layout_gravity="center";
      {
        TextView;
        layout_gravity="center";
        text="炼	丹";
        textSize=getsize(16);
        textColor="#FFFFFF";
      };
    };
    {
      LinearLayout;
      layout_height="match_parent";
      backgroundColor="#000000";
      layout_width="match_parent";
      orientation="horizontal";
      {
        FrameLayout;
        layout_height="match_parent";
        layout_width="match_parent";
        layout_margin="0.5%w";
        backgroundColor="#FFFFFF";
        {
          LinearLayout;
          layout_height="match_parent";
          layout_width="match_parent";
          orientation="horizontal";
          {
            LinearLayout;
            layout_height="match_parent";
            layout_width="45%w";
            orientation="vertical";
            {
              FrameLayout;
              layout_height="7%h";
              layout_width="match_parent";
              {
                CardView;
                layout_margin="3%w";
                layout_width="match_parent";
                layout_gravity="center";
                backgroundColor="#000000";
                layout_height="match_parent";
                radius="1.8%h";
                {
                  CardView;
                  layout_margin="0.4%w";
                  layout_width="match_parent";
                  layout_height="match_parent";
                  backgroundColor="#C6C6C6";
                  radius="1.6%h";
                  {
                    TextView;
                    id="lddsdj";
                    layout_gravity="center";
                    text=table.concat({"丹师等级:",品级[SaveTable["炼丹"].level].key});
                    textSize=getsize(12);
                    textColor="#000000";
                  };
                };
              };
            };
            {
              FrameLayout;
              layout_height="7%h";
              layout_width="match_parent";
              {
                CardView;
                layout_margin="3%w";
                layout_width="match_parent";
                layout_gravity="center";
                backgroundColor="#000000";
                layout_height="match_parent";
                radius="1.8%h";
                {
                  CardView;
                  layout_margin="0.4%w";
                  layout_width="match_parent";
                  layout_height="match_parent";
                  backgroundColor="#C6C6C6";
                  radius="1.6%h";
                  {
                    TextView;
                    id="ldsn";
                    layout_gravity="center";
                    text=table.concat({"神念:",math.ceil(SaveTable.owner["神念"]),"/",math.ceil(SaveTable.owner["神念上限"])});
                    textSize=getsize(12);
                    textColor="#000000";
                  };
                };
              };
            };
            {
              FrameLayout;
              layout_height="7%h";
              layout_width="match_parent";
              {
                CardView;
                layout_margin="3%w";
                layout_width="match_parent";
                layout_gravity="center";
                backgroundColor="#000000";
                layout_height="match_parent";
                radius="1.8%h";
                {
                  CardView;
                  layout_margin="0.4%w";
                  layout_width="match_parent";
                  layout_height="match_parent";
                  backgroundColor="#C6C6C6";
                  radius="1.6%h";
                  {
                    TextView;
                    id="ldcgl";
                    layout_gravity="center";
                    text="成丹率:"..cdcs["成丹率"].."%";
                    textSize=getsize(12);
                    textColor="#000000";
                  };
                };
              };
            };
            {
              Button;
              onClick=function 选择丹方() end;
              textSize=getsize(13);
              text="丹方";
              layout_marginLeft="1%h";
              layout_marginTop="15%w";
            };
          };
          {
            LinearLayout;
            layout_height="match_parent";
            layout_width="match_parent";
            orientation="vertical";
            {
              FrameLayout;
              layout_height="7%h";
              layout_width="match_parent";
              {
                CardView;
                layout_margin="3%w";
                layout_width="match_parent";
                layout_gravity="center";
                backgroundColor="#000000";
                layout_height="match_parent";
                radius="1.8%h";
                {
                  CardView;
                  layout_margin="0.4%w";
                  layout_width="match_parent";
                  layout_height="match_parent";
                  backgroundColor="#C6C6C6";
                  radius="1.6%h";
                  {
                    TextView;
                    id="ldexp";
                    layout_gravity="center";
                    textSize=getsize(12);
                    textColor="#000000";
                  };
                };
              };
            };
            {
              FrameLayout;
              layout_height="7%h";
              layout_width="match_parent";
              {
                CardView;
                layout_margin="3%w";
                layout_width="match_parent";
                layout_gravity="center";
                backgroundColor="#000000";
                layout_height="match_parent";
                radius="1.8%h";
                {
                  CardView;
                  layout_margin="0.4%w";
                  layout_width="match_parent";
                  layout_height="match_parent";
                  backgroundColor="#C6C6C6";
                  radius="1.6%h";
                  {
                    TextView;
                    layout_gravity="center";
                    text=Html.fromHtml("丹炉:"..dl);
                    textSize=getsize(12);
                    textColor="#000000";
                  };
                };
              };
            };
            {
              FrameLayout;
              layout_height="7%h";
              layout_width="match_parent";
              {
                CardView;
                layout_margin="3%w";
                layout_width="match_parent";
                layout_gravity="center";
                backgroundColor="#000000";
                layout_height="match_parent";
                radius="1.8%h";
                {
                  CardView;
                  layout_margin="0.4%w";
                  layout_width="match_parent";
                  layout_height="match_parent";
                  backgroundColor="#C6C6C6";
                  radius="1.6%h";
                  {
                    TextView;
                    id="ldcdl";
                    layout_gravity="center";
                    text="出丹率:"..cdcs["出丹率"].."%";
                    textSize=getsize(12);
                    textColor="#000000";
                  };
                };
              };
            };
            {
              Button;
              textSize=getsize(12);
              text="卸下丹炉";
              onClick=function
                if SaveTable["炼丹"].eq.key == nil then
                  提示("你还没有装备丹炉")
                 else
                  local itb = table.clone(SaveTable["炼丹"].eq)
                  提示(Html.fromHtml(Color:Get(itb.key,Item:GetLevel(itb.key)).."已被卸下!"))
                  SaveTable["炼丹"].eq = {}
                  table.insert(SaveTable.Item,itb)
                  madedan.dismiss()
                end
              end;
              layout_marginLeft="10%h";
              layout_marginTop="15%w";
            };
          };
        };
      };
    };
  };
  madedan=PopupWindow(activity)--创建PopWindow
  madedan.setContentView(loadlayout(ldmb))--设置布局
  madedan.setWidth(activity.Width*0.9)--设置宽度
  madedan.setHeight(activity.Width*0.8)--设置高度
  madedan.setFocusable(true)--设置可获得焦点
  madedan.setTouchable(true)--设置可触摸
  madedan.setOutsideTouchable(true)
  madedan.showAtLocation(view,Gravity.CENTER,0,0)
  if SaveTable["炼丹"].level >= 13 then
    ldexp.Text="已满级"
   else
    ldexp.Text=table.concat({math.ceil(SaveTable["炼丹"].exp),"/",品级[SaveTable["炼丹"].level].exp});
  end
end