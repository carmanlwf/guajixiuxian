--全局开启全屏
activity.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,WindowManager.LayoutParams.FLAG_FULLSCREEN)
--activity.ActionBar.hide() -- 隐藏标题栏

function 加群(群号)
  url="mqqapi://card/show_pslcard?src_type=internal&version=1&uin="..群号.."&card_type=group&source=qrcode"
  activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
end

--背景调控器
--控件id，边框宽度，圆角度数，内部颜色，边框颜色
function hs(u,callback)
  Http.get(u,function(code,body)
    callback(code,body)
  end)
end

function fp(u,data,callback)
  Http.post(u,data,function(code,body)
    callback(code,body)
  end)
end

--下载文件
--网址，保存路径
function hd(u,p)
  local o = http.download(u,p)
  hd内容 = o
end

--上传文件
--网址，文件标题，文件路径

function hd(u,p,callback)
  Http.download(u,p,function(code,body)
    callback(code,body)
  end)
end

function fu(u,t,p,callback)
  local code,cook,body = http.upload(u,{title=t,msg="上传文件"},{file=p})
  callback(code,body)
end

function tw(nr)
  Toast.makeText(activity,nr,Toast.LENGTH_SHORT).show()
end

function GetFilelastTime(path)
  f = File(path);
  cal = Calendar.getInstance();
  time = f.lastModified()
  cal.setTimeInMillis(time);
  修改时间 = cal.getTime().toLocaleString()
end

function GetFileSize(path)
  import "java.io.File"
  import "android.text.format.Formatter"
  size=File(tostring(path)).length()
  Sizes=Formatter.formatFileSize(activity, size)
  文件大小 = Sizes
end

function fw(lj)
  --创建文件夹--
  local lj=activity.getLuaDir().."/data/"..lj
  File(lj).mkdirs()
end

function fe(lj)
  --判断文件存在--
  local 文件储存路径 = activity.getLuaDir().."/data/"..lj..".jar"
  return File(文件储存路径).isFile()
end

function fd(路径)
  local lj=activity.getLuaDir().."/data/"..路径..".jar"
  File(lj).delete()
end

function 写入背包(文件名称,材料类型,材料名称,材料数量,材料id)
  fe("role/bb/"..文件名称)
  if 是否存在 == false then
    -- 新写入
    local 材料信息 = "物品类型："..材料类型..",\n材料名称："..材料名称..",\n材料数量："..材料数量..",\n材料介绍："..材料库[1][材料id].材料介绍..",\n材料礼包："..材料库[1][材料id].材料礼包..",\n材料价格："..材料库[1][材料id].材料价格..","
    加密创建("role/bb/"..文件名称,材料信息)
   else
    -- 叠加写入数量
    解密("role/bb/"..文件名称)
    cl = 解密内容
    cllx = string.match(cl,"物品类型：(.-),")
    clmc = string.match(cl,"材料名称：(.-),")
    clsl = string.match(cl,"材料数量：(.-),")
    slj = tonumber(clsl + 材料数量)
    local 材料信息 = "物品类型："..cllx..",\n材料名称："..clmc..",\n材料数量："..slj..",\n材料介绍："..材料库[1][材料id].材料介绍..",\n材料礼包："..材料库[1][材料id].材料礼包..",\n材料价格："..材料库[1][材料id].材料价格..","
    加密创建("role/bb/"..文件名称,材料信息)
  end
end


function 扣除背包(文件名称,材料类型,材料名称,材料数量,材料id)
  fe("role/bb/"..文件名称)
  if 是否存在 == false then
    -- 新写入
    local 材料信息 = "物品类型："..材料类型..",\n材料名称："..材料名称..",\n材料数量：0,\n材料介绍："..材料库[1][材料id].材料介绍..",\n材料礼包："..材料库[1][材料id].材料礼包..",\n材料价格："..材料库[1][材料id].材料价格..","
    加密创建("role/bb/"..文件名称,材料信息)
   else
    -- 叠加写入数量
    解密("role/bb/"..文件名称)
    cl = 解密内容
    cllx = string.match(cl,"物品类型：(.-),")
    clmc = string.match(cl,"材料名称：(.-),")
    clsl = string.match(cl,"材料数量：(.-),")
    slj = tonumber(clsl - 材料数量)
    local 材料信息 = "物品类型："..cllx..",\n材料名称："..clmc..",\n材料数量："..slj..",\n材料介绍："..材料库[1][材料id].材料介绍..",\n材料礼包："..材料库[1][材料id].材料礼包..",\n材料价格："..材料库[1][材料id].材料价格..","
    加密创建("role/bb/"..文件名称,材料信息)
  end
