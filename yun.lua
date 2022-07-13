import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "java.io.File" -- 文件操作类
import "Game" -- 导入模块
import "android.provider.Settings"
import "android.content.Intent"
import "android.net.Uri"

function tmkey()
  local nstr=http.get("http://82.157.62.200/time.php?")
  local num = 0
  local nums = ""
  for i=1,#nstr do
    local n = math.random(1,9)
    num = tonumber(string.sub(nstr,i,i)) * n + num
    nums = table.concat({nums,n})
  end
  num = num ^ 2
  return table.concat({math.ceil(tonumber(nums)),"|",math.ceil(num)})
end

function unicode2utf8(s)
  return loadstring([[return "]]..s
  :gsub("\\","\\\\")
  :gsub("\\\\u","\\u")
  :gsub("\"","\\\"")..[["]])()
end

function 账号管理()
  local function getTimeStamp(t)
    return os.date("%Y年%m月%d日%H时%M分%S秒上传",t)
  end
  local tb
  local ph
  local zg = {
    LinearLayout;
    background='#ffffffff';
    orientation="vertical";
    layout_height="fill";
    gravity="center";
    layout_width="fill";
    {
      LinearLayout;
      orientation="horizontal";
      {
        TextView;
        text="当前账号:"..解密("role/zh");
        textColor="#000000";
      };
      {
        Button;
        text="更换账号";
        onClick=function
          fd("role/zh")
          fd("role/mm")
          登录()
          ph.dismiss()
        end;
      };
    };
    {
      TextView;
      id="云";
      textColor="#000000";
      text="云存档:";
    };
    {
      LinearLayout;
      orientation="horizontal";
      {
        Button;
        onClick=function
          local cjson = import "cjson"
          local db = decosave()
          local it = table.clone(db.Item)
          local pt = table.clone(db.pet)
          db.pet=nil
          db.Item=nil
          上传存档({id=解密("role/zh"),save=cjson.encode(db),item=cjson.encode(it),pet=cjson.encode(pt),type="1"})
          ph.dismiss()
        end;
        text="上传存档";
      };
      {
        Button;
        onClick=function
          if tb ~= nil then
            local jkka = 加载框()
            hs("http://82.157.62.200/yxg.php?id="..解密("role/zh").."&type=0&key="..tmkey(),function(code,body)
              if code ~= -1 and code >= 200 and code <= 400 then
                if body == "400" then
                  SaveTable = tb
                  loadsavewrite(0)
                  SaveTable = nil
                  提示("存档已恢复")
                  ph.dismiss()
                 else
                  提示("没有云存档数据")
                  ph.dismiss()
                end
              end
              jkka.dismiss()
            end)
           else
            提示("你还没有上传云存档")
          end
        end;
        text="恢复存档";
      };
    };
  };
  ph = PopupWindow(activity)--创建PopWindow
  ph.setContentView(loadlayout(zg))--设置布局
  ph.setWidth(-2)--设置宽度
  ph.setHeight(-2)--设置高度
  --ph.setFocusable(false)--设置可获得焦点
  --ph.getBackground().setAlpha(0)
  ph.setTouchable(true)--设置可触摸
  --设置点击外部区域是否可以消失
  ph.setOutsideTouchable(true)
  --显示
  ph.showAtLocation(view,Gravity.CENTER,0,0)
  fp("http://82.157.62.200/ccd.php?",{id=解密("role/zh"),type="1"},function(code,body)
    if code ~= -1 and code >= 200 and code <= 400 then
      if body == "404" then
        云.Text = "云存档:无"
       else
        local tab = cjson.decode(body)
        tb = cjson.decode(tab.data)
        tb.Item = cjson.decode(tab.item)
        tb.pet = cjson.decode(tab.pet)
        云.Text = "云存档:"..getTimeStamp(tonumber(tab.time))
      end
     else
      提示("网络连接失败")
    end
  end)
end

function urlDecode(s)
  s = string.gsub(s, '%%(%x%x)', function(h)
  return string.char(tonumber(h, 16)) end)
  return s
end
--主视图事件import "android.provider.Settings"
function 判断悬浮窗权限()
  if (Build.VERSION.SDK_INT >= 23 and not Settings.canDrawOverlays(this)) then
    return false
   elseif Build.VERSION.SDK_INT < 23 then
    return nil
   else
    return true
  end
end
function 获取悬浮窗权限()
  intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION);
  intent.setData(Uri.parse("package:" .. activity.getPackageName()));
  activity.startActivityForResult(intent, 100);
end

function 上传存档(data)
  弹框("上传云存档后将会强制删除本地存档，确定继续吗?","确定",function
    local jjy = 加载框()
    fp("http://82.157.62.200/sc.php?",data,function(code,body)
      if code ~= -1 and code >= 200 and code <= 400 and body == "400" then
        jjy.dismiss()
        提示("上传成功")
        清理存档()
       else
        提示("网络连接失败")
      end
    end)
  end)
end

function 登录()
  SaveTable = nil
  if fe("role/zh") == true and fe("role/mm") == true then
    local zh = 解密("role/zh")
    local mm = 解密("role/mm")
    hs("http://82.157.62.200/Gamewap/reg.php?type=2&user="..zh.."&pass="..mm,function(code,body)
      local 返回 = body
      if 返回 == nil or 返回 == "" then
        提示("网络不稳定！")
       elseif 返回 == "402"
        提示("登录成功")
        加密创建("role/zh",zh) -- 写入账号
        加密创建("role/mm",mm) -- 写入密码
       elseif 返回 == "403"
        提示("账号或密码错误")
       elseif 返回 == "405"
        提示("该账号并未注册！")
       else
        提示("未知错误")
      end
    end)
   else
    local zh = {
      LinearLayout;
      orientation="vertical";
      layout_height="fill";
      gravity="center";
      layout_width="fill";
      {
        EditText;
        id="zhbjk";
        hint="请输入账号";
      };
      {
        EditText;
        id="mmbjk";
        hint="请输入密码";
      };
      {
        Button;
        id="button1";
        text="注册";
      };
      {
        Button;
        id="button2";
        text="登录";
      };
    };

    -- 登录游戏
    local 视图 = AlertDialog.Builder(activity)
    .setView(loadlayout(zh)) -- 显示视图
    local 对话框 = 视图.show() -- 显示
    对话框.setCanceledOnTouchOutside(false)
    对话框.setCancelable(false)
    button1.onClick=function() -- 注册系统
      local zh = zhbjk.text
      local zhcd = #zh
      local mm = mmbjk.text
      local mmcd = #mm
      if zh == "" or mm == "" then
        提示("账号或密码为空！")
       elseif zhcd <= 6 or mmcd <= 6 then
        提示("账号或密码长度不能小于6位")
       elseif zhcd > 12 or mmcd > 12 then
        提示("账号或密码长度不能大于12位")
       elseif HasChinese(zh) then
        提示("账号不可设置为中文")
       else
        -- 获取后台账号系统
        hs("http://82.157.62.200/Gamewap/reg.php?type=1&user="..zh.."&pass="..mm,function(code,body)
          local 返回 = body
          if 返回 == nil or 返回 == "" then
            提示("网络不稳定！")
           elseif 返回 == "403"
            提示("账号已被使用")
           elseif 返回 == "402"
            提示("注册登录成功!")
            fw("role")
            加密创建("role/zh",zh) -- 写入账号
            加密创建("role/mm",mm) -- 写入密码
            对话框.dismiss() -- 关闭对话宽
           else
            提示("未知错误")
          end
        end)
      end
    end
    button2.onClick=function() -- 登录系统
      local zh = zhbjk.text
      local zhcd = #zh
      local mm = mmbjk.text
      local mmcd = #mm
      if zh == "" or mm == "" then
        提示("账号或密码为空！")
       elseif zhcd <= 6 or mmcd <= 6 then
        提示("账号或密码长度不能小于6位")
       elseif zhcd > 12 or mmcd > 12 then
        提示("账号或密码长度不能大于12位")
       else
        -- 获取后台账号系统
        hs("http://82.157.62.200/Gamewap/reg.php?type=2&user="..zh.."&pass="..mm,function(code,body)
          local 返回 = body
          if 返回 == nil or 返回 == "" then
            提示("网络不稳定！")
           elseif 返回 == "402"
            提示("登录成功")
            fw("role")
            加密创建("role/zh",zh) -- 写入账号
            加密创建("role/mm",mm) -- 写入密码
            对话框.dismiss() -- 关闭对话宽
           elseif 返回 == "403"
            提示("账号或密码错误")
           elseif 返回 == "405"
            提示("该账号并未注册！")
           else
            提示("未知错误")
          end
        end)
      end
    end
  end
end
-- 文本1 控件事件
function 重新登录()
  local zh = {
    LinearLayout;
    orientation="vertical";
    layout_height="fill";
    gravity="center";
    layout_width="fill";
    {
      EditText;
      id="zhbjk";
      hint="请输入账号";
    };
    {
      EditText;
      id="mmbjk";
      hint="请输入密码";
    };
    {
      Button;
      id="button1";
      text="注册";
    };
    {
      Button;
      id="button2";
      text="登录";
    };
  };

  -- 登录游戏
  local 视图 = AlertDialog.Builder(activity)
  .setView(loadlayout(zh)) -- 显示视图
  local 对话框 = 视图.show() -- 显示
  对话框.setCanceledOnTouchOutside(false)
  对话框.setCancelable(false)
  button1.onClick=function() -- 注册系统
    local zh = zhbjk.text
    local zhcd = #zh
    local mm = mmbjk.text
    local mmcd = #mm
    if zh == "" or mm == "" then
      提示("账号或密码为空！")
     elseif zhcd <= 6 or mmcd <= 6 then
      提示("账号或密码长度不能小于6位")
     elseif zhcd > 12 or mmcd > 12 then
      提示("账号或密码长度不能大于12位")
     elseif HasChinese(zh) then
      提示("账号不可设置为中文")
     else
      -- 获取后台账号系统
      hs("http://82.157.62.200/Gamewap/reg.php?type=1&user="..zh.."&pass="..mm,function(code,body)
        local 返回 = body
        if 返回 == nil or 返回 == "" then
          提示("网络不稳定！")
         elseif 返回 == "403"
          提示("账号已被使用")
         elseif 返回 == "402"
          提示("注册登录成功!")
          fw("role")
          加密创建("role/zh",zh) -- 写入账号
          加密创建("role/mm",mm) -- 写入密码
          SaveTable.zh = zh
          对话框.dismiss() -- 关闭对话宽
         else
          提示("未知错误")
        end
      end)
    end
  end
  button2.onClick=function() -- 登录系统
    local zh = zhbjk.text
    local zhcd = #zh
    local mm = mmbjk.text
    local mmcd = #mm
    if zh == "" or mm == "" then
      提示("账号或密码为空！")
     elseif zhcd <= 6 or mmcd <= 6 then
      提示("账号或密码长度不能小于6位")
     elseif zhcd > 12 or mmcd > 12 then
      提示("账号或密码长度不能大于12位")
     elseif HasChinese(zh) then
      提示("账号不可设置为中文")
     else
      -- 获取后台账号系统
      hs("http://82.157.62.200/Gamewap/reg.php?type=2&user="..zh.."&pass="..mm,function(code,body)
        local 返回 = body
        if 返回 == nil or 返回 == "" then
          提示("网络不稳定！")
         elseif 返回 == "402"
          提示("登录成功")
          fw("role")
          加密创建("role/zh",zh) -- 写入账号
          加密创建("role/mm",mm) -- 写入密码
          对话框.dismiss() -- 关闭对话宽
          SaveTable.zh = zh
         elseif 返回 == "403"
          提示("账号或密码错误")
         elseif 返回 == "405"
          提示("该账号并未注册！")
         else
          提示("未知错误")
        end
      end)
    end
  end
end