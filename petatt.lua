require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
local ik = import "petinskill"
local jn = import "petskill"
local pet = import "petdata"
local pt = import "pettupo"

function getsiwei(data,id,lv)
  local sw = pet[id]["四维"]
  return {["体质"]=math.ceil(data[1]/2000*pt[lv].attribute),["真元"]=math.ceil(data[2]/2000*pt[lv].attribute),["身法"]=math.ceil(data[3]/2000*pt[lv].attribute),["肉身"]=math.ceil(data[4]/2000*pt[lv].attribute),["基础生命"]=0,["基础法力"]=0,["基础防御"]=0,["基础攻击"]=0,["基础会心"]=0,["基础命中"]=0,["基础闪避"]=0,["免伤"]=0,["减伤"]=0,["增伤"]=0,["附伤"]=0,["反伤"]=0,["气血回复"]=0,["法力回复"]=0,["物穿"]=0,["法穿"]=0}
end

function jichuup(pt,tb,lv)
  for i=1,#pt.inskill do
    for k,v in pairs(ik[pt.inskill[i].key].Attribute) do
      tb[k] = tb[k] + (v * math.ceil(((1 + ik[pt.inskill[i].key].step) ^ pt.inskill[i].level))*10)/10
    end
    for k,v in pairs(ik[pt.inskill[i].key].data) do
      if pt.inskill[i].level >= v[2] then
        tb[k] = tb[k] + v[1]
      end
    end
  end
  for i=1,#pt.skill do
    for k,v in pairs(jn[pt.skill[i].key]) do
      if string.find(k,"基础") then
        tb[k] = tb[k] + (v * math.ceil(((1 + jn[pt.skill[i].key].step) ^ pt.skill[i].level))*10)/10
      end
    end
    for k,v in pairs(jn[pt.skill[i].key].data) do
      if pt.skill[i].level >= v[2] then
        tb[k] = tb[k] + v[1]
      end
    end
  end
  return tb
end

function getbodyup(ptb,tb)
  for k,v in pairs(ptb.body) do
    tb[v.attribute[1]]=tb[v.attribute[1]] + math.ceil(v.attribute[2]*(1.092^(v.level-1)))
  end
  return tb
end

function petat(ptb,id)
  local tb = getsiwei(ptb["四维"],ptb.bh,ptb.level)
  tb = jichuup(ptb,tb)
  tb["气血上限"]=math.ceil((tb["体质"]*50+tb["真元"]*16+tb["肉身"]*16)*(1+tb["基础生命"]*0.01))
  tb["法力上限"]=math.ceil((tb["真元"]*40)*(1+tb["基础法力"]*0.01))
  tb["内攻"]=math.ceil((tb["真元"]*8)*(1+tb["基础攻击"]*0.01))
  tb["外攻"]=math.ceil((tb["肉身"]*4.5+tb["体质"]*4+tb["身法"]*0.8)*(1+tb["基础攻击"]*0.01))
  tb["内防"]=math.ceil((tb["真元"]*2.4+tb["肉身"]*3.2+tb["体质"]*2.4)*(1+tb["基础防御"]*0.01))
  tb["外防"]=math.ceil((tb["真元"]*0.8+tb["肉身"]*4+tb["体质"]*3.2)*(1+tb["基础防御"]*0.01))
  tb["会心率"]=math.ceil((tb["真元"]*0.8+tb["身法"]*4)*(1+tb["基础会心"]*0.01))
  tb["抗会心率"]=math.ceil((tb["体质"]*2.4+tb["肉身"]*2.4))
  tb["闪避"]=math.ceil((tb["身法"]*4)*(1+tb["基础闪避"]*0.01))
  tb["会心伤害"]=math.ceil(tb["真元"]*0.16+tb["身法"]*0.24+tb["肉身"]*0.08+50)
  tb["命中"]=math.ceil((tb["身法"]*2.4+tb["真元"]*1.6)*(1+tb["基础命中"]*0.01))
  tb["会心免伤"]=math.ceil(tb["体质"]*0.12+tb["肉身"]*0.24+50)
  tb["最终伤害放大"]=math.ceil(tb["真元"]*0.16+tb["身法"]*0.24)
  tb["最终伤害抵消"]=math.ceil(tb["肉身"]*0.24+tb["体质"]*0.2)
  tb = getbodyup(ptb,tb)
  ptb.attribute = tb
  --for k,v in pairs(tb) do
  --print(k.."="..v)
  --end
  return tb
end