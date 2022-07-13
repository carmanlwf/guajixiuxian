require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
local Color = {hui="#C6C6C6",black="#000000",white="#FFFFFF",green="#008000",blue="#0000FF",red="#FF0000",orange="#FFA500",gold="#FFD700"}
local Item = import "item"
local role = import "role"

function dxup(lv)
  local x,y
  if lv > 32 then
    x = 3600
    y = 20
   elseif lv > 28 then
    x = 3600
    y = 15
   elseif lv > 24 then
    x = 3600
    y = 10
   elseif lv > 20 then
    x = 3600
    y = 5
   elseif lv > 16 then
    x = 3600
    y = 3
   elseif lv > 12 then
    x = 2000
    y = 1
   else
    x = 5000
    y = 1
  end
  return x,y
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

local function getdrop()
  local t
  for k,v in pairs(role) do
    if type(v) == "table" then
      if v.level == SaveTable.owner.level then
        t = v.drop
      end
    end
  end
  return t
end

function 离线挂机()
  Http.get("http://api.k780.com/?app=life.time&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json",nil,nil,nil,function(q,w,e,r)
    if q ~= -1 then
      SaveTable.off=cjson.decode(w)["result"]["timestamp"]
      提示("开始离线挂机刷怪，上限时间1天(24小时)")
      loadsavewrite(0)
      task(2000,function os.exit() end)
    end
  end)
end

function 离线结算()
  if SaveTable.off ~= nil then
    local bj = {
      LinearLayout;
      orientation="vertical";
      layout_width="fill";
      layout_height="fill";
      {
        LinearLayout;
        orientation="vertical";
        layout_width="match_parent";
        layout_marginTop="45%h";
        {
          TextView;
          textColor="#000000";
          text="正在结算离线奖励,请勿中途退出…";
          layout_gravity="center";
        };
        {
          TextView;
          id="jd";
          textColor="#000000";
          text="进度:";
          layout_gravity="center";
        };
      };
    };
    activity.setContentView(bj)
    jd.Text="计算中.."
    Http.get("http://api.k780.com/?app=life.time&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json",nil,nil,nil,function(q,w,e,r)
      activity.setContentView(bj)
      if q ~= -1 and q >= 200 and q <= 400 and math.floor(cjson.decode(w)["result"]["timestamp"] - SaveTable.off) > 0 then
        local round = math.floor((cjson.decode(w)["result"]["timestamp"] - SaveTable.off)/60)
        local drop = getdrop()
        if round >= 10 then
          if round > 1440 then
            round = 1440
          end
          if SaveTable["刷新"] == nil then
            SaveTable["刷新"] = {}
          end
          for k,v in pairs(SaveTable["刷新"]) do
            v.number[1] = v.number[1] + 60 * round
            if v.number[1] >= v.number[2] then
              MD提示(v.key.."已刷新！")
              SaveTable["刷新"][k] = nil
            end
          end
          local num3 = math.floor(round * 60 / 300)
          local x,y = dxup(SaveTable.owner.level)
          local dx = 0
          for i=1,round*3 do
            if probability(1/x*60) then
              dx = dx + y
            end
          end
          SaveTable.owner["神念"] = SaveTable.owner["神念"] + (SaveTable.owner["神念上限"] * 0.01) * num3
          if SaveTable.owner["神念"] > SaveTable.owner["神念上限"] then
            SaveTable.owner["神念"] = SaveTable.owner["神念上限"]
          end
          local t = {["修为"]=0,["灵石"]=0,item={}}
          function 结算()
            if t ~= nil then
              SaveTable.owner["修为"] = SaveTable.owner["修为"] + t["修为"]
              SaveTable.owner.money = SaveTable.owner.money + t["灵石"]
              for k,v in pairs(SaveTable.pet) do
                if v.eq == 1 then
                  v["修为"] = v["修为"] + t["修为"]
                end
              end
              MD提示("当前已离线挂机"..math.floor(round).."分钟")
              提示("获得修为"..t["修为"].."点")
              提示("获得灵石"..t["灵石"].."点")
              if dx > 0 then
                SaveTable.owner["道心"] = SaveTable.owner["道心"] + dx
                提示("修炼之余，感悟天道，道心提升"..dx.."点")
              end
              local i = 0
              for k,v in pairs(t.item) do
                i=i+1
                Item:Add(k,v)
                提示(Html.fromHtml("获得物品"..Color:Get(k,tonumber(Item:GetPinzhi(k))).."*"..v))
              end
              t=nil
              SaveTable.off = nil
              loadsavewrite(0)
              saveloadfile("主界面",true)
            end
          end
          local nnn = 0
          local num1 = round
          local lx=Ticker()
          lx.Period=1
          lx.onTick=function()
            if nnn ~= nil and nnn < num1 then
              t["修为"]=t["修为"]+drop["修为"]*20
              t["灵石"]=t["灵石"]+drop.money*20
              for k,v in pairs(drop.item) do
                if probability(v.probability*20) then
                  if t.item[v.drop] ~= nil then
                    t.item[v.drop] = t.item[v.drop] + math.ceil(v.probability*20)
                   else
                    t.item[v.drop] = math.ceil(v.probability*20)
                  end
                end
              end
              if drop["随机材料"] ~= nil then
                for k,v in pairs(Item) do
                  if type(v) == "table" then
                    if v.type >= 10 and v.type < 14 and v["品质"] == drop["随机材料"][1] then
                      local gl = drop["随机材料"][3] * 5
                      if v.pro ~= nil then
                        gl = gl * v.pro
                      end
                      if probability(gl) then
                        local num = math.random(drop["随机材料"][2][1],drop["随机材料"][2][2])
                        if t.item[v.key] ~= nil then
                          t.item[v.key] = t.item[v.key] + num * 4
                         else
                          t.item[v.key] = num * 4
                        end
                      end
                    end
                  end
                end
              end
              if math.ceil((nnn-1)/(round*5)*100) < math.ceil(nnn/(round)*100) then
                jd.Text=table.concat({"结算进度:",math.ceil(nnn/(round)*100),"%"})
              end
              nnn = nnn + 1
             elseif nnn ~= nil then
              nnn = nil
              lx.stop()
              结算()
            end
          end
          lx.start()
         else
          SaveTable.off = nil
          loadsavewrite(0)
          saveloadfile("主界面",true)
          提示("离线挂机时间不足10分钟，无法获得收益")
        end
       else
        提示("无法获取网络时间")
        activity.finish()
      end
    end)
   else
    saveloadfile("主界面",true)
  end
end