-----------------------------------------------------------------------------
-- Author: AndLua+ 陵阳
-----------------------------------------------------------------------------

import "android.graphics.PorterDuffColorFilter"
import "android.graphics.PorterDuff"

function getsize(num)
  local num1 = activity.getWidth()/1080
  return table.concat({math.floor(num*num1),"sp"})
end

function HasChinese(str)
  local br = false
  for i=1,#str do
    if string.byte(str, i) > 127 then
      br = true
    end
  end
  return br
end

function skillgetpz(key)
  local skill = import "skill"
  local pz
  for k,v in pairs(skill) do
    if v.key == key then
      pz = v["品质"]
      break
    end
  end
  return pz
end

function 加载框()
  local pop = loadlayout({
    LinearLayout;
    gravity="center";
    layout_height="fill";
    layout_width="fill";
    orientation="vertical";
    {
      TextView;
      text="加载中..";
    };
  })
  local pwpp = PopupWindow(activity)--创建PopWindow
  pwpp.setContentView(pop)--设置布局
  pwpp.setWidth(activity.Width)--设置宽度
  pwpp.setHeight(activity.Height)--设置高度
  pwpp.setFocusable(false)--设置可获得焦点
  pwpp.getBackground().setAlpha(0)
  pwpp.setTouchable(true)--设置可触摸
  --设置点击外部区域是否可以消失
  pwpp.setOutsideTouchable(false)
  --显示
  pwpp.showAtLocation(view,Gravity.CENTER,0,0)
  return pwpp
end

--[[
-- 深度克隆一个值
-- example:
-- 1. t2是t1应用,修改t2时，t1会跟着改变
    local t1 = { a = 1, b = 2, }
    local t2 = t1
    t2.b = 3    -- t1 = { a = 1, b = 3, } == t1.b跟着改变
    
-- 2. clone() 返回t1副本，修改t2,t1不会跟踪改变
    local t1 = { a = 1, b = 2 }
    local t2 = clone( t1 )
    t2.b = 3    -- t1 = { a = 1, b = 3, } == t1.b不跟着改变
    
-- @param object 要克隆的值
-- @return objectCopy 返回值的副本
--]]
function clone( object )
  local lookup_table = {}
  local function copyObj( object )
    if type( object ) ~= "table" then
      return object
     elseif lookup_table[object] then
      return lookup_table[object]
    end

    local new_table = {}
    lookup_table[object] = new_table
    for key, value in pairs( object ) do
      new_table[copyObj( key )] = copyObj( value )
    end
    return setmetatable( new_table, getmetatable( object ) )
  end
  return copyObj( object )
end

