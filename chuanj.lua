require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "BattleFiled"
SaveTable,value2=...
function getsize(num)
  local num1 = activity.getWidth()/1080
  return table.concat({math.floor(num*num1),"sp"})
end

local buju = {
  LinearLayout;
  backgroundColor="#000000";
  layout_height="fill";
  layout_width="fill";
  orientation="horizontal";
  {
    CardView;
    layout_margin="2%w";
    layout_height="fill";
    layout_width="fill";
    radius="10dp";
    {
      ListView;
      layout_width="fill";
      layout_height="fill";
      id="战斗地图";
    };
  };
};

activity.setContentView(loadlayout(buju))
local mps = {
  LinearLayout;
  backgroundColor="#000000";
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
        id="地图名";
      };
    };
  };
};
SaveTable.zt = 1
local data={}
local zdtb = {"寂静森林","战斗1","战斗2","战斗3","战斗4","战斗5","战斗6","战斗7","战斗8","战斗9","战斗10","战斗11","战斗12","战斗13","战斗14","战斗15","战斗16","战斗17","战斗18","战斗19"}
local zdjj = {"[炼气一层]","[炼气初期]","[炼气中期]","[炼气后期]","[筑基初期]","[筑基中期]","[筑基后期]","[筑基大圆满]","[金丹初期]","[金丹中期]","[金丹后期]","[金丹大圆满]","[元婴初期]","[元婴中期]","[元婴后期]","[元婴大圆满]","[化神初期]","[化神中期]","[化神后期]","[化神大圆满]"}
local adp=LuaAdapter(activity,data,mps)
if SaveTable.sys == nil then
  SaveTable.sys = {level=1,shop=1,battle=1}
end
for k,v in pairs(zdtb) do
  if k <= SaveTable.sys.battle + 1 then
    data[#data+1]={地图名=v..zdjj[k]}
  end
end
战斗地图.Adapter=adp
战斗地图.onItemClick=function(l,v,p,i)
  SaveTable.zt = nil
  BattleStart(zdtb[i])
end
-- 0横屏，1竖屏