; object.inc
Object STRUC
    x           DW ?
    y           DW ?
    sprite      DW ?
    radius      DW ?
    tick_walk   DB ?
    direction   DB ?
    dead        DB ?
    hit         DB ?
Object ENDS

objectsize      equ     12
max_enemies     equ     4