function 加载布局()
  savelay = {}
  savelay.map = loadlayout({
    LinearLayout;
    layout_width="fill";
    layout_height="fill";
    orientation="vertical";
    {
      RelativeLayout;
      layout_width="match_parent";
      layout_height="match_parent";
      gravity="center";
      {
        LinearLayout;
        layout_margin="3%w";
        background="img/ditu.png";
        layout_height="wrap_content";
        layout_width="match_parent";
        {
          LinearLayout;
          layout_width="match_parent";
          orientation="vertical";
          layout_height="match_parent";
          layout_margin="4%w";
          {
            TextView;
            id="位置";
            layout_gravity="center";
            textColor="#FFFFFF";
          };
          {
            LinearLayout;
            layout_width="match_parent";
            layout_height="wrap_content";
            {
              TextView;
              id="dtjs";
              textColor="#FFFFFF";
              layout_height="15%h";
            };
          };
          {
            LinearLayout;
            id="项目1";
            orientation="horizontal";
            layout_width="match_parent";
          };
          {
            LinearLayout;
            id="项目2";
            orientation="horizontal";
            layout_width="match_parent";
          };
          {
            LinearLayout;
            id="项目3";
            orientation="horizontal";
            layout_width="match_parent";
          };
        };
      };
    };
  })
  savelay.bj = {}
  for i=1,3 do
    savelay.bj[i] = loadlayout{
      LinearLayout;
      orientation="horizontal";
      layout_width="fill";
      layout_height="fill";
    }
  end
  savelay.kj = {}
  savelay.bt = {}
  savelay.bt[1]= loadlayout{
    AbsoluteLayout;
    layout_height="fill";
    layout_width="fill";
    {
      LinearLayout;
      layout_height="fill";
      layout_width="fill";
      backgroundColor="#FFFFFF";
      orientation="vertical";
      {
        LinearLayout;
        layout_height="32%h";
        backgroundColor="#000000";
        orientation="horizontal";
        layout_width="match_parent";
        {
          ListView;
          backgroundColor="#FFFFFF";
          layout_height="match_parent";
          id="己方面板";
          layout_width="49.4%w";
          layout_margin="0.4%w";
          dividerHeight="0";
        };
        {
          ListView;
          backgroundColor="#FFFFFF";
          layout_height="match_parent";
          id="敌方面板";
          layout_width="match_parent";
          layout_marginTop="0.4%w";
          layout_marginRight="0.4%w";
          layout_marginBottom="0.4%w";
          dividerHeight="0";
        };
      };
      {
        ListView;
        id="战斗信息";
        layout_width="fill";
        layout_height="50%h";
        layout_marginLeft="1.5%h";
        dividerHeight="0";
      };
      {
        LinearLayout;
        layout_width="fill";
        layout_height="6%h";
        {
          Button;
          text="储物";
          onClick=function OpenBag() end;
          layout_width="18%w";
        };
        {
          Button;
          layout_width="18%w";
          text="停挂";
          onClick=function 停止挂机() end;
        };
        {
          Button;
          onClick=function ShopItemShow(0,100) end;
          layout_width="18%w";
          text="商城";
        };
      };
    };
    {
      FrameLayout;
      layout_x="70%w";
      layout_y="70%h";
      id="插";
    }
  }
  local zhandou = {
    LinearLayout;
    orientation="vertical";
    layout_width="fill";
    layout_height="7.8%h";
    {
      LinearLayout;
      layout_marginLeft="1%h";
      layout_width="40.4%w";
      orientation="vertical";
      layout_marginleft="1%w";
      layout_height="7.2%h";
      {
        LinearLayout;
        orientation="vertical";
        layout_width="match_parent";
        layout_height="3%h";
        {
          TextView;
          id="名称境界";
          text="名字没怎么怎么这么早";
          textColor="#000000";
          textSize=getsize(8);
          layout_gravity="center";
        };
        {
          TextView;
          textSize=getsize(7);
          textColor="#FF0000";
          text="境界";
          layout_gravity="center";
        };
      };
      {
        AbsoluteLayout;
        layout_width="match_parent";
        layout_height="2%h";
        {
          LinearLayout;
          layout_height="2%h";
          backgroundColor="#000000";
          layout_width="match_parent";
          layout_y="0";
          {
            LinearLayout;
            layout_width="match_parent";
            backgroundColor="#F08080";
            layout_margin="0.1%h";
            layout_height="1.8%h";
            {
              TextView;
              id="血条";
              text="";
              layout_height="100%h";
              TextSize="1sp";
              backgroundColor="#FF0000";
            };
          };
        };
        {
          RelativeLayout;
          gravity="center";
          layout_width="match_parent";
          layout_height="match_parent";
          {
            TextView;
            id="血量显示";
            TextSize="3.5sp";
            textColor="#000000";
            text="100/400";
          };
        };
      };
      {
        AbsoluteLayout;
        layout_marginTop="0.3%h";
        layout_width="match_parent";
        layout_height="2%h";
        {
          LinearLayout;
          layout_height="2%h";
          backgroundColor="#000000";
          layout_width="match_parent";
          layout_y="0";
          {
            LinearLayout;
            layout_width="match_parent";
            backgroundColor="#87CEEB";
            layout_margin="0.1%h";
            layout_height="1.8%h";
            {
              TextView;
              id="蓝条";
              TextSize="1sp";
              layout_height="100%h";
              text="";
              backgroundColor="#0000FF";
            };
          };
        };
        {
          RelativeLayout;
          gravity="center";
          layout_width="match_parent";
          layout_height="match_parent";
          {
            TextView;
            id="法力显示";
            TextSize="3.5sp";
            textColor="#000000";
            text="100/400";
          };
        };
      };
    };
  };
  savelay.bt[2] = {}
  savelay.bt[3] = LuaAdapter(activity,savelay.bt[2],zhandou)
  local dren = {
    LinearLayout;
    orientation="vertical";
    layout_width="fill";
    layout_height="7.8%h";
    {
      LinearLayout;
      layout_marginRight="1%h";
      layout_gravity="end";
      layout_width="40.4%w";
      orientation="vertical";
      layout_height="7.2%h";
      {
        LinearLayout;
        orientation="vertical";
        layout_width="match_parent";
        layout_height="3%h";
        {
          TextView;
          id="名称境界";
          text="名字没怎么怎么这么早";
          textColor="#000000";
          textSize=getsize(8);
          layout_gravity="center";
        };
        {
          TextView;
          textSize=getsize(7);
          textColor="#FF0000";
          text="境界";
          layout_gravity="center";
        };
      };
      {
        AbsoluteLayout;
        layout_width="match_parent";
        layout_height="2%h";
        {
          LinearLayout;
          layout_height="2%h";
          backgroundColor="#000000";
          layout_width="match_parent";
          layout_y="0";
          {
            LinearLayout;
            layout_width="match_parent";
            backgroundColor="#F08080";
            layout_margin="0.1%h";
            layout_height="1.8%h";
            {
              TextView;
              id="血条";
              text="";
              layout_height="100%h";
              TextSize="1sp";
              backgroundColor="#FF0000";
            };
          };
        };
        {
          RelativeLayout;
          gravity="center";
          layout_width="match_parent";
          layout_height="match_parent";
          {
            TextView;
            id="血量显示";
            TextSize="3.5sp";
            textColor="#000000";
            text="100/400";
          };
        };
      };
      {
        AbsoluteLayout;
        layout_marginTop="0.3%h";
        layout_width="match_parent";
        layout_height="2%h";
        {
          LinearLayout;
          layout_height="2%h";
          backgroundColor="#000000";
          layout_width="match_parent";
          layout_y="0";
          {
            LinearLayout;
            layout_width="match_parent";
            backgroundColor="#87CEEB";
            layout_margin="0.1%h";
            layout_height="1.8%h";
            {
              TextView;
              id="蓝条";
              TextSize="1sp";
              layout_height="100%h";
              text="";
              backgroundColor="#0000FF";
            };
          };
        };
        {
          RelativeLayout;
          gravity="center";
          layout_width="match_parent";
          layout_height="match_parent";
          {
            TextView;
            id="法力显示";
            TextSize="3.5sp";
            textColor="#000000";
            text="100/400";
          };
        };
      };
    };
  };
  savelay.bt[4] = {}
  savelay.bt[5] = LuaAdapter(activity,savelay.bt[4],dren)
  local item5 = {
    FrameLayout;
    layout_width="match_parent";
    backgroundColor="#FFFFFF";
    {
      TextView;
      id="zdxx";
      TextSize=getsize(6);
    };
  }
  savelay.bt[6] = {}
  savelay.bt[7] = LuaAdapter(activity,savelay.bt[6],item5)
  savelay.gw = loadlayout{
    LinearLayout;
    orientation="vertical";
    layout_width="fill";
    layout_height="fill";
    {
      LinearLayout;
      orientation="vertical";
      layout_width="match_parent";
      layout_height="match_parent";
      backgroundColor="#FFFFFF";
      {
        LinearLayout;
        layout_width="match_parent";
        layout_height="4%h";
        backgroundColor="#000000";
        {
          TextView;
          textSize=getsize(15);
          textColor="#FFFFFF";
          text="交互面板";
        };
      };
      {
        LinearLayout;
        layout_width="match_parent";
        layout_height="20%h";
        {
          TextView;
          text="人物信息";
          textColor="#000000";
          id="gwxin";
        };
      };
      {
        LinearLayout;
        orientation="horizontal";
        layout_width="match_parent";
        {
          CardView;
          id="zrzd";
          layout_width="13%w";
          layout_marginLeft="1%h";
          layout_height="4.5%h";
          backgroundColor="#FF0000";
          {
            LinearLayout;
            layout_width="match_parent";
            layout_height="match_parent";
            backgroundColor="#FFFFFF";
            layout_margin="0.4%w";
            {
              CardView;
              layout_width="match_parent";
              layout_height="match_parent";
              backgroundColor="#000000";
              layout_margin="0.4%w";
              {
                TextView;
                text="攻击";
                textColor="#FF0000";
                layout_gravity="center";
              };
            };
          };
        };
        {
          CardView;
          id="gwlk";
          layout_width="13%w";
          layout_marginLeft="33%h";
          layout_height="4.5%h";
          backgroundColor="#000000";
          {
            LinearLayout;
            layout_width="match_parent";
            layout_height="match_parent";
            backgroundColor="#FFFFFF";
            layout_margin="0.4%w";
            {
              CardView;
              layout_width="match_parent";
              layout_height="match_parent";
              backgroundColor="#000000";
              layout_margin="0.4%w";
              {
                TextView;
                text="离开";
                textColor="#FFFFFF";
                layout_gravity="center";
              };
            };
          };
        };
      };
    };
  }
  local wd = {
    LinearLayout;
    layout_height="fill";
    orientation="vertical";
    layout_width="fill";
    {
      LinearLayout;
      layout_height="match_parent";
      orientation="vertical";
      backgroundColor="#FFFFFF";
      layout_width="match_parent";
      {
        LinearLayout;
        layout_height="4%h";
        backgroundColor="#000000";
        layout_width="match_parent";
        {
          TextView;
          textColor="#FFFFFF";
          textSize="15sp";
          text="战斗结束";
        };
      };
      {
        LinearLayout;
        layout_height="wrap";
        layout_width="match_parent";
        {
          TextView;
          id="zdxxa";
          layout_marginTop="2%w";
          layout_marginLeft="8%w";
          textColor="#000000";
        };
      };
      {
        FrameLayout;
        layout_width="match_parent";
        {
          FrameLayout;
          layout_width="match_parent";
          {
            FrameLayout;
            id="zdqra";
            layout_height="4.5%h";
            backgroundColor="#000000";
            layout_gravity="end";
            layout_width="13%w";
            {
              FrameLayout;
              layout_height="match_parent";
              layout_margin="0.4%w";
              backgroundColor="#FFFFFF";
              layout_width="match_parent";
              {
                FrameLayout;
                layout_height="match_parent";
                layout_margin="0.4%w";
                backgroundColor="#000000";
                layout_width="match_parent";
                {
                  TextView;
                  textColor="#FFFFFF";
                  layout_gravity="center";
                  text="确定";
                };
              };
            };
          };
        };
        {
          FrameLayout;
          layout_width="match_parent";
          {
            FrameLayout;
            id="zdsha";
            layout_height="4.5%h";
            backgroundColor="#000000";
            layout_gravity="start";
            layout_width="13%w";
            {
              FrameLayout;
              layout_height="match_parent";
              layout_margin="0.4%w";
              backgroundColor="#FFFFFF";
              layout_width="match_parent";
              {
                FrameLayout;
                layout_height="match_parent";
                layout_margin="0.4%w";
                backgroundColor="#000000";
                layout_width="match_parent";
                {
                  TextView;
                  textColor="#FFFFFF";
                  layout_gravity="center";
                  text="详情";
                };
              };
            };
          };
        };
      };
    };
  };
  savelay.zdif=loadlayout(wd)
  savelay.tc = AlertDialog.Builder(this)
