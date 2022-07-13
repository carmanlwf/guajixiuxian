require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

local Color = {hui="#C6C6C6",black="#000000",white="#FFFFFF",green="#008000",blue="#0000FF",red="#FF0000",orange="#FFA500",cyan="#00FFFF",gold="#FFD700"}
function Color:Get(str,lv)
  if lv >= 13 then
    str={"<font color=",self.gold,">",str,"</font>"}
   elseif lv >= 10 then
    str={"<font color=",self.orange,">",str,"</font>"}
   elseif lv >= 7 then
    str={"<font color=",self.red,">",str,"</font>"}
   elseif lv >= 4 then
    str={"<font color=",self.blue,">",str,"</font>"}
   else
    str={"<font color=",self.green,">",str,"</font>"}
  end
  return table.concat(str)
end

function 系统()
  local Item = import "item"
  if SaveTable.sys == nil then
    SaveTable.sys = {level=1,shop=1,battle=1}
  end
  local sdata = {{key="黄阶下品",level=1,cost=1000},{key="黄阶中品",level=1,cost=5000},{key="黄阶上品",level=2,cost=50000},{key="玄阶下品",level=2,cost=100000},{key="玄阶中品",level=2,cost=200000},{key="玄阶上品",level=3,cost=2000000},{key="地阶下品",level=3,cost=4000000},{key="地阶中品",level=3,cost=8000000},{key="地阶上品",level=4,cost=50000000},{key="天阶下品",level=4,cost=100000000},{key="天阶中品",level=4,cost=200000000},{key="天阶上品",level=5,cost=1000000000},"仙品"}
  local ldata = {{key="炼气初期",level=1,cost=1000},{key="炼气中期",level=1,cost=2000},{key="炼气后期",level=1,cost=10000},{key="筑基初期",level=1,cost=15000},{key="筑基中期",level=1,cost=15000},{key="筑基后期",level=1,cost=20000},{key="筑基大圆满",level=2,cost=100000},{key="金丹初期",level=2,cost=150000},{key="金丹中期",level=2,cost=200000},{key="金丹后期",level=2,cost=300000},{key="金丹大圆满",level=3,cost=1000000},{key="元婴初期",level=3,cost=1500000},{key="元婴中期",level=3,cost=2000000},{key="元婴后期",level=3,cost=3000000},{key="元婴大圆满",level=4,cost=5000000},{key="化神初期",level=4,cost=6000000},{key="化神中期",level=4,cost=7000000},{key="化神后期",level=4,cost=8000000},{key="化神大圆满",level=4,cost=10000000},{key="合体初期",level=4,cost=20000000},{key="合体中期",level=5,cost=30000000},{key="合体后期",level=5,cost=50000000},{key="合体大圆满",level=5,cost=100000000},{key="大乘初期",level=5,cost=150000000},{key="大乘中期",level=5,cost=20000000},{key="大乘后期",level=5,cost=300000000},{key="大乘大圆满"}}
  local bdata = {{item={["黄晶"]=2000,["玄晶"]=400},money=100000,level=13},{item={["黄晶"]=10000,["玄晶"]=2000,["地晶"]=500},money=1000000,level=17},{item={["黄晶"]=100000,["玄晶"]=20000,["地晶"]=5000,["天晶"]=1000},money=10000000,level=21},{item={["黄晶"]=500000,["玄晶"]=100000,["地晶"]=20000,["天晶"]=5000,["仙晶"]=1000}},money=50000000,level=25}
  local sjb,sjs,sjl
  local xt = {
    LinearLayout;
    background="#ffffffff";
    layout_height="fill";
    layout_width="fill";
    orientation="vertical";
    gravity="center";
    {
      LinearLayout;
      orientation="vertical";
      {
        LinearLayout;
        orientation="horizontal";
        {
          TextView;
          id="sjbb";
          textSize="20sp";
          text="系统版本:"..SaveTable.sys.level*10/10;
          textColor="#000000";
        };
        {
          Button;
          textSize=getsize(10);
          layout_height="5%h";
          layout_width="15%w";
          onClick=function
            if bdata[SaveTable.sys.level] ~= nil and SaveTable.owner.level >= bdata[SaveTable.sys.level].level then
              if sjb ~= nil then
                sjb.dismiss()
              end
              local br = true
              local str = ""
              for k,v in pairs(bdata[SaveTable.sys.level].item) do
                str=table.concat({str,Color:Get(k,Item:GetLevel(k)),"*",v,"、"})
                if Itnum(k) < v then
                  br = false
                end
              end
              sjb=AlertDialog.Builder(this)
              .setTitle("确定")
              .setMessage(Html.fromHtml("需要消耗"..bdata[SaveTable.sys.level].money.."灵石,"..str.."进行升级，确定继续吗？"))
              .setPositiveButton("确定",{onClick=function
                  if SaveTable.owner.money >= bdata[SaveTable.sys.level].money then
                    if br then
                      SaveTable.owner.money = SaveTable.owner.money - bdata[SaveTable.sys.level].money
                      for k,v in pairs(bdata[SaveTable.sys.level].item) do
                        删除物品(k,v)
                      end
                      SaveTable.sys.level = SaveTable.sys.level + 1
                      提示("成功升级系统版本！")
                      sjbb.Text="系统版本:"..SaveTable.sys.level*10/10
                     else
                      提示("物品数量不足")
                    end
                   else
                    提示("灵石数量不足！")
                  end
              end})
              .setNegativeButton("取消",nil)
              .show()
              sjb.create()
             else
              提示("当前无法升级版本！")
            end
          end;
          text="升级";
        };
      };
      {
        LinearLayout;
        orientation="vertical";
        {
          TextView;
          id="sclv";
          textSize=getsize(20);
          text="商城等级:"..math.ceil(SaveTable.sys.shop).."(商城可刷新出"..sdata[SaveTable.sys.shop].key.."的物品)";
          textColor="#000000";
        };
        {
          Button;
          textSize=getsize(10);
          layout_height="5%h";
          layout_width="15%w";
          onClick=function
            if ldata[SaveTable.sys.shop].level ~= nil then
              if SaveTable.sys.level >= sdata[SaveTable.sys.shop].level then
                if SaveTable.owner.money >= sdata[SaveTable.sys.shop].cost then
                  if sjs ~= nil then
                    sjs.dismiss()
                  end
                  sjs=AlertDialog.Builder(this)
                  .setTitle("确定")
                  .setMessage("需要消耗"..sdata[SaveTable.sys.shop].cost.."灵石进行升级，确定继续吗？")
                  .setPositiveButton("确定",{onClick=function
                      SaveTable.owner.money = SaveTable.owner.money - sdata[SaveTable.sys.shop].cost
                      SaveTable.sys.shop = SaveTable.sys.shop + 1
                      sclv.Text="商城等级:"..math.ceil(SaveTable.sys.shop).."(商城可刷新出"..sdata[SaveTable.sys.shop].key.."的物品)";
                      提示("升级成功！")
                  end})
                  .setNegativeButton("取消",nil)
                  .show()
                  sjs.create()
                 else
                  提示("你的灵石不够，需"..sdata[SaveTable.sys.shop].cost.."灵石才可升级！")
                end
               else
                提示("当前系统版本过低，无法继续升级")
              end
             else
              提示("当前已无法继续升级！")
            end
          end;
          text="升级";
        };
      };
      {
        LinearLayout;
        orientation="vertical";
        {
          TextView;
          id="lllv";
          textSize=getsize(20);
          text="历练等级:"..math.ceil(SaveTable.sys.battle).."(解锁"..ldata[SaveTable.sys.battle].key.."历练挂机场景)";
          textColor="#000000";
        };
        {
          Button;
          layout_height="5%h";
          layout_width="15%w";
          textSize=getsize(10);
          onClick=function
            if ldata[SaveTable.sys.battle].level ~= nil then
              if SaveTable.sys.level >= ldata[SaveTable.sys.battle].level then
                if SaveTable.owner.money >= ldata[SaveTable.sys.battle].cost then
                  if sjl ~= nil then
                    sjl.dismiss()
                  end
                  sjl=AlertDialog.Builder(this)
                  .setTitle("确定")
                  .setMessage("需要消耗"..ldata[SaveTable.sys.battle].cost.."灵石进行升级，确定继续吗？")
                  .setPositiveButton("确定",{onClick=function
                      SaveTable.owner.money = SaveTable.owner.money - ldata[SaveTable.sys.battle].cost
                      SaveTable.sys.battle = SaveTable.sys.battle + 1
                      lllv.Text="历练等级:"..math.ceil(SaveTable.sys.battle).."(解锁"..ldata[SaveTable.sys.battle].key.."历练挂机场景)";
                      提示("升级成功！")
                  end})
                  .setNegativeButton("取消",nil)
                  .show()
                  sjl.create()
                 else
                  提示("你的灵石不够，需"..ldata[SaveTable.sys.battle].cost.."灵石才可升级！")
                end
               else
                提示("当前系统版本过低，无法继续升级")
              end
             else
              提示("当前已无法继续升级！")
            end
          end;
          text="升级";
        };
      };
    };
  };
  local xts=PopupWindow(activity)--创建PopWindow
  xts.setContentView(loadlayout(xt))--设置布局
  xts.setWidth(activity.Width*0.96)--设置宽度
  xts.setHeight(-2)--设置高度
  xts.setFocusable(true)--设置可获得焦点
  xts.setTouchable(true)--设置可触摸
  xts.setOutsideTouchable(true)
  xts.showAtLocation(view,Gravity.CENTER,0,0)
end