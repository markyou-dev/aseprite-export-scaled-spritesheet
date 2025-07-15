-- doc : https://www.aseprite.org/api/
-- Script Start
local spr = app.activeSprite
if not spr then
  app.alert("No active sprite!")
  return
end

local outputDir = app.fs.joinPath(app.fs.filePath(spr.filename), "export")
local scale = 5 -- Desired scale factor

-- Create output folder
if not app.fs.isDirectory(outputDir) then
  app.fs.makeDirectory(outputDir)
end

-- File paths
local baseName = app.fs.fileTitle(spr.filename)
local sheetPath = app.fs.joinPath(outputDir, baseName .. "_" .. scale .. "x.png")
local dataPath = app.fs.joinPath(outputDir, baseName .. "_" .. scale .. "x.json")

-- Export Sprite Sheet
app.command.ExportSpriteSheet{
  ui=false,
  -- recent=true,
  askOverwrite=true,
  type=SpriteSheetType.ROWS,
  -- columns=0,
  -- rows=0,
  -- width=0,
  -- height=0,
  -- bestFit=false,
  textureFilename=sheetPath,
  dataFilename=dataPath,
  dataFormat=SpriteSheetDataFormat.JSON_ARRAY,
  filenameFormat="{layer}/{tag}/{frame}",
  -- borderPadding=0,
  -- shapePadding=0,
  -- innerPadding=0,
  -- trimSprite=false,
  -- trim=false,
  -- trimByGrid=false,
  -- extrude=false,
  -- ignoreEmpty=false,
  -- mergeDuplicates=false,
  -- openGenerated=false,
  -- layer="",
  -- tag="",
  splitLayers=true,
  splitTags=false,
  splitGrid=false,
  listLayers=false,
  listTags=false,
  listSlices=false,
  fromTilesets=false,
}

-- Scale PNG image
local function scaleImage(imagePath, scale)
  local originalImage = Image{ fromFile = imagePath }
  if not originalImage then return false end

  local scaledImage = Image(originalImage.width * scale, originalImage.height * scale, originalImage.colorMode)

  for y = 0, originalImage.height - 1 do
    for x = 0, originalImage.width - 1 do
      local pixel = originalImage:getPixel(x, y)
      for sy = 0, scale - 1 do
        for sx = 0, scale - 1 do
          scaledImage:putPixel(x * scale + sx, y * scale + sy, pixel)
        end
      end
    end
  end

  scaledImage:saveAs(imagePath)
  return true
end

-- Scale coordinates in JSON
local function scaleJsonData(jsonPath, scale)
  local file = io.open(jsonPath, "r")
  if not file then return false end

  local content = file:read("*all")
  file:close()

  local function scaleField(field)
    return content:gsub('("' .. field .. '"):%s*(%d+)', function(key, num)
      return key .. ': ' .. (tonumber(num) * scale)
    end)
  end

  content = scaleField("x")
  content = scaleField("y")
  content = scaleField("w")
  content = scaleField("h")

  local outputFile = io.open(jsonPath, "w")
  if outputFile then
    outputFile:write(content)
    outputFile:close()
    return true
  end

  return false
end

-- Apply scaling
local imageSuccess = scaleImage(sheetPath, scale)
local jsonSuccess = scaleJsonData(dataPath, scale)

if imageSuccess and jsonSuccess then
  app.alert("Export complete!\nSheet: " .. sheetPath .. "\nJSON: " .. dataPath .. "\nScale applied: " .. scale .. "x")
else
  app.alert("Export complete, but an error occurred during scaling.")
end