end

function 加群(群号)
  import "android.content.Intent"
  import "android.net.Uri"
  activity.startActivity(Intent(Intent.ACTION_VIEW,Uri.parse("mqqapi://card/show_pslcard?src_type=internal&version=1&uin="..群号.."&card_type=group&source=qrcode")))
end

function popno(tx)
  if type(tx) == "table" then
    tx = loadlayout(tx)
  end
  local pwpp = PopupWindow(activity)--创建PopWindow
  pwpp.setContentView(tx)--设置布局
  pwpp.setWidth(activity.Width)--设置宽度
  pwpp.setHeight(activity.Height)--设置高度
  pwpp.setFocusable(false)--设置可获得焦点
  pwpp.getBackground().setAlpha(0)
  pwpp.setTouchable(true)--设置可触摸
  --设置点击外部区域是否可以消失
  pwpp.setOutsideTouchable(false)
  --显示
  pwpp.showAtLocation(view,Gravity.CENTER,0,0)
  return pwpp
end

function popyes(tx)
  if type(tx) == "table" then
    tx = loadlayout(tx)
  end
  local pwpp = PopupWindow(activity)--创建PopWindow
  pwpp.setContentView(tx)--设置布局
  pwpp.setWidth(-2)--设置宽度
  pwpp.setHeight(-2)--设置高度
  pwpp.setFocusable(true)--设置可获得焦点
  pwpp.getBackground().setAlpha(0)
  pwpp.setTouchable(true)--设置可触摸
  --设置点击外部区域是否可以消失
  pwpp.setOutsideTouchable(true)
  --显示
  pwpp.showAtLocation(view,Gravity.CENTER,0,0)
  return pwpp
