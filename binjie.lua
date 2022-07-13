require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

function 兵解()
  dsq.stop()
  activity.setContentView(loadlayout(MapUI()["创建角色"]))
  local Item = import "item"
  local owner = {key="狗蛋",level=1,money=500,
    ["修为"]=100,["体质"]=10,["真元"]=15,["身法"]=10,["肉身"]=10,["神念上限"]=100,["神念"]=100,Point=10,UsePoint=0,["年龄"]=16,["寿元"]=80,["道心"]=0,["修炼"]={type=0,key=0,time=0},buff={},
    eq={},
    use={},
    skill={{key="秀水剑法",eq=1,level=1,exp=0}},inskill={{key="归元决",level=1,exp=0}}}
  SaveTable={}
  SaveTable["服务器"]="正式服"
  SaveTable.owner=owner
  SaveTable.owner.buff={["转生"]=21}
  SaveTable.pet={{bh=4,eq=1,key="熊",level=3,修为=0,key1="金刚地熊",name="小金",buff={},四维={1200,650,700,1100},skill={{key="黑岩爪",eq=1,exp=0,level=7},{key="地刺术",eq=1,exp=0,level=7},{key="扑杀",eq=1,exp=0,level=7},{key="沙石破",eq=1,exp=0,level=6}},inskill={{key="金身诀",eq=1,exp=0,level=7},{key="金石心诀",eq=1,exp=0,level=7},{key="金刚录",eq=1,exp=0,level=8}},body={}}}
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