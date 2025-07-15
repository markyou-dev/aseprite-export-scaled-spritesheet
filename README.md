# Aseprite Scaled Sheet Exporter

A Lua script for Aseprite that exports sprite sheets and JSON data using structured filenames, and automatically scales both the PNG image and the JSON coordinate data.

> ✅ Ideal for pixel-art games that need scaled textures with accurate frame metadata.

---

## ✨ Features

- 📦 Exports a sprite sheet using `{layer}/{tag}/{frame}` as the frame filename
- 🧾 Outputs `json-array` format compatible with most game frameworks
- 🔍 Nearest-neighbor scaling for both image and JSON frame coordinates
- 📁 Automatically saves to an `export/` subfolder next to your .aseprite file
- ⚙️ Easy to configure scale factor

---

## 📂 Output Example

If your `.aseprite` file is named `hero.aseprite`, running the script will generate:

```
your-folder/
├── hero.aseprite
└── export/
├── hero_5x.png
└── hero_5x.json
```

The JSON file will look like:

```json
{
  "frames": [
    {
      "filename": "character/front/1",
      "frame": { "x": 0, "y": 0, "w": 80, "h": 80 },
      ...
    },
    ...
  ]
}
```

## 🚀 How to Use
* Open Aseprite
* Go to File > Scripts > Open Scripts Folder
* Copy the Lua file (e.g., export_scaled_spritesheet.lua) into that folder
* Restart Aseprite
* Open the .aseprite file you want to export
* Run the script via File > Scripts > export_scaled_spritesheet

## ⚙️ Configuration
You can change the scale factor at the top of the script:

```lua
local scale = 5 -- Change this to your desired scale factor
```

## 🧠 Requirements

* Aseprite v1.3 or higher
* Uses Aseprite’s Lua API: https://www.aseprite.org/api/

## 📄 License

This project is licensed under the [MIT License](./LICENSE).