end

function poppb(tx)
  if type(tx) == "table" then
    tx = loadlayout(tx)
  end
  local pwpp = PopupWindow(activity)--创建PopWindow
  pwpp.setContentView(tx)--设置布局
  pwpp.setWidth(activity.Width*0.9)--设置宽度
  pwpp.setHeight(-2)--设置高度
  pwpp.setFocusable(false)--设置可获得焦点
  pwpp.getBackground().setAlpha(0)
  pwpp.setTouchable(true)--设置可触摸
  --设置点击外部区域是否可以消失
  pwpp.setOutsideTouchable(false)
  --显示
  pwpp.showAtLocation(view,Gravity.CENTER,0,0)
  return pwpp
end

function 关闭加载框(ly)
  ly.dismiss()
end

local uuu
function 弹框(xx,bt,fun)
  if uuu ~= nil then
    uuu.dismiss()
  end
  uuu = AlertDialog.Builder(this)
  .setTitle(bt)
  .setMessage(xx)
  .setPositiveButton("取消",nil)
  .setNegativeButton("确认",{onClick=fun})
  .show();
end

function badword(text)
  local br = true
  for k,v in pairs(mgtb) do
    if string.find(v,text) then
      text = "狗蛋"
      br = false
      break
    end
  end
  return text,br
