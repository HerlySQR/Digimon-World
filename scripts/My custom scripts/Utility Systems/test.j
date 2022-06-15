scope IntroBattle
  globals
    private constant real MIN_SCREEN_X = -0.135
    private constant real MAX_SCREEN_X = 0.935
    private constant real MIN_SCREEN_Y = 0
    private constant real MAX_SCREEN_Y = 0.6

    // INTRO DURATION
    private constant real MAX_DURATION = 2.7

    private constant string FRAME_TEXTURE = "UI\\Widgets\\EscMenu\\Human\\human-options-menu-background.blp"

    // THESES NAMES ARE GENERATED IN FDF file
    private constant string FRAME_NAME = "IntroBattleFh-"                     // IntroBattleFh-1  IntroBattleFh-2  IntroBattleFh-3 ....
    private constant string FRAME_TEXTURE_NAME = "IntroBattleFhTexture-"      // IntroBattleFhTexture-1  IntroBattleFhTexture-2 ...

    // USEFUL TO GENERATE FRAMES NAMES (nbr of frames names in the fdf file)
    // it loops in the code the generated name num is re-set to 1 when it goes over the limit
    private constant integer MAX_FRAME_NUM = 500

    // INTRO RANDOM (DAMIER SPAWN RANDOM)
    // private constant integer RANDOM_NBR_COLS = 4
    // private constant integer RANDOM_NBR_LINE = 3
    private constant integer RANDOM_NBR_COLS = 20
    private constant integer RANDOM_NBR_LINE = 12

    // VARIABLE USED TO SET THE ARRAY LENGTH
    private constant integer RANDOM_ARRAY_SIZE = 245

    // VARIABLES SET IN the "initIntrosBattle" function
    // INTERVAL BETWEEN EACH APPARITION
    private real RANDOM_INTERVAL

    // FRAMES DIMENTIONS
    private real RANDOM_FH_WIDTH
    private real RANDOM_FH_HEIGHT

    // END INTRO RANDOM

    private integer NBR_FRAMES
    private integer CURRENT_FRAME_NUM
    private real SCREEN_WIDTH
    private real SCREEN_HEIGHT

  endglobals

private function getFrameName takes nothing returns string
  return FRAME_NAME + I2S(CURRENT_FRAME_NUM)
endfunction

private function getFrameTextureName takes nothing returns string
  return FRAME_TEXTURE_NAME + I2S(CURRENT_FRAME_NUM)
endfunction

function showFrameForPlayers takes framehandle fh, player P, player P1 returns nothing
  call BlzFrameSetVisible(fh, (P == GetLocalPlayer() or P1 == GetLocalPlayer()))
endfunction