end

function 后台播放()
  import "android.media.MediaPlayer"
  mediaPlayer1 = MediaPlayer()
  --初始化参数
  mediaPlayer1.reset()
  --设置播放资源
  mediaPlayer1.setDataSource(activity.getLuaDir().."/src/gx.mp3")
  --开始缓冲资源
  mediaPlayer1.prepare()
  --是否循环播放该资源
  mediaPlayer1.setLooping(true)
  --开始播放
  mediaPlayer1.start()
end

function 按钮播放()
  import "android.media.MediaPlayer"
  mediaPlayer2 = MediaPlayer()
  --初始化参数
  mediaPlayer2.reset()
  --设置播放资源
  mediaPlayer2.setDataSource(activity.getLuaDir().."/src/anyx.mp3")
  --开始缓冲资源
  mediaPlayer2.prepare()
  --开始播放
  mediaPlayer2.start()
end

function 字体美化(控件id)
  -- 字体包
  import "android.graphics.*"
  --加粗文本字体
  控件id.getPaint().setFakeBoldText(true)
end

-- 获取控件高宽
function getwh(view)
  view.measure(View.MeasureSpec.makeMeasureSpec(0,View.MeasureSpec.UNSPECIFIED),View.MeasureSpec.makeMeasureSpec(0,View.MeasureSpec.UNSPECIFIED));
  height =view.getMeasuredHeight();
  width =view.getMeasuredWidth();
  return width,height
end

--加密
function 加密创建(k,内容)
  local lj=activity.getLuaDir().."/data/"..k..".jar"
  io.open(lj,"w"):write(内容):close()
  local lj=activity.getLuaDir().."/data/"..k..".jar"
  source_str=io.open(lj):read("*a")
  local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  local s64 = ''
  local str = source_str

  while #str > 0 do
    local bytes_num = 0
    local buf = 0

    for byte_cnt=1,3 do
      buf = (buf * 256)
      if #str > 0 then
        buf = buf + string.byte(str, 1, 1)
        str = string.sub(str, 2)
        bytes_num = bytes_num + 1
      end
    end

    for group_cnt=1,(bytes_num+1) do
      local b64char = math.fmod(math.floor(buf/262144), 64) + 1
      s64 = s64 .. string.sub(b64chars, b64char, b64char)
      buf = buf * 64
    end

    for fill_cnt=1,(3-bytes_num) do
      s64 = s64 .. '='
    end
  end
  a=string.gsub(s64,"0","ZQJDNSOWHEJEEIHEHRDIHDEHEJUEBEJEEJHDDBDIFFJFUFHFR棂")
  b=string.gsub(a,"1","XUSBDIDBSKDHDBEKWJWHWBEURHBEJEHEHEJHDHHHDHDHDHDUEKS翼")
  c=string.gsub(b,"2","whdbejdhdbsjJDJDJEJEJDJSKSKISQLALQOQOORNRBRVXMZIDHJ贰")
  d=string.gsub(c,"3","ZHXUJDKEOWKWKWKQKWLWLSKSJHEBWBSJSHEWJWJWNWNSNDBJDJD糁")
  e=string.gsub(d,"4","ehdhsnsjsjJDJKWOWOWEIRHJEOEJEHEWIWOSHBEBSZNSNGRHEJH嗣")
  f=string.gsub(e,"5","wWdnKEKWWKWHWBJWJEBEHGHENEEMBVWIODJHWLDUEJEJRODKLLJ无")
  io.open(lj,"w"):write(f):close()
end

