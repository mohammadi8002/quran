dir=package.searchpath("main",package.path):match("(.*)main.lua")
dofile(dir.."imports.lua")

win = "main"
win_ = 1
if useCustomGestures then
  if service then
    service.loadGesturePackage("Quran extension gestures")
  end
end
mainLayout.startAnimation(enterAnim)
activity.ActionBar.hide()
activity.setContentView(mainLayout)
playBasmala()
loadContent()

function onKeyDown(keycode, event)
  if keycode == event.KEYCODE_BACK then
    if win == "main" then
      if useCustomGestures then
        if service then
          service.loadGesturePackage("مُخَصَّص")
        end
      end
      if stop then
        stopCurrentAndCancelNext()
      end
      activity.finish()
     elseif win == "window" then
      quranLayout = loadlayout("layout.quran")
      showQuran(index)
      win = "quran"
     elseif win == "general" or win == "audio" or win == "appearance" then
      showSettings()
     else
      if win == "quran" then
        if saveLastPos then
          lastPos = listView.getFirstVisiblePosition() + 1
          posText = results[lastPos].text
          if string.find(posText, "-") then
            lastPos = lastPos + 1
          end
          editor.putInt("lastPos", results[lastPos].number)
          editor.commit()
        end
       else
        dofile(dir .. "imports.lua")
        loadContent(dnt)
      end
      activity.setContentView(mainLayout)
      win = "main"
    end
    return true
  end
end

local xStart, xEnd, yStart, yEnd

local function onTouch(view, event)
  action = event.getAction()
  if action == MotionEvent.ACTION_DOWN then
    xStart = event.getX()
    yStart = event.getY()
   elseif action == MotionEvent.ACTION_UP then
    xEnd = event.getX()
    yEnd = event.getY()
    if xStart and xEnd and yStart and yEnd then
      xDiff = math.abs(xEnd - xStart)
      yDiff = math.abs(yEnd - yStart)
      if xDiff > yDiff and xDiff > 100 then
        if xEnd > xStart then
          titleBar.setVisibility(View.GONE)
          btnBar.setVisibility(View.GONE)
         else
          activity.setContentView(mainLayout)
        end
        return true
      end
    end
  end
  return false
end

quranContainer.setOnTouchListener(onTouch)

if backLastPos then
  if dnt == "juzs" then
    index = ayas[lastPos].juz
   elseif dnt == "suras" then
    index = ayas[lastPos].suraNumber
   elseif dnt == "hizbs" then
    index = ayas[lastPos].hizb
   elseif dnt == "quarts" then
    index = ayas[lastPos].quarter
   elseif dnt == "pages" then
    index = ayas[lastPos].page
  end
  showQuran()
  goBookmark(lastPos)
end