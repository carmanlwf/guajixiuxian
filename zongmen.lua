require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "other"
import "shen"
local cjson = import "cjson"
local 境界 = import "tupo"
local 品级 = {"黄阶下品","黄阶中品","黄阶上品","玄阶下品","玄阶中品","玄阶上品","地阶下品","地阶中品","地阶上品","天阶下品","天阶中品","天阶上品","仙品"}

local zmm
local cj
local tp
function 进入宗门()
  local zm = {
    LinearLayout;
    background='#ffffffff',
    layout_height="fill";
    orientation="vertical";
    layout_width="fill";
    {
      FrameLayout;
      backgroundColor="#000000";
      layout_height="6%h";
      layout_width="match_parent";
      {
        TextView;
        text="请选择你要加入的宗门";
        textColor="#FFFFFF";
        layout_gravity="center";
      };
    };
    {
      FrameLayout;
      layout_height="40%h";
      layout_width="match_parent";
      {
        ListView;
        id="宗门";
        layout_height="match_parent";
        layout_width="match_parent";
      };
    };
    {
      Button;
      onClick=function
        local wj = {
          LinearLayout;
          orientation="vertical";
          gravity="center";
          layout_height="fill";
          layout_width="fill";
          {
            EditText;
            id="zn";
            hint="请输入宗门名:";
          };
          {
            EditText;
            id="iof";
            hint="请输入宗门宣言:";
          };
          {
            EditText;
            id="zq";
            hint="请输入宗门Q群:(非必填)";
          };
          {
            RadioGroup;
            id="zml";
            orientation="horizontal";
            {
              RadioButton;
              text="外挂";
            };
            {
              RadioButton;
              text="异常";
            };
            {
              RadioButton;
              text="绿色";
            };
          };
          {
            Button;
            onClick=function
              if tp ~= nil then
                if #zn.Text >= 3 and #zn.Text <= 24 and badword(zn.Text) ~= "狗蛋" then
                  if #iof.Text ~= 0 and badword(iof.Text) ~= "狗蛋" then
                    local jjy = 加载框()
                    hs("http://82.157.62.200/zm/cjzm.php?key="..tmkey().."&type="..tp.."&name="..zn.Text.."&info="..iof.Text.."&qq="..zq.Text.."&GN="..SaveTable.owner.key.."&level=1&shoplevel=1&id="..解密("role/zh").."&time="..SaveTable.savetime,function(code,body)
                      if code ~= -1 and code >= 200 and code <= 400 and body ~= "404" then
                        if body ~= "405" and body ~= "406" then
                          jjy.dismiss()
                          zmm.dismiss()
                          cj.dismiss()
                          提示("创建成功!")
                         elseif body == "406" then
                          jjy.dismiss()
                          zmm.dismiss()
                          提示("建档时间大于24小时方可建立宗门")
                         else
                          jjy.dismiss()
                          zmm.dismiss()
                          cj.dismiss()
                          提示("当前已有宗门!")
                        end
                       else
                        jjy.dismiss()
                        提示("网络错误")
                      end
                    end)
                   else
                    提示("宗门宣言不规范!")
                  end
                 else
                  提示("宗门取名不规范!")
                end
               else
                提示("请选择宗门类型")
              end
            end;
            text="确认创建";
          };
        };
        if zmm ~= nil then
          zmm.dismiss()
        end
        zmm=PopupWindow(activity)--创建PopWindow
        zmm.setContentView(loadlayout(wj))--设置布局
        zmm.setWidth(-2)--设置宽度
        zmm.setHeight(-2)--设置高度
        zmm.setFocusable(true)--设置可获得焦点
        zmm.setTouchable(true)--设置可触摸
        zmm.setOutsideTouchable(true)
        zmm.showAtLocation(view,Gravity.CENTER,0,0)
        zml.setOnCheckedChangeListener{
          onCheckedChanged=function(g,c)
            local l=g.findViewById(c).text
            if l == "外挂" then
              tp = 1
             elseif l == "异常" then
              tp = 2
             elseif l == "绿色" then
              tp = 3
            end
        end}
      end;
      text="创建宗门";
    };
  };
  if cj ~= nil then
    cj.dismiss()
  end
  local jjy = 加载框()
  cj=PopupWindow(activity)--创建PopWindow
  cj.setContentView(loadlayout(zm))--设置布局
  cj.setWidth(activity.Width*0.96)--设置宽度
  cj.setHeight(-2)--设置高度
  cj.setFocusable(true)--设置可获得焦点
  cj.setTouchable(true)--设置可触摸
  cj.setOutsideTouchable(true)
  cj.showAtLocation(view,Gravity.CENTER,0,0)
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
  local data={}
  local adp=LuaAdapter(activity,data,its)
  local lx = {"外挂宗门","数据异常","绿色宗门"}
  hs("http://82.157.62.200/zm/zm.php?key="..tmkey(),function(code,body)
    if code ~= -1 and code >= 200 and code <= 400 and body ~= "404" then
      jjy.dismiss()
      local tb = cjson.decode(urlDecode(body))
      table.sort(tb,function(a,b)
        return tonumber(a.number) > tonumber(b.number)
      end)
      for k,v in pairs(tb) do
        table.insert(data,{name=table.concat({v.name,"[等级:",v.level,"][类型:",lx[tonumber(v.type)],"]","[人数:",v.number,"]"})})
      end
      宗门.Adapter=adp
      local czz
      宗门.onItemClick=function(l,v,p,i)
        local zmb = {
          LinearLayout;
          background='#ffffffff',
          gravity="center";
          layout_height="fill";
          layout_width="fill";
          orientation="vertical";
          {
            TextView;
            textColor="#000000";
            text="宗门:"..tb[i].name;
          };
          {
            TextView;
            textColor="#000000";
            text="宗主:"..tb[i].GN;
          };
          {
            TextView;
            textColor="#000000";
            text="等级:"..tb[i].level;
          };
          {
            TextView;
            textColor="#000000";
            text="人数:"..tb[i].number;
          };
          {
            TextView;
            textColor="#000000";
            text="宣言:"..tb[i].info;
          };
          {
            LinearLayout;
            orientation="horizontal";
            {
              Button;
              onClick=function
                hs("http://82.157.62.200/zm/sqzm.php?key="..tmkey().."&zm="..tb[i].name.."&id="..解密("role/zh"),function(code,body)
                  if code ~= -1 and code >= 200 and code <= 400 and body ~= "404" then
                    if body ~= "405" then
                      czz.dismiss()
                      提示("申请成功，将会自动覆盖上一次申请记录")
                     else
                      czz.dismiss()
                      提示("已有宗门")
                    end
                  end
                end)
              end;
              text="申请加入";
            };
            {
              Button;
              onClick=function
                czz.dismiss()
              end;
              text="关闭界面";
            };
          };
        };
        if czz ~= nil then
          czz.dismiss()
        end
        czz=PopupWindow(activity)--创建PopWindow
        czz.setContentView(loadlayout(zmb))--设置布局
        czz.setWidth(activity.Width*0.96)--设置宽度
        czz.setHeight(-2)--设置高度
        czz.setFocusable(true)--设置可获得焦点
        czz.setTouchable(true)--设置可触摸
        czz.setOutsideTouchable(true)
        czz.showAtLocation(view,Gravity.CENTER,0,0)
      end
     else
      jjy.dismiss()
      提示("网络错误")
    end
  end)