function 解密(k)
  local lj=activity.getLuaDir().."/data/"..k..".jar"
  o=io.open(lj):read("*a")
  a=string.gsub(o,"ZQJDNSOWHEJEEIHEHRDIHDEHEJUEBEJEEJHDDBDIFFJFUFHFR棂","0")
  b=string.gsub(a,"XUSBDIDBSKDHDBEKWJWHWBEURHBEJEHEHEJHDHHHDHDHDHDUEKS翼","1")
  c=string.gsub(b,"whdbejdhdbsjJDJDJEJEJDJSKSKISQLALQOQOORNRBRVXMZIDHJ贰","2")
  d=string.gsub(c,"ZHXUJDKEOWKWKWKQKWLWLSKSJHEBWBSJSHEWJWJWNWNSNDBJDJD糁","3")
  e=string.gsub(d,"ehdhsnsjsjJDJKWOWOWEIRHJEOEJEHEWIWOSHBEBSZNSNGRHEJH嗣","4")
  str64=string.gsub(e,"wWdnKEKWWKWHWBJWJEBEHGHENEEMBVWIODJHWLDUEJEJRODKLLJ无","5")
  local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  local temp={}
  for i=1,64 do
    temp[string.sub(b64chars,i,i)] = i
  end
  temp['=']=0
  local str=""
  for i=1,#str64,4 do
    if i>#str64 then
      break
    end
    local data = 0
    local str_count=0
    for j=0,3 do
      local str1=string.sub(str64,i+j,i+j)
      if not temp[str1] then
        return
      end
      if temp[str1] < 1 then
        data = data * 64
       else
        data = data * 64 + temp[str1]-1
        str_count = str_count + 1
      end
    end
    for j=16,0,-8 do
      if str_count > 0 then
        str=str..string.char(math.floor(data/math.pow(2,j)))
        data=math.fmod(data,math.pow(2,j))
        str_count = str_count - 1
      end
    end
  end


  local last = tonumber(string.byte(str, string.len(str), string.len(str)))
  if last == 0 then
    str = string.sub(str, 1, string.len(str) - 1)
  end
  return str
end


function boto(k)
  o=k
  a=string.gsub(o,"ZQJDNSOWHEJEEIHEHRDIHDEHEJUEBEJEEJHDDBDIFFJFUFHFR棂","0")
  b=string.gsub(a,"XUSBDIDBSKDHDBEKWJWHWBEURHBEJEHEHEJHDHHHDHDHDHDUEKS翼","1")
  c=string.gsub(b,"whdbejdhdbsjJDJDJEJEJDJSKSKISQLALQOQOORNRBRVXMZIDHJ贰","2")
  d=string.gsub(c,"ZHXUJDKEOWKWKWKQKWLWLSKSJHEBWBSJSHEWJWJWNWNSNDBJDJD糁","3")
  e=string.gsub(d,"ehdhsnsjsjJDJKWOWOWEIRHJEOEJEHEWIWOSHBEBSZNSNGRHEJH嗣","4")
  str64=string.gsub(e,"wWdnKEKWWKWHWBJWJEBEHGHENEEMBVWIODJHWLDUEJEJRODKLLJ无","5")
  local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  local temp={}
  for i=1,64 do
    temp[string.sub(b64chars,i,i)] = i
  end
  temp['=']=0
  local str=""
  for i=1,#str64,4 do
    if i>#str64 then
      break
    end
    local data = 0
    local str_count=0
    for j=0,3 do
      local str1=string.sub(str64,i+j,i+j)
      if not temp[str1] then
        return
      end
      if temp[str1] < 1 then
        data = data * 64
       else
        data = data * 64 + temp[str1]-1
        str_count = str_count + 1
      end
    end
    for j=16,0,-8 do
      if str_count > 0 then
        str=str..string.char(math.floor(data/math.pow(2,j)))
        data=math.fmod(data,math.pow(2,j))
        str_count = str_count - 1
      end
    end
  end


  local last = tonumber(string.byte(str, string.len(str), string.len(str)))
  if last == 0 then
    str = string.sub(str, 1, string.len(str) - 1)
  end
  otob=str
end