private struct Random
  static Random array R
  static integer RT = 0
  static timer T = null

  player P
  player P1
  real duration
  integer context
  // the array where the hidden remaining frames are stored
  framehandle array hiddenFh [RANDOM_ARRAY_SIZE]
  // the number of remaining hidden frames
  integer nbrFrames
  boolean done

  private method clearAllFrames takes nothing returns nothing
    local integer I = 0

    loop
      exitwhen I >= RANDOM_ARRAY_SIZE
      set hiddenFh[I] = null
      set I = I + 1
    endloop

  endmethod

  private method onDestroy takes nothing returns nothing
    call .clearAllFrames()

    // A Struct that list framehandles and player to destroye all of them
    call Frame.destroyForPlayer(.P)

    set .P = null
    set .P1 = null

  endmethod

  private method spawnFrameAtLoc takes framehandle parent, real xTopLeft, real yTopLeft returns nothing
    local framehandle fh = BlzCreateSimpleFrame(getFrameName(), parent, .context)
    local framehandle textureFrame = BlzGetFrameByName(getFrameTextureName(), .context)

    // function that calculates XMax, XMin, YMax, YMin of the frame
    // move it with top corner point
    // and resize the frame
    call setFramePos(fh, xTopLeft, yTopLeft, RANDOM_FH_WIDTH, RANDOM_FH_HEIGHT)

    call BlzFrameSetTexture(textureFrame, FRAME_TEXTURE, 0, true)

    // BY DEFAULT THEY ARE ALL HIDDEN
    call BlzFrameSetVisible(fh, false)

    set .nbrFrames = .nbrFrames + 1
    set .hiddenFh[.nbrFrames] = fh

    // when the frames are shown they are stored into a structure that will destroy them at the end of the intro
    call Frame.addFrame(.P, fh, xTopLeft, yTopLeft, true)

    set NBR_FRAMES = NBR_FRAMES + 1

    set fh = null
    set textureFrame = null

  endmethod

  // FRAMES ARE SUMMONED BY LINE
  private method spawnLine takes framehandle parent, integer lineNum returns nothing
    local real XTopLeft = MIN_SCREEN_X
    local real YTopLeft = MAX_SCREEN_Y - ((lineNum - 1) * RANDOM_FH_HEIGHT)
    local integer colNum = 0

    loop
      set colNum = colNum + 1
      set CURRENT_FRAME_NUM = CURRENT_FRAME_NUM + 1

      call .spawnFrameAtLoc(parent, XTopLeft, YTopLeft)

      set XTopLeft = XTopLeft + RANDOM_FH_WIDTH

      if CURRENT_FRAME_NUM >= MAX_FRAME_NUM then
        set CURRENT_FRAME_NUM = 0
      endif

      exitwhen colNum >= RANDOM_NBR_COLS
    endloop

  endmethod

  // USED TO COVER LE SCREEN BY HIDDEN FRAME TO INIT
  private method createFrames takes nothing returns nothing
    local framehandle parent = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
    local integer lineNum = 0

    loop
      set lineNum = lineNum + 1

      call .spawnLine(parent, lineNum)

      exitwhen lineNum >= RANDOM_NBR_LINE
    endloop

    set parent = null

  endmethod

  // SHOW A RANDOM FRAME
  private method showRandomFrame takes nothing returns nothing
    local integer num = GetRandomInt(1, .nbrFrames)
    local framehandle fh = .hiddenFh[num]

    call showFrameForPlayers(fh, .P, .P1)

    set .hiddenFh[num] = .hiddenFh[.nbrFrames]
    set .hiddenFh[.nbrFrames] = null
    set .nbrFrames = .nbrFrames - 1

    set fh = null

  endmethod

  // CHECK IF SOME FRAME ARE STILL HIDDEN
  private method manageShowFrame takes nothing returns nothing
    if .nbrFrames > 0 then
      call .showRandomFrame()
    else
      set .done = true
    endif

  endmethod

  private method initTable takes nothing returns nothing
    local integer I = 0

    loop
      exitwhen I >= RANDOM_ARRAY_SIZE
      set hiddenFh[I] = null
      set I = I + 1
    endloop

  endmethod

  static method update takes nothing returns nothing
    local Random r
    local integer I = 0

    loop
      set I = I + 1
      set r = .R[I]

      set r.duration = r.duration + RANDOM_INTERVAL

      call r.manageShowFrame()

      if r.done then
        call r.destroy()

        set .R[I] = .R[.RT]
        set .RT = .RT - 1
        set I = I - 1
      endif

      exitwhen I >= .RT
    endloop

    if .RT <= 0 then
      call PauseTimer(.T)
      set .RT = 0
    endif

  endmethod

  static method addRandom takes player P, player P1 returns nothing
    local Random r = Random.allocate()

    set r.P = P
    set r.P1 = P1
    set r.context = GetPlayerId(P) + 3
    set r.duration = 0
    set r.nbrFrames = 0
    set r.done = false

    // A method to be sure that the bug is not due to the array
    call r.initTable()

    // An init methos that creates all the frames hidden
    call r.createFrames()

    set .RT = .RT + 1
    set .R[.RT] = r

    if .RT == 1 then
      // The timer will show to the target players the given frames
      call TimerStart(.T, RANDOM_INTERVAL, true, function Random.update)
    endif

  endmethod
endstruct

function startIntroForPlayers takes player P, player P1 returns nothing
  call Random.addRandom(P, P1)
endfunction

// INITIALIZATION OF INTROS VARIABLES
function initIntrosBattle takes nothing returns nothing
  local integer nbrCells = 0

  set SCREEN_WIDTH = MAX_SCREEN_X - MIN_SCREEN_X
  set SCREEN_HEIGHT = MAX_SCREEN_Y - MIN_SCREEN_Y
  set NBR_FRAMES = 0

    // "RANDOM" called like that because the screen will be randomly covered by frames over the time
    set nbrCells = RANDOM_NBR_COLS * RANDOM_NBR_LINE
    set RANDOM_FH_WIDTH = SCREEN_WIDTH / RANDOM_NBR_COLS
    set RANDOM_FH_HEIGHT = SCREEN_HEIGHT / RANDOM_NBR_LINE
    set RANDOM_INTERVAL = MAX_DURATION / (nbrCells + 1)
    set Random.T = CreateTimer()

  set CURRENT_FRAME_NUM = 0

endfunction

endscope