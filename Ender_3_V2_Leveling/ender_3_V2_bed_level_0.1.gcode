; *** This version is for 32 Bit Ender 3 using M25 Pause  **** 

G90 ; Use Absolute Positioning
G28 ; Home all axes

G1 Z5 ; Lift Z axis
G1 X32 Y36 F3000; Move to Position 1
G1 Z0.1 ; Lower Z axis
M25 ; Pause print
G1 Z10 ; Lift Z axis
G1 X32 Y206 F3000; Move to Position 2
G1 Z0.1 ; Lower Z axis
M25 ; Pause printx
G1 Z5 ; Lift Z axis
G1 X202 Y206 F3000; Move to Position 3
G1 Z0.1 ; Lower Z axis
M25 ; Pause print
G1 Z5 ; Lift Z axis
G1 X202 Y36 F3000; Move to Position 4
G1 Z0.1 ; Lower Z axis
M25 ; Pause print
G1 Z5 ; Lift Z axis
G1 X117 Y121 F3000; Move to Position 5
G1 Z0.1 ; Lower Z axis
M25 ; Pause print
G1 Z5 ; Lift Z axis
G1 X32 Y206 F3000; Move to Position 2
G1 Z0.1 ; Lower Z axis
M25 ; Pause print
G1 Z5 ; Lift Z axis
G1 X202 Y206 F3000; Move to Position 3
G1 Z0.1 ; Lower Z axis
M25 ; Pause print
G1 Z5 ; Lift Z axis
G1 X32 Y36 F3000; Move to Position 1
G1 Z0.1 ; Lower Z axis
M25 ; Pause print
G1 Z5 ; Lift Z axis
G1 X202 Y36 F3000; Move to Position 4
G1 Z0.1 ; Lower Z axis
M25 ; Pause print
G1 Z5 ; Lift Z axis
G1 X117 Y121 F3000; Move to Position 5
G1 Z0.1 ; Lower Z axis
M25 ; Pause print
G1 Z10 ; Lift Z axis
G1 X32 Y206 F3000; Move to Position 2
G1 Z0.1 ; Lower Z axis
M25 ; Pause print
G1 Z5 ; Lift Z axis
G1 X202 Y206 F3000; Move to Position 3
G1 Z0.1 ; Lower Z axis
M25 ; Pause print
G1 Z5 ; Lift Z axis
G1 X202 Y36 F3000; Move to Position 4
G1 Z0.1 ; Lower Z axis
M25 ; Pause print
G1 Z5 ; Lift Z axis
G1 X32 Y36 F3000; Move to Position 1
G1 Z0.1 ; Lower Z axis
M25 ; Pause print

G28 ; Home all axis
M84 ; Disable all motors