function 装备显示()
  解密("role/zb/wq")
  local 武器 = 解密内容
  if 武器 == "无" then
    ckwb1.text = "武器："..武器
   else
    local 装备名称 = string.match(武器,"装备名称：(.-),")
    local 强化等级 = string.match(武器,"强化等级：(.-),")
    ckwb1.text = "武器："..装备名称.."＋"..强化等级
  end
  解密("role/zb/sy")
  local 上衣 = 解密内容
  if 上衣 == "无" then
    ckwb2.text = "上衣："..上衣
   else
    local 装备名称 = string.match(上衣,"装备名称：(.-),")
    local 强化等级 = string.match(上衣,"强化等级：(.-),")
    ckwb2.text = "上衣："..装备名称.."＋"..强化等级
  end
  解密("role/zb/ht")
  local 护腿 = 解密内容
  if 护腿 == "无" then
    ckwb3.text = "护腿："..护腿
   else
    local 装备名称 = string.match(护腿,"装备名称：(.-),")
    local 强化等级 = string.match(护腿,"强化等级：(.-),")
    ckwb3.text = "护腿："..装备名称.."＋"..强化等级
  end
  解密("role/zb/xz")
  local 脚部 = 解密内容
  if 脚部 == "无" then
    ckwb4.text = "鞋子："..脚部
   else
    local 装备名称 = string.match(脚部,"装备名称：(.-),")
    local 强化等级 = string.match(脚部,"强化等级：(.-),")
    ckwb4.text = "鞋子："..装备名称.."＋"..强化等级
  end
  解密("role/zb/sb")
  local 手部 = 解密内容
  if 手部 == "无" then
    ckwb5.text = "手部："..手部
   else
    local 装备名称 = string.match(手部,"装备名称：(.-),")
    local 强化等级 = string.match(手部,"强化等级：(.-),")
    ckwb5.text = "手部："..装备名称.."＋"..强化等级
  end
  解密("role/zb/xl")
  local 颈部 = 解密内容
  if 颈部 == "无" then
    ckwb6.text = "项链："..颈部
   else
    local 装备名称 = string.match(颈部,"装备名称：(.-),")
    local 强化等级 = string.match(颈部,"强化等级：(.-),")
    ckwb6.text = "项链："..装备名称.."＋"..强化等级
  end
  解密("role/zb/fs")
  local 副手 = 解密内容
  if 副手 == "无" then
    ckwb7.text = "副手："..副手
   else
    local 装备名称 = string.match(副手,"装备名称：(.-),")
    local 强化等级 = string.match(副手,"强化等级：(.-),")
    ckwb7.text = "副手："..装备名称.."＋"..强化等级
  end
  解密("role/zb/sw")
  local 手腕 = 解密内容
  if 手腕 == "无" then
    ckwb8.text = "手镯："..手腕
   else
    local 装备名称 = string.match(手腕,"装备名称：(.-),")
    local 强化等级 = string.match(手腕,"强化等级：(.-),")
    ckwb8.text = "手镯："..装备名称.."＋"..强化等级
  end
end


function 装备替换(lj)
  解密(lj)
  替换内容 = 解密内容
  装备区分1 = string.match(替换内容,"物品类型：(.-),")
  装备名称1 = string.match(替换内容,"装备名称：(.-),")
  装备类型1 = string.match(替换内容,"装备类型：(.-),")
  装备品质1 = string.match(替换内容,"装备品质：(.-),")
  装备强度1 = string.match(替换内容,"装备强度：(.-),")
  强化等级1 = string.match(替换内容,"强化等级：(.-),")
  强化上限1 = string.match(替换内容,"强化上限：(.-),")
  强化消耗1 = string.match(替换内容,"强化消耗：(.-),")
  强化概率1 = string.match(替换内容,"强化概率：(.-),")
  精炼等级1 = string.match(替换内容,"精炼等级：(.-),")
  精炼消耗1 = string.match(替换内容,"精炼消耗：(.-),")
  精炼概率1 = string.match(替换内容,"精炼概率：(.-),")
  装备生命1 = string.match(替换内容,"装备生命：(.-),")
  装备魔力1 = string.match(替换内容,"装备魔力：(.-),")
  装备物理攻击1 = string.match(替换内容,"装备物理攻击：(.-),")
  装备魔法攻击1 = string.match(替换内容,"装备魔法攻击：(.-),")
  装备物理防御1 = string.match(替换内容,"装备物理防御：(.-),")
  装备魔法防御1 = string.match(替换内容,"装备魔法防御：(.-),")
  装备暴击1 = string.match(替换内容,"装备暴击：(.-),")
  装备暴击伤害1 = string.match(替换内容,"装备暴击伤害：(.-),")
  装备暴击抗性1 = string.match(替换内容,"装备暴击抗性：(.-),")
  装备命中1 = string.match(替换内容,"装备命中：(.-),")
  装备闪避1 = string.match(替换内容,"装备闪避：(.-),")
  装备物理穿透1 = string.match(替换内容,"装备物理穿透：(.-),")
  装备魔法穿透1 = string.match(替换内容,"装备魔法穿透：(.-),")
  装备力量1 = string.match(替换内容,"装备力量：(.-),")
  装备敏捷1 = string.match(替换内容,"装备敏捷：(.-),")
  装备智力1 = string.match(替换内容,"装备智力：(.-),")
  装备体质1 = string.match(替换内容,"装备体质：(.-),")
  力量宝石1 = string.match(替换内容,"力量宝石：(.-),")
  智力宝石1 = string.match(替换内容,"智力宝石：(.-),")
  敏捷宝石1 = string.match(替换内容,"敏捷宝石：(.-),")
  体质宝石1 = string.match(替换内容,"体质宝石：(.-),")
  装备附魔1 = string.match(替换内容,"装备附魔：(.-),")
  装备价格1 = string.match(替换内容,"装备价格：(.-),")
  装备状态1 = string.match(替换内容,"是否锁定：(.-),")
  zb1 = "物品类型："..装备区分1..",\n装备名称："..装备名称1..",\n装备类型："..装备类型1..",\n装备品质："..装备品质1..",\n装备强度："..装备强度1..",\n强化等级："..强化等级1..",\n强化消耗："..强化消耗1..",\n强化概率："..强化概率1..",\n强化上限："..强化上限1..",\n精炼等级："..精炼等级1..",\n精炼消耗："..精炼消耗1..",\n精炼概率："..精炼概率1..",\n装备生命："..装备生命1..",\n装备魔力："..装备魔力1..",\n装备物理攻击："..装备物理攻击1..",\n装备魔法攻击："..装备魔法攻击1..",\n装备物理防御："..装备物理防御1..",\n装备魔法防御："..装备魔法防御1..",\n装备暴击："..装备暴击1..",\n装备暴击伤害："..装备暴击伤害1..",\n装备暴击抗性："..装备暴击抗性1..",\n装备命中："..装备命中1..",\n装备闪避："..装备闪避1..",\n装备物理穿透："..装备物理穿透1..",\n装备魔法穿透："..装备魔法穿透1..",\n装备力量："..装备力量1..",\n装备敏捷："..装备敏捷1..",\n装备智力："..装备智力1..",\n装备体质："..装备体质1..",\n力量宝石："..力量宝石1..",\n敏捷宝石："..敏捷宝石1..",\n智力宝石："..智力宝石1..",\n体质宝石："..体质宝石1..",\n装备附魔："..装备附魔1..",\n装备价格："..装备价格1..",\n是否锁定："..装备状态1..","