end
local cjj
function 载入宗门(body)
  local lx = {"外挂宗门","数据异常","绿色宗门"}
  local tbl = cjson.decode(body)
  local zrz = {
    LinearLayout;
    backgroundColor="#FFFFFF";
    layout_height="fill";
    orientation="vertical";
    layout_width="fill";
    gravity="center";
    {
      TextView;
      id="zmj";
      text="宗门名:";
      textColor="#000000";
    };
    {
      TextView;
      id="zml";
      text="宗门类型:";
      textColor="#000000";
    };
    {
      TextView;
      id="zzn";
      text="宗主:";
      textColor="#000000";
    };
    {
      TextView;
      id="zlv";
      text="宗门等级:";
      textColor="#000000";
    };
    {
      TextView;
      id="zmn";
      textColor="#000000";
      text="宗门人数:";
    };
    {
      TextView;
      id="zdw";
      textColor="#000000";
      text="宗门地位:";
    };
    {
      TextView;
      id="zmx";
      textColor="#000000";
      text="宗门宣言:";
    };
    {
      LinearLayout;
      orientation="horizontal";
      id="zmq";
    };
    {
      LinearLayout;
      orientation="horizontal";
      {
        Button;
        text="成员";
        onClick=function
          local yjl = 加载框()
          local cyb = {
            LinearLayout;
            backgroundColor="#ffffff";
            orientation="vertical";
            layout_height="fill";
            layout_width="fill";
            {
              CardView;
              layout_width="fill";
              layout_height="7%h";
              CardElevation="2%w";
              backgroundColor="#000000";
              {
                TextView;
                textColor="#FFFFFF";
                text="宗门成员";
                textSize="25sp";
                layout_gravity="center";
              };
            };
            {
              LinearLayout;
              layout_width="fill";
              layout_height="fill";
              {
                LinearLayout;
                orientation="vertical";
                layout_height="fill";
                layout_width="20%w";
              };
              {
                LinearLayout;
                layout_width="fill";
                layout_height="fill";
                {
                  ListView;
                  layout_width="fill";
                  layout_height="fill";
                  id="zmcy";
                };
              };
            };
          };
          local cji=PopupWindow(activity)--创建PopWindow
          cji.setContentView(loadlayout(cyb))--设置布局
          cji.setWidth(activity.Width*0.96)--设置宽度
          cji.setHeight(-2)--设置高度
          cji.setFocusable(true)--设置可获得焦点
          cji.setTouchable(true)--设置可触摸
          cji.setOutsideTouchable(true)
          cji.showAtLocation(view,Gravity.CENTER,0,0)
          hs("http://82.157.62.200/zm/cxcy.php?key="..tmkey().."&name="..tbl.name,function(code,body)
            yjl.dismiss()
            if code ~= -1 and code >= 200 and code <= 400 and body ~= "404" then
              local tb = cjson.decode(unicode2utf8(body))
              local its = {
                LinearLayout;
                layout_height="fill";
                layout_width="fill";
                {
                  CardView;
                  cardBackgroundColor="#FFF7F7F7";
                  layout_gravity="center";
                  layout_height="24%h";
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
              local data1={}
              local adp=LuaAdapter(activity,data1,its)
              if #tb >= 2 then
                table.sort(tb,function(a,b)
                  return tonumber(a.level) > tonumber(b.level)
                end)
              end
              for k,v in pairs(tb) do
                local rt
                if v.root == "" then
                  rt="未知"
                 elseif v.root == "1" then
                  rt = "root设备"
                 else
                  rt = "非root设备"
                end
                local sf
                if v.sf == "5" then
                  sf = "宗主"
                 elseif v.sf == "4" then
                  sf = "长老"
                 else
                  sf = "弟子"
                end
                table.insert(data1,{name="道号:"..v.name.."\n身份:"..sf.."\n设备状态:"..rt.."\n境界:"..境界[tonumber(v.level)]["境界"].."\n财富值:"..math.ceil(tonumber(v.money)).."\n炼丹等阶:"..品级[math.ceil(tonumber(v.liandan))].."\n炼器等阶:"..品级[math.ceil(tonumber(v.lianqi))],id=v.id})
              end
              zmcy.Adapter=adp
              local ppo
              zmcy.onItemClick=function(l,v,p,i)
                if ppo ~= nil then
                  ppo.dismiss()
                end
                local sf
                if tb[i].sf == "5" then
                  sf = "宗主"
                 elseif tb[i].sf == "4" then
                  sf = "长老"
                 else
                  sf = "弟子"
                end
                local gl = {
                  LinearLayout;
                  gravity="center";
                  layout_width="fill";
                  layout_height="fill";
                  orientation="vertical";
                  backgroundColor="#FFFFFF";
                  {
                    TextView;
                    textColor="#000000";
                    text="账号:"..tb[i].id;
                  };
                  {
                    TextView;
                    textColor="#000000";
                    text="道号:"..tb[i].name;
                  };
                  {
                    TextView;
                    textColor="#000000";
                    text="职位:"..sf;
                  };
                  {
                    LinearLayout;
                    orientation="horizontal";
                    {
                      Button;
                      onClick=function
                        hs("http://82.157.62.200/zm/csx.php?id="..tb[i].id.."&key=owner",function(code,body)
                          属性面板(cjson.decode(body))
                        end)
                      end;
                      textSize=getsize(13);
                      text="查看属性";
                    };
                    {
                      Button;
                      onClick=function
                        hs("http://82.157.62.200/zm/csx.php?id="..tb[i].id.."&key=item",function(code,body)
                          otherbag(cjson.decode(body))
                        end)
                      end;
                      textSize=getsize(13);
                      text="查看背包";
                    };
                    {
                      Button;
                      onClick=function
                        hs("http://82.157.62.200/zm/csx.php?id="..tb[i].id.."&key=pet",function(code,body)
                          otherpet(cjson.decode(body))
                        end)
                      end;
                      textSize=getsize(13);
                      text="查看宠物";
                    };
                    {
                      Button;
                      onClick=function
                        hs("http://82.157.62.200/zm/chad.php?id="..tb[i].id,function(code,body)
                          if code ~= -1 and code >= 200 and code <= 400 then
                            if body == "404" then
                              提示("该玩家还没有店铺")
                             else
                              print(body)
                              othershop(cjson.decode(unicode2utf8(body)))
                            end
                           else
                            提示("网络错误")
                          end
                        end)
                      end;
                      textSize=getsize(13);
                      text="查看店铺";
                    };
                  };
                  {
                    LinearLayout;
                    id="管理";
                  };
                };
                ppo=PopupWindow(activity)--创建PopWindow
                ppo.setContentView(loadlayout(gl))--设置布局
                ppo.setWidth(activity.Width*0.96)--设置宽度
                ppo.setHeight(-2)--设置高度
                ppo.setFocusable(true)--设置可获得焦点
                ppo.setTouchable(true)--设置可触摸
                ppo.setOutsideTouchable(true)
                ppo.showAtLocation(view,Gravity.CENTER,0,0)
                if tonumber(tbl.sf) >= 4 and tonumber(tbl.sf) > tonumber(tb[i].sf) then
                  管理.addView(loadlayout{
                    Button;
                    onClick=function
                      弹框("确定要将这名弟子逐出宗门吗？","确定",function
                        hs("http://82.157.62.200/zm/tichu.php?id="..tb[i].id.."&key="..tmkey(),function(code,body)
                          if code ~= -1 and code >= 200 and code <= 400 and body ~= "404" then
                            cjj.dismiss()
                            table.remove(data1,i)
                            adp.notifyDataSetChanged()
                            提示("操作成功")
                          end
                        end)
                      end)
                    end;
                    text="逐出门派";
                  })
                  if tonumber(tbl.sf) == 5 then
                    if tonumber(tb[i].sf) < 4 then
                      管理.addView(loadlayout{
                        Button;
                        onClick=function
                          hs("http://82.157.62.200/zm/gxdw.php?id="..tb[i].id.."&sf=4&key="..tmkey(),function(code,body)
                            if code ~= -1 and code >= 200 and code <= 400 and body ~= "404" then
                              提示("任命成功")
                            end
                          end)
                        end;
                        text="任命长老";
                      })
                     elseif tonumber(tb[i].sf) ~= 5 then
                      管理.addView(loadlayout{
                        Button;
                        onClick=function
                          hs("http://82.157.62.200/zm/gxdw.php?id="..tb[i].id.."&sf=1&key="..tmkey(),function(code,body)
                            if code ~= -1 and code >= 200 and code <= 400 and body ~= "404" then
                              提示("操作成功")
                            end
                          end)
                        end;
                        text="卸任长老";
                      })
                    end
                  end
                end
              end
             else
              提示("网络错误")
            end
          end)
        end;
      };
      {
        Button;
        onClick=function
          提示("待制作")
        end;
        text="商店";
      };
      {
        Button;
        onClick=function
          if tbl.sf ~= "5" then
            弹框("确定退出宗门吗？","确定",function
              hs("http://82.157.62.200/zm/tichu.php?id="..解密("role/zh").."&key="..tmkey(),function(code,body)
                if code ~= -1 and code >= 200 and code <= 400 and body ~= "404" then
                  cjj.dismiss()
                  提示("退出成功")
                end
              end)
            end)
           else
            弹框("退出后，将强行解散宗门，确定吗？","确定",function
              hs("http://82.157.62.200/zm/jiesan.php?id="..解密("role/zh").."&key="..tmkey(),function(code,body)
                if code ~= -1 and code >= 200 and code <= 400 and body ~= "404" then
                  cjj.dismiss()
                  if body ~= "403" then
                    提示("宗门已解散")
                   else
                    提示("未知错误")
                  end
                 else
                  提示("网络错误")
                end
              end)
            end)
          end
        end;
        text="退出";
      };
      {
        Button;
        onClick=function
          hs("http://82.157.62.200/zm/cxqx.php?id="..解密("role/zh").."&key="..tmkey(),function(code,body)
            if code ~= -1 and code >= 200 and code <= 400 and body ~= "404" then
              if tonumber(body) >= 4 then
                local yjl = 加载框()
                local zyb = {
                  LinearLayout;
                  backgroundColor="#ffffff";
                  orientation="vertical";
                  layout_height="fill";
                  layout_width="fill";
                  {
                    CardView;
                    layout_width="fill";
                    layout_height="7%h";
                    CardElevation="2%w";
                    backgroundColor="#000000";
                    {
                      TextView;
                      textColor="#FFFFFF";
                      text="申请成员";
                      textSize="25sp";
                      layout_gravity="center";
                    };
                  };
                  {
                    LinearLayout;
                    layout_width="fill";
                    layout_height="fill";
                    {
                      LinearLayout;
                      orientation="vertical";
                      layout_height="fill";
                      layout_width="20%w";
                    };
                    {
                      LinearLayout;
                      layout_width="fill";
                      layout_height="fill";
                      {
                        ListView;
                        layout_width="fill";
                        layout_height="fill";
                        id="sqcy";
                      };
                    };
                  };
                };
                hs("http://82.157.62.200/zm/cxsq.php?sqzm="..tbl.name.."&key="..tmkey(),function(code,body)
                  yjl.dismiss()
                  if code ~= -1 and code >= 200 and code <= 400 and body ~= "404" then
                    local ttb = cjson.decode(unicode2utf8(body))
                    local its = {
                      LinearLayout;
                      layout_height="fill";
                      layout_width="fill";
                      {
                        CardView;
                        cardBackgroundColor="#FFF7F7F7";
                        layout_gravity="center";
                        layout_height="24%h";
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
                    local data1={}
                    local adp=LuaAdapter(activity,data1,its)
                    local ppi=PopupWindow(activity)--创建PopWindow
                    ppi.setContentView(loadlayout(zyb))--设置布局
                    ppi.setWidth(activity.Width*0.96)--设置宽度
                    ppi.setHeight(-2)--设置高度
                    ppi.setFocusable(true)--设置可获得焦点
                    ppi.setTouchable(true)--设置可触摸
                    ppi.setOutsideTouchable(true)
                    ppi.showAtLocation(view,Gravity.CENTER,0,0)
                    for k,v in pairs(ttb) do
                      local rt
                      if v.root == "" then
                        rt="未知"
                       elseif v.root == "1" then
                        rt = "root设备"
                       else
                        rt = "非root设备"
                      end
                      table.insert(data1,{name="道号:"..v.name.."\n设备状态:"..rt.."\n境界:"..境界[tonumber(v.level)]["境界"].."\n财富值:"..math.ceil(tonumber(v.money)).."\n炼丹等阶:"..品级[math.ceil(tonumber(v.liandan))].."\n炼器等阶:"..品级[math.ceil(tonumber(v.lianqi))],id=v.id})
                    end
                    sqcy.Adapter=adp
                    local ppo
                    sqcy.onItemClick=function(l,v,p,i)
                      if ppo ~= nil then
                        ppo.dismiss()
                      end
                      local gl = {
                        LinearLayout;
                        gravity="center";
                        layout_width="fill";
                        layout_height="fill";
                        orientation="vertical";
                        backgroundColor="#FFFFFF";
                        {
                          TextView;
                          textColor="#000000";
                          text="账号:"..ttb[i].id;
                        };
                        {
                          TextView;
                          textColor="#000000";
                          text="道号:"..ttb[i].name;
                        };
                        {
                          LinearLayout;
                          orientation="horizontal";
                          {
                            Button;
                            onClick=function
                              hs("http://82.157.62.200/zm/csx.php?id="..ttb[i].id.."&key=owner",function(code,body)
                                属性面板(cjson.decode(body))
                              end)
                            end;
                            textSize=getsize(13);
                            text="查看属性";
                          };
                          {
                            Button;
                            onClick=function
                              hs("http://82.157.62.200/zm/csx.php?id="..ttb[i].id.."&key=item",function(code,body)
                                otherbag(cjson.decode(body))
                              end)
                            end;
                            textSize=getsize(13);
                            text="查看背包";
                          };
                          {
                            Button;
                            onClick=function
                              hs("http://82.157.62.200/zm/csx.php?id="..ttb[i].id.."&key=pet",function(code,body)
                                otherpet(cjson.decode(body))
                              end)
                            end;
                            textSize=getsize(13);
                            text="查看宠物";
                          };
                          {
                            Button;
                            onClick=function
                              hs("http://82.157.62.200/zm/chad.php?id="..ttb[i].id,function(code,body)
                                if code ~= -1 and code >= 200 and code <= 400 then
                                  if body == "404" then
                                    提示("该玩家还没有店铺")
                                   else
                                    print(body)
                                    othershop(cjson.decode(unicode2utf8(body)))
                                  end
                                 else
                                  提示("网络错误")
                                end
                              end)
                            end;
                            textSize=getsize(13);
                            text="查看店铺";
                          };
                        };
                        {
                          LinearLayout;
                          {
                            Button;
                            onClick=function
                              hs("http://82.157.62.200/zm/zmsq.php?id="..ttb[i].id.."&key="..tmkey().."&value="..tbl.name,function(code,body)
                                if code ~= -1 and code >= 200 and code <= 400 and body ~= "404" then
                                  if body == "405" then
                                    提示("该玩家已有宗门")
                                   else
                                    提示("处理成功！")
                                  end
                                  table.remove(data1,i)
                                  adp.notifyDataSetChanged()
                                 else
                                  提示("网络错误")
                                end
                              end)
                            end;
                            text="同意申请";
                          };
                          {
                            Button;
                            onClick=function
                              hs("http://82.157.62.200/zm/zmsq.php?id="..ttb[i].id.."&key="..tmkey().."&value=",function(code,body)
                                if code ~= -1 and code >= 200 and code <= 400 and body ~= "404" then
                                  提示("处理成功")
                                  table.remove(data1,i)
                                  adp.notifyDataSetChanged()
                                end
                              end)
                            end;
                            text="拒绝申请";
                          };
                        };
                      };
                      ppo=PopupWindow(activity)--创建PopWindow
                      ppo.setContentView(loadlayout(gl))--设置布局
                      ppo.setWidth(activity.Width*0.96)--设置宽度
                      ppo.setHeight(-2)--设置高度
                      ppo.setFocusable(true)--设置可获得焦点
                      ppo.setTouchable(true)--设置可触摸
                      ppo.setOutsideTouchable(true)
                      ppo.showAtLocation(view,Gravity.CENTER,0,0)
                    end
                   else
                    提示("网络错误")
                  end
                end)
               else
                提示("无权操作")
              end
             else
              提示("网络错误")
            end
          end)
        end;
        text="申请";
      };
    };
    {
      LinearLayout;
      orientation="horizontal";
      {
        Button;
        onClick=function
          飞剑传书()
        end;
        text="传书";
      };
      {
        Button;
        onClick=function
          local yjl = 加载框()
          hs("http://82.157.62.200/zm/cxqx.php?id="..解密("role/zh").."&key="..tmkey(),function(code,body)
            yjl.dismiss()
            if code ~= -1 and code >= 200 and code <= 400 and body ~= "404" then
              if tonumber(body) >= 4 then
                shenhey()
               else
                提示("无权操作")
              end
            end
          end)
        end;
        text="审核邮件";
      };
    };
    {
      LinearLayout;
      orientation="horizontal";
      id="zmxg";
    };
  };
  if cjj~=nil then
    cjj.dismiss()
  end
  cjj=PopupWindow(activity)--创建PopWindow
  cjj.setContentView(loadlayout(zrz))--设置布局
  cjj.setWidth(activity.Width*0.96)--设置宽度
  cjj.setHeight(-2)--设置高度
  cjj.setFocusable(true)--设置可获得焦点
  cjj.setTouchable(true)--设置可触摸
  cjj.setOutsideTouchable(true)
  cjj.showAtLocation(view,Gravity.CENTER,0,0)
  zmj.Text = "宗门:"..tbl.name
  zlv.Text = "等级:"..tbl.level
  zml.Text = "宗门类型:"..lx[tonumber(tbl.type)]
  zzn.Text = "宗主:"..tbl.GN
  zmx.Text = "宗门宣言:"..tbl.info
  zmn.Text = "人数:"..tbl.number
  local sf
  if tbl.sf == "5" then
    sf = "宗主"
   elseif tbl.sf == "4" then
    sf = "长老"
   else
    sf = "弟子"
  end
  zdw.Text="宗门地位:"..sf
  if tbl.qq ~= nil and tbl.qq ~= "" then
    zmq.addView(loadlayout{
      TextView;
      textColor="#000000";
      text="宗门Q群:"..tbl.qq;
    })
    zmq.addView(loadlayout{
      Button,--按钮控件;
      layout_height="8%w";
      layout_width="18%w";
      textSize="10sp";
      onClick=function
        加群(tbl.qq)
      end;
      text="点击加入";
    })
  end
  if tbl.sf == "5" then
    zmxg.addView(loadlayout{
      Button,--按钮控件;
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
            hint="请输入你要修改的QQ群号";
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
            hs("http://82.157.62.200/zm/xgss.php?name="..tbl.name.."&text="..edit.Text.."&key="..tmkey(),function(code,body)
              if code ~= -1 and code >= 200 and code <= 400 and body ~= "404" then
                提示("配置成功")
               else
                提示("网络错误")
              end
            end)
        end})
        .setNegativeButton("取消",nil)
        .show()
      end;
      text="配置Q群";
    })
    zmxg.addView(loadlayout{
      Button,--按钮控件;
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
            hint="请输入你要修改的宗门宣言";
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
            hs("http://82.157.62.200/zm/xgii.php?name="..tbl.name.."&text="..edit.Text.."&key="..tmkey(),function(code,body)
              if code ~= -1 and code >= 200 and code <= 400 and body ~= "404" then
                提示("配置成功")
               else
                提示("网络错误")
              end
            end)
        end})
        .setNegativeButton("取消",nil)
        .show()
      end;
      text="配置宣言";
    })
  end
end