end

function StoryCondition(tb)
  local br = true
  if tb ~= nil then
    for k,v in pairs(tb) do
      if v.key == "should_kill" then
        if SaveTable["击杀"] == nil then
          SaveTable["击杀"] = {}
        end
        if SaveTable["击杀"][v.value.key] == nil or SaveTable["击杀"][v.value.key] < v.value.number then
          br = false
        end
       elseif v.key == "level_more_than" then
        if SaveTable.owner.level < v.value then
          br = false
        end
       elseif v.key == "should_finish_story" then
        if SaveTable.finish_story == nil then
          SaveTable.finish_story = {}
        end
        if SaveTable.finish_story[v.value.key] == nil or SaveTable.finish_story[v.value.key] < v.value.number then
          br = false
        end
       elseif v.key == "should_finish_task" then
        if SaveTable.finishtask == nil then
          SaveTable.finishtask = {}
        end
        if SaveTable.finishtask[v.value.key] == nil or SaveTable.finishtask[v.value.key] < v.value.number then
          br = false
        end
       elseif v.key == "cost_time" then
        if SaveTable["刷新"][v.value] ~= nil then
          br = false
        end
      end
    end
  end
  return br
end
function MD提示(文本)
  local ppp = {
    RelativeLayout;
    layout_height="fill";
    layout_width="fill";
    gravity="bottom";
    {
      RelativeLayout;
      id="popt";
      layout_width="match_parent";
      layout_height="match_parent";
      gravity="center";
    };
  };
  local pop=PopupWindow(activity)--创建PopWindow
  pop.setContentView(loadlayout(ppp))--设置布局
  pop.setWidth(activity.Width)--设置宽度
  pop.setHeight(activity.Height)--设置高度
  pop.setFocusable(false)--设置可获得焦点
  pop.getBackground().setAlpha(0)
  pop.setTouchable(false)--设置可触摸
  --设置点击外部区域是否可以消失
  pop.setOutsideTouchable(false)
  --显示
  pop.showAtLocation(view,0,0,0)
  local dly
  local nowtime = os.clock()
  import "android.view.animation.DecelerateInterpolator"
  import "android.view.animation.Animation"
  import "android.animation.ObjectAnimator"
  if (mdtime ~= nil and nowtime - mdtime < 1) then
    dly=(nowtime - mdtime)*2000
   else
    dly=3000
  end
  mdtime=os.clock()
  local tcxx={
    LinearLayout;--线性布局
    id="move";
    orientation='vertical';--布局方向
    layout_width='wrap';--布局宽度
    layout_height='wrap';--布局高度
    {
      CardView;--卡片控件
      layout_width='wrap';--卡片宽度
      layout_height='wrap';--卡片高度
      CardBackgroundColor='#aaeeeeee';--卡片颜色
      elevation=0;--阴影属性
      radius='19dp';--卡片圆角
      {
        TextView;
        layout_width="wrap";--布局宽度
        layout_height="wrap";--布局高度
        background="#FFFFFF";--背景颜色
        padding="8dp";--布局填充
        textSize=getsize(15);--文字大小
        TextColor="#000000";--文字颜色
        layout_gravity="center";--布局居中
        id="wenzi";--控件ID
      };
    };
  };
  popt.addView(loadlayout(tcxx))
  wenzi.Text=文本
  local a = ObjectAnimator.ofFloat(move, "Y",{activity.Height*0.7, activity.Height*0.5})
  a.setInterpolator(DecelerateInterpolator())
  a.setDuration(5000)
  a.start()
  task(3000,function pop.dismiss() end)
