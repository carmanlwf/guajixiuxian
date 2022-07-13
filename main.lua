require "import"
import "AndLua"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "GetItem"
import "GetAttribute"
import "getskill"
import "android.text.Html"
import "http"
import "BattleFiled"
import "itemonresult"
import "shop"
import "paihang"
import "paimai"
import "shouce"
import "bmob"
import "time"
import "pet"
import "offget"
import "java.io.File"
import "chuanshu"
import "loadmap"
import "liandan"
import "lianqi"
import "daoru"
import "npcshop"
import "setting"
import "sys"
import "badWords"
import "lei"
import "yun"
import "binjie"
import "baitan"
import "libao"
import "zongmen"
import "commonHelper"

local bag
local cheak
local cjson=import "cjson"
local id="7ae633a369a78cf8355607124387a410" --Application ID
local key="4a2f4b51681f7ca185b828f949b49bba" --REST API Key
local b=bmob(id,key)
--登录()

if savelay == nil then
  加载布局()
end

back=false

thread(function()
  while true do
    require "import"
    import "java.net.NetworkInterface"
    import "java.util.Collections"
    import "java.util.Enumeration"
    import "java.util.Iterator"
    local niList = NetworkInterface.getNetworkInterfaces()
    if niList ~= nil then
      local it = Collections.list(niList).iterator()
      while it.hasNext() do
        local intf = it.next()
        if intf.isUp() and intf.getInterfaceAddresses().size() ~= 0 then
          if String("tun0").equals(intf.getName()) or String("ppp0").equals(intf.getName()) then
            os.exit()
            back = true
           else
            --print("未开启VPN")
            back = false
          end
        end
      end
    end
    Thread.sleep(1000)
  end
end)

function loadqiyu(num)
  b:query("qiyu",nil,function(r,p)
    if r >= 200 and r <= 400 then
      local tab = p.results
      qiyu = {}
      for k,v in pairs(tab) do
        if qiyu[v.map] == nil then
          qiyu[v.map] = {v}
         else
          table.insert(qiyu[v.map],v)
        end
      end
     else
      task(5000,function loadqiyu()
      end)
    end
  end)
end
--loadqiyu()
local a

--Http.get("http://api.k780.com/?app=life.time&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json",nil,nil,nil,function(a,b,c,d)
--local data = cjson.decode(b);
--MD提示(data["result"]["timestamp"])
--if data["result"]["timestamp"] then
--MD提示("成功")
--end
--end)
战斗停止 = true

--if activity.getPackageName() ~= "com.guaji.xiuxianzhuan" then
--activity.finish()
--end
local Item = import "item"
local 境界 = import "tupo"
local dh = import "duihua"
local 资源 = import "resource"
local luji1 = "sdcard/Android/xiuxian/"..activity.getPackageName().."/files/save/savedata"
local luji2 = activity.getLuaDir().."/backup/bug"
local luji = activity.getLuaDir().."/save/savedata"
local cklj = "/sdcard/browser/MediaCache/exoplayer-cache/cheak"
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
function 环境检测()
  if cheak ~= nil and cheak.Period ~= 5000 then
    SaveTable.作弊 = 1
  end
  local brr = false
  local function hasRoot()
    import "com.androlua.util.RootUtil"
    local root = RootUtil()
    return root.haveRoot()
  end
  if not hasRoot() then
    local tr = {"/su", "/su/bin/su", "/sbin/su",
      "/data/local/xbin/su", "/data/local/bin/su", "/data/local/su",
      "/system/xbin/su",
      "/system/bin/su", "/system/sd/xbin/su", "/system/bin/failsafe/su",
      "/system/bin/cufsdosck", "/system/xbin/cufsdosck", "/system/bin/cufsmgr",
      "/system/xbin/cufsmgr", "/system/bin/cufaevdd", "/system/xbin/cufaevdd",
      "/system/bin/conbb", "/system/xbin/conbb","/data/user/0/com.guaji.xiuxianzhuan/app_x8zsdex/classes.dex"}
    for k,v in pairs(tr) do
      if File(v).isFile() then
        brr = true
        break
      end
    end
   else
    brr = true
  end
  if string.find(tostring(activity.getLuaDir()),"tap") ~= nil and SaveTable.cheak ~= nil and SaveTable.tap == nil then
    SaveTable.作弊 = nil
    SaveTable.tap = 1
  end
  if not brr then
    if activity.getLuaDir() ~= "/data/user/0/com.guaji.xiuxianzhuan/files" and string.find(tostring(activity.getLuaDir()),"tap") == nil then
      brr = true
    end
  end
  if brr then
    SaveTable.作弊 = 1
  end
end
local a
activity.setContentView(MapUI()["菜单"])

local 品级 = {"黄阶下品","黄阶中品","黄阶上品","玄阶下品","玄阶中品","玄阶上品","地阶下品","地阶中品","地阶上品","天阶下品","天阶中品","天阶上品","仙品"}

