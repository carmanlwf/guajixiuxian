require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

function 万向滚动(d,b,c,a)
  limoa=a
  function 调用(fun1)
    function myerrorhandler( err )
      print( "调用错误:", err )
    end
    fun=[[xpcall(  function() 
]]..fun1..[[
 end ,myerrorhandler)
]]
    import "java.io.File"
    if 文件是否存在("/sdcard/android/dofile.l")==true then
     else
      创建文件('/sdcard/android/dofile.l')
    end
    io.open("/storage/emulated/0/android/dofile.l","w"):write(fun):close()
    dofile("/storage/emulated/0/android/dofile.l")
  end



  调用([[
  limomm=    {
      LinearLayout;
      id="滚动b]]..d..[[";       
        ]]..string.sub(tostring(dump(b)),2,-4)..[[
      
          {
      LinearLayout;
      id="滚动c]]..d..[[";
        ]]..string.sub(tostring(dump(c)),2,-4)..[[
      
 
        limoa;
      };
    };
 
]])
  return limomm
end
function 滚动初始化(a,b)
  if b==nil then
    b=1
  end
  function 拖动12(nm,a,c)
    function intx(a)
      local a=tostring(a)
      local b=string.find(a,"%.")
      a=string.sub(a,1,b-1)
      return tonumber(a)
    end
    function nm.OnTouchListener(v,event)
      if event.getAction()==MotionEvent.ACTION_DOWN then
        firstX=event.getRawX()
        firstY=event.getRawY()
        wmX=c.x
        wmY=c.y

       elseif event.getAction()==MotionEvent.ACTION_MOVE then
        if c.getWidth()>a.getWidth() then

          if intx(wmX+((event.getRawX()-firstX)*b))<=0 then
            if intx(wmX+((event.getRawX()-firstX)*b))>=a.getWidth()-c.getWidth()then
              c.x=wmX+((event.getRawX()-firstX)*b)
             else
              c.x=a.getWidth()-c.getWidth()
            end
           else
            c.x=0
          end
        end

        if c.getHeight()>a.getHeight() then

          if intx(wmY+((event.getRawY()-firstY))*b)<=0 then
            if intx(wmY+((event.getRawY()-firstY))*b)>=a.getHeight()-c.getHeight()then
              c.y=wmY+((event.getRawY()-firstY)*b)
             else
              c.y=a.getHeight()-c.getHeight()
            end
           else
            c.y=0
          end
        end

       elseif event.getAction()==MotionEvent.ACTION_UP then
      end
      return true
    end
  end


  调用("拖动12(滚动b"..a..",滚动b"..a..",滚动c"..a..")")
end