end
function 窗口标题(text)
  activity.setTitle(text)
end

function 载入界面(id)
  activity.setContentView(loadlayout(id))
end

function 隐藏标题栏()
  activity.ActionBar.hide()
end

function 设置主题(id)
  activity.setTheme(id)
end

function 打印(text)
  print(text)
end

function 窗口全屏()
  activity.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,WindowManager.LayoutParams.FLAG_FULLSCREEN)
end

function 取消全屏()
  activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
end

function 返回桌面()
  activity.moveTaskToBack(true)
end

function 提示(文本)
  local tcxx={
    LinearLayout;--线性布局
    orientation='vertical';--布局方向
    layout_width='fill';--布局宽度
    layout_height='fill';--布局高度
    {
      CardView;--卡片控件
      layout_width='wrap';--卡片宽度
      layout_height='wrap';--卡片高度
      CardBackgroundColor='#aaeeeeee';--卡片颜色
      elevation=0;--阴影属性
      radius='19dp';--卡片圆角
      {
        TextView;
        layout_width="wrap";--布局宽度
        layout_height="wrap";--布局高度
        background="#FFFFFF";--背景颜色
        padding="8dp";--布局填充
        textSize="15sp";--文字大小
        TextColor="#000000";--文字颜色
        gravity="center";--布局居中
        id="wenzi";--控件ID
      };
    };
  };
  local toast=Toast.makeText(activity,"文本",Toast.LENGTH_SHORT).setView(loadlayout(tcxx))
  toast.setGravity(Gravity.BOTTOM,0,240)
  wenzi.Text=文本
  toast.show()
end

function 截取文本(str,str1,str2)
  str1=str1:gsub("%p",function(s) return("%"..s) end)
  return str:match(str1 .. "(.-)"..str2)
end

function 替换文本(str,str1,str2)
  str1=str1:gsub("%p",function(s) return("%"..s) end)
  str2=str2:gsub("%%","%%%%")
  return str:gsub(str1,str2)
end

function 字符串长度(str)
  return utf8.len(str)
end

function 状态栏颜色(color)
  if Build.VERSION.SDK_INT >= 21 then
    activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS).setStatusBarColor(color);
  end
end

function 沉浸状态栏()
  if Build.VERSION.SDK_INT >= 19 then
    activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
  end
end

function 设置文本(id,text)
  id.Text=text
end

function 跳转页面(name)
  activity.newActivity(name)
end

function 关闭页面()
  activity.finish()
end

function 获取文本(id)
  return id.Text
end

function 结束程序()
  activity.finish()
end

function 重构页面()
  activity.recreate()
end

function 控件圆角(view,InsideColor,radiu)
  import "android.graphics.drawable.GradientDrawable"
  drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setColor(InsideColor)
  drawable.setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu});
  view.setBackgroundDrawable(drawable)
end

function 获取设备标识码()
  import "android.provider.Settings$Secure"
  return Secure.getString(activity.getContentResolver(), Secure.ANDROID_ID)
end

function 获取IMEI()
  import "android.content.Context"
  return activity.getSystemService(Context.TELEPHONY_SERVICE).getDeviceId()
