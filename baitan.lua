local Item = import "item"
local cjson = import "cjson"
import "pmu"

function Itclone(tb)
  local function GetEquipmentShow(ltb)
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
  local t = GetEquipmentShow(tb)
  t["附加属性"]=tb["附加属性"]
  return SaveTableClone(t)
end

function 打开店铺()
  local 品级 = {"黄阶下品","黄阶中品","黄阶上品","玄阶下品","玄阶中品","玄阶上品","地阶下品","地阶中品","地阶上品","天阶下品","天阶中品","天阶上品","仙品"}
  local Color = {hui="#C6C6C6",black="#000000",white="#FFFFFF",green="#008000",blue="#0000FF",red="#FF0000",orange="#FFA500",gold="#FFD700"}
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
  local its = {
    FrameLayout;
    layout_height="6%h";
    layout_width="fill";
    {
      CardView;
      layout_width="match_parent";
      layout_margin="1%w";
      layout_height="match_parent";
      radius="1.2%h";
      CardElevation="0";
      backgroundColor=721420288;
      {
        TextView;
        id="name";
        layout_gravity="center";
      };
    };
  };
  function 我的摊位(jjy)
    function 寄售物品()
      local tb
      local bbb = {
        LinearLayout;
        layout_width="fill";
        backgroundColor="#ffffff";
        orientation="vertical";
        layout_height="fill";
        {
          CardView;
          layout_width="fill";
          CardElevation="15dp";
          layout_height="7%h";
          {
            TextView;
            textSize="24sp";
            text="请选择需要寄售的物品:";
            textColor="#000000";
            layout_gravity="center";
          };
        };
        {
          LinearLayout;
          layout_height="fill";
          layout_width="fill";
          {
            RadioGroup;
            id="bt";
            layout_height="fill";
            orientation="vertical";
            layout_width="18%w";
            {
              RadioButton;
              id="全部";
              textSize="16sp";
              text="全部";
            };
            {
              RadioButton;
              id="武器";
              textSize="16sp";
              text="武器";
            };
            {
              RadioButton;
              id="衣服";
              textSize="16sp";
              text="衣服";
            };
            {
              RadioButton;
              id="帽子";
              textSize="16sp";
              text="帽子";
            };
            {
              RadioButton;
              id="护手";
              textSize="16sp";
              text="护手";
            };
            {
              RadioButton;
              id="鞋子";
              textSize="16sp";
              text="鞋子";
            };
            {
              RadioButton;
              id="饰品";
              textSize="16sp";
              text="饰品";
            };
            {
              RadioButton;
              id="丹药";
              textSize="16sp";
              text="丹药";
            };
            {
              RadioButton;
              id="秘籍";
              textSize="16sp";
              text="秘籍";
            };
            {
              RadioButton;
              id="特殊";
              textSize="16sp";
              text="特殊";
            };
            {
              RadioButton;
              id="副职";
              textSize="16sp";
              text="副职";
            };
            {
              LinearLayout;
              layout_height="10%h";
            };
            {
              Button;
              textSize="16sp";
              text="确定";
            };
          };
          {
            ListView;
            layout_width="fill";
            layout_height="fill";
            id="摆摊上传";
          };
        };
      };

      local tan = {
        LinearLayout;
        background='#ffffffff';
        layout_height="fill";
        orientation="vertical";
        layout_width="fill";
        {
          FrameLayout;
          layout_height="5%h";
          layout_width="match_parent";
          {
            TextView;
            text="摊位详情";
            layout_gravity="center";
            textColor="#000000";
          };
        };
        {
          CardView;
          layout_margin="2.5%w";
          layout_height="50%h";
          layout_width="fill";
          {
            ListView;
            id="货品";
            layout_height="match_parent";
            layout_width="match_parent";
          };
        };
        {
          Button;
          onClick=function
            local kk=PopupWindow(activity)--创建PopWindow
            kk.setContentView(loadlayout(tan))--设置布局
            kk.setWidth(activity.Width*0.96)--设置宽度
            kk.setHeight(-2)--设置高度
            kk.setFocusable(true)--设置可获得焦点
            kk.setTouchable(true)--设置可触摸
            kk.setOutsideTouchable(true)
            kk.showAtLocation(view,Gravity.CENTER,0,0)
          end;
          text="开设";
        };
        {
          Button;
          onClick=function
            local kk=PopupWindow(activity)--创建PopWindow
            kk.setContentView(loadlayout(tan))--设置布局
            kk.setWidth(activity.Width*0.96)--设置宽度
            kk.setHeight(-2)--设置高度
            kk.setFocusable(true)--设置可获得焦点
            kk.setTouchable(true)--设置可触摸
            kk.setOutsideTouchable(true)
            kk.showAtLocation(view,Gravity.CENTER,0,0)
          end;
          text="开设";
        };
      };
      local tt=PopupWindow(activity)--创建PopWindow
      tt.setContentView(loadlayout(bbb))--设置布局
      tt.setWidth(activity.Width*0.96)--设置宽度
      tt.setHeight(-2)--设置高度
      tt.setFocusable(true)--设置可获得焦点
      tt.setTouchable(true)--设置可触摸
      tt.setOutsideTouchable(true)
      tt.showAtLocation(view,Gravity.CENTER,0,0)
      local data = {}
      local adp=LuaAdapter(activity,data,its)
      local function MyTable(n,m)
        local tb = {}
        for k,v in pairs(SaveTable.Item) do
          local tp = Item:GetTable(v.key).type
          if tp >= n and tp <= m then
            table.insert(tb,v)
          end
        end
        return tb
      end
      摆摊上传.Adapter=adp
      local function updates(tb)
        local no = #data
        for i=1,no do
          table.remove(data)
        end
        for k,v in pairs(tb) do
          local p = Item:GetTable(v.key)
          if p.type <= 5 then
            table.insert(data,{name=Color:Set(table.concat({v.key,"[",品级[p["品质"]],"][评分:",upeqdatas(v),"][数量:",math.ceil(v.number),"]"}),p["品质"])})
           else
            table.insert(data,{name=Color:Set(table.concat({v.key,"[",品级[p["品质"]],"][数量:",math.ceil(v.number),"]"}),p["品质"])})
          end
        end
        adp.notifyDataSetChanged()
      end
      tb = MyTable(0,100)
      updates(tb)
      bt.setOnCheckedChangeListener{
        onCheckedChanged=function(g,c)
          l=g.findViewById(c)
          if l.Text == "全部" then
            tb = MyTable(-5,100)
            updates(tb)
           elseif l.Text == "武器" then
            tb = MyTable(0,0)
            updates(tb)
           elseif l.Text == "衣服" then
            tb = MyTable(1,1)
            updates(tb)
           elseif l.Text == "帽子" then
            tb = MyTable(2,2)
            updates(tb)
           elseif l.Text == "护手" then
            tb = MyTable(3,3)
            updates(tb)
           elseif l.Text == "鞋子" then
            tb = MyTable(4,4)
            updates(tb)
           elseif l.Text == "饰品" then
            tb = MyTable(5,5)
            updates(tb)
           elseif l.Text == "丹药" then
            tb = MyTable(6,6)
            updates(tb)
           elseif l.Text == "秘籍" then
            tb = MyTable(7,7)
            updates(tb)
           elseif l.Text == "特殊" then
            tb = MyTable(8,15)
            updates(tb)
           elseif l.Text == "副职" then
            tb = MyTable(-5,-1)
            updates(tb)
          end
          if #tb == 0 then
            table.insert(data,{name="无物品"})
          end
      end}
      摆摊上传.onItemClick=function(l,v,p,i)
        local num = 1
        local e,q = ShowMenu(tb[i])
        function 选择数量()
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
              hint="请输入你要上架的数量";
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
              if (tonumber(edit.Text) and tonumber(edit.Text) > 0) then
                if tonumber(edit.Text) > tb[i].number then
                  num = tb[i].number
                 else
                  num = tonumber(edit.Text)
                end
              end
              上架数量.Text="上架数量:"..math.ceil(num).."件"
          end})
          .setNegativeButton("取消",nil)
          .show()
          edit.setInputType(InputType.TYPE_CLASS_NUMBER)
          edit.setKeyListener(DigitsKeyListener.getInstance("0123456789"))
        end
        local csa
        function SalePost()
          local idx = Itclone(tb[i])
          local tp = table.clone(tb[i])
          tp.number = nil
          local price
          local ttt = Item:GetTable(tp.key).price
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
              text="请输入你要出售的单价:";
            };
            {
              EditText;
              hint="下限"..ttt*2 .."上限"..ttt*40;
              layout_marginTop="5dp";
              layout_marginLeft="10dp",
              layout_marginRight="10dp",
              layout_width="match_parent";
              layout_gravity="center",
              id="edit";
            };
          };
          if csa ~= nil then
            csa.dismiss()
          end
          csa = AlertDialog.Builder(this)
          .setTitle("请输入")
          .setView(loadlayout(InputLayout))
          .setPositiveButton("确定",{onClick=function(v)
              if (tonumber(edit.Text) and tonumber(edit.Text) > 0) then
                if tonumber(edit.Text) > ttt * 40 then
                  price = ttt * 40
                 elseif tonumber(edit.Text) < ttt * 2 then
                  price = ttt * 2
                 else
                  price = tonumber(edit.Text)
                end
                q.dismiss()
                hs("http://82.157.62.200/zm/stc.php?id="..解密("role/zh").."&item="..cjson.encode(tp).."&type=0&number="..num.."&price="..price.."&key="..tmkey(),function(code,body)
                  if code ~= -1 and code >= 200 and code <= 400 and body == "400" then
                    MD提示("上架成功!将提交至宗门后台进行审核")
                    if SaveTable.Item[idx].number > num then
                      SaveTable.Item[idx].number = SaveTable.Item[idx].number - num
                      data[i] = {name=Color:Set(table.concat({tb[i].key,"[",品级[Item:GetTable(tb[i].key)["品质"]],"][数量:",math.ceil(tb[i].number),"]"}),Item:GetTable(tb[i].key)["品质"])}
                     else
                      table.remove(SaveTable.Item,idx)
                      table.remove(tb,i)
                      table.remove(data,i)
                    end
                    adp.notifyDataSetChanged()
                    loadsavewrite(0)
                   else
                    提示("网络连接失败！")
                  end
                end)
              end
          end})
          .setNegativeButton("取消",nil)
          .show()
          edit.setInputType(InputType.TYPE_CLASS_NUMBER)
          edit.setKeyListener(DigitsKeyListener.getInstance("0123456789"))
        end
        e.addView(loadlayout{
          LinearLayout;
          {
            TextView;
            id="上架数量";
            layout_gravity="center";
            textColor="#000000";
            text="上架数量:1件";
          };
          {
            Button;
            onClick=function 选择数量() end;
            text="选择数量";
            layout_width="80dp";
            layout_gravity="center";
            textSize=getsize(12);
            layout_height="36dp";
          };
        })
        e.addView(loadlayout{
          LinearLayout;
          layout_width="fill";
          layout_height="50dp";
          {
            Button;
            onClick=function SalePost() end;
            layout_width="70dp";
            text="上传";
            layout_height="50dp";
          };
        })
      end
    end
    local wei = {
      LinearLayout;
      background='#ffffffff';
      layout_height="fill";
      orientation="vertical";
      layout_width="fill";
      {
        FrameLayout;
        layout_height="5%h";
        layout_width="match_parent";
        {
          TextView;
          id="myshop";
          text="我的摊位";
          layout_gravity="center";
          textColor="#000000";
        };
      };
      {
        CardView;
        layout_margin="2.5%w";
        layout_height="50%h";
        layout_width="fill";
        {
          ListView;
          id="我的摊位";
          layout_height="match_parent";
          layout_width="match_parent";
        };
      };
      {
        Button;
        onClick=function 寄售物品() end;
        text="寄售";
      };
      {
        Button;
        onClick=function
          hs("http://82.157.62.200/zm/tiqu.php?id="..解密("role/zh").."&key="..tmkey(),function(code,body)
            if code ~= -1 and code >= 200 and code <= 400 and body ~= "404" then
              if tonumber(body) > 0 then
                SaveTable.owner.money = SaveTable.owner.money + tonumber(body)
                MD提示("成功提取收益"..body.."灵石")
                收益.Text = "0"
                loadsavewrite(0)
               else
                MD提示("没有可提取的收益")
              end
            end
          end)
        end;
        text="提取收益";
      };
      {
        TextView;
        id="收益";
        text="灵石收益:500000";
        textColor="#000000";
      };
    };
    hs("http://82.157.62.200/zm/chad.php?id="..解密("role/zh"),function(code,body)
      if code ~= -1 and code >= 200 and code <= 400 then
        if body == "404" then
          task(1000,function jjy.dismiss() end)
          local kkd
          弹框("你还没有店铺，是否花费五百灵石申请一个店铺。","确认",function
            if SaveTable.owner.money >= 500 then
              if kkd ~= nil then
                kkd.dismiss()
              end
              local kd = {
                LinearLayout;
                gravity="center";
                layout_width="match_parent";
                orientation="vertical";
                layout_height="match_parent";
                {
                  EditText;
                  id="店名";
                  hint="请输入店铺名";
                };
                {
                  Button;
                  onClick=function
                    if #店名.Text >= 6 and #店名.Text <= 30 then
                      hs("http://82.157.62.200/zm/cd.php?id="..解密("role/zh").."&money=0&name="..SaveTable.owner.key.."&hot=0&type=1&info="..badword(店名.Text).."&key="..tmkey(),function(code,body)
                        if code ~= -1 and code >= 200 and code <= 400 and body ~= "404" then
                          SaveTable.owner.money = SaveTable.owner.money - 500
                          kkd.dismiss()
                          提示("注册成功!")
                          loadsavewrite(0)
                         else
                          提示("网络连接失败")
                        end
                      end)
                     else
                      提示("名称不能小于两个中文字符或大于十个中文字符")
                    end
                  end;
                  text="注册店铺";
                };
              };
              kkd=PopupWindow(activity)--创建PopWindow
              kkd.setContentView(loadlayout(kd))--设置布局
              kkd.setWidth(-2)--设置宽度
              kkd.setHeight(-2)--设置高度
              kkd.setFocusable(true)--设置可获得焦点
              kkd.setTouchable(true)--设置可触摸
              kkd.setOutsideTouchable(true)
              kkd.showAtLocation(view,Gravity.CENTER,0,0)
             else
              提示("灵石不足!")
            end
          end)
         else
          local ww=PopupWindow(activity)--创建PopWindow
          ww.setContentView(loadlayout(wei))--设置布局
          ww.setWidth(activity.Width*0.96)--设置宽度
          ww.setHeight(-2)--设置高度
          ww.setFocusable(true)--设置可获得焦点
          ww.setTouchable(true)--设置可触摸
          ww.setOutsideTouchable(true)
          ww.showAtLocation(view,Gravity.CENTER,0,0)
          local tbl = cjson.decode(unicode2utf8(body))
          myshop.Text = table.concat({tbl.info,"[热度:",tbl.hot,"]"})
          收益.Text = "灵石:"..tbl.money
          hs("http://82.157.62.200/zm/dcd.php?id="..tbl.id,function(code,body)
            task(500,function jjy.dismiss() end)
            if code ~= -1 and code >= 200 and code <= 400 then
              local tb = cjson.decode(body)
              local data1 = {}
              local adp1=LuaAdapter(activity,data1,its)
              local no = #data1
              for i=1,no do
                table.remove(data1)
              end
              for k,v in pairs(tb) do
                tb[k].item = cjson.decode(v.item)
                local p = Item:GetTable(v.item.key)
                if p.type <= 5 then
                  str = table.concat({v.item.key,"[",品级[p["品质"]],"][评分:",upeqdatas(v.item),"][数量:",math.ceil(v.number),"][单价:",math.ceil(v.price),"]"})
                 else
                  str = table.concat({v.item.key,"[",品级[p["品质"]],"][数量:",math.ceil(v.number),"][单价:",math.ceil(v.price),"]"})
                end
                if tonumber(v.type) == 1 then
                  table.insert(data1,{name=Color:Set(table.concat({str,"[已上架]"}),p["品质"])})
                 elseif tonumber(v.type) == 2 then
                  table.insert(data1,{name=Color:Set(table.concat({str,"[被拒审]"}),p["品质"])})
                 else
                  table.insert(data1,{name=Color:Set(table.concat({str,"[待审核]"}),p["品质"])})
                end
              end
              if #data1 == 0 then
                table.insert(data1,{name="无商品"})
              end
              我的摊位.Adapter=adp1
              我的摊位.onItemClick=function(l,v,p,i)
                local e,q = ShowMenu(tb[i].item)
                e.addView(loadlayout{
                  LinearLayout;
                  layout_width="fill";
                  layout_height="50dp";
                  {
                    Button;
                    onClick=function
                      hs("http://82.157.62.200/zm/xiajia.php?id="..解密("role/zh").."&uid="..tb[i].uid.."&key="..tmkey(),function(code,body)
                        if code ~= -1 and code >= 200 and code <= 400 and body ~= "404" then
                          if body ~= "403" then
                            local tp = cjson.decode(body)
                            local tba = table.clone(cjson.decode(unicode2utf8(tp.item)))
                            if Item:GetTable(tba.key).type > 5 then
                              Item:Add(tba.key,tonumber(tp.number))
                             else
                              tba.number = tonumber(tp.number)
                              table.insert(SaveTable.Item,tba)
                            end
                            q.dismiss()
                            adp1.notifyDataSetChanged()
                            MD提示("下架成功")
                            table.remove(tb,i)
                            table.remove(data1,i)
                            loadsavewrite(0)
                           else
                            MD提示("该物品不存在")
                          end
                         else
                          提示("网络错误")
                        end
                      end)
                    end;
                    layout_width="60dp";
                    text="下架";
                    layout_height="45dp";
                  };
                })
              end
             else
              提示("网络连接失败")
            end
          end)
        end
       else
        task(500,function jjy.dismiss() end)
        提示("网络连接失败")
      end
    end)
  end
  local xts
  local tanwei = {
    LinearLayout;
    background='#ffffff';
    layout_height="fill";
    orientation="vertical";
    layout_width="fill";
    {
      FrameLayout;
      layout_height="5%h";
      layout_width="match_parent";
      {
        TextView;
        text="摊位";
        layout_gravity="center";
        textColor="#000000";
      };
    };
    {
      CardView;
      layout_margin="2.5%w";
      layout_height="50%h";
      layout_width="fill";
      {
        ListView;
        id="摊位";
        layout_height="fill";
        layout_width="fill";
      };
    };
    {
      Button;
      onClick=function
        xts.dismiss()
        local jjy = 加载框()
        我的摊位(jjy)
      end;
      text="我的店铺";
    };
  };

  xts=PopupWindow(activity)--创建PopWindow
  xts.setContentView(loadlayout(tanwei))--设置布局
  xts.setWidth(activity.Width*0.96)--设置宽度
  xts.setHeight(-2)--设置高度
  xts.setFocusable(true)--设置可获得焦点
  xts.setTouchable(true)--设置可触摸
  xts.setOutsideTouchable(true)
  xts.showAtLocation(view,Gravity.CENTER,0,0)
  local jy = {
    LinearLayout;
    background='#EEEEEE',
    layout_width="fill";
    gravity="center";
    lolayout_margin="0.5%w";
    layout_height="5%h";
    {
      TextView;
      id="txt";
      textColor="#000000";
      layout_gravity="center";
    };
  };
  hs("http://82.157.62.200/zm/csd.php?type=1&id="..解密("role/zh"),function(code,body)
    if code ~= -1 and code >= 200 and code <= 400 then
      local tb = cjson.decode(body)
      table.sort(tb,function(a,b)
        return tonumber(a.hot) > tonumber(b.hot)
      end)
      local data = {}
      local adp=LuaAdapter(activity,data,jy)
      for k,v in pairs(tb) do
        adp.add{txt=table.concat({v.info,"[热度:",v.hot,"]"})}
      end
      摊位.Adapter=adp
      local xts
      摊位.onItemClick=function(l,v,p,i)
        if xts ~= nil then
          xts.dismiss()
        end
        if tb[i].id ~= 解密("role/zh") then
          local jjy = 加载框()
          hs("http://82.157.62.200/zm/dcd.php?id="..tb[i].id,function(code,body)
            task(500,function jjy.dismiss() end)
            if code ~= -1 and code >= 200 and code <= 400 then
              local wei1 = {
                LinearLayout;
                background='#ffffffff';
                layout_height="fill";
                orientation="vertical";
                layout_width="fill";
                {
                  FrameLayout;
                  layout_height="5%h";
                  layout_width="match_parent";
                  {
                    TextView;
                    id="otshop";
                    text="他人摊位";
                    layout_gravity="center";
                    textColor="#000000";
                  };
                };
                {
                  ListView;
                  id="他人摊位";
                  layout_height="match_parent";
                  layout_width="match_parent";
                };
              };
              xts=PopupWindow(activity)--创建PopWindow
              xts.setContentView(loadlayout(wei1))--设置布局
              xts.setWidth(activity.Width*0.96)--设置宽度
              xts.setHeight(activity.Width*1.6)--设置高度
              xts.setFocusable(true)--设置可获得焦点
              xts.setTouchable(true)--设置可触摸
              xts.setOutsideTouchable(true)
              xts.showAtLocation(view,Gravity.CENTER,0,0)
              otshop.Text = tb[i].info.."[热度:"..tb[i].hot.."]"
              local tb = cjson.decode(body)
              local data2 = {}
              local adp2=LuaAdapter(activity,data2,its)
              local no = #data2
              for i=1,no do
                table.remove(data2)
              end
              local tab = table.clone(tb)
              tb = {}
              for k,v in pairs(tab) do
                if tonumber(v.type) == 1 then
                  table.insert(tb,v)
                end
              end
              for k,v in pairs(tb) do
                tb[k].item = cjson.decode(v.item)
                local p = Item:GetTable(v.item.key)
                if p.type <= 5 then
                  str = Color:Set(table.concat({v.item.key,"[",品级[p["品质"]],"][评分:",upeqdatas(v.item),"][数量:",math.ceil(v.number),"][价格:",math.ceil(v.price),"]"}),p["品质"])
                 else
                  str = Color:Set(table.concat({v.item.key,"[",品级[p["品质"]],"][数量:",math.ceil(v.number),"][价格:",math.ceil(v.price),"]"}),p["品质"])
                end
                if tonumber(v.type) == 1 then
                  table.insert(data2,{name=str})
                end
              end
              if #data2 == 0 then
                table.insert(data2,{name="无商品"})
              end
              他人摊位.Adapter=adp2
              他人摊位.onItemClick=function(l,v,p,i)
                if #tb ~= 0 then
                  local e,q = ShowMenu(tb[i].item)
                  local num = 1
                  拍卖信息.addView(loadlayout {
                    LinearLayout;
                    {
                      TextView;
                      id="购买数量";
                      layout_gravity="center";
                      textColor="#000000";
                      text="购买数量:1件";
                    };
                    {
                      Button;
                      onClick=function
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
                            hint="请输入你要购买的数量";
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
                            if (tonumber(edit.Text) and tonumber(edit.Text) > 0) then
                              if tonumber(edit.Text) > tonumber(tb[i].number) then
                                num = tonumber(tb[i].number)
                               else
                                num = tonumber(edit.Text)
                              end
                            end
                            购买数量.Text="购买数量:"..math.ceil(num).."件"
                        end})
                        .setNegativeButton("取消",nil)
                        .show()
                        edit.setInputType(InputType.TYPE_CLASS_NUMBER)
                        edit.setKeyListener(DigitsKeyListener.getInstance("0123456789"))
                      end;
                      text="选择数量";
                      layout_width="80dp";
                      layout_gravity="center";
                      textSize=getsize(12);
                      layout_height="36dp";
                    };
                  })
                  拍卖信息.addView(loadlayout{
                    LinearLayout;
                    layout_width="fill";
                    layout_height="50dp";
                    {
                      Button;
                      onClick=function
                        xts.dismiss()
                        q.dismiss()
                        local num1 = tonumber(tb[i].price) * num
                        if SaveTable.owner.money >= num1 then
                          hs("http://82.157.62.200/zm/goumai.php?id="..tb[i].id.."&uid="..tb[i].uid.."&number="..num.."&key="..tmkey(),function(code,body)
                            if code ~= -1 and code >= 200 and code <= 400 and body ~= "404" and type(tonumber(body)) == "number" then
                              if body ~= "nothing" then
                                local num3 = tonumber(body) * tonumber(tb[i].price)
                                if Item:GetTable(tb[i].item.key).type > 5 then
                                  SaveTable.owner.money = SaveTable.owner.money - num3
                                  Item:Add(tb[i].item.key,tonumber(body))
                                  MD提示(Html.fromHtml("购买成功，消费"..math.ceil(num3).."灵石,获得物品"..Color:Get(tb[i].item.key,Item:GetTable(tb[i].item.key)["品质"]).."*"..body))
                                  loadsavewrite(0)
                                 else
                                  SaveTable.owner.money = SaveTable.owner.money - num3
                                  local tlb = table.clone(tb[i].item)
                                  tlb.number = tonumber(body)
                                  table.insert(SaveTable.Item,tlb)
                                  MD提示(Html.fromHtml("购买成功，消费"..math.ceil(num3).."灵石,获得物品"..Color:Get(tb[i].item.key,Item:GetTable(tb[i].item.key)["品质"]).."*"..body))
                                  loadsavewrite(0)
                                end
                               else
                                提示("该物品已下架！")
                              end
                             else
                              提示("网络连接失败")
                            end
                          end)
                         else
                          提示("灵石不足")
                        end
                      end;
                      layout_width="60dp";
                      text="购买";
                      layout_height="45dp";
                    };
                  })
                end
              end
             else
              提示("网络连接失败")
            end
          end)
         else
          提示("这是你自己的店铺")
        end
      end
     else
      提示("网络连接失败")
    end
  end)
end