end
function 替换()
  角色属性()
  jc1 = tonumber(smx-装备生命1)
  jc2 = tonumber(mlx-装备魔力1)
  jc3 = tonumber(wlgj-装备物理攻击1)
  jc4 = tonumber(mfgj-装备魔法攻击1)
  jc5 = tonumber(wlfy-装备物理防御1)
  jc6 = tonumber(mffy-装备魔法防御1)
  jc7 = tonumber(bjl-装备暴击1)
  jc8 = tonumber(bjsh-装备暴击伤害1)
  jc9 = tonumber(bjkx-装备暴击抗性1)
  jc10 = tonumber(wlct-装备物理穿透1)
  jc11 = tonumber(mfct-装备魔法穿透1)
  jc12 = tonumber(mzl-装备命中1)
  jc13 = tonumber(sbl-装备闪避1)
  jc14 = tonumber(ll-装备力量1)
  jc15 = tonumber(mj-装备敏捷1)
  jc16 = tonumber(zl-装备智力1)
  jc17 = tonumber(tz-装备体质1)
  加密创建("role/sm",jc1) -- 生命
  加密创建("role/smx",jc1) -- 最大生命
  加密创建("role/ml",jc2) -- 魔力
  加密创建("role/mlx",jc2) -- 最大魔力
  加密创建("role/wlgj",jc3) -- 物理攻击
  加密创建("role/mfgj",jc4) -- 魔法攻击
  加密创建("role/wlfy",jc5) -- 物理防御
  加密创建("role/mffy",jc6) -- 魔法防御
  加密创建("role/bjl",jc7) -- 暴击率
  加密创建("role/bjsh",jc8) -- 暴击伤害
  加密创建("role/bjkx",jc9) -- 暴击抗性
  加密创建("role/mzl",jc12) -- 命中率
  加密创建("role/sbl",jc13) -- 闪避率
  加密创建("role/wlct",jc10) -- 物理穿透
  加密创建("role/mfct",jc11) -- 魔法穿透
  加密创建("role/ll",jc14) -- 力量
  加密创建("role/mj",jc15) -- 敏捷
  加密创建("role/zl",jc16) -- 智力
  加密创建("role/tz",jc17) -- 体质
end