end

function 控件背景渐变动画(view,color1,color2,color3,color4)
  import "android.animation.ObjectAnimator"
  import "android.animation.ArgbEvaluator"
  import "android.animation.ValueAnimator"
  import "android.graphics.Color"
  colorAnim = ObjectAnimator.ofInt(view,"backgroundColor",{color1, color2, color3,color4})
  colorAnim.setDuration(3000)
  colorAnim.setEvaluator(ArgbEvaluator())
  colorAnim.setRepeatCount(ValueAnimator.INFINITE)
  colorAnim.setRepeatMode(ValueAnimator.REVERSE)
  colorAnim.start()
end

function 获取屏幕尺寸(ctx)
  import "android.util.DisplayMetrics"
  dm = DisplayMetrics();
  ctx.getWindowManager().getDefaultDisplay().getMetrics(dm);
  diagonalPixels = Math.sqrt(Math.pow(dm.widthPixels, 2) + Math.pow(dm.heightPixels, 2));
  return diagonalPixels / (160 * dm.density);
end

function 是否安装APP(packageName)
  if pcall(function() activity.getPackageManager().getPackageInfo(packageName,0) end) then
    return true
   else
    return false
  end
end

function 设置中划线(id)
  import "android.graphics.Paint"
  id.getPaint().setFlags(Paint. STRIKE_THRU_TEXT_FLAG)
end

function 设置下划线(id)
  import "android.graphics.Paint"
  id.getPaint().setFlags(Paint. UNDERLINE_TEXT_FLAG)
end

function 设置字体加粗(id)
  import "android.graphics.Paint"
  id.getPaint().setFakeBoldText(true)
end

function 设置斜体(id)
  import "android.graphics.Paint"
  id.getPaint().setTextSkewX(0.2)
end

function 分享内容(text)
  intent=Intent(Intent.ACTION_SEND);
  intent.setType("text/plain");
  intent.putExtra(Intent.EXTRA_SUBJECT, "分享");
  intent.putExtra(Intent.EXTRA_TEXT, text);
  intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
  activity.startActivity(Intent.createChooser(intent,"分享到:"));
end

function 加QQ群(qq)
  import "android.net.Uri"
  import "android.content.Intent"
  activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("mqqapi://card/show_pslcard?src_type=internal&version=1&uin="..qq.."&card_type=group&source=qrcode")))
end

function QQ聊天(qq)
  import "android.net.Uri"
  import "android.content.Intent"
  activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("mqqwpa://im/chat?chat_type=wpa&uin="..qq)))
end

function 发送短信(phone,text)
  require "import"
  import "android.telephony.*"
  SmsManager.getDefault().sendTextMessage(tostring(phone), nil, tostring(text), nil, nil)
end

function 获取剪切板()
  import "android.content.Context"
  return activity.getSystemService(Context.CLIPBOARD_SERVICE).getText()
end

function 写入剪切板(text)
  import "android.content.Context"
  activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(text)
end

function 开启WIFI()
  import "android.content.Context"
  wifi = activity.Context.getSystemService(Context.WIFI_SERVICE)
  wifi.setWifiEnabled(true)
end

function 关闭WIFI()
  import "android.content.Context"
  wifi = activity.Context.getSystemService(Context.WIFI_SERVICE)
  wifi.setWifiEnabled(false)
end

function 断开网络()
  import "android.content.Context"
  wifi = activity.Context.getSystemService(Context.WIFI_SERVICE)
  wifi.disconnect()
end

function 创建文件(file)
  import "java.io.File"
  return File(file).createNewFile()
end

function 创建文件夹(file)
  import "java.io.File"
  return File(file).mkdir()
end

function 创建多级文件夹(file)
  import "java.io.File"
  return File(file).mkdirs()
end

function 移动文件(file,file2)
  import "java.io.File"
  return File(file).renameTo(File(file2))
end

function 写入文件(file,text)
  return io.open(file,"w"):write(text):close()
end

function 设置按钮颜色(id,color)
  id.getBackground().setColorFilter(PorterDuffColorFilter(color,PorterDuff.Mode.SRC_ATOP))
end

function 设置编辑框颜色(id,color)
  id.getBackground().setColorFilter(PorterDuffColorFilter(color,PorterDuff.Mode.SRC_ATOP));
