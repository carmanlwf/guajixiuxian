require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"


local tuzhi = import "tuzhi"
local pfcs
local madeqi
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

function gettzbox(key)
  local x
  for k,v in pairs(SaveTable["炼器"].learn) do
    if key == v.key then
      x = v
      break
    end
  end
  return x
end

function 炼器()
  local tuzh
  local 品级 = {
    {key="黄阶下品",
      ["成功率"]=25,
      ["属性品质"]=10,
      ["评分提升"]=5,
      exp=1000},
    {key="黄阶中品",
      ["成功率"]=40,
      ["属性品质"]=15,
      ["评分提升"]=8,
      exp=2000},
    {key="黄阶上品",
      ["成功率"]=60,
      ["属性品质"]=20,
      ["评分提升"]=10,
      exp=5000},
    {key="玄阶下品",
      ["成功率"]=100,
      ["属性品质"]=30,
      ["评分提升"]=15,
      exp=10000},
    {key="玄阶中品",
      ["成功率"]=150,
      ["属性品质"]=40,
      ["评分提升"]=20,
      exp=20000},
    {key="玄阶上品",
      ["成功率"]=200,
      ["属性品质"]=50,
      ["评分提升"]=25,
      exp=50000},
    {key="地阶下品",
      ["成功率"]=300,
      ["属性品质"]=70,
      ["评分提升"]=35,
      exp=100000},
    {key="地阶中品",
      ["成功率"]=400,
      ["属性品质"]=85,
      ["评分提升"]=40,
      exp=200000},
    {key="地阶上品",
      ["成功率"]=500,
      ["属性品质"]=100,
      ["评分提升"]=45,
      exp=500000},
    {key="天阶下品",
      ["成功率"]=700,
      ["属性品质"]=130,
      ["评分提升"]=60,
      exp=1000000},
    {key="天阶中品",
      ["成功率"]=850,
      ["属性品质"]=150,
      ["评分提升"]=70,
      exp=2000000},
    {key="天阶上品",
      ["成功率"]=1000,
      ["属性品质"]=170,
      ["评分提升"]=80,
      exp=5000000},
    {key="仙阶",
      ["成功率"]=1500,
      ["属性品质"]=200,
      ["评分提升"]=100
  }}
  function 提升炼器经验(key,num)
    SaveTable["炼器"].exp = SaveTable["炼器"].exp + num
    while 品级[SaveTable["炼器"].level].exp ~= nil and SaveTable["炼器"].exp >= 品级[SaveTable["炼器"].level].exp do
      SaveTable["炼器"].exp = SaveTable["炼器"].exp - 品级[SaveTable["炼器"].level].exp
      SaveTable["炼器"].level = SaveTable["炼器"].level + 1
    end
    for k,v in pairs(SaveTable["炼器"].learn) do
      if v.key == key then
        v.exp = v.exp + num
        while v.level < 5 and v.exp >= tuzhi[key].maxexp *(2^(v.level - 1)) do
          v.exp = v.exp - tuzhi[key].maxexp *(2^(v.level - 1))
          v.level = v.level + 1
        end
        break
      end
    end
  end
  local Item = import "item"
  pfcs={["成功率"]=品级[SaveTable["炼器"].level]["成功率"],["评分提升"]=品级[SaveTable["炼器"].level]["评分提升"],["属性品质"]=品级[SaveTable["炼器"].level]["属性品质"],["神念消耗"]=1,["获取经验"]=1,["材料消耗"]=1}
  local tbt = Item:GetTable(SaveTable["炼器"].eq.key)
  for k,v in pairs(SaveTable["炼器"].eq) do
    for n,m in pairs(pfcs) do
      if k == n then
        if k ~= "神念消耗" or k ~= "获取经验" or k ~= "材料消耗" then
          pfcs[n] = m + v * tbt[k]
         else
          pfcs[n] = m + v * tbt[k]/100
        end
      end
    end
  end
  function 选择图纸()
    if tuzh ~= nil then
      tuzh.dismiss()
    end
    tuzh=PopupWindow(activity)--创建PopWindow
    tuzh.setContentView(loadlayout(MapUI()["炼器"]))--设置布局
    tuzh.setWidth(activity.Width*0.96)--设置宽度
    tuzh.setHeight(activity.Width*1.08)--设置高度
    tuzh.setFocusable(true)--设置可获得焦点
    tuzh.setTouchable(true)--设置可触摸
    tuzh.setOutsideTouchable(true)
    tuzh.showAtLocation(view,Gravity.CENTER,0,0)
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
    local data = {}
    local adp=LuaAdapter(activity,data,item)
    maqi.Adapter=adp
    local wds
    function 图纸筛子(num)
      local dt = {"黄阶图纸","玄阶图纸","地阶图纸","天阶图纸","仙阶图纸"}
      local buju = {
        LinearLayout;
        layout_height="match_parent";
        layout_width="match_parent";
        orientation="vertical";
        {
          FrameLayout;
          onClick=function 图纸筛子(1) end;
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
                text="黄阶图纸";
                layout_gravity="center";
              };
            };
          };
        };
        {
          FrameLayout;
          onClick=function 图纸筛子(2) end;
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
                text="玄阶图纸";
                layout_gravity="center";
              };
            };
          };
        };
        {
          FrameLayout;
          onClick=function 图纸筛子(3) end;
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
                text="地阶图纸";
                layout_gravity="center";
              };
            };
          };
        };
        {
          FrameLayout;
          onClick=function 图纸筛子(4) end;
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
                text="天阶图纸";
                layout_gravity="center";
              };
            };
          };
        };
        {
          FrameLayout;
          onClick=function 图纸筛子(5) end;
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
                text="仙阶图纸";
                layout_gravity="center";
              };
            };
          };
        };
      };
      local tab = {
        FrameLayout;
        onClick= function 图纸筛子(num) end;
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
        adp.add({tz=Color:Set(table.concat({v,"[",品级[tuzhi[v]["品质"]].key,"][熟练:",熟练[gettzbox(v).level],"]"}),tuzhi[v]["品质"])})
      end
      adp.notifyDataSetChanged()
      local lz
      maqi.onItemClick=function(l,v,p,i)
        local tzbox = gettzbox(wds[num][i])
        local Item = import "item"
        function gnum(key)
          local num1 = 0
          for n,m in pairs(SaveTable.Item) do
            if key == m.key then
              num1 = m.number
            end
          end
          return num1
        end
        function 更新炼器()
          adp.remove(i-1)
          adp.insert(i-1,{tz=Color:Set(table.concat({tzbox.key,"[",品级[tuzhi[tzbox.key]["品质"]].key,"][熟练:",熟练[gettzbox(tzbox.key).level],"]"}),tuzhi[tzbox.key]["品质"])})
          pfcs={["成功率"]=品级[SaveTable["炼器"].level]["成功率"],["评分提升"]=品级[SaveTable["炼器"].level]["评分提升"],["属性品质"]=品级[SaveTable["炼器"].level]["属性品质"],["神念消耗"]=1,["获取经验"]=1,["材料消耗"]=1}
          local tbt = Item:GetTable(SaveTable["炼器"].eq.key)
          for k,v in pairs(SaveTable["炼器"].eq) do
            for n,m in pairs(pfcs) do
              if k == n then
                if k ~= "神念消耗" and k ~= "获取经验" and k ~= "材料消耗" then
                  pfcs[n] = m + v * tbt[k]
                 else
                  pfcs[n] = m + v * tbt[k]/100
                end
              end
            end
          end
          if SaveTable["炼器"].level >= 13 then
            ldexp.Text="已满级"
           else
            ldexp.Text=table.concat({math.ceil(SaveTable["炼器"].exp),"/",品级[SaveTable["炼器"].level].exp});
          end
          tzbox["评分提升"] = pfcs["评分提升"]
          tzbox["属性品质"] = pfcs["属性品质"]
          tzbox["神念消耗"] = pfcs["神念消耗"]
          tzbox["成功率"] = pfcs["成功率"]
          tzbox["材料消耗"] = pfcs["材料消耗"]
          tzbox["获取经验"] = pfcs["获取经验"]
          if SaveTable["炼器"].eq["附加属性"] ~= nil then
            for k,v in pairs(SaveTable["炼器"].eq["附加属性"]) do
              if tzbox[v.value[1]] ~= nil and tzbox.key == v.key then
                if v.value[1] =="成功率" or v.value[1] =="属性品质" or v.value[1] =="评分提升" then
                  tzbox[v.value[1]] = tzbox[v.value[1]] + v.value[2]
                 else
                  tzbox[v.value[1]] = tzbox[v.value[1]] + v.value[2]/100
                end
              end
            end
          end
          ldcdl.Text="法器品质提升:"..tzbox["评分提升"].."%";
          lddsdj.Text=table.concat({"炼器等级:",品级[SaveTable["炼器"].level].key});
          ldsn.Text=table.concat({"神念:",math.ceil(SaveTable.owner["神念"]),"/",math.ceil(SaveTable.owner["神念上限"])});
          ldcgl.Text="成功率:"..tzbox["成功率"].."%";
          local str=table.concat({"<br>神念消耗:",math.ceil(tuzhi[tzbox.key].mp/tzbox["神念消耗"]),"<br>"})
          str = table.concat({str,"<br>需求材料:<br>"})
          for k,v in pairs(tuzhi[tzbox.key].cost) do
            local num = math.ceil(gnum(v[1]))
            local num1 = math.ceil(v[2]/tzbox["材料消耗"])
            if num1 > num then
              num = Color:Get(tostring(num),7)
            end
            str=table.concat({str,Color:Get(v[1],Item:GetLevel(v[1])),":",num,"/",num1,"<br>"})
          end
          local tzcs = 1
          local tzcd = 1
          for i=1,tzbox.level-1 do
            tzcs = tzcs + i * 0.1
            tzcd = tzcd + i * 0.05
          end
          local cdl = {math.floor(tuzhi[tzbox.key].point[1]*(1 + tzbox["评分提升"]/100)*50*tzcd*(1.2^(SaveTable["炼器"].level-tuzhi[tzbox.key]["品质"]))),math.floor(tuzhi[tzbox.key].point[2]*(1 + tzbox["评分提升"]/100)*tzcd*50*(1.2^(SaveTable["炼器"].level-tuzhi[tzbox.key]["品质"])))}
          if cdl[1] > 100 then
            cdl[1] = 100
          end
          if cdl[2] > 120 then
            cdl[2] = 120
          end
          local cgl = math.floor((tuzhi[tzbox.key].probability*(1.5^(SaveTable["炼器"].level-tuzhi[tzbox.key]["品质"]))*(1+tzbox["成功率"]/100)*tzcs)*100)
          if cgl > 100 then
            cgl = 100
          end
          tzbox["属性品质"] = ((1 + tzbox["属性品质"]/100) * tzcs)*(1.2^(SaveTable["炼器"].level-tuzhi[tzbox.key]["品质"]))
          tzbox["成功率"]=cgl
          tzbox["评分提升"]=cdl
          tzbox["神念消耗"]=math.ceil(tuzhi[tzbox.key].mp/tzbox["神念消耗"])
          str=table.concat({str,"<br>成功率:",cgl,"%<br>"})
          str=table.concat({str,"预计法器评分:",cdl[1],"~",math.ceil(120),"<br>"})
          if 熟练[tzbox.level+1] ~= nil then
            str=table.concat({Color:Get(table.concat({熟练[tzbox.level],":",math.ceil(tzbox.exp),"/",math.ceil(tuzhi[tzbox.key].maxexp*(2^(tzbox.level-1)))}),tuzhi[tzbox.key]["品质"]),"<br>物品介绍:",Item:GetInfo(tzbox.key),str})
           else
            str=table.concat({Color:Get(table.concat({熟练[tzbox.level],"[已满级]"}),tuzhi[tzbox.key]["品质"]),"<br>物品介绍:",Item:GetInfo(tzbox.key),str})
          end
          ldcs.Text=Html.fromHtml(str)
        end
        local function DeleteItem(key,num)
          local x = 1
          repeat
          if (SaveTable.Item[x].key == key) then
            if SaveTable.Item[x].number > num then
              SaveTable.Item[x].number = SaveTable.Item[x].number - num
             else
              table.remove(SaveTable.Item,x)
            end
            break
           else
            x = x + 1
          end
          until x > #SaveTable.Item
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
                text=Color:Set(table.concat({tzbox.key,"[",品级[tuzhi[tzbox.key]["品质"]].key,"]"}),tuzhi[tzbox.key]["品质"]);
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
                  for k,v in pairs(tuzhi[tzbox.key].cost) do
                    local num = gnum(v[1])
                    local num1 = math.ceil(v[2]/tzbox["材料消耗"])
                    if num1 > num then
                      br = false
                      break
                    end
                  end
                  if br then
                    if tzbox["神念消耗"] <= SaveTable.owner["神念"] then
                      for k,v in pairs(tuzhi[tzbox.key].cost) do
                        DeleteItem(v[1],math.ceil(v[2]/tzbox["材料消耗"]))
                      end
                      SaveTable.owner["神念"] = SaveTable.owner["神念"] - tzbox["神念消耗"]
                      if probability(tzbox["成功率"]/100) then
                        提升炼器经验(tzbox.key,math.ceil(tuzhi[tzbox.key].exp*tzbox["获取经验"]))
                        Item:Add(tzbox.key,1,tzbox["评分提升"],tzbox["属性品质"])
                        MD提示(Html.fromHtml(table.concat({"炼制成功,获得",Color:Get(tzbox.key,tuzhi[tzbox.key]["品质"]),"*",1})))
                        更新炼器()
                       else
                        提示("炼制失败")
                        更新炼器()
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
        更新炼器()
      end
    end
    wds={{},{},{},{},{}}
    for k,v in pairs(SaveTable["炼器"].learn) do
      if tuzhi[v.key]["品质"] >= 13 then
        table.insert(wds[5],v.key)
       elseif tuzhi[v.key]["品质"] >= 10 then
        table.insert(wds[4],v.key)
       elseif tuzhi[v.key]["品质"] >= 7 then
        table.insert(wds[3],v.key)
       elseif tuzhi[v.key]["品质"] >= 4 then
        table.insert(wds[2],v.key)
       else
        table.insert(wds[1],v.key)
      end
    end
  end
  local dl = "无"
  if SaveTable["炼器"].eq.key ~= nil then
    dl = SaveTable["炼器"].eq.key
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
        text="炼	器";
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
                    text=table.concat({"炼器等级:",品级[SaveTable["炼器"].level].key});
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
                    text="成功率:"..pfcs["成功率"].."%";
                    textSize=getsize(12);
                    textColor="#000000";
                  };
                };
              };
            };
            {
              Button;
              onClick=function 选择图纸() end;
              textSize=getsize(13);
              text="图纸";
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
                    text=Html.fromHtml("器鼎:"..dl);
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
                    text="法器品质提升:"..pfcs["评分提升"].."%";
                    textSize=getsize(12);
                    textColor="#000000";
                  };
                };
              };
            };
            {
              Button;
              textSize=getsize(12);
              text="卸下器鼎";
              onClick=function
                if SaveTable["炼器"].eq.key == nil then
                  提示("你还没有装备器鼎")
                 else
                  local itb = table.clone(SaveTable["炼器"].eq)
                  提示(Html.fromHtml(Color:Get(itb.key,Item:GetLevel(itb.key)).."已被卸下!"))
                  SaveTable["炼器"].eq = {}
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
  if SaveTable["炼器"].level >= 13 then
    ldexp.Text="已满级"
   else
    ldexp.Text=table.concat({math.ceil(SaveTable["炼器"].exp),"/",品级[SaveTable["炼器"].level].exp});
  end
end