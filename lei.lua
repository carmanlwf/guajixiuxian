require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

function 雷劫(dm)
  local Item = import "item"
  import "android.view.animation.TranslateAnimation"
  local function ljtb(csz)
    local tb = {}
    local br = false
    for i=1,9 do
      local num = math.random(math.ceil(dm*0.7),math.ceil(dm*1.2))
      csz = math.ceil(csz - num)
      dm = math.ceil(dm*1.2)
      table.insert(tb,table.clone({num,csz}))
    end
    if csz > 0 then
      br = true
    end
    return tb,br
  end
  SaveTable.owner.Attribute=Item:GetTirgger(SaveTable.owner)
  local csz = SaveTable.owner.Attribute["体质"] + SaveTable.owner.Attribute["真元"] + SaveTable.owner.Attribute["身法"] + SaveTable.owner.Attribute["肉身"]
  local lay=loadlayout{
    LinearLayout;
    BackgroundColor="#000000";
    layout_width="match_parent";
    layout_height="match_parent";
    orientation="vertical";
  };
  local a1=PopupWindow(activity)--创建PopWindow
  a1.setContentView(lay)--设置布局
  a1.setWidth(activity.Width)--设置宽度
  a1.setHeight(activity.Height)
  a1.setFocusable(false)--设置可获得焦点
  a1.getBackground().setAlpha(0)
  a1.setTouchable(true)--设置可触摸
  --设置点击外部区域是否可以消失
  a1.setOutsideTouchable(false)
  --显示
  a1.showAtLocation(view,Gravity.CENTER,0,0)
  local down_top=TranslateAnimation(0, 0, activity.Height*0.03, 0)
  down_top.setDuration(500)
  down_top.setFillAfter(true)
  local tb,br = ljtb(csz)
  local i = 1
  local str="天空中乌云阵阵，雷声滚滚，片刻间一道青色雷电自黑云间孕育而出(当前雷劫承受值"..math.ceil(csz)..").."
  local bot1 = loadlayout(
  {
    TextView;
    textColor="#FFFFFF";
    textSize=getsize(18);
    text=str;
  })
  lay.addView(bot1)
  bot1.startAnimation(down_top)
  local ti=Ticker()
  ti.Period=1000
  ti.onTick=function()
    local down_top1=TranslateAnimation(0, 0, activity.Height*0.03, 0)
    down_top1.setDuration(500)
    down_top1.setFillAfter(true)
    bot1 = loadlayout(
    {
      TextView;
      textColor="#FFFFFF";
      textSize=getsize(18);
      text=str;
    })
    bot1.Text = "第"..i.."道雷劫，你受到"..tb[i][1].."点伤害，当前雷劫承受值"..tb[i][2].."点!"
    lay.addView(bot1)
    bot1.startAnimation(down_top1)
    if tb[i][2] > 0 then
      if i >= 9 then
        提示("晋级成功！")
        ti.stop()
        task(2000,function
          a1.dismiss()
        end)
       else
        i = i + 1
      end
     else
      提示("突破失败！")
      ti.stop()
      task(2000,function
        a1.dismiss()
      end)
    end
  end
  ti.start()
  return br
end