end

function 设置进度条颜色(id,color)
  id.IndeterminateDrawable.setColorFilter(PorterDuffColorFilter(color,PorterDuff.Mode.SRC_ATOP))
end

function 设置控件颜色(id,color)
  id.setBackgroundColor(color)
end

function 获取手机存储路径()
  return Environment.getExternalStorageDirectory().toString()
end

function 获取屏幕宽()
  return activity.getWidth()
end

function 获取屏幕高()
  return activity.getHeight()
end

function 文件是否存在(file)
  return File(file).exists()
end

function 关闭左侧滑(id)
  id.closeDrawer(3)
end

function 打开左侧滑()
  id.openDrawer(3)
end

function 显示控件(id)
  id.setVisibility(0)
end

function 隐藏控件(id)
  id.setVisibility(8)
end

function 播放本地音乐(url)
  import "android.content.Intent"
  import "android.net.Uri"
  intent = Intent(Intent.ACTION_VIEW)
  uri = Uri.parse("file://"..url)
  intent.setDataAndType(uri, "audio/mp3")
  this.startActivity(intent)
end

function 在线播放音乐(url)
  import "android.content.Intent"
  import "android.net.Uri"
  intent = Intent(Intent.ACTION_VIEW)
  uri = Uri.parse(url)
  intent.setDataAndType(uri, "audio/mp3")
  this.startActivity(intent)
end

function 播放本地视频(url)
  import "android.content.Intent"
  import "android.net.Uri"
  intent = Intent(Intent.ACTION_VIEW)
  uri = Uri.parse("file://"..url)
  intent.setDataAndType(uri, "video/mp4")
  activity.startActivity(intent)
end

function 在线播放视频(url)
  import "android.content.Intent"
  import "android.net.Uri"
  intent = Intent(Intent.ACTION_VIEW)
  uri = Uri.parse(url)
  intent.setDataAndType(uri, "video/mp4")
  activity.startActivity(intent)
end

function 打开APP(packageName)
  import "android.content.Intent"
  import "android.content.pm.PackageManager"
  manager = activity.getPackageManager()
  open = manager.getLaunchIntentForPackage(packageName)
  this.startActivity(open)
end

function 卸载APP(file)
  import "android.net.Uri"
  import "android.content.Intent"
  uri = Uri.parse("package:"..file)
  intent = Intent(Intent.ACTION_DELETE,uri)
  activity.startActivity(intent)
end

function 安装APP(file)
  import "android.content.Intent"
  import "android.net.Uri"
  intent = Intent(Intent.ACTION_VIEW)
  intent.setDataAndType(Uri.parse("file://"..file), "application/vnd.android.package-archive")
  intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
  activity.startActivity(intent)
end

function 系统下载文件(url,directory,name)
  import "android.content.Context"
  import "android.net.Uri"
  downloadManager=activity.getSystemService(Context.DOWNLOAD_SERVICE);
  url=Uri.parse(url);
  request=DownloadManager.Request(url);
  request.setAllowedNetworkTypes(DownloadManager.Request.NETWORK_MOBILE|DownloadManager.Request.NETWORK_WIFI);
  request.setDestinationInExternalPublicDir(directory,name);
  request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
  downloadManager.enqueue(request);
end

function 弹窗1(title,content,text,fun)
  dialog=AlertDialog.Builder(this)
  .setTitle(title)
  .setMessage(content)
  .setPositiveButton(text,{onClick=fun})
  .show()
  dialog.create()
end

function 波纹(id,color)
  import "android.content.res.ColorStateList"
  local attrsArray = {android.R.attr.selectableItemBackgroundBorderless}
  local typedArray =activity.obtainStyledAttributes(attrsArray)
  ripple=typedArray.getResourceId(0,0)
  aoos=activity.Resources.getDrawable(ripple)
  aoos.setColor(ColorStateList(int[0].class{int{}},int{color}))
  id.setBackground(aoos.setColor(ColorStateList(int[0].class{int{}},int{color})))
end

function 随机数(min,max)
  return math.random(min,max)
end

function 删除控件(id,id2)
  return (id).removeView(id2)
end

function 状态栏亮色()
  if Build.VERSION.SDK_INT >= 23 then
    activity.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
  end
end