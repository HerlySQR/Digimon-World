--[[ TasCheatBox V0.8 by Tasyen

A UI addition that gives the user various powers. Good to have fun or test your map.
Works out of the box, for singleplayer only.
TasCheatBox becomes more powerful when your map has installed TasButtonList and Load in the default Templates.

]]
do
    TasCheatBox = {
       AutoRun = true --(true) will create Itself at 0s, (false) you need to TasCheatBox.Init()
       ,TemplatesToc = "war3mapImported\\Templates.toc" -- optional for the Lua input box
       ,ParentFunc = function() return BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0) end
 
       ,OpenX = 0.2
       ,OpenY = 0.15
       ,OpenPos = FRAMEPOINT_BOTTOMLEFT
 
       ,X = 0.79
       ,Y = 0.16
       ,Pos = FRAMEPOINT_BOTTOMRIGHT
 
 
       -- Units/Item only work when TasButtonList is installed
       ,ListX = 0.77
       ,ListY = 0.57
       ,ListPos = FRAMEPOINT_TOPRIGHT
       ,ListCols = 4
       ,LisRows = 6
 
       ,Scale = 0.8
 
       ,IncludeDefaultItems = true --add default Items to the List?
       ,IncludeDefaultUnits = true
       ,IncludeCustomItems = false  --Try to find Custom Items and add them to the List?
       ,IncludeCustomUnits = false
       ,CheckCustomObject = true -- slows the process but excludes objects without name
       ,CustomItemEnd = FourCC'I09Z' -- LastItem Custom Id
       
       ,CustomUnitCodes = {
          {FourCC'h000',FourCC'h0A0'} -- startIndex , endIndex
          ,{FourCC'H000',FourCC'H09Z'}
          ,{FourCC'o000',FourCC'o09Z'}
          ,{FourCC'O000',FourCC'O09Z'}
          ,{FourCC'u000',FourCC'u09Z'}
          ,{FourCC'U000',FourCC'U09Z'}
          ,{FourCC'e000',FourCC'e09Z'}
          ,{FourCC'E000',FourCC'E09Z'}
          ,{FourCC'n000',FourCC'n09Z'}
          ,{FourCC'N000',FourCC'N09Z'}
       }
       
 
       ,ButtonCount = __jarray(0)
       ,ButtonAction = {}
       ,ButtonActionGroup = {}
       ,ParentPage = {}
       ,CurrentUnitOwner = 0
       ,PageName = {
          "Unit","Player Game", "Place Unit","Place Item","Lua"
       }
       
    }
    local this = TasCheatBox
    
 
    --this.SelectAction = function()
       --this.Selected = GetTriggerUnit()
    --end
 
    function this.ActionClone()
       local u = GetEnumUnit()
       local u2 = CreateUnit(GetOwningPlayer(u), GetUnitTypeId(u), GetUnitX(u), GetUnitY(u), GetUnitFacing(u))
       if IsUnitType(u, UNIT_TYPE_HERO) then
          SetHeroLevel(u2, GetHeroLevel(u))
          SetHeroAgi(u2, GetHeroAgi(u), true)
          SetHeroInt(u2, GetHeroInt(u), true)
          SetHeroStr(u2, GetHeroStr(u), true)
          for i = 0, bj_MAX_INVENTORY-1 do
             UnitAddItemToSlotById(u2, GetItemTypeId(UnitItemInSlot(u, i)), i)
          end
       end
       PauseUnit(u2, IsUnitPaused(u))
    end
    function this.ActionInvul()
       local  u = GetEnumUnit()
       SetUnitInvulnerable(u, not  BlzIsUnitInvulnerable(u))
    end
    function this.ActionControl()
       SetUnitOwner(GetEnumUnit(), GetTriggerPlayer(), true)
    end
    function this.ActionHeal()
       local  u = GetEnumUnit()
       SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_MAX_LIFE))
       SetUnitState(u, UNIT_STATE_MANA, GetUnitState(u, UNIT_STATE_MAX_MANA))
       UnitResetCooldown(u)
    end
    function this.ActionMaxLevel() SetHeroLevel(GetEnumUnit(), 99999, true) end
    function this.ActionKill() KillUnit(GetEnumUnit()) end
    function this.ActionDispel() UnitRemoveBuffs(GetEnumUnit(), true, true) end
    function this.ActionTeleport() SetUnitPosition(GetEnumUnit(), GetCameraTargetPositionX(), GetCameraTargetPositionY()) end
    function this.ActionPause() PauseUnit(GetEnumUnit(), not IsUnitPaused(GetEnumUnit())) end
    function this.ActionPauseAll() PauseAllUnitsBJ(true) end
    function this.ActionUnPauseAll() PauseAllUnitsBJ(false) end
    function this.ActionFood0(player) 
       SetPlayerState(player, PLAYER_STATE_RESOURCE_FOOD_USED, 0)
       SetPlayerState(player, PLAYER_STATE_RESOURCE_FOOD_CAP, 999)
    end
    function this.ActionDefeatPlayer(player)      
       GroupEnumUnitsSelected(this.Group, player, nil)
       local u = FirstOfGroup(this.Group)
       GroupClear(this.Group)
       if u then CustomDefeatBJ(GetOwningPlayer(u), GetLocalizedString("GAMEOVER_DEFEAT_MSG")) end
    end
 
    function this.ActionVictory(player)
       CustomVictoryBJ(player, true, true)
    end
    function this.ActionRevive(player)
       GroupEnumUnitsOfPlayer(this.Group, player, nil)
       for i = 0, BlzGroupGetSize(this.Group) - 1 do
          local u = BlzGroupUnitAt(this.Group, i)
          if IsUnitType(u, UNIT_TYPE_HERO) then
             SetUnitUseFood(u, false)
             ReviveHero(u, GetCameraTargetPositionX(), GetCameraTargetPositionY(), true)
          else
             return
          end
       end
    end
    
 
    function this.ActionFastBuilt(player)
       Cheat("warpten")
       Cheat("WHOISJOHNGALT")
    end
 
    function this.AddIds(id, idEnd, tasButList)
       local rest = ModuloInteger(id, 256)
       local digit00XX
       -- easy to use variables for later
       local bj_256power2 = 256 * 256
       local bj_ZZ = 256 * 90 + 90
       local bj_00 = 47 + 48 * 256
       local bj_9Z = 256 * 57 + 90
       local bj_A0 = 256 * 65 + 47
       while id <= idEnd do
           --Number 0 to 9                       A to Z
           if (rest >= 48 and rest <= 57 ) or (rest >= 65 and rest <= 90)  then
               --Instead of Debug you would have to add remove ability or create Items/Units.       
               --print(id..": "..GetObjectName(id))
               if not this.CheckCustomObject or GetObjectName(id) ~= "" then
                TasButtonListAddData(tasButList, id)
               end
               id = id + 1
               rest = rest +1
           --move 1 expo up and jump to 0
           elseif rest > 90 then
               digit00XX = ModuloInteger(id, bj_256power2)
               -- 'ZZ', push 1 digit up.?
               if digit00XX > bj_ZZ then
                    id = id + bj_256power2 - bj_ZZ + bj_00   --'00' has to be added.
               --skip value between 'A09Z' and 'A0A0'?
               elseif digit00XX > bj_9Z then
                   id = id + (bj_A0  - bj_9Z)
               else
                   id =  id + (256 - rest + 48)
               end
               rest = 48
           --skip values between 9 and A
           elseif rest > 57 then
               id =  id + (65 - rest)
               rest = 65
           end
        end
       return id
    end
    
    this.AnyAction = function()
       local frame = BlzGetTriggerFrame()
       local player = GetTriggerPlayer()
       BlzFrameSetEnable(frame, false)
       BlzFrameSetEnable(frame, true)
       StopCamera()
       print("Cheat",BlzFrameGetText(frame), GetPlayerName(player))
       if this.ButtonAction[frame] then
          if type(this.ButtonAction[frame]) == "function" then
             this.ButtonAction[frame](player)
          elseif type(this.ButtonAction[frame]) == "string" then
             Cheat(this.ButtonAction[frame])
          end
       end      
       if this.ButtonActionGroup[frame] then
          GroupEnumUnitsSelected(this.Group, player, nil)
          ForGroup(this.Group, this.ButtonActionGroup[frame])
       end
    end
    this.OpenAction = function()
       BlzFrameSetVisible(BlzGetFrameByName("CheatFrame", 0), BlzGetTriggerFrameEvent() == FRAMEEVENT_CHECKBOX_CHECKED)
    end
    this.ShowPage = function(page)
       for i, v in ipairs(this.ParentPage) do BlzFrameSetVisible(v, false) end
       BlzFrameSetVisible(this.ParentPage[page], true)
       if page == 5 then
          print "Insert Lua code into the EditBox & press Enter/Return\nUdg_Unit is single selected Unit\nSupports CTRL V/C Pos1 end marking with shift"
       end
    end
 local function TryCreateTooltp(frame, text)
    if CreateSimpleTooltip and text then
       CreateSimpleTooltip(frame, text)
     end
 end
    this.AddButton = function(page, text, action, actionSelectedUnits, toolTipText)
       local frame
       local trig = CreateTrigger()
       TriggerAddAction(trig, this.AnyAction)
       this.ButtonCount[0] = this.ButtonCount[0] + 1
       
 
       frame = BlzCreateFrameByType("GLUETEXTBUTTON", "CheatButton", this.ParentPage[page], "ScriptDialogButton", this.ButtonCount[0])
       TryCreateTooltp(frame, toolTipText)
       if this.ButtonCount[page] == 0 then
          BlzFrameSetAbsPoint(frame, this.Pos, this.X, this.Y + 0.025)
       else
          BlzFrameSetPoint(frame, FRAMEPOINT_BOTTOM, BlzGetFrameByName("CheatButton", this.ButtonCount[page]), FRAMEPOINT_TOP, 0,0)
       end
       this.ButtonCount[page] = this.ButtonCount[0]
       BlzTriggerRegisterFrameEvent(trig, frame, FRAMEEVENT_CONTROL_CLICK)
       BlzFrameSetText(frame, text)
       this.ButtonAction[frame] = action
       this.ButtonActionGroup[frame] = actionSelectedUnits
    end
 
    this.InitFrames = function()
       BlzLoadTOCFile(this.TemplatesToc)
       this.Parent = BlzCreateFrameByType("FRAME", "CheatFrame", this.ParentFunc(), "", 0)
       BlzFrameSetScale(this.Parent, this.Scale)
       this.ParentPage[1] = BlzCreateFrameByType("FRAME", "CheatFramePageA", this.Parent, "", 0)
       this.ParentPage[2] = BlzCreateFrameByType("FRAME", "CheatFramePageB", this.Parent, "", 0)
       this.ParentPage[3] = BlzCreateFrameByType("FRAME", "CheatFramePageC", this.Parent, "", 0)
       this.ParentPage[4] = BlzCreateFrameByType("FRAME", "CheatFramePageD", this.Parent, "", 0)
       this.ParentPage[5] = BlzCreateFrameByType("FRAME", "CheatFramePageE", this.Parent, "", 0)
       
       for i = 1, #this.ParentPage do
          frame = BlzCreateFrameByType("GLUETEXTBUTTON", "CheatFramePageButton", this.Parent, "ScriptDialogButton", i)
          BlzFrameSetSize(frame, 0.03, 0.03)
          BlzFrameSetText(frame, i)
          BlzFrameSetAbsPoint(frame, this.Pos, this.X - 0.035*i +0.035, this.Y)
          local trig = CreateTrigger()
          TriggerAddAction(trig, function()
             this.ShowPage(i)
             BlzFrameSetEnable(BlzGetTriggerFrame(), false)
             BlzFrameSetEnable(BlzGetTriggerFrame(), true)
          end)
          BlzTriggerRegisterFrameEvent(trig, frame, FRAMEEVENT_CONTROL_CLICK)
          TryCreateTooltp(frame, this.PageName[i])
       end
 
       BlzCreateFrame("EscMenuEditBoxTemplate", this.ParentPage[5], 0, 0)
       TryCreateTooltp(BlzGetFrameByName("EscMenuEditBoxTemplate", 0), "executes Lua code|nudg_Unit is the current Selected Unit|n   ctrl + v")
         BlzFrameSetAbsPoint(BlzGetFrameByName("EscMenuEditBoxTemplate", 0), this.Pos, this.X, this.Y + 0.025)
         BlzFrameSetSize(BlzGetFrameByName("EscMenuEditBoxTemplate", 0), 0.16, 0.032)
         local trig = CreateTrigger()
         TriggerAddAction(trig, function() xpcall(function() load(BlzFrameGetText(BlzGetTriggerFrame()))() end, print) end)
         BlzTriggerRegisterFrameEvent(trig, BlzGetFrameByName("EscMenuEditBoxTemplate", 0), FRAMEEVENT_EDITBOX_ENTER)       
         BlzFrameSetScale(BlzGetFrameByName("EscMenuEditBoxTemplate", 0), 1.1)
       
       local frame = BlzCreateFrameByType("GLUECHECKBOX", "CheatCheckBox", this.ParentFunc(), "QuestCheckBox", 0)
       BlzFrameSetAbsPoint(frame, this.OpenPos, this.OpenX, this.OpenY)
       local trig = CreateTrigger()
       TriggerAddAction(trig, this.OpenAction)
       BlzTriggerRegisterFrameEvent(trig, frame, FRAMEEVENT_CHECKBOX_CHECKED)
       BlzTriggerRegisterFrameEvent(trig, frame, FRAMEEVENT_CHECKBOX_UNCHECKED)
       TryCreateTooltp(frame, "Show CheatBox?")
 
       this.AddButton(1,"Kill", nil, this.ActionKill, "Kill Selected")
       this.AddButton(2,"Victory", this.ActionVictory, "You win")
       this.AddButton(1,"Teleport", nil, this.ActionTeleport, "Selected Units -> center of Screen")
       this.AddButton(1,"Dispel", nil, this.ActionDispel, "Remove All Buffs Selected")
       this.AddButton(1,"Clone", nil, this.ActionClone, "Create Copies of Selected")
       this.AddButton(1,"MaxLevel", nil, this.ActionMaxLevel, "Max Hero Level")
       this.AddButton(2,"Resources", "greedisgood 999999", nil, "Much Lumber & Golld")
       this.AddButton(2,"Food", this.ActionFood0, nil, "Food used 0; Food cap Max")
       this.AddButton(1,"Heal & Cooldown", nil, this.ActionHeal, "HP & MP & Cooldowns Selected")
       this.AddButton(1,"(In)vul", nil, this.ActionInvul, "Toggle Invul Selected")
       this.AddButton(2,"Vision", "ISEEDEADPEOPLE", nil, "Reveal all Map On/off")
       this.AddButton(2,"Fast Built & Research", this.ActionFastBuilt)
       this.AddButton(2,"Morning", "RISEANDSHINE", nil, "6h")
       this.AddButton(2,"Evening", "LIGHTSOUT", nil,  "18h")
       this.AddButton(1,"Control", nil, this.ActionControl, "Selected is yours")
       this.AddButton(2,"Revive", this.ActionRevive, nil, "Revive your Heroes, might need to repeat")
       this.AddButton(1,"(Un)Pause", nil, this.ActionPause, "Toggle Pause state of Selected")
       this.AddButton(2,"Pause All", this.ActionPauseAll, nil, "Pause all Units currently on the map")
       this.AddButton(2,"UnPause All", this.ActionUnPauseAll, nil, "UnPause all Units currently on the map")
       this.AddButton(2,"Defeat", this.ActionDefeatPlayer, nil, "Defeats the player owning the selected Unit")
 
       if TasButtonList then
          
          for pInt = 0, bj_MAX_PLAYER_SLOTS - 1 do
             local colorButton = BlzCreateFrameByType("GLUEBUTTON", "UnitListPlayerColorButton", this.ParentPage[3], "IconicButtonTemplate", pInt)
             BlzFrameSetSize(colorButton, 0.018, 0.018)
             if pInt == 0 then
                BlzFrameSetAbsPoint(colorButton, this.ListPos, this.ListX, this.ListY)
             elseif pInt == 12 then
                BlzFrameSetAbsPoint(colorButton, this.ListPos, this.ListX, this.ListY - 0.0182)
             elseif pInt == 24 then
                BlzFrameSetAbsPoint(colorButton, this.ListPos, this.ListX, this.ListY - 0.0364)
             else
                BlzFrameSetPoint(colorButton, FRAMEPOINT_RIGHT, BlzGetFrameByName("UnitListPlayerColorButton", pInt - 1), FRAMEPOINT_LEFT,  -0.002, 0)
             end
             local icon = BlzCreateFrameByType("BACKDROP", "UnitListPlayerColorIcon", colorButton, "", pInt)
             BlzFrameSetAllPoints(icon, colorButton)
             local colorIndex = GetHandleId(GetPlayerColor(Player(pInt)))
             if colorIndex < 10 then
                BlzFrameSetTexture(icon, "ReplaceableTextures\\TeamColor\\TeamColor0"..colorIndex, 0, false)
             else
                BlzFrameSetTexture(icon, "ReplaceableTextures\\TeamColor\\TeamColor"..colorIndex, 0, false)
             end
             local trig = CreateTrigger()
             TriggerAddAction(trig, function() 
                this.CurrentUnitOwner = pInt
                BlzFrameSetPoint(this.SpriteFrame, FRAMEPOINT_BOTTOMLEFT, BlzGetTriggerFrame(), FRAMEPOINT_BOTTOMLEFT, -0.003, -0.003)
                BlzFrameSetEnable(BlzGetTriggerFrame(), false)
                BlzFrameSetEnable(BlzGetTriggerFrame(), true)
             end)
             BlzTriggerRegisterFrameEvent(trig, colorButton, FRAMEEVENT_CONTROL_CLICK)
             
          end
          local sprite = BlzCreateFrameByType("SPRITE", "UnitListPlayerColorSprite", this.ParentPage[3], "", 0)
          BlzFrameSetModel(sprite, "ui\\feedback\\autocast\\ui-modalbuttonon.mdx", 0)
          BlzFrameSetScale(sprite, 0.018/0.039)
          BlzFrameSetSize(sprite, 0.001, 0.001)
          BlzFrameSetPoint(sprite, FRAMEPOINT_BOTTOMLEFT, BlzGetFrameByName("UnitListPlayerColorButton", this.CurrentUnitOwner), FRAMEPOINT_BOTTOMLEFT, -0.003, -0.003)
          this.SpriteFrame = sprite
 
 
          this.UnitListFrame = BlzCreateFrameByType("FRAME", "", this.ParentPage[3], "",0)
          BlzFrameSetSize(this.UnitListFrame, 0.23, 0.001)
          BlzFrameSetScale(this.UnitListFrame, 1)
          --BlzFrameSetAbsPoint(frameA, FRAMEPOINT_TOPRIGHT, 0.78, 0.54)
          BlzFrameSetAbsPoint(this.UnitListFrame, this.ListPos, this.ListX, this.ListY - 0.06)
 
          this.UnitList = CreateTasButtonListEx("TasButtonGrid", this.ListCols, this.LisRows, this.UnitListFrame, function(data, buttonListObject, dataIndex)
             this.CurrentUnitCode = data
             BlzSetSpecialEffectScale(this.PreviewItem, 0.00001)
             BlzSetSpecialEffectScale(this.PreviewUnit, 1)
             print "Left Click -> create\nother mouse clicks end it"
          end)
          for int = 1, this.ListCols*this.LisRows do
             BlzFrameSetVisible(this.UnitList.Frames[int].TextLumber, false)
             BlzFrameSetVisible(this.UnitList.Frames[int].TextGold, false)
             BlzFrameSetVisible(this.UnitList.Frames[int].IconGold, false)
             BlzFrameSetVisible(this.UnitList.Frames[int].IconLumber, false)
             BlzFrameSetSize(this.UnitList.Frames[int].Button, 0.03, 0.0265)
             BlzFrameSetScale(this.UnitList.Frames[int].Button, 1.5)
             BlzFrameSetScale(this.UnitList.Frames[int].ToolTipFrame, 1.0)
         end
         BlzFrameSetPoint(this.UnitList.Frames[1].Button, FRAMEPOINT_TOPRIGHT, this.UnitList.InputFrame, FRAMEPOINT_BOTTOMRIGHT, -BlzFrameGetWidth(this.UnitList.Frames[1].Button)*(5-1)*0.5, 0)
          local data = {"Hamg"
 , "Hblm", "Hmkg", "Hpal", "hbot", "hbsh", "hdes", "hdhw", "hfoo", "hgry", "hgyr", "hkni", "hmil"
 , "hmpr", "hmtm", "hmtt", "hpea", "hphx", "hpxe", "hrif", "hrtt", "hsor", "hspt", "hwat", "hwt2"
 , "hwt3", "nlv1", "nlv2", "nlv3", "halt", "harm", "hars", "hatw", "hbar", "hbla", "hcas", "hctw"
 , "hgra", "hgtw", "hhou", "hkee", "hlum", "hshy", "htow", "hvlt", "hwtw", "Obla", "Ofar", "Oshd"
 , "Otch", "ncat", "nsw1", "nsw2", "nsw3", "nwad", "obot", "ocat", "odes", "odoc", "oeye", "ogru"
 , "ohun", "ohwd", "okod", "opeo", "orai", "oshm", "osp1", "osp2", "osp3", "osp4", "ospm", "ospw"
 , "osw1", "osw2", "osw3", "otau", "otbk", "otbr", "otot", "owyv", "oalt", "obar", "obea", "ofor"
 , "ofrt", "ogre", "oshy", "osld", "ostr", "otrb", "otto", "ovln", "owtw", "Edem", "Edmm", "Ekee"
 , "Emoo", "Ewar", "earc", "ebal", "ebsh", "echm", "edcm", "edes", "edoc", "edot", "edry", "edtm"
 , "efdr", "efon", "ehip", "ehpr", "emtg", "esen", "espv", "even", "ewsp", "eaoe", "eaom", "eaow"
 , "eate", "eden", "edob", "edos", "egol", "emow", "eshy", "etoa", "etoe", "etol", "etrp", "Ucrl"
 , "Udea", "Udre", "Ulic", "uabo", "uaco", "uban", "ubsp", "ucrm", "ucry", "ucs1", "ucs2", "ucs3"
 , "ucsB", "ucsC", "ufro", "ugar", "ugho", "ugrm", "uloc", "umtw", "unec", "uobs", "uplg", "ushd"
 , "uske", "uskm", "uubs", "uaod", "ubon", "ugol", "ugrv", "unp1", "unp2", "unpl", "usap", "usep"
 , "ushp", "uslh", "utod", "utom", "uzg1", "uzg2", "uzig", "Nal2", "Nal3", "Nalc", "Nalm", "Nbrn"
 , "Nbst", "Nfir", "Nngs", "Npbm", "Nplh", "Nrob", "Ntin", "ncg1", "ncg2", "ncg3", "ncgb", "ndr1"
 , "ndr2", "ndr3", "nfa1", "nfa2", "nfac", "ngz1", "ngz2", "ngz3", "ngz4", "ngzc", "ngzd", "npn1"
 , "npn2", "npn3", "npn4", "npn5", "npn6", "nqb1", "nqb2", "nqb3", "nqb4", "nwe1", "nwe2", "nwe3"
 , "nadk", "nadr", "nadw", "nahy", "nanb", "nanc", "nane", "nanm", "nano", "nanw", "narg", "nass"
 , "nba2", "nbal", "nban", "nbda", "nbdk", "nbdm", "nbdo", "nbdr", "nbds", "nbdw", "nbld", "nbnb"
 , "nbot", "nbrg", "nbwm", "nbzd", "nbzk", "nbzw", "ncea", "ncen", "ncer", "ncfs", "nchp", "ncim"
 , "ncks", "ncnk", "ndqn", "ndqp", "ndqs", "ndqt", "ndqv", "ndrv", "ndtb", "ndth", "ndtp", "ndtr"
 , "ndtt", "ndtw", "nehy", "nelb", "nele", "nenc", "nenf", "nenp", "nepl", "nerd", "ners", "nerw"
 , "nfel", "nfgb", "nfgo", "nfgt", "nfgu", "nfod", "nfor", "nfot", "nfov", "nfpc", "nfpe", "nfpl"
 , "nfps", "nfpt", "nfpu", "nfra", "nfrb", "nfre", "nfrg", "nfrl", "nfrp", "nfrs", "nfsh", "nfsp"
 , "nftb", "nftk", "nftr", "nftt", "ngdk", "nggr", "ngh1", "ngh2", "ngir", "nglm", "ngna", "ngnb"
 , "ngno", "ngns", "ngnv", "ngnw", "ngrd", "ngrk", "ngrw", "ngsp", "ngst", "ngza", "nhar", "nhdc"
 , "nhfp", "nhhr", "nhrh", "nhrq", "nhrr", "nhrw", "nhyc", "nhyd", "nhyh", "nhym", "nina", "ninc"
 , "ninf", "ninm", "nith", "nitp", "nitr", "nits", "nitt", "nitw", "njg1", "njga", "njgb", "nkob"
 , "nkog", "nkol", "nkot", "nlds", "nlkl", "nlpd", "nlpr", "nlps", "nlrv", "nlsn", "nltc", "nltl"
 , "nlur", "nmam", "nmbg", "nmcf", "nmdr", "nmfs", "nmgd", "nmgr", "nmgw", "nmit", "nmmu", "nmpg"
 , "nmrl", "nmrm", "nmrr", "nmrv", "nmsc", "nmsn", "nmtw", "nmyr", "nmys", "nndk", "nndr", "nnht"
 , "nnmg", "nnrg", "nnrs", "nnsu", "nnsw", "nnwa", "nnwl", "nnwq", "nnwr", "nnws", "noga", "nogl"
 , "nogm", "nogn", "nogo", "nogr", "nomg", "nowb", "nowe", "nowk", "npfl", "npfm", "nplb", "nplg"
 , "nqbh", "nrdk", "nrdr", "nrel", "nrog", "nrvd", "nrvf", "nrvi", "nrvl", "nrvs", "nrwm", "nrzb"
 , "nrzg", "nrzm", "nrzs", "nrzt", "nsat", "nsbm", "nsbs", "nsc2", "nsc3", "nsca", "nscb", "nsce"
 , "nsel", "nsgb", "nsgg", "nsgh", "nsgn", "nsgt", "nska", "nske", "nskf", "nskg", "nskm", "nsko"
 , "nslf", "nslh", "nsll", "nslm", "nsln", "nslr", "nslv", "nsnp", "nsns", "nsoc", "nsog", "nspb"
 , "nspd", "nspg", "nspp", "nspr", "nsqa", "nsqe", "nsqo", "nsqt", "nsra", "nsrh", "nsrn", "nsrv"
 , "nsrw", "nssp", "nsth", "nstl", "nsts", "nstw", "nsty", "nthl", "ntka", "ntkc", "ntkf", "ntkh"
 , "ntks", "ntkt", "ntkw", "ntor", "ntrd", "ntrg", "ntrh", "ntrs", "ntrt", "ntrv", "ntws", "nubk"
 , "nubr", "nubw", "nvde", "nvdg", "nvdl", "nvdw", "nwen", "nwgs", "nwiz", "nwld", "nwlg", "nwlt"
 , "nwna", "nwnr", "nwns", "nwrg", "nws1", "nwwd", "nwwf", "nwwg", "nwzd", "nwzg", "nwzr", "nzep"
 , "nzom", "nzof", "nalb", "ncrb", "nder", "ndog", "ndwm", "nech", "necr", "nfbr", "nfro", "nhmc"
 , "now2", "now3", "nowl", "npig", "npng", "npnw", "nrac", "nrat", "nsea", "nsha", "nshe", "nshf"
 , "nshw", "nskk", "nsno", "nvil", "nvk2", "nvl2", "nvlk", "nvlw", "nvul", "ncb0", "ncb1", "ncb2"
 , "ncb3", "ncb4", "ncb5", "ncb6", "ncb7", "ncb8", "ncb9", "ncba", "ncbb", "ncbc", "ncbd", "ncbe"
 , "ncbf", "ncnt", "ncop", "ncp2", "ncp3", "nct1", "nct2", "ndch", "ndh0", "ndh1", "ndh2", "ndh3"
 , "ndh4", "ndrg", "ndrk", "ndro", "ndrr", "ndru", "ndrz", "nfh0", "nfh1", "nfoh", "nfr1", "nfr2"
 , "ngad", "ngme", "ngnh", "ngni", "ngol", "ngt2", "ngwr", "nhns", "nmer", "nmg0", "nmg1", "nmh0"
 , "nmh1", "nmoo", "nmr0", "nmr2", "nmr3", "nmr4", "nmr5", "nmr6", "nmr7", "nmr8", "nmr9", "nmra"
 , "nmrb", "nmrc", "nmrd", "nmre", "nmrf", "nmrk", "nnzg", "nshp", "ntav", "nten", "nth0", "nth1"
 , "ntn2", "ntnt", "ntt2", "nwgt", "Ecen", "Eevi", "Eevm", "Efur", "Eidm", "Eill", "Eilm", "Ekgg"
 , "Emfr", "Emns", "Etyr", "Ewrd", "Hant", "Hapm", "Harf", "Hart", "Hdgo", "Hgam", "Hhkl", "Hjai"
 , "Hkal", "Hlgr", "Hmbr", "Hmgd", "Hpb1", "Hpb2", "Huth", "Hvsh", "Hvwd", "Naka", "Nbbc", "Nkjx"
 , "Nklj", "Nmag", "Nman", "Npld", "Nsjs", "Ocb2", "Ocbh", "Odrt", "Ogld", "Ogrh", "Opgh", "Orex"
 , "Orkn", "Osam", "Otcc", "Othr", "Oths", "Uanb", "Ubal", "Uclc", "Udth", "Uear", "Uktl", "Umal"
 , "Usyl", "Utic", "Uvar", "Uvng", "Uwar", "eilw", "enec", "ensh", "eshd", "etrs", "hbew", "hcth"
 , "hhdl", "hhes", "hprt", "hrdh", "nbee", "nbel", "nbsp", "nchg", "nchr", "nchw", "nckb", "ncpn"
 , "ndmu", "ndrd", "ndrf", "ndrh", "ndrj", "ndrl", "ndrm", "ndrn", "ndrp", "ndrs", "ndrt", "ndrw"
 , "ndsa", "negz", "nemi", "nfgl", "ngbl", "nhea", "nhef", "nhem", "nhew", "njks", "nmdm", "nmed"
 , "nmpe", "nmsh", "nser", "nspc", "nssn", "nthr", "nw2w", "nwat", "nzlc", "odkt", "ogrk", "ojgn"
 , "omtg", "onzg", "oosc", "oswy", "ovlj", "owar", "ownr", "uabc", "uarb", "ubdd", "ubdr", "ubot"
 , "udes", "uktg", "uktn", "uswb", "haro", "nbfl", "nbse", "nbsm", "nbsw", "nbt1", "nbt2", "nbwd"
 , "ncap", "ncaw", "ncmw", "ncta", "ncte", "nctl", "ndfl", "ndgt", "ndke", "ndkw", "ndmg", "ndrb"
 , "ndt1", "ndt2", "nef0", "nef1", "nef2", "nef3", "nef4", "nef5", "nef6", "nef7", "nefm", "negf"
 , "negm", "negt", "net1", "net2", "nfnp", "nfrm", "nfrt", "nft1", "nft2", "nfv0", "nfv1", "nfv2"
 , "nfv3", "nfv4", "ngob", "nhcn", "nheb", "nico", "nitb", "nmgv", "nnad", "nnfm", "nnsa", "nnsg"
 , "nntg", "nntt", "npgf", "npgr", "nshr", "ntt1", "ntx2", "nvr0", "nvr1", "nvr2", "nwc1", "nwc2"
 , "nwc3", "nwc4", "nzin", "ocbw", "zcso", "zhyd", "zjug", "zmar", "zshv", "zsmc", "zzrg", "Nmsr"
 , "Nswt", "ntn3", "nggm", "nggg", "nggd", "ngow", "nwzw", "ngos", "ngog", "nwar", "nccd", "ncco"
 , "nccu", "nccr", "Hjnd", "nmg2", "nhn2", "obai", "hrrh", "Haah", "Hssa", "Hddt", "owad"
     }
     if this.IncludeDefaultUnits then
       for _, k in ipairs(data) do
          TasButtonListAddData(this.UnitList, k)
       end
    end
 
    -- load in the custom Units
    if this.IncludeCustomUnits then
       for i, v in ipairs(this.CustomUnitCodes) do
          this.AddIds(v[1], v[2],this.UnitList)
       end
    end
 
     --force an update to the TasButtonList after removing/adding this should be done
     BlzFrameSetValue(this.UnitList.Slider, 999999)
 
          
     this.ItemListFrame = BlzCreateFrameByType("FRAME", "", this.ParentPage[4], "",0)
     BlzFrameSetSize(this.ItemListFrame, 0.23, 0.001)
     BlzFrameSetScale(this.ItemListFrame, 1)
     --BlzFrameSetAbsPoint(frameA, FRAMEPOINT_TOPRIGHT, 0.78, 0.54)
     BlzFrameSetAbsPoint(this.ItemListFrame, this.ListPos, this.ListX, this.ListY)
 
     this.ItemList = CreateTasButtonListEx("TasButtonGrid", this.ListCols, this.LisRows, this.ItemListFrame, function(data, buttonListObject, dataIndex)
        this.CurrentItemCode = data
        BlzSetSpecialEffectScale(this.PreviewItem, 1)
          BlzSetSpecialEffectScale(this.PreviewUnit, 0.0001)
          print "Left Click -> create\nother mouse clicks end it"
     end)
     local data = {"ckng","modt","tkno","ratf","ofro","desc","fgdg","infs","shar","sand"
     ,"wild","srrc","odef","rde4","pmna","rhth","ssil","spsh","sres","pdiv","pres","totw"
     ,"fgfh","fgrd","fgrg","hcun","hval","mcou","ajen","clfm","ratc","war2","kpin","lgdh"
     ,"ankh","whwd","fgsk","wcyc","hlst","mnst","belv","bgst","ciri","lhst","afac","sbch"
     ,"brac","rwiz","pghe","pgma","pnvu","sror","woms","crys","evtl","penr","prvt","rat9"
     ,"rde3","rlif","bspd","rej3","will","wlsd","wswd","cnob","gcel","rat6","rde2","tdx2"
     ,"tin2","tpow","tst2","pnvl","clsd","rag1","rin1","rst1","manh","tdex","tint","tstr"
     ,"pomn","wshs","rej6","rej5","rej4","ram4","dsum","ofir","ocor","oli2","oven","ram3"
     ,"tret","tgrh","rej2","gemt","ram2","stel","stwp","wneg","sneg","wneu","shea","sman"
     ,"rej1","pspd","dust","ram1","pinv","phea","pman","spro","hslv","moon","shas","skul"
     ,"mcri","rnec","ritd","tsct","azhr","bzbe","bzbf","ches","cnhn","glsk","gopr","k3m1"
     ,"k3m2","k3m3","ktrm","kybl","kygh","kymn","kysn","ledg","phlt","sehr","engs","sorf"
     ,"gmfr","jpnt","shwd","skrt","thle","sclp","wtlg","wolg","mgtk","mort","dphe","dkfw"
     ,"dthb","fgun","lure","olig","amrc","ccmd","flag","gobm","gsou","nflg","nspi","oflg"
     ,"pams","pgin","rat3","rde0","rde1","rnsp","soul","tels","tgxp","uflg","anfg","brag"
     ,"drph","iwbr","jdrn","lnrn","mlst","oslo","sbok","sksh","sprn","tmmt","vddl","spre"
     ,"sfog","sor1","sor2","sor3","sor4","sor5","sor6","sor7","sor8","sor9","sora","fwss"
     ,"shtm","esaz","btst","tbsm","tfar","tlum","tbar","tbak","gldo","stre","horl","hbth"
     ,"blba","rugt","frhg","gvsm","crdt","arsc","scul","tmsc","dtsb","grsl","arsh","shdt"
     ,"shhn","shen","thdm","stpg","shrs","bfhr","cosl","shcw","srbd","frgd","envl","rump"
     ,"srtl","stwa","klmm","rots","axas","mnsf","schl","asbl","kgal","ward","gold","lmbr"
     ,"gfor","guvi","rspl","rre1","rre2","gomn","rsps","rspd","rman","rma2","rres","rreb"
     ,"rhe1","rhe2","rhe3","rdis","texp","rwat","pclr","plcl","silk","vamp","sreg","ssan","tcas","ofr2"
    }
    if this.IncludeDefaultItems then
       for _, k in ipairs(data) do
          TasButtonListAddData(this.ItemList, k)
        end
    end
    
        for int = 1, this.ListCols*this.LisRows do
          BlzFrameSetVisible(this.ItemList.Frames[int].TextLumber, false)
          BlzFrameSetVisible(this.ItemList.Frames[int].TextGold, false)
          BlzFrameSetVisible(this.ItemList.Frames[int].IconGold, false)
          BlzFrameSetVisible(this.ItemList.Frames[int].IconLumber, false)
          BlzFrameSetSize(this.ItemList.Frames[int].Button, 0.03, 0.0265)
          BlzFrameSetScale(this.ItemList.Frames[int].Button, 1.5)
          BlzFrameSetScale(this.ItemList.Frames[int].ToolTipFrame, 1.0)
      end
      BlzFrameSetPoint(this.ItemList.Frames[1].Button, FRAMEPOINT_TOPRIGHT, this.ItemList.InputFrame, FRAMEPOINT_BOTTOMRIGHT, -BlzFrameGetWidth(this.ItemList.Frames[1].Button)*(5-1)*0.5, 0)
 
      if this.IncludeCustomItems then
       this.AddIds(FourCC'I000', this.CustomItemEnd,this.ItemList)
      end
 
      BlzFrameSetValue(this.ItemList.Slider, 999999)  
 
     local trig = CreateTrigger()
       TriggerAddAction(trig, function()
          if BlzGetTriggerPlayerMouseButton() == MOUSE_BUTTON_TYPE_LEFT then
             if this.CurrentUnitCode then
                CreateUnit(Player(this.CurrentUnitOwner), this.CurrentUnitCode, BlzGetTriggerPlayerMouseX(), BlzGetTriggerPlayerMouseY(), 270)
             elseif this.CurrentItemCode then
                CreateItem(this.CurrentItemCode, BlzGetTriggerPlayerMouseX(), BlzGetTriggerPlayerMouseY())
             end
          else
             BlzSetSpecialEffectScale(this.PreviewItem, 0.0001)
             BlzSetSpecialEffectScale(this.PreviewUnit, 0.0001)
             this.CurrentUnitCode = nil
             this.CurrentItemCode = nil
          end
       end)
       TriggerRegisterPlayerEvent(trig, GetLocalPlayer(), EVENT_PLAYER_MOUSE_DOWN)
       
    else
       BlzFrameSetVisible(BlzGetFrameByName("CheatFramePageButton", 3), false)
       BlzFrameSetVisible(BlzGetFrameByName("CheatFramePageButton", 4), false)
 
       end
       
 
       this.ShowPage(1)
       BlzFrameSetVisible(this.Parent, false)
       print("init frames done")
    end
 
    this.Init = function()
       this.Group = CreateGroup()
       --local trig = CreateTrigger()
       --TriggerAddAction(trig, this.SelectAction)
       --TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_SELECTED)
 
       this.PreviewUnit = AddSpecialEffect("Objects\\InvalidObject\\InvalidObject.mdx", 0, 0)
       this.PreviewItem =  AddSpecialEffect("Objects\\InventoryItems\\TreasureChest\\treasurechest.mdx", 0, 0)
       BlzSetSpecialEffectScale(this.PreviewItem, 0.0001)
       BlzSetSpecialEffectScale(this.PreviewUnit, 0.0001)
 
       local loc = Location(0, 0)
       local trig = CreateTrigger()
       TriggerAddAction(trig, function()
          MoveLocation(loc, BlzGetTriggerPlayerMouseX(), BlzGetTriggerPlayerMouseY())
          if this.CurrentUnitCode then
             BlzSetSpecialEffectPosition(this.PreviewUnit, BlzGetTriggerPlayerMouseX(), BlzGetTriggerPlayerMouseY(), GetLocationZ(loc) + 56)
             --BlzSetSpecialEffectHeight(this.PreviewUnit, GetLocationZ(loc) + 56)
          elseif this.CurrentItemCode then
             BlzSetSpecialEffectPosition(this.PreviewItem, BlzGetTriggerPlayerMouseX(), BlzGetTriggerPlayerMouseY(), GetLocationZ(loc) + 65)
             --BlzSetSpecialEffectHeight(this.PreviewItem, GetLocationZ(loc) + 56)
          end 
       end)
       TriggerRegisterPlayerEvent(trig, GetLocalPlayer(), EVENT_PLAYER_MOUSE_MOVE)
 
       local trig = CreateTrigger()
       TriggerAddAction(trig, function()
          udg_Unit = GetTriggerUnit()
       end)
       TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_SELECTED)
       
 
       xpcall(function() this.InitFrames() end, print)
       if FrameLoaderAdd then FrameLoaderAdd(this.InitFrames) end
    end
 
 
    if this.AutoRun then
       if OnInit then -- Total Initialization v5.2.0.1 by Bribe
           OnInit.final(TasCheatBox.Init)
       else -- without
           local real = MarkGameStarted
           function MarkGameStarted()
               real()
               TasCheatBox.Init()
           end
       end
   end
 
 end
 
 --TasCheatBox.Init()