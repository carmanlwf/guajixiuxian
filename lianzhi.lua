require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

function lianzhi()
  local l=AlertDialog.Builder(activity)
  .setView(loadlayout(MapUI()["炼制面板"]))
  local m = l.show()
  炼制等级.Text="炼器等级:"..lianqi[SaveTable["炼器"].level][1].."("..SaveTable["炼器"].exp.."/"..lianqi[SaveTable["炼器"].level][2]..")"
end