function upeqdatas(v)
  local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中","神念消耗","材料消耗","成丹率","成功率","出丹率","评分提升","属性品质","获取经验"}
  local pt = {}
  local num = 0
  for n,m in pairs(tab) do
    if v[m] ~= nil then
      num = num + v[m]
      table.insert(pt,v[m])
    end
  end
  local num1 = math.floor((num/(#pt*2))*100)
  if num1 > 120 then
    num1 = 120
  end
  return num1
end

function upeqdata(v)
  local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中","神念消耗","材料消耗","成丹率","成功率","出丹率","评分提升","属性品质","获取经验"}
  local pt = {}
  local itb = Item:GetTable(v.key)
  local num = 0
  for n,m in pairs(tab) do
    if v[m] ~= nil then
      num = num + v[m]/itb[m]
      table.insert(pt,itb[m])
    end
  end
  local num1 = math.floor((num/(#pt*2))*100)
  if num1 > 120 then
    num1 = 120
  end
  return num1
end

function leixin(yy)
  return type(yy)
end

function 更新面板()
  if SaveTable["战功"] == nil then
    SaveTable["战功"] = 0
  end
  if SaveTable.age == nil then
    SaveTable.age = os.time()
  end
  local nage = os.time() - SaveTable.age
  while nage >= 14400 do
    nage = nage - 14400
    SaveTable.owner["年龄"] = SaveTable.owner["年龄"] + 1
    SaveTable.age = SaveTable.age + 14400
  end
  SaveTable.owner.Attribute = Item:GetTirgger(SaveTable.owner)
  道号.Text=table.concat({SaveTable.owner.key})
  jj.Text=table.concat({境界[SaveTable.owner.level]["境界"]})
  nl.Text=table.concat({math.ceil(SaveTable.owner["年龄"]),"岁"})
  sy.Text=table.concat({math.ceil(SaveTable.owner["寿元"]),"年"})
  xl.Text=Html.fromHtml(table.concat({GetColor(SaveTable.owner.Attribute["气血上限"],Color.red)}))
  fl.Text=Html.fromHtml(table.concat({GetColor(SaveTable.owner.Attribute["法力上限"],Color.blue)}))
  xw.Text=table.concat({math.ceil(SaveTable.owner["修为"])})
  ls.Text=table.concat({math.ceil(SaveTable.owner.money)})
end

function 提取角色()
  local tb = cjson.encode(SaveTable.owner)
  import "android.content.*"
  activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(tb)
  提示("提取成功")
end

function onKeyDown(code,event)
  if string.find(tostring(event),"KEYCODE_BACK") ~= nil then
    if SaveTable ~= nil then
      if SaveTable.zt ~= nil then
        SaveTable.zt = nil
        saveloadfile("主界面")
      end
    end
  end
  return true
end

function qunhao()
  import "android.net.Uri"
  import "android.content.Intent"
  url="mqqapi://card/show_pslcard?src_type=internal&version=1&uin=962120920&card_type=group&source=qrcode"
  activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
end

function GetFilelastTime(path)
  f = File(path);
  cal = Calendar.getInstance();
  time = f.lastModified()
  cal.setTimeInMillis(time);
  return time
end

function 适配()
  local bjjja = {
    LinearLayout;
    layout_width="fill";
    orientation="vertical";
    id="布局";
    layout_height="fill";
    {
      TextView;
      backgroundColor="#000000";
      text="";
      id="控件";
      TextSize="1sp";
    };
  };
  activity.setContentView(loadlayout(bjjja))
  import "android.content.Context"

  function getwh(view)
    view.measure(View.MeasureSpec.makeMeasureSpec(0,View.MeasureSpec.UNSPECIFIED),View.MeasureSpec.makeMeasureSpec(0,View.MeasureSpec.UNSPECIFIED));
    height =view.getMeasuredHeight();
    width =view.getMeasuredWidth();
    return width,height
  end
  function getScreenPhysicalSize(ctx)
    import "android.util.DisplayMetrics"
    dm = DisplayMetrics();
    ctx.getWindowManager().getDefaultDisplay().getMetrics(dm);
    return dm.widthPixels,dm.heightPixels
  end
  local x = activity.getWidth()
  x = x*0.4
  --调用方法
  local p = getwh(控件)
  local str=""
  while p < x do
    str=table.concat({str," "})
    控件.Text=str
    p = getwh(控件)
  end
  SaveTable.shipei = #str
end

function EqLevel(key,level)
  level = level or 0
  if level > 0 then
    return table.concat({key,"[",math.ceil(level),"转]"})
   else
    return key
  end
end

function EqAddFloat(key,num)
  for k,v in pairs(SaveTable.owner.eq) do
    if key == v.key then
      v.level = v.level + num
      break
    end
  end
end


function HasItem(key,num)
  local br
  for k,v in pairs(SaveTable.Item) do
    if key == v.key then
      if v.number >= num then
        br = true
      end
      break
    end
  end
  return br
end

function DeleteItem(key,num)
  for k,v in pairs(SaveTable.Item) do
    if key == v.key then
      if v.number > num then
        v.number = v.number - num
       else
        table.remove(SaveTable.Item,k)
      end
      break
    end
  end
end

function SkillColor(str,lv)
  if lv >= 13 then
    str="<font color="..Color.gold..">"..str.."</font>"
   elseif lv >= 10 then
    str="<font color="..Color.orange..">"..str.."</font>"
   elseif lv >= 7 then
    str="<font color="..Color.red..">"..str.."</font>"
   elseif lv >= 4 then
    str="<font color="..Color.blue..">"..str.."</font>"
   else
    str="<font color="..Color.green..">"..str.."</font>"
  end
  return str
end

function GetColor(str,co)
  if co == nil then
    co = "#000000"
  end
  str="<font color="..co..">"..str.."</font>"
  return str
end

function addxiuwei(lv)
  local x,y
  if lv > 32 then
    x = 20
    y = 300
   elseif lv > 28 then
    x = 15
    y = 200
   elseif lv > 24 then
    x = 10
    y = 160
   elseif lv > 20 then
    x = 8
    y = 100
   elseif lv > 16 then
    x = 5
    y = 60
   elseif lv > 12 then
    x = 3
    y = 40
   else
    x = 1
    y = 20
  end
  return x,y
end

function TriggerTable(mytable,t)
  local sp = split(Trigger["属性"][t["品质"]][mytable[1]],"#")
  local tb = {}
  for k,v in pairs(sp) do
    local sp1 = split(v,"|")
    local tab = {}
    for i=1,#sp1 do
      if tonumber(sp1[i]) then
        table.insert(tab,tonumber(sp1[i]))
       else
        table.insert(tab,sp1[i])
      end
    end
    table.insert(tb,tab)
  end
  local co
  for g,h in pairs(tb) do
    if mytable[2] <= h[2] then
      co = "#"..h[4]
      break
    end
  end
  return tb,co
end

function NetTime(time)
  local hour = math.floor(time/3600)
  local min = math.floor((time - hour * 3600)/60)
  return hour.."小时"..min.."分钟"
end

function GameTime(time)
  local year = math.floor(time/14400)
  local day = math.floor((time - year * 14400)*365/14400)
  return year.."年"..day.."天"
end

function probability(num)
  local num1 = math.random(0,1000000)
  return num*1000000 > num1
end

function 存档()
  loadsavewrite(0)
  MD提示("保存成功!")
end

function OffGame()
  AlertDialog.Builder(this)
  .setTitle("确认")
  .setMessage("确定要退出游戏吗？")
  .setPositiveButton("取消",nil)
  .setNegativeButton("确认",function os.exit() end)
  .show();
end

function split(str, reps)
  local resultStrsList = {};
  string.gsub(str, '[^' .. reps ..']+', function(w) table.insert(resultStrsList, w) end );
  return resultStrsList;
end

function huode()
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
      hint="请输入需要获得的物品";
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
      if shuru.Text == "销毁背包" then
        SaveTable.Item = nil
        MD提示("背包已销毁!")
       elseif shuru.Text == "恢复神念" then
        SaveTable.owner["神念"] = SaveTable.owner["神念上限"]
        MD提示("神念已恢复！")
       elseif shuru.Text == "恢复存档" then
        fp("http://82.157.62.200/huifu.php?",{id=解密("role/zh")},function(code,body)
          if code >= 200 and code <= 400 and body ~= "404" then
            local tb = cjson.decode(body)
            local tbl = cjson.decode(tb.data)
            tbl.Item = cjson.decode(tb.item)
            tbl.pet = cjson.decode(tb.pet)
            savedata(cjson.encode(tbl))
            提示("恢复成功")
           else
            提示("网络连接失败")
          end
        end)
       elseif shuru.Text == "创建背包" then
        SaveTable.Item = {}
        MD提示("背包创建成功!")
       elseif shuru.Text == "离线挂机" then
        SaveTable.off=0
       elseif shuru.Text == "解除修改" then
        SaveTable.cheak = nil
       elseif shuru.Text == "建档时间" then
        SaveTable.savetime = os.time() - 86400
       else
        local str = split(shuru.Text,"#")
        if str[1] == "载入剧情" then
          文字动画(str[2],1)
         elseif str[1] == "外挂" then
          for k,v in pairs(SaveTable.owner.eq) do
            v.level = tonumber(str[2])
          end
         elseif str[1] == "宠兽修为" then
          for k,v in pairs(SaveTable.pet) do
            v.修为 = tonumber(str[2])
          end
         elseif str[1] == "载入战斗" then
          载入战斗(str[2])
         elseif str[1] == "修改等级" then
          if type(tonumber(str[2])) == "number" then
            SaveTable.owner.level = tonumber(str[2])
          end
         elseif str[1] == "服务器" then
          SaveTable["服务器"] = str[2]
         elseif str[1] == "道心" then
          SaveTable.owner["道心"] = SaveTable.owner["道心"] + tonumber(str[2])
         elseif type(tonumber(str[2])) == "number" then
          Item:Add(str[1],tonumber(str[2]))
        end
      end
      --print(str[1],str[2])
  end})
  .setNegativeButton("取消",nil)
  .show()
end

--人物面板
local a1
function rolemenu(bb)
  if a1 ~= nil then
    a1.dismiss()
  end
  if bb == nil then
    a1=PopupWindow(activity)--创建PopWindow
    a1.setContentView(loadlayout(MapUI()["人物面板"]))--设置布局
    a1.setWidth(activity.Width*0.92)--设置宽度
    a1.setHeight(-2)
    a1.setFocusable(true)--设置可获得焦点
    a1.getBackground().setAlpha(0)
    a1.setTouchable(true)--设置可触摸
    --设置点击外部区域是否可以消失
    a1.setOutsideTouchable(false)
    --显示
    a1.showAtLocation(view,Gravity.CENTER,0,0)
  end
  function RoleSetUI()
    if SaveTable.age == nil then
      SaveTable.age = os.time()
    end
    local nage = os.time() - SaveTable.age
    while nage >= 14400 do
      nage = nage - 14400
      SaveTable.owner["年龄"] = SaveTable.owner["年龄"] + 1
      SaveTable.age = SaveTable.age + 14400
    end
    SaveTable.owner.Attribute = Item:GetTirgger(SaveTable.owner)
    姓名.Text = "姓名:"..SaveTable.owner.key
    道心.Text = "道心:"..math.ceil(SaveTable.owner["道心"])
    寿元.Text = "寿元:"..math.ceil(SaveTable.owner["年龄"]).."/"..math.ceil(SaveTable.owner["寿元"])
    xjs.Text = "境界:"..境界[SaveTable.owner.level]["境界"]
    体质.Text = "体质:"..math.ceil(SaveTable.owner.Attribute["体质"])
    真元.Text = "真元:"..math.ceil(SaveTable.owner.Attribute["真元"])
    身法.Text = "身法:"..math.ceil(SaveTable.owner.Attribute["身法"])
    肉身.Text = "肉身:"..math.ceil(SaveTable.owner.Attribute["肉身"])
    内攻.Text = "内攻:"..SaveTable.owner.Attribute["内攻"]
    外攻.Text = "外攻:"..SaveTable.owner.Attribute["外攻"]
    内防.Text = "内防:"..SaveTable.owner.Attribute["内防"]
    外防.Text = "外防:"..SaveTable.owner.Attribute["外防"]
    气血.Text = "气血:"..SaveTable.owner.Attribute["气血上限"]
    法力.Text = "法力:"..SaveTable.owner.Attribute["法力上限"]
    会心率.Text = "会心率:"..SaveTable.owner.Attribute["会心率"]
    抗会心率.Text = "抗会心率:"..SaveTable.owner.Attribute["抗会心率"]
    闪避.Text = "闪避:"..SaveTable.owner.Attribute["闪避"]
    命中.Text = "命中:"..SaveTable.owner.Attribute["命中"]
    会心伤害.Text = "会心伤害:"..SaveTable.owner.Attribute["会心伤害"].."%"
    会心免伤.Text = "会心免伤:"..SaveTable.owner.Attribute["会心免伤"].."%"
    最终伤害放大.Text = "最终伤害放大:"..SaveTable.owner.Attribute["最终伤害放大"].."%"
    最终伤害抵消.Text = "最终伤害抵消:"..SaveTable.owner.Attribute["最终伤害抵消"].."%"
    灵石.Text = "灵石:"..math.ceil(SaveTable.owner.money)
    属性点.Text = "可分配属性点:"..math.ceil(SaveTable.owner.Point)
    修为.Text = "修为:"..math.ceil(SaveTable.owner["修为"])
    战斗力.Text = "战斗力:"..math.ceil(SaveTable.owner.Attribute["内攻"]*2+SaveTable.owner.Attribute["外攻"]*2+SaveTable.owner.Attribute["内防"]*2.5+SaveTable.owner.Attribute["外防"]*2.5+SaveTable.owner.Attribute["气血上限"]*0.2+SaveTable.owner.Attribute["法力上限"]*0.1+SaveTable.owner.Attribute["会心率"]*2+SaveTable.owner.Attribute["抗会心率"]*2+SaveTable.owner.Attribute["闪避"]*2.5+SaveTable.owner.Attribute["命中"]*2.5+SaveTable.owner.Attribute["会心伤害"]*20+SaveTable.owner.Attribute["会心免伤"]*20+SaveTable.owner.Attribute["最终伤害放大"]*30+SaveTable.owner.Attribute["最终伤害抵消"]*30)
  end
  local d
  if bb == nil then
    function 开始修炼.onClick()
      local c
      if SaveTable.owner["修炼"].type == 0 or HasInskill(SaveTable.owner["修炼"].key) == false then
        local its = {
          LinearLayout;
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
                id="name";
              };
            };
          };
        };
        local 品阶 = {"黄阶初级","黄阶中级","黄阶高级","玄阶初级","玄阶中级","玄阶高级","地阶初级","地阶中级","地阶高级","天阶初级","天阶中级","天阶高级","仙经","仙阶中级","仙阶高级"}
        if d ~= nil then
          d.dismiss()
        end
        d=AlertDialog.Builder(this).show()
        d.getWindow().setContentView(loadlayout(MapUI()["修炼布局"]));
        local data={}
        local adp=LuaAdapter(activity,data,its)
        修炼选择.Adapter=adp
        local Inskill = import "inskill"
        local inSkillBox = Inskill:GetinSkillBox(SaveTable.owner.inskill)
        for k,v in pairs(inSkillBox) do
          table.insert(data,{name=Color:Set(v.key.."["..品阶[v["品质"]].."]",v["品质"])})
        end
        if #data == 0 then
          table.insert(data,{name="无"})
        end
        if #inSkillBox > 0 then
          local b
          修炼选择.onItemClick=function(l,v,p,i)
            local jm = {}
            for k,v in pairs(MapUI()["功法修炼"]) do
              jm[k] = v
            end
            jm[3][2] = {
              LinearLayout;
              orientation="vertical";
              layout_height="fill";
              layout_width="70%w";
              {
                TextView;
                text="功法名称";
                textSize=getsize(10);
                id="功法名称";
              };
              {
                TextView;
                text="功法等级";
                textSize=getsize(10);
                id="功法等级";
              };
              {
                TextView;
                text="功法熟练";
                textSize=getsize(10);
                id="功法熟练";
              };
              {
                TextView;
                text="功法效率";
                textSize=getsize(10);
                id="功法效率";
              };
              {
                TextView;
                text="功法介绍";
                textSize=getsize(10);
                id="功法介绍";
              };
              {
                TextView;
                text="功法属性";
                textSize=getsize(10);
                id="功法属性";
                textColor="#000000";
              };
              {
                TextView;
                text="功法特性:";
                textSize=getsize(10);
                id="功法特性";
                textColor="#000000";
              };
            };
            for k,v in pairs(inSkillBox[i].updata) do
              local file = "功法修炼至"..math.ceil(v.level).."重"
              for n,m in pairs(v.Attribute) do
                if n == "会心伤害" or n == "会心免伤" or n == "最终伤害放大" or n == "最终伤害抵消" or string.find(n,"基础") then
                  file=file..",提升"..n..m.."%"
                 elseif n=="气血上限" then
                  file=file..",提升气血上限"..m
                 elseif n=="法力上限" then
                  file=file..",提升法力上限"..m
                 else
                  file=file..",提升"..n..m.."点"
                end
              end
              if inSkillBox[i].level >= v.level then
                file=file.."[已达成]"
                local lt = {
                  TextView;
                  textSize=getsize(10);
                  text=file;
                  textColor="#000000";
                };
                jm[3][2][#jm[3][2]+1]=lt
               else
                file=file.."[未达成]"
                local lt = {
                  TextView;
                  textSize=getsize(10);
                  text=file;
                  textColor="#C6C6C6";
                };
                jm[3][2][#jm[3][2]+1]=lt
              end
            end
            jm[3][3]= {
              LinearLayout;
              orientation="vertical";
              layout_height="fill";
              layout_width="fill";
              {
                Button;
                text="修炼";
                id="修炼心法";
              };
            };
            if b ~= nil then
              b.dismiss()
            end
            b=AlertDialog.Builder(this).show()
            b.getWindow().setContentView(loadlayout(jm));
          --  local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中"}
            local exp = import "skillexp"
            local xlsp = math.ceil(inSkillBox[i]["修炼效率"]*((1+inSkillBox[i].step)^(inSkillBox[i].level-1))*1000)/10
            功法名称.Text=Color:Set(inSkillBox[i].key.."["..品阶[inSkillBox[i]["品质"]].."]",inSkillBox[i]["品质"])
            功法效率.Text=Color:Set("修炼效率:"..xlsp.."%",inSkillBox[i]["品质"])
            功法熟练.Text=Color:Set("当前熟练度:"..math.ceil(inSkillBox[i].exp).."/"..exp[inSkillBox[i]["品质"]][inSkillBox[i].level],inSkillBox[i]["品质"])
            功法等级.Text=Color:Set("当前已修炼至第"..math.ceil(inSkillBox[i].level).."重",inSkillBox[i]["品质"])
            功法介绍.Text=inSkillBox[i].Info.."\n"
            local str = "功法属性:\n"
            for k,v in pairs(tab) do
              if inSkillBox[i][v] then
                if v == "会心伤害" or v == "会心免伤" or v == "最终伤害放大" or v == "最终伤害抵消" or string.find(v,"基础") then
                  str=str.."提升"..v..math.ceil(inSkillBox[i][v]*((1+inSkillBox[i].step)^inSkillBox[i].level)).."%\n"
                 elseif v=="气血上限" then
                  str=str.."提升气血上限"..math.ceil(inSkillBox[i][v]*((1+inSkillBox[i].step)^inSkillBox[i].level)).."点\n"
                 elseif v=="法力上限" then
                  str=str.."提升法力上限"..math.ceil(inSkillBox[i][v]*((1+inSkillBox[i].step)^inSkillBox[i].level)).."点\n"
                 else
                  str=str.."提升"..v..math.ceil(inSkillBox[i][v]*((1+inSkillBox[i].step)^inSkillBox[i].level)).."点\n"
                end
              end
            end
            功法属性.Text = str
            function 修炼心法.onClick()
              Http.get("http://api.k780.com/?app=life.time&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json",nil,nil,nil,function(q,w,e,r)
                local time = cjson.decode(w)["result"]["timestamp"]
                local x,y = addxiuwei(SaveTable.owner.level)
                y = math.ceil(y * xlsp * 0.01)
                MD提示("开始打坐修炼,当前修炼每分钟消耗"..x.."块灵石，获得修为,"..inSkillBox[i].key.."熟练度"..y.."点!")
                SaveTable.owner["修炼"].type = 1
                SaveTable.owner["修炼"].key = inSkillBox[i].key
                SaveTable.owner["修炼"].time = time
                d.dismiss()
                b.dismiss()
                loadsavewrite()
                RoleSetUI()
              end)
            end
          end
        end
       else
        while c ~= nil do
          b.dismiss()
        end
        if c == nil then
          c=AlertDialog.Builder(activity)
          .setView(loadlayout(MapUI()["修炼弹窗"]))
          b = c.show()
          Http.get("http://api.k780.com/?app=life.time&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json",nil,nil,nil,function(q,w,e,r)
            local time = cjson.decode(w)["result"]["timestamp"]
            local x,y = addxiuwei(SaveTable.owner.level)
            local extime = time - SaveTable.owner["修炼"].time
            local getexp
            local Inskill = import "inskill"
            local inskill = Inskill:RollinSkill(SaveTable.owner["修炼"].key)
            local lv,id = GetInSkillLevel(inskill.key)
            local xlsp = inskill["修炼效率"] * ((1+inskill.step)^(lv-1))
            if SaveTable.owner.money < math.floor(extime/60)*x then
              getexp = math.floor(SaveTable.owner.money/x) * y * xlsp
             else
              getexp = math.floor(extime/60) * y * xlsp
            end
            弹窗提示.Text="当前已修炼"..GameTime(extime).."("..NetTime(extime).."),共计获得修为,"..inskill.key.."熟练度"..math.ceil(getexp).."点!"
            弹出按钮.Text="结束修炼"
            弹出按钮1.Text="返回"
            function 返回界面()
              b.dismiss()
            end
            function 结束修炼()
              if SaveTable.owner["修炼"].type~=0 then
                extime = time - SaveTable.owner["修炼"].time
                local xlsp = inskill["修炼效率"] * ((1+inskill.step)^(lv-1))
                if SaveTable.owner.money < math.floor(extime/60)*x then
                  getexp = math.floor(SaveTable.owner.money/x) * y * xlsp
                 else
                  getexp = math.floor(extime/60) * y * xlsp
                end
                SaveTable.owner["修为"]=SaveTable.owner["修为"] + math.ceil(getexp)
                SaveTable.owner.inskill[id].exp=SaveTable.owner.inskill[id].exp + math.ceil(getexp)
                local exp = import "skillexp"
                if exp[inskill["品质"]][SaveTable.owner.inskill[id].level] ~= "max" then
                  while type(exp[inskill["品质"]][SaveTable.owner.inskill[id].level]) == "number" and SaveTable.owner.inskill[id].exp >= exp[inskill["品质"]][SaveTable.owner.inskill[id].level] do
                    SaveTable.owner.inskill[id].exp = SaveTable.owner.inskill[id].exp - exp[inskill["品质"]][SaveTable.owner.inskill[id].level]
                    SaveTable.owner.inskill[id].level = SaveTable.owner.inskill[id].level + 1
                    MD提示(SaveTable.owner.inskill[id].key.."提升至"..math.ceil(SaveTable.owner.inskill[id].level).."重")
                  end
                end
                SaveTable.owner.money=SaveTable.owner.money-math.ceil(getexp / y * x / xlsp)
                SaveTable.owner["修炼"].type=0
                MD提示("消耗"..math.ceil(getexp / y / xlsp) * x.."块灵石,获得修为"..math.ceil(getexp).."点!")
                b.dismiss()
                loadsavewrite()
                RoleSetUI()
               else
                MD提示("错误!")
              end
            end
          end)
        end
      end
    end
  end
  local b
  function UpRole()
    if b ~= nil then
      b.dismiss()
    end
    local c=AlertDialog.Builder(activity)
    .setView(loadlayout(MapUI()["突破"]))
    b = c.show()
    local pr = ((SaveTable.owner["道心"]*10000+境界[SaveTable.owner.level].cost)/境界[SaveTable.owner.level].cost)*境界[SaveTable.owner.level].probability
    if pr > 1 then
      pr = 1
     elseif pr < 0 then
      pr = 0
    end
    local str = 境界[SaveTable.owner.level]["境界"].."→"..境界[SaveTable.owner.level+1]["境界"].."\n消耗修为:"..境界[SaveTable.owner.level].cost.."\n突破成功率:"..pr*100 .."%\n体质提升:"..境界[SaveTable.owner.level]["体质"].."\n真元提升:"..境界[SaveTable.owner.level]["真元"].."\n身法提升:"..境界[SaveTable.owner.level]["身法"].."\n肉身提升:"..境界[SaveTable.owner.level]["肉身"].."\n获得自由属性点:"..境界[SaveTable.owner.level].Point
    if 境界[SaveTable.owner.level]["寿元"] then
      提示内容.Text=str.."\n寿元提升:"..境界[SaveTable.owner.level]["寿元"]
     else
      提示内容.Text=str
    end
    function UpRoleData()
      local numb = 1
      if SaveTable["新衣"] ~= nil then
        numb = 1.2
      end
      if SaveTable.owner["修为"] >= 境界[SaveTable.owner.level].cost then
        if probability(pr*numb) then
          if 境界[SaveTable.owner.level]["雷劫"] == nil then
            local tzts = 境界[SaveTable.owner.level]["体质"]
            local zyts = 境界[SaveTable.owner.level]["真元"]
            local sfts = 境界[SaveTable.owner.level]["身法"]
            local rsts = 境界[SaveTable.owner.level]["肉身"]
            local ptts = 境界[SaveTable.owner.level].Point
            local kcxw = 境界[SaveTable.owner.level].cost
            提示("突破成功，属性大量提升！")
            提示("体质提升"..tzts.."点！")
            提示("真元提升"..zyts.."点！")
            提示("身法提升"..sfts.."点！")
            提示("肉身提升"..rsts.."点！")
            提示("可分配属性点提升"..ptts.."点！")
            提示("扣除修为"..kcxw.."点！")
            SaveTable.owner["体质"]=SaveTable.owner["体质"]+境界[SaveTable.owner.level]["体质"]
            SaveTable.owner["真元"]=SaveTable.owner["真元"]+境界[SaveTable.owner.level]["真元"]
            SaveTable.owner["身法"]=SaveTable.owner["身法"]+境界[SaveTable.owner.level]["身法"]
            SaveTable.owner["肉身"]=SaveTable.owner["肉身"]+境界[SaveTable.owner.level]["肉身"]
            SaveTable.owner.Point=SaveTable.owner.Point+境界[SaveTable.owner.level].Point
            SaveTable.owner["修为"]=SaveTable.owner["修为"]-境界[SaveTable.owner.level].cost
            if 境界[SaveTable.owner.level]["寿元"] then
              local sy = 境界[SaveTable.owner.level]["寿元"]
              local sn = 境界[SaveTable.owner.level]["神念"]
              提示("神念提升"..sn.."点！道心清零!")
              提示("寿元提升"..sy.."点！道心清零!")
              SaveTable.owner["寿元"]=SaveTable.owner["寿元"]+境界[SaveTable.owner.level]["寿元"]
              SaveTable.owner["神念上限"]=SaveTable.owner["神念上限"]+境界[SaveTable.owner.level]["神念"]
              SaveTable.owner["神念"]=SaveTable.owner["神念上限"]
              SaveTable.owner["道心"]=0
            end
            SaveTable.owner.level = SaveTable.owner.level + 1
            local jjcs = 境界[SaveTable.owner.level]["境界"]
            提示("境界提升至"..jjcs.."！")
            if SaveTable.owner.level == 13 then
              a1.dismiss()
              文字动画("筑基剧情",1)
             else
              loadsavewrite(0)
            end
           else
            local css = 1+(SaveTable.owner["道心"]*10000+境界[SaveTable.owner.level].cost)/境界[SaveTable.owner.level].cost
            if css < 0.1 then
              css = 0.1
            end
            local dm = math.ceil(境界[SaveTable.owner.level]["雷劫"]/css)
            if 雷劫(dm) then
              SaveTable.owner["体质"]=SaveTable.owner["体质"]+境界[SaveTable.owner.level]["体质"]
              SaveTable.owner["真元"]=SaveTable.owner["真元"]+境界[SaveTable.owner.level]["真元"]
              SaveTable.owner["身法"]=SaveTable.owner["身法"]+境界[SaveTable.owner.level]["身法"]
              SaveTable.owner["肉身"]=SaveTable.owner["肉身"]+境界[SaveTable.owner.level]["肉身"]
              SaveTable.owner.Point=SaveTable.owner.Point+境界[SaveTable.owner.level].Point
              SaveTable.owner["修为"]=SaveTable.owner["修为"]-境界[SaveTable.owner.level].cost
              SaveTable.owner["寿元"]=SaveTable.owner["寿元"]+境界[SaveTable.owner.level]["寿元"]
              SaveTable.owner["神念上限"]=SaveTable.owner["神念上限"]+境界[SaveTable.owner.level]["神念"]
              SaveTable.owner["神念"]=SaveTable.owner["神念上限"]
              SaveTable.owner.level = SaveTable.owner.level + 1
              SaveTable.owner["道心"]=0
             else
              SaveTable.owner["修为"]=SaveTable.owner["修为"]-境界[SaveTable.owner.level].cost
              SaveTable.owner["道心"]=math.ceil(SaveTable.owner["道心"]-math.ceil(境界[SaveTable.owner.level].cost/50000))
            end
            loadsavewrite(0)
          end
         else
          local kcxw = 境界[SaveTable.owner.level].cost
          local dxjd = math.ceil(境界[SaveTable.owner.level].cost/50000)
          SaveTable.owner["修为"]=SaveTable.owner["修为"]-境界[SaveTable.owner.level].cost
          SaveTable.owner["道心"]=math.ceil(SaveTable.owner["道心"]-math.ceil(境界[SaveTable.owner.level].cost/50000))
          提示("突破失败！")
          提示("扣除修为"..kcxw.."点！")
          提示("道心降低"..dxjd .."点！")
          loadsavewrite(0)
        end
        b.dismiss()
        RoleSetUI()
       else
        b.dismiss()
        提示("修为不足！")
      end
    end
    function 关闭提示()
      b.dismiss()
    end
  end
  --提取装备属性1
  local function GetEquipmentShow(ltb)
    local x = 1
    local tb
    --local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中"}
    repeat
    if ltb.key == Item[x].key then
      tb={type=Item[x].type,Info=Item[x].Info,["品质"]=Item[x]["品质"],price=Item[x].price,pet=Item[x].pet}
      for k,v in pairs(ltb) do
        tb[k] = v
      end
      for k,v in pairs(tab) do
        if Item[x][v] then
          tb[v] = math.ceil(Item[x][v] * tb[v])
        end
      end
      if Item[x]["资源参数"] then
        tb["资源参数"]=Item[x]["资源参数"]
      end
      break
     else
      x = x + 1
    end
    until x > #Item
    return tb
  end

  function EquipmentId(key)
    local t
    for k,v in pairs(SaveTable.owner.eq) do
      if v.key == key then
        t = k
        break
      end
    end
    return t
  end

  --生成物品的table表
  local function EquipmentShow(eq1)
    local tb = {}
    for k,v in pairs(eq1) do
      tb[#tb+1] = GetEquipmentShow(v)
    end
    return tb
  end

  --提升人物属性
  function AddAttribute(key,num)
    if SaveTable.owner.Point >= 1 then
      SaveTable.owner.Point = SaveTable.owner.Point - num
      SaveTable.owner.UsePoint = SaveTable.owner.UsePoint + num
      SaveTable.owner[key] = SaveTable.owner[key] + num
      MD提示("你的"..key.."提升"..num.."点")
      RoleSetUI()
     else
      MD提示("可分配属性点不足!")
    end
  end

  function OpenEquipment(eq)
    if a1 ~= nil then
      a1.dismiss()
    end
    if a ~= nil then
      a.dismiss()
      a = nil
    end
    local EqTable = EquipmentShow(eq)
    import"android.graphics.drawable.ColorDrawable"
    a=PopupWindow(activity)--创建PopWindow
    a.setContentView(loadlayout(MapUI()["装备面板"]))--设置布局
    a.setWidth(activity.Width*0.92)--设置宽度
    a.setHeight(-2)--设置高度
    a.setFocusable(true)--设置可获得焦点
    a.getBackground().setAlpha(0)
    a.setTouchable(true)--设置可触摸
    --设置点击外部区域是否可以消失
    a.setOutsideTouchable(false)
    --显示
    a.showAtLocation(view,Gravity.CENTER,0,0)
    for k,v in pairs(EqTable) do
      if v.type == 0 then
        武器.Text = Color:Set(EqLevel(v.key,v.level),v["品质"])
       elseif v.type == 1 then
        衣服.Text = Color:Set(EqLevel(v.key,v.level),v["品质"])
       elseif v.type == 2 then
        帽子.Text = Color:Set(EqLevel(v.key,v.level),v["品质"])
       elseif v.type == 3 then
        护手.Text = Color:Set(EqLevel(v.key,v.level),v["品质"])
       elseif v.type == 4 then
        鞋子.Text = Color:Set(EqLevel(v.key,v.level),v["品质"])
       elseif v.type == 5 then
        首饰.Text = Color:Set(EqLevel(v.key,v.level),v["品质"])
      end
    end

    function EquipmentShowMenu(type)
      local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中","神念消耗","材料消耗","成丹率","成功率","出丹率","评分提升","属性品质","获取经验"}
      local x = 1
      local t
      if #EqTable ~= 0 then
        repeat
        if type == EqTable[x].type then
          t = EqTable[x]
          break
         else
          x = x + 1
        end
        until x > #EqTable
      end
      if t ~= nil then
        a.dismiss()
        import"android.graphics.drawable.ColorDrawable"
        a=PopupWindow(activity)--创建PopWindow
        a.setContentView(loadlayout(MapUI()["装备数据"]))--设置布局
        a.setWidth(activity.Width*0.9)--设置宽度
        a.setHeight(-2)
        a.setFocusable(true)--设置可获得焦点
        a.getBackground().setAlpha(0)
        a.setTouchable(true)--设置可触摸
        --设置点击外部区域是否可以消失
        a.setOutsideTouchable(false)
        --显示
        a.showAtLocation(view,Gravity.CENTER,0,0)
        物品名称.Text = Color:Set(EqLevel(t.key,t.level).."["..品级[t["品质"]].."]",t["品质"])
        物品成长.Text = "评分:"..upeqdata(t) .."\n"
        物品介绍.Text = 物品介绍.Text..":\n"..t.Info.."\n"
        local f = ""
        for k,v in pairs(tab) do
          if t[v] then
            if v == "会心伤害" or v == "会心免伤" or v == "最终伤害放大" or v == "最终伤害抵消" or string.find(v,"基础") then
              f=f..v..":"..math.ceil(t[v]*(1.1^t.level)).."%\n"
             elseif v=="气血上限" then
              f=f.."气血上限:"..math.ceil(t[v]*(1.1^t.level)).."\n"
             elseif v=="法力上限" then
              f=f.."法力上限:"..math.ceil(t[v]*(1.1^t.level)).."\n"
             else
              f=f..v..":"..math.ceil(t[v]*(1.1^t.level)).."\n"
            end
          end
        end
        物品属性.Text=物品属性.Text.."\n"..f
        if #t["附加属性"] > 0 then
          local num
          if t["品质"] >= 13 then
            num = 10
           elseif t["品质"] > 9 then
            num = 7
           elseif t["品质"] > 6 then
            num = 5
           elseif t["品质"] > 3 then
            num = 3
           else
            num = 2
          end
          装备框.addView(loadlayout{
            TextView;
            text=Html.fromHtml("附加属性("..#t["附加属性"].."/"..num.."):");
          },5)
          local num1 = 6
          local tx
          local Trigger = import "Trigger"
          for k,v in pairs(t["附加属性"]) do
            local sp = split(Trigger["属性"][t["品质"]][v[1]],"#")
            local tb = {}
            for k,v in pairs(sp) do
              local sp1 = split(v,"|")
              local tab = {}
              for i=1,#sp1 do
                if tonumber(sp1[i]) then
                  table.insert(tab,tonumber(sp1[i]))
                 else
                  table.insert(tab,sp1[i])
                end
              end
              table.insert(tb,tab)
            end
            local co
            for g,h in pairs(tb) do
              if v[2] <= h[2] then
                co = "#"..h[4]
                break
               elseif g == #tb then
                local idx
                for k,v in pairs(SaveTable.owner.eq) do
                  if v.key == t.key then
                    idx = k
                    break
                  end
                end
                table.remove(SaveTable.owner.eq[idx]["附加属性"],k)
              end
            end
            if co == nil then
              co = "#000000"
            end
            if v[1] == "会心伤害" or v[1] == "会心免伤" or v[1] == "最终伤害放大" or v[1] == "最终伤害抵消" or string.find(v[1],"基础") then
              tx = v[1]..":"..math.ceil(v[2]*(1.1^t.level)).."%"
             elseif v[1] == "气血上限" then
              tx = "气血上限:"..math.ceil(v[2]*(1.1^t.level))
             elseif v[1] == "法力上限" then
              tx = "法力上限:"..math.ceil(v[2]*(1.1^t.level))
             else
              tx = v[1]..":"..math.ceil(v[2]*(1.1^t.level))
            end
            装备框.addView(loadlayout{
              TextView;
              text=Html.fromHtml(GetColor(tx,co));
            },num1)
            num1 = num1 + 1
          end
          local z = math.floor(t.level/5)
          local djp
          if #SaveTable.owner.eq >= 6 then
            for k,v in pairs(EqTable) do
              if djp == nil then
                djp = v["品质"]
               elseif v["品质"] < djp then
                djp = v["品质"]
              end
              local fl = math.floor(v.level/5)
              if z > fl then
                z = fl
              end
            end
            local stri,numi
            if djp >= 13 then
              stri = "仙器"
              numi = math.ceil((10+10*z)*z/2)
             elseif djp >= 10 then
              stri = "天阶"
              numi = math.ceil((7+7*z)*z/2)
             elseif djp >= 7 then
              stri = "地阶"
              numi = math.ceil((5+5*z)*z/2)
             elseif djp >= 4 then
              stri = "玄阶"
              numi = math.ceil((3+3*z)*z/2)
             else
              stri = "黄阶"
              numi = math.ceil((2+2*z)*z/2)
            end
            if z > 0 then
              装备框.addView(loadlayout{
                TextView;
                text=Color:Set("<br>"..stri..math.ceil(z*5).."转:<br>基础生命:"..numi.."%<br>基础法力:"..numi.."%<br>基础攻击:"..numi.."%<br>基础防御:"..numi.."%<br>基础命中:"..numi.."%<br>基础闪避:"..numi.."%<br>基础会心:"..numi.."%",djp);
              },num1)
            end
          end
        end
       else
        MD提示("没有佩戴相应的装备!")
      end
      local e
      function UpEquipment()
        local jilian = import "qianghua"
        local numb = 1
        if SaveTable["新衣"] ~= nil then
          numb = 1.2
        end
        if e ~= nil then
          e.dismiss()
        end
        local d=AlertDialog.Builder(activity)
        .setView(loadlayout(MapUI()["祭炼"]))
        e = d.show()
        costmn.Text="消耗灵石:"..math.ceil(jilian[t["品质"]][4]*(1.2^t.level))
        costcl.Text=Html.fromHtml("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;消耗物品:"..math.ceil(jilian[t["品质"]][3]*(1.2^t.level)).."个"..Color:Get(jilian[t["品质"]][2],t["品质"]))
        function cgl(num)
          local cg = num
          if cg > 100 then
            cg = 100
          end
          return math.floor(cg*100)/100
        end
        local ff = EquipmentId(t.key)
        local itt = SaveTable.owner.eq[ff]
        local jl = 1
        if itt.jl then
          jl = 1.2 ^ tonumber(itt.jl)
        end
        成功率.Text="祭炼成功率:".. cgl(100*(1.2^(0-t.level))*jl*numb) .."%"
        function 关闭祭炼()
          e.dismiss()
        end
        function 开始祭炼()
          if SaveTable.owner.money < math.ceil(jilian[t["品质"]][4]*(1.2^t.level)) then
            MD提示("灵石不足!")
           elseif not HasItem(jilian[t["品质"]][2],math.ceil(jilian[t["品质"]][3]*(1.2^t.level))) then
            MD提示(jilian[t["品质"]][2].."数量不足!")
           else
            DeleteItem(jilian[t["品质"]][2],math.ceil(jilian[t["品质"]][3]*(1.2^t.level)))
            SaveTable.owner.money=SaveTable.owner.money-math.ceil(jilian[t["品质"]][4]*(1.2^t.level))
            if probability(1*((1.2^(0-t.level))*jl*numb)) then
              t.level=t.level+1
              itt.jl = nil
              for k,v in pairs(SaveTable.owner.eq) do
                if v.key == t.key then
                  v.level = t.level
                end
              end
              e.dismiss()
              a.dismiss()
              EquipmentShowMenu(type)
              MD提示("装备祭炼成功!")
              loadsavewrite()
             else
              MD提示("装备祭炼失败，下一次祭炼的成功率提升20%")
              if itt.jl ~= nil then
                itt.jl = tonumber(itt.jl) + 1
               else
                itt.jl = 1
              end
              e.dismiss()
              loadsavewrite(0)
            end
          end
        end
      end

      function DeleteEquipment()
        local Id = EquipmentId(t.key)
        table.insert(SaveTable.Item,SaveTable.owner.eq[Id])
        table.remove(SaveTable.owner.eq,Id)
        MD提示("你的装备"..t.key.."已卸下!")
        a.dismiss()
        loadsavewrite()
      end
    end
  end
  RoleSetUI()
end

function DeleteSave()
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
      hint="请输入'确认删除'进行操作";
      layout_marginTop="5dp";
      layout_marginLeft="10dp",
      layout_marginRight="10dp",
      layout_width="match_parent";
      layout_gravity="center",
      id="edit";
    };
  };

  AlertDialog.Builder(this)
  .setTitle("确定要删除存档吗?")
  .setView(loadlayout(InputLayout))
  .setPositiveButton("确定",{onClick=function(v)
      if edit.Text == "确认删除" then
        清理存档()
        MD提示("存档已删除")
       else
        MD提示("输入错误")
      end
  end})
  .setNegativeButton("取消",nil)
  .show()
end

function 作弊弹窗()
  local tc = {
    LinearLayout;
    orientation="vertical";
    layout_height="fill";
    layout_width="fill";
    {
      TextView;
      text="请勿修改破解游戏!";
    };
  };
  activity.setContentView(loadlayout(tc))
end

function 清理存档()
  if File(activity.getLuaDir().."/save").isDirectory() then
    local j = luajava.astable(File(activity.getLuaDir().."/save").listFiles())
    for k,v in pairs(j) do
      if string.find(tostring(v),"savedata") ~= nil then
        os.remove(tostring(v))
      end
    end
   else
    os.execute('mkdir '..activity.getLuaDir()..'/save')
  end
end

function rollatt()
  SaveTable.owner["体质"] = math.random(5,20)
  SaveTable.owner["真元"] = math.random(5,20)
  SaveTable.owner["身法"] = math.random(5,20)
  SaveTable.owner["肉身"] = math.random(5,20)
  while SaveTable.owner["体质"] + SaveTable.owner["真元"] + SaveTable.owner["身法"] + SaveTable.owner["肉身"] ~= 45 do
    SaveTable.owner["体质"] = math.random(5,20)
    SaveTable.owner["真元"] = math.random(5,20)
    SaveTable.owner["身法"] = math.random(5,20)
    SaveTable.owner["肉身"] = math.random(5,20)
  end
  SaveTable.owner.Attribute=Item:GetTirgger(SaveTable.owner)
  rolltz.Text = table.concat({"体质:",SaveTable.owner.Attribute["体质"]})
  rollzy.Text = table.concat({"真元:",SaveTable.owner.Attribute["真元"]})
  rollsf.Text = table.concat({"身法:",SaveTable.owner.Attribute["身法"]})
  rollrs.Text = table.concat({"肉身:",SaveTable.owner.Attribute["肉身"]})
end
function GameStart()
  local tx,br = badword(rollname.Text)
  if #rollname.Text < 3 then
    提示("名字过短")
   elseif #rollname.Text > 18 then
    提示("名字过长")
   elseif tonumber(rollname.Text) then
    提示("名字不能全部为数字")
   elseif string.find(rollname.Text," ") then
    提示("名字不能出现空格")
   elseif not br then
    提示("内容敏感")
   else
    SaveTable.owner.key = badword(rollname.Text)
    更新库存()
    loadsavewrite(0)
    saveloadfile(str,true,true)
    --文字动画("开局剧情",1)
  end
end

function decosave()
  if File(activity.getLuaDir().."/save").listFiles() == nil then
    File(activity.getLuaDir().."/save").mkdir()
  end
  local j = luajava.astable(File(activity.getLuaDir().."/save").listFiles())
  local idx = 1
  for k,v in pairs(j) do
    if string.find(tostring(v),"savedata") ~= nil then
      idx = k
      break
    end
  end
  --Sharing(tostring(j[idx]))
  local tb
  if #j > 0 then
    tb = loadsaveread(tostring(j[idx]))
  end
  return tb
end

function 自动上传()
  local data = {}
  local tbt = table.clone(SaveTable)
  data.item = cjson.encode(tbt.Item)
  tbt.Item = nil
  data.pet = cjson.encode(tbt.pet)
  tbt.pet = nil
  data.owner = cjson.encode(tbt.owner)
  tbt.owner = nil
  data.data = cjson.encode(tbt)
  data.level = tostring(SaveTable.owner.level)
  data.name = SaveTable.owner.key
  data.money = tostring(allmoney())
  data.liandan = tostring(SaveTable["炼丹"].level)
  data.lianqi = tostring(SaveTable["炼器"].level)
  data.id = 解密("role/zh")
  if SaveTable.作弊 == nil then
    data.root = "0"
   else
    data.root = "1"
  end
  fp("http://82.157.62.200/zm/zidong.php?",data,function(code,body)
    if code == -1 then
      task(5000,function 自动上传() end)
    end
  end)
end

function 更新库存()
  if SaveTable["库存"] == nil then
    SaveTable["库存"] = {}
  end
  local sp = import "shopitem"
  for k,v in pairs(sp) do
    if SaveTable["库存"][k] == nil then
      SaveTable["库存"][k] = {}
    end
    for n,m in pairs(v) do
      if m.number ~= nil then
        if SaveTable["库存"][k][m.key] == nil then
          SaveTable["库存"][k][m.key] = m.number
        end
       else
        SaveTable["库存"][k][m.key] = -1
      end
    end
  end
end

function saveloadfile(str,br,gj)
 -- local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中"}
  local function 修复装备(t)
    local tb = Item:GetTable(t.key)
    for k,v in pairs(tab) do
      if t[v] ~= nil then
        while t[v] > 2.4 do
          t[v] = t[v] / tb[v]
        end
      end
    end
    return t
  end
  if SaveTable == nil then
    SaveTable = decosave()
  end
  if SaveTable ~= nil then
    if SaveTable.owner == nil then
      SaveTable.owner = table.clone(SaveTable.Owner)
      SaveTable.Owner = nil
    end
    SaveTable.owner.key = badword(SaveTable.owner.key)
    if SaveTable["服务器"] == nil then
      SaveTable["服务器"] = "测试服"
    end
    for k,v in pairs(SaveTable.pet) do
      SaveTable.pet[k].name = badword(v.name)
    end
    if SaveTable.savetime == nil then
      建档时间()
    end
    import "android.provider.Settings$Secure"
    local ma = Secure.getString(activity.getContentResolver(), Secure.ANDROID_ID)
    if SaveTable.owner.id == nil then
      SaveTable.owner.id = ma
    end
    if SaveTable.owner.money > 999999999999 then
      SaveTable.owner.money = 10000
    end
    local num = #SaveTable.Item
    local tbb = {}
    for i=1,num do
      if SaveTable.Item[i] ~= nil then
        if SaveTable.Item[i].key == nil then
          table.insert(tbb,i)
        end
        if SaveTable.Item[i].number ~= nil and SaveTable.Item[i].number > 10000 then
          if Item:GetTable(SaveTable.Item[i].key).price*SaveTable.Item[i].number > 9999999999 then
            table.insert(tbb,i)
          end
        end
      end
    end
    for i=1,#tbb do
      table.remove(SaveTable.Item,tbb[i]-i+1)
    end
    if SaveTable.set == nil then
      SaveTable.set = {["嗑药"]={["百分比"]=50}}
    end
    SaveTable.wl = nil
    更新库存()
    if SaveTable.owner["身法"] < 99999 then
      if gj == true then
        离线结算()
       else
        适配()
        activity.setContentView(loadlayout(MapUI()["主界面"]))
        地图.addView(savelay.map)
        if SaveTable.age == nil then
          SaveTable.age = os.time()
        end
        local nage = os.time() - SaveTable.age
        while nage >= 14400 do
          nage = nage - 14400
          SaveTable.owner["年龄"] = SaveTable.owner["年龄"] + 1
          SaveTable.age = SaveTable.age + 14400
        end
        SaveTable.owner.Attribute = Item:GetTirgger(SaveTable.owner)
        道号.Text=道号.Text..SaveTable.owner.key
        jj.Text=jj.Text..境界[SaveTable.owner.level]["境界"]
        nl.Text=nl.Text..math.ceil(SaveTable.owner["年龄"]).."岁"
        sy.Text=sy.Text..math.ceil(SaveTable.owner["寿元"]).."年"
        xl.Text=Html.fromHtml(xl.Text..GetColor(SaveTable.owner.Attribute["气血上限"],Color.red))
        fl.Text=Html.fromHtml(fl.Text..GetColor(SaveTable.owner.Attribute["法力上限"],Color.blue))
        xw.Text=xw.Text..math.ceil(SaveTable.owner["修为"])
        ls.Text=ls.Text..math.ceil(SaveTable.owner.money)
        SaveTable.owner.Attribute = Item:GetTirgger(SaveTable.owner)
        SaveTable.owner.fight = math.ceil(SaveTable.owner.Attribute["内攻"]*2+SaveTable.owner.Attribute["外攻"]*2+SaveTable.owner.Attribute["内防"]*2.5+SaveTable.owner.Attribute["外防"]*2.5+SaveTable.owner.Attribute["气血上限"]*0.2+SaveTable.owner.Attribute["法力上限"]*0.1+SaveTable.owner.Attribute["会心率"]*2+SaveTable.owner.Attribute["抗会心率"]*2+SaveTable.owner.Attribute["闪避"]*2.5+SaveTable.owner.Attribute["命中"]*2.5+SaveTable.owner.Attribute["会心伤害"]*20+SaveTable.owner.Attribute["会心免伤"]*20+SaveTable.owner.Attribute["最终伤害放大"]*30+SaveTable.owner.Attribute["最终伤害抵消"]*30)
        if br == true then
          if SaveTable.map == nil then
            跳转地图("映日村",true)
           else
            if br == 1 then
              跳转地图(SaveTable.map,true,1)
             else
              跳转地图(SaveTable.map,true)
            end
          end
         else
          if SaveTable.map == nil then
            跳转地图("映日村",true)
           else
            if br == 1 then
              跳转地图(SaveTable.map,true,1)
             else
              跳转地图(SaveTable.map,true)
            end
          end
        end
      end
     else
      os.remove(luji)
      提示("数据异常，存档已删除")
    end
   else
    activity.setContentView(loadlayout(MapUI()["创建角色"]))
    local owner = {key="狗蛋",level=1,money=5000000,
      ["修为"]=10000,["体质"]=10,["真元"]=15,["身法"]=10,["肉身"]=10000,["神念上限"]=10000,["神念"]=10000,Point=10000,UsePoint=0,["年龄"]=16,["寿元"]=80,["道心"]=0,["修炼"]={type=0,key=0,time=0},buff={},
      eq={},
      use={},
      skill={{key="秀水剑法",eq=1,level=1,exp=0}},inskill={{key="归元决",level=1,exp=0}}}
    SaveTable={}
    SaveTable["服务器"]="正式服"
    SaveTable.owner=owner
    SaveTable.pet={{bh=4,eq=1,key="熊",level=3,修为=0,key1="金刚地熊",name="小金",buff={},四维={1700,850,900,1700},skill={{key="黑岩爪",eq=1,exp=0,level=7},{key="地刺术",eq=1,exp=0,level=7},{key="扑杀",eq=1,exp=0,level=7},{key="沙石破",eq=1,exp=0,level=6}},inskill={{key="金身诀",eq=1,exp=0,level=7},{key="金石心诀",eq=1,exp=0,level=7},{key="金刚录",eq=1,exp=0,level=8}},body={}}}
    SaveTable.set = {["嗑药"]={["百分比"]=50}}
    SaveTable["炼丹"]={level=1,exp=0,eq={},learn={}}
    SaveTable["炼器"]={level=1,exp=0,eq={},learn={}}
    SaveTable["制符"]={level=1,exp=0,eq={},learn={}}
    SaveTable["法阵"]={level=1,exp=0,eq={},learn={}}
    建档时间()
    SaveTable.Item={{key="倚天剑",["外攻"]=1.5,["会心率"]=1.5,["会心伤害"]=1.5,level=0,number=1,["附加属性"]={{"外攻",120}}}}
    SaveTable.owner.Attribute=Item:GetTirgger(SaveTable.owner)
    rolltz.Text = table.concat({"体质:",SaveTable.owner.Attribute["体质"]})
    rollzy.Text = table.concat({"真元:",SaveTable.owner.Attribute["真元"]})
    rollsf.Text = table.concat({"身法:",SaveTable.owner.Attribute["身法"]})
    rollrs.Text = table.concat({"肉身:",SaveTable.owner.Attribute["肉身"]})
  end
end

function savedata(str)
  import "java.io.File"
  local function encosave()
    清理存档()
    os.rename(luji2,luji)
  end
  local f = File(tostring(File(tostring(luji2)).getParentFile())).mkdirs()
  io.open(tostring(luji2),"w"):write(tostring(str)):close()
  encosave()
end

function saves(func)
  local tb=decosave()
  SaveTable=table.clone(tb)
  loadsavewrite(0,func(tb))
end

function loadsaveread(luji2)
  local tab
  local file = io.open(luji2,"r")
  local str = file:read("*a")
  --local tab1 = cjson.decode(str1)
  if string.find(str,"inskill")~=nil then
    tab = cjson.decode(str)
   else
    local len=str:len()
    local ostr=""
    for i=1,len do
      local s1=string.char(string.byte(str.sub(str,i,i))-1)
      ostr=table.concat({ostr,s1})
    end
    tab = cjson.decode(ostr)
    --tab.owner = tab1
  end
  return tab
end

function 建档时间()
  Http.get("http://api.k780.com/?app=life.time&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json",nil,nil,nil,function(q,w,e,r)
    local time = cjson.decode(w)["result"]["timestamp"]
    SaveTable.savetime = time
    loadsavewrite(0)
  end)
end

function GetFileSize(path)
  import "java.io.File"
  import "android.text.format.Formatter"
  size=File(tostring(path)).length()
  return size
end

function dlysave()
  AlertDialog.Builder(this)
  .setTitle("确认")
  .setMessage("确定修复存档？")
  .setPositiveButton("取消",nil)
  .setNegativeButton("确认",function
    os.remove(activity.getLuaDir().."/save/bug")
    MD提示("存档修复成功")
  end)
  .show();
end

function loadsavewrite(mm)
  if 禁止存档 == nil or mm ~= nil then
    local file = cjson.encode(SaveTable)
    savedata(file)
  end
end

function OpenBag()
  local its = {
    LinearLayout;
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
          id="name";
        };
      };
    };
  };

  function GetEquipmentShow(ltb)
    local x = 1
    local tb
    local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中","神念消耗","材料消耗","成丹率","成功率","出丹率","评分提升","属性品质","获取经验"}
    repeat
    if ltb.key == Item[x].key then
      tb={type=Item[x].type,Info=Item[x].Info,["品质"]=Item[x]["品质"],price=Item[x].price,pet=Item[x].pet}
      for k,v in pairs(ltb) do
        tb[k] = v
      end
      for k,v in pairs(tab) do
        if Item[x][v] then
          tb[v] = math.ceil(Item[x][v] * tb[v])
        end
      end
      if Item[x]["资源参数"] then
        tb["资源参数"]=Item[x]["资源参数"]
      end
      break
     else
      x = x + 1
    end
    until x > #Item
    return tb
  end

  local function EquipmentShow()
    local t = {}
    local tp = type or {9,9}
    for k,v in pairs(SaveTable.Item) do
      t[k] = GetEquipmentShow(v)
    end
    return t
  end
  function ItemShow(type)
    table.sort(SaveTable.Item,function(a,b)
      return Item:GetTable(a.key)["品质"] < Item:GetTable(b.key)["品质"]
    end)
    GetItemId()
    返回="主界面"
    if bag ~= nil then
      bag.dismiss()
      bag = nil
    end
    bag = PopupWindow(activity)--创建PopWindow
    bag.setContentView(loadlayout(MapUI()["背包"]))--设置布局
    bag.setWidth(activity.Width*0.92)--设置宽度
    bag.setHeight(activity.Height*0.88)--设置高度
    bag.setFocusable(true)--设置可获得焦点
    bag.getBackground().setAlpha(0)
    bag.setTouchable(true)--设置可触摸
    --设置点击外部区域是否可以消失
    bag.setOutsideTouchable(false)
    --显示
    bag.showAtLocation(view,Gravity.CENTER,0,0)
    local data={}
    local adp=LuaAdapter(activity,data,its)
    背包.Adapter=adp
    local ItemTable = EquipmentShow()
    local nb = {}
    for k,v in pairs(ItemTable) do
      if (v.type >= type[1] and v.type <= type[2]) then
        if v.type <= 5 then
          local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中","神念消耗","材料消耗","成丹率","成功率","出丹率","评分提升","属性品质","获取经验"}
          local pt = {}
          local itb = Item:GetTable(v.key)
          local num = 0
          for n,m in pairs(tab) do
            if v[m] ~= nil then
              num = num + v[m]/itb[m]
              table.insert(pt,itb[m])
            end
          end
          local point = math.floor(num/(#pt*2)*100)
          if point > 120 then
            point = 120
          end
          table.insert(data,{name=Color:Set(v.key.."["..品级[v["品质"]].."]".."[数量:"..math.ceil(v.number).."][评分:"..point.."]",v["品质"])})--添加数据进适配器，还有一种方法table.insert(data,{})
         else
          table.insert(data,{name=Color:Set(v.key.."["..品级[v["品质"]].."]".."[数量:"..math.ceil(v.number).."]",v["品质"])})--添加数据进适配器，还有一种方法table.insert(data,{})
        end
       else
        table.insert(nb,k)
      end
    end
    for i=1,#nb do
      table.remove(ItemTable,nb[i]-i+1)
    end
    if #data == 0 then
      table.insert(data,{name="空空如也"})
    end
    function SetUI()
      local p = #data
      for i=1,p do
        table.remove(data,1)
      end
      ItemTable = EquipmentShow()
      local nb = {}
      for k,v in pairs(ItemTable) do
        if (v.type >= type[1] and v.type <= type[2]) then
          if v.type <= 5 then
            local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中","神念消耗","材料消耗","成丹率","成功率","出丹率","评分提升","属性品质","获取经验"}
            local pt = {}
            local itb = Item:GetTable(v.key)
            local num = 0
            for n,m in pairs(tab) do
              if v[m] ~= nil then
                num = num + v[m]/itb[m]
                table.insert(pt,itb[m])
              end
            end
            local point = math.floor(num/(#pt*2)*100)
            if point > 120 then
              point = 120
            end
            table.insert(data,{name=Color:Set(v.key.."["..品级[v["品质"]].."]".."[数量:"..math.ceil(v.number).."][评分:"..point.."]",v["品质"])})--添加数据进适配器，还有一种方法table.insert(data,{})
           else
            table.insert(data,{name=Color:Set(v.key.."["..品级[v["品质"]].."]".."[数量:"..math.ceil(v.number).."]",v["品质"])})--添加数据进适配器，还有一种方法table.insert(data,{})
          end
         else
          table.insert(nb,k)
        end
      end
      for i=1,#nb do
        table.remove(ItemTable,nb[i]-i+1)
      end
      if #data == 0 then
        table.insert(data,{name="空空如也"})
      end
      adp.notifyDataSetChanged()
    end
    local a
    背包.onItemClick=function(l,v,p,i)
      if #ItemTable > 0 then
        local e
        local t = ItemTable[i]
        local tab = {"体质","真元","身法","肉身","外攻","内攻","气血上限","法力上限","外防","内防","会心率","抗会心率","会心伤害","会心免伤","闪避","命中","最终伤害放大","最终伤害抵消","基础生命","基础法力","基础攻击","基础防御","基础会心","基础闪避","基础命中","神念消耗","材料消耗","成丹率","成功率","出丹率","评分提升","属性品质","获取经验"}
        import"android.graphics.drawable.ColorDrawable"
        if a ~= nil then
          a.dismiss()
        end
        a=AlertDialog.Builder(this).show()
        a.getWindow().setContentView(loadlayout(MapUI()["物品面板"]));
        物品名称.Text = Color:Set(EqLevel(t.key,t.level).."["..品级[t["品质"]].."]",t["品质"])
        物品介绍.Text = 物品介绍.Text..":\n"..t.Info.."\n"
        function 出售物品()
          if SaveTableClone(t) then
            if e ~= nil then
              e.dismiss()
            end
            local d=AlertDialog.Builder(activity)
            .setView(loadlayout(MapUI()["出售物品"]))
            e = d.show()
            物品单价.Text=Html.fromHtml("当前出售的物品为:"..SkillColor(t.key,t["品质"]).."<br>当前的物品单价为:"..math.ceil(t.price).."<br>是否确认出售该物品?<br>")
            local num = 1
            if t.number > 1 then
              添加.addView(loadlayout
              {
                Button;
                id="edit";
                text="点击输入数量";
              })
              edit.onClick=function()
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
                    hint="请输入你需要出售的数量";
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
                    if tonumber(edit.Text) then
                      if tonumber(edit.Text) > t.number then
                        num = t.number
                       else
                        num = tonumber(edit.Text)
                      end
                    end
                    salenumber.Text="出售数量:"..math.ceil(num).."个"
                end})
                .setNegativeButton("取消",nil)
                .show()
                import "android.view.View$OnFocusChangeListener"
                import "android.text.InputType"
                import "android.text.method.DigitsKeyListener"
                edit.setInputType(InputType.TYPE_CLASS_NUMBER)
                edit.setKeyListener(DigitsKeyListener.getInstance("0123456789"))
                edit.setOnFocusChangeListener(OnFocusChangeListener{
                  onFocusChange=function(v,hasFocus)
                    if hasFocus then
                      Prompt.setTextColor(0xFD009688)
                    end
                end})
              end
            end
            关闭.onClick=function() e.dismiss() end;
            出售.onClick=function()
              local num9 = SaveTableClone(t)
              if t.number >= 0 then
                if num >= t.number then
                  table.remove(SaveTable.Item,num9)
                 else
                  t.number = t.number - num
                  SaveTable.Item[num9].number = SaveTable.Item[num9].number - num
                end
                GetItemId()
                SaveTable.owner.money = SaveTable.owner.money + math.ceil(t.price * num)
                MD提示(Html.fromHtml("出售"..SkillColor(t.key,t["品质"])..math.ceil(num).."个,获得灵石"..math.ceil(t.price*num).."!"))
                a.dismiss()
                e.dismiss()
                SetUI()
                loadsavewrite()
               else
                MD提示("物品不存在!")
              end
            end
           else
            MD提示("物品不存在!")
          end
        end
        if t["资源参数"] then
          local f = ""
          for k,v in pairs(t["资源参数"]) do
            if k ~= "耐药性" then
              if leixin(v) == "table" then
                f=f..资源["资源参数"][k][1]..v[#v]..资源["资源参数"][k][2]
               else
                f=f..资源["资源参数"][k][1]..v..资源["资源参数"][k][2]
              end
            end
          end
          物品框.addView(loadlayout
          {
            TextView;
            text="使用效果:\n"..f;
          },3)
         else
          local f = ""
          for k,v in pairs(tab) do
            if t[v] then
              if v == "会心伤害" or v == "会心免伤" or v == "最终伤害放大" or v == "最终伤害抵消" or string.find(v,"基础") then
                f=f..v..":"..math.ceil(t[v]*(1.1^t.level)).."%\n"
               elseif v=="气血上限" then
                f=f.."气血上限:"..math.ceil(t[v]*(1.1^t.level)).."\n"
               elseif v=="法力上限" then
                f=f.."法力上限:"..math.ceil(t[v]*(1.1^t.level)).."\n"
               elseif v=="神念消耗" or v=="材料消耗" then
                f=f..v.."降低:"..math.ceil(t[v]*(1.1^t.level)).."%\n"
               elseif v=="成丹率" or v=="出丹率" or v=="成功率" or v=="属性品质" or v=="评分提升" or v=="获取经验" then
                f=f..v.."提升:"..math.ceil(t[v]*(1.1^t.level)).."%\n"
               else
                f=f..v..":"..math.ceil(t[v]*(1.1^t.level)).."\n"
              end
            end
          end
          if #f > 3 then
            物品框.addView(loadlayout
            {
              TextView;
              text="物品属性:\n"..f;
            },3)
            物品框.addView(loadlayout
            {
              TextView;
              text="评分:"..upeqdata(t).."\n";
            },3)
          end
          if t["附加属性"] ~= nil and t.type >= 0 then
            if #t["附加属性"] > 0 then
              local num
              if t["品质"] >= 13 then
                num = 10
               elseif t["品质"] > 9 then
                num = 7
               elseif t["品质"] > 6 then
                num = 5
               elseif t["品质"] > 3 then
                num = 3
               else
                num = 2
              end
              物品框.addView(loadlayout{
                TextView;
                text=Html.fromHtml("附加属性("..#t["附加属性"].."/"..num.."):");
              },5)
              local num1 = 6
              local tx
              local Trigger = import "Trigger"
              for k,v in pairs(t["附加属性"]) do
                local sp = split(Trigger["属性"][t["品质"]][v[1]],"#")
                local tb = {}
                for k,v in pairs(sp) do
                  local sp1 = split(v,"|")
                  local tab = {}
                  for i=1,#sp1 do
                    if tonumber(sp1[i]) then
                      table.insert(tab,tonumber(sp1[i]))
                     else
                      table.insert(tab,sp1[i])
                    end
                  end
                  table.insert(tb,tab)
                end
                local co
                for g,h in pairs(tb) do
                  if v[2] <= h[2] then
                    co = "#"..h[4]
                    break
                  end
                end
                if v[1] == "会心伤害" or v[1] == "会心免伤" or v[1] == "最终伤害放大" or v[1] == "最终伤害抵消" or string.find(v[1],"基础") then
                  tx = v[1]..":"..math.ceil(v[2]*(1.1^t.level)).."%"
                 elseif v[1] == "气血上限" then
                  tx = "气血上限:"..math.ceil(v[2]*(1.1^t.level))
                 elseif v[1] == "法力上限" then
                  tx = "法力上限:"..math.ceil(v[2]*(1.1^t.level))
                 else
                  tx = v[1]..":"..math.ceil(v[2]*(1.1^t.level))
                end
                物品框.addView(loadlayout{
                  TextView;
                  text=Html.fromHtml(GetColor(tx,co));
                },num1)
                num1 = num1 + 1
              end
            end
            物品功能.addView(loadlayout{
              Button;
              id="洗练";
              layout_width="60dp";
              textSize=getsize(13);
              text="洗练";
            },1)
            物品功能.addView(loadlayout{
              Button;
              id="分解";
              layout_width="60dp";
              textSize=getsize(13);
              text="分解";
            },2)
            local j
            分解.onClick=function()
              if j ~= nil then
                j.dismiss()
              end
              j = AlertDialog.Builder(this)
              .setTitle("确认")
              .setMessage(Html.fromHtml("确定要分解"..Color:Get(t.key,t["品质"]).."吗?"))
              .setPositiveButton("取消",nil)
              .setNegativeButton("确认",function
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
                local str="分解成功，获得"
                for k,v in pairs(sl[t["品质"]]) do
                  local num = math.random(v[1],v[2])
                  Item:Add(k,num)
                  str=str..Color:Get(k,v[3])..num.."个!"
                end
                table.remove(SaveTable.Item,SaveTableClone(t))
                GetItemId()
                SetUI()
                MD提示(Html.fromHtml(str))
                a.dismiss()
                j.dismiss()
                adp.notifyDataSetChanged()
              end)
              .show();
            end
            洗练.onClick=function()
              local t1
              for k,v in pairs(SaveTable.owner.eq) do
                if Item:GetTable(v.key).type == t.type then
                  t1=Item:GetTable(v.key)
                  t1["附加属性"]=table.clone(v["附加属性"])
                  break
                end
              end
              if t1 ~= nil then
                if t1["品质"] < t["品质"] then
                  提示("不能用高等阶装备去洗练低等阶装备!")
                 else
                  e=AlertDialog.Builder(this).show()
                  e.getWindow().setContentView(loadlayout(MapUI()["洗练面板"]));
                  local tx1
                  for k,v in pairs(t["附加属性"]) do
                    local tb,co = TriggerTable(v,t)
                    if v[1] == "会心伤害" or v[1] == "会心免伤" or v[1] == "最终伤害放大" or v[1] == "最终伤害抵消" or string.find(v[1],"基础") then
                      tx1 = v[1]..":"..v[2].."%"
                     else
                      tx1 = v[1]..":"..math.ceil(v[2])
                    end
                    洗练选择.addView(loadlayout{
                      RadioButton;
                      text=Html.fromHtml(GetColor(tx1,co));
                    })
                  end
                  local ct
                  if t1["品质"] >= 13 then
                    ct = 10
                   elseif t1["品质"] > 9 then
                    ct = 7
                   elseif t1["品质"] > 6 then
                    ct = 5
                   elseif t1["品质"] > 3 then
                    ct = 3
                   else
                    ct = 2
                  end
                  local tx2
                  for i=1,ct do
                    if t1["附加属性"][i] ~= nil then
                      local tb,co = TriggerTable(t1["附加属性"][i],t1)
                      if t1["附加属性"][i][1] == "会心伤害" or t1["附加属性"][i][1] == "会心免伤" or t1["附加属性"][i][1] == "最终伤害放大" or t1["附加属性"][i][1] == "最终伤害抵消" or string.find(t1["附加属性"][i][1],"基础") then
                        tx2 = t1["附加属性"][i][1]..":"..t1["附加属性"][i][2].."%"
                       else
                        tx2 = t1["附加属性"][i][1]..":"..math.ceil(t1["附加属性"][i][2])
                      end
                      替换选择.addView(loadlayout{
                        RadioButton;
                        text=Html.fromHtml(GetColor(tx2,co));
                      })
                     else
                      替换选择.addView(loadlayout{
                        RadioButton;
                        text="——空——";
                      })
                    end
                  end
                  local xl
                  local th
                  洗练选择.setOnCheckedChangeListener{
                    onCheckedChanged=function(g,c)
                      local l=g.findViewById(c)
                      xl=l.Text
                  end}
                  替换选择.setOnCheckedChangeListener{
                    onCheckedChanged=function(g,c)
                      local l=g.findViewById(c)
                      th=l.Text
                  end}
                  function 关闭洗练()
                    e.dismiss()
                  end
                  function 开始洗练()
                    if not xl then
                      提示("请选择准备用于洗练的属性!")
                     elseif not th then
                      提示("请选择准备替换的属性!")
                     else
                      if th == "——空——" then
                        local x
                        local sj = split(xl,":")
                        for k,v in pairs(t1["附加属性"]) do
                          if sj[1] == v[1] then
                            x = true
                            break
                          end
                        end
                        if x then
                          提示("无法同时存在两种相同的属性!")
                         else
                          local ti = SaveTableClone(t)
                          for k,v in pairs(t["附加属性"]) do
                            if sj[1] == v[1] then
                              local xtb = table.clone(v)
                              table.remove(SaveTable.Item[ti]["附加属性"],k)
                              for q,w in pairs(SaveTable.owner.eq) do
                                if t1.key == w.key then
                                  table.insert(w["附加属性"],xtb)
                                  提示("属性洗练成功!")
                                  e.dismiss()
                                  a.dismiss()
                                  loadsavewrite()
                                  break
                                end
                              end
                              break
                            end
                          end
                        end
                       else
                        local sj = split(xl,":")
                        local sk = split(th,":")
                        local br
                        for k,v in pairs(t1["附加属性"]) do
                          if sj[1] == v[1] then
                            br = true
                            break
                          end
                        end
                        if (br == true and sk[1] ~= sj[1]) then
                          MD提示("无法存在两种相同的属性!")
                         else
                          local ti = SaveTableClone(t)
                          local x3
                          for k,v in pairs(t["附加属性"]) do
                            if sj[1] == v[1] then
                              x3 = table.clone(v)
                              table.remove(SaveTable.Item[ti]["附加属性"],k)
                              break
                            end
                          end
                          for k,v in pairs(t1["附加属性"]) do
                            if sk[1] == v[1] then
                              for q,w in pairs(SaveTable.owner.eq) do
                                if t1.key == w.key then
                                  table.remove(w["附加属性"],k)
                                  table.insert(w["附加属性"],x3)
                                  MD提示("洗练成功!")
                                  e.dismiss()
                                  a.dismiss()
                                  loadsavewrite()
                                  break
                                end
                              end
                              break
                            end
                          end
                        end
                      end
                    end
                  end
                end
               else
                local pd = {"武器","衣服","帽子","护手","鞋子","饰品"}
                MD提示("没有佩戴"..pd[t.type+1].."部位的法器，无法进行洗练操作!")
              end
            end
           elseif t["附加属性"] ~= nil then
            local str=""
            for k,v in pairs(t["附加属性"]) do
              if v.value[1] == "神念消耗" or v.value[1] == "材料消耗" then
                str=table.concat({str,"<br>",v.key,v.value[1],"降低:",v.value[2],"%"})
               elseif v.value[1] == "成丹率" or v.value[1] == "出丹率" or v.value[1] == "成功率" or v.value[1] == "评分提升" or v.value[1] == "属性品质" or v.value[1] == "获取经验" then
                str=table.concat({str,"<br>",v.key,v.value[1],"增加:",v.value[2],"%"})
              end
            end
            物品框.addView(loadlayout{
              TextView;
              text=Html.fromHtml("附加属性:"..Color:Get(str,t["品质"]));
            },5)
          end
        end
        local x = 1
        if t.type <= 5 and t.type >= 0 then
          if #SaveTable.owner.eq ~= 0 then
            repeat
            if t.type == Item:GetType(SaveTable.owner.eq[x].key) then
              使用物品.Text = "更换"
              break
             else
              x = x + 1
            end
            until x > #SaveTable.owner.eq
            if x > #SaveTable.owner.eq then
              使用物品.Text = "装备"
            end
           else
            使用物品.Text = "装备"
          end
         elseif (t.type == 9 and t["资源参数"] ~= nil) then
          使用物品.Text = "预览"
         elseif (t.type == -1) then
          if leixin(SaveTable["炼丹"].eq) == "table" and SaveTable["炼丹"].eq.key ~= nil then
            使用物品.Text = "更换"
           else
            使用物品.Text = "装备"
          end
         elseif (t.type == -2) then
          if leixin(SaveTable["炼器"].eq) == "table" and SaveTable["炼器"].eq.key ~= nil then
            使用物品.Text = "更换"
           else
            使用物品.Text = "装备"
          end
        end
        function UseItem()
          if t.type <= 5 and t.type >= 0 then
            if 使用物品.Text == "更换" then
              local eq = table.clone(SaveTable.owner.eq[x])
              local ipt = SaveTableClone(t)
              table.insert(SaveTable.owner.eq,table.clone(SaveTable.Item[ipt]))
              table.insert(SaveTable.Item,eq)
              table.remove(SaveTable.Item,ipt)
              table.remove(SaveTable.owner.eq,x)
              MD提示("装备更换成功!")
              GetItemId()
              loadsavewrite()
              a.dismiss()
              SetUI()
             else
              local itp = SaveTableClone(t)
              table.insert(SaveTable.owner.eq,table.clone(SaveTable.Item[itp]))
              table.remove(SaveTable.Item,itp)
              GetItemId()
              a.dismiss()
              SetUI()
              MD提示("装备成功")
              loadsavewrite()
            end
           else
            Item:tocontidion(t,a)
          end
        end
      end
    end
  end
  ItemShow({-5,100})
end
mgtb=敏感词()