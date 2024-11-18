if Debug then Debug.beginFile("StringWidth") end
OnInit("StringWidth", function ()

    local width = __jarray(0)

    -- Returns the width of the string
    ---@param s string
    ---@return integer
    function string.getWidth(s)
        local w = 0
        for i = 1, s:len() do
            w = w + width[s:byte(i)]
        end
        return w
    end

    width[0] = 0
    width[1] = 0
    width[2] = 0
    width[3] = 0
    width[4] = 0
    width[5] = 0
    width[6] = 0
    width[7] = 0 --\a
    width[8] = 0 --\b
    width[9] = 0 --\t
    width[10] = 1000000000 --\n
    width[11] = 0 --\v
    width[12] = 0 --\f
    width[13] = 0 --\r
    width[14] = 0
    width[15] = 0
    width[16] = 0
    width[17] = 0
    width[18] = 0
    width[19] = 0
    width[20] = 0
    width[21] = 0
    width[22] = 0
    width[23] = 0
    width[24] = 0
    width[25] = 0
    width[26] = 0
    width[27] = 0 --\e
    width[28] = 0
    width[29] = 0
    width[30] = 0
    width[31] = 0
    width[string.byte(' ')] = 70
    width[string.byte('!')] = 60
    width[string.byte('"')] = 80
    width[string.byte('#')] = 180
    width[string.byte('$')] = 140
    width[string.byte('\x25')] = 199
    width[string.byte('&')] = 219
    width[string.byte("'")] = 40
    width[string.byte('(')] = 80
    width[string.byte(')')] = 80
    width[string.byte('*')] = 121
    width[string.byte('+')] = 140
    width[string.byte(',')] = 55
    width[string.byte('-')] = 104
    width[string.byte('.')] = 51
    width[string.byte('/')] = 121
    width[string.byte('0')] = 160
    width[string.byte('1')] = 60
    width[string.byte('2')] = 160
    width[string.byte('3')] = 160
    width[string.byte('4')] = 180
    width[string.byte('5')] = 160
    width[string.byte('6')] = 160
    width[string.byte('7')] = 140
    width[string.byte('8')] = 160
    width[string.byte('9')] = 160
    width[string.byte(':')] = 60
    width[string.byte(';')] = 60
    width[string.byte('<')] = 140
    width[string.byte('=')] = 140
    width[string.byte('>')] = 140
    width[string.byte('?')] = 140
    width[string.byte('@')] = 199
    width[string.byte('A')] = 206
    width[string.byte('B')] = 162
    width[string.byte('C')] = 183
    width[string.byte('D')] = 193
    width[string.byte('E')] = 153
    width[string.byte('F')] = 122
    width[string.byte('G')] = 204
    width[string.byte('H')] = 200
    width[string.byte('I')] = 77
    width[string.byte('J')] = 80
    width[string.byte('K')] = 183
    width[string.byte('L')] = 148
    width[string.byte('M')] = 264
    width[string.byte('N')] = 200
    width[string.byte('O')] = 225
    width[string.byte('P')] = 156
    width[string.byte('Q')] = 237
    width[string.byte('R')] = 179
    width[string.byte('S')] = 156
    width[string.byte('T')] = 151
    width[string.byte('U')] = 187
    width[string.byte('V')] = 183
    width[string.byte('W')] = 282
    width[string.byte('X')] = 204
    width[string.byte('Y')] = 179
    width[string.byte('Z')] = 179
    width[string.byte('[')]= 80
    width[string.byte('\\')] = 100
    width[string.byte(']')] = 80
    width[string.byte('^')] = 140
    width[string.byte('_')] = 140
    width[string.byte('`')] = 100
    width[string.byte('a')] = 151
    width[string.byte('b')] = 159
    width[string.byte('c')] = 147
    width[string.byte('d')] = 162
    width[string.byte('e')] = 159
    width[string.byte('f')] = 98
    width[string.byte('g')] = 176
    width[string.byte('h')] = 159
    width[string.byte('i')] = 65
    width[string.byte('j')] = 77
    width[string.byte('k')] = 147
    width[string.byte('l')] = 68
    width[string.byte('m')] = 227
    width[string.byte('n')] = 156
    width[string.byte('o')] = 166
    width[string.byte('p')] = 162
    width[string.byte('q')] = 162
    width[string.byte('r')] = 98
    width[string.byte('s')] = 126
    width[string.byte('t')] = 100
    width[string.byte('u')] = 159
    width[string.byte('v')] = 159
    width[string.byte('w')] = 229
    width[string.byte('x')] = 159
    width[string.byte('y')] = 159
    width[string.byte('z')] = 147
    width[string.byte('{')] = 80
    width[string.byte('|')] = 60
    width[string.byte('}')] = 80
    width[string.byte('~')] = 140
    width[127] = 0
end)
if Debug then Debug.endFile() end