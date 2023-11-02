scope Test initializer Init

    native GetUnitGoldCost takes integer unitid returns integer

    private function Init takes nothing returns nothing
        call BJDebugMsg(I2S(GetUnitGoldCost('rwiz')))
    endfunction
endscope