/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  event.ch
  Teo. Mexico 2006
*/

#define wxEVT_COMMAND_BUTTON_CLICKED            10082
#define wxEVT_COMMAND_CHECKBOX_CLICKED          10083
#define wxEVT_COMMAND_CHOICE_SELECTED           10084
#define wxEVT_COMMAND_LISTBOX_SELECTED          10085
#define wxEVT_COMMAND_LISTBOX_DOUBLECLICKED     10086
#define wxEVT_COMMAND_CHECKLISTBOX_TOGGLED      10087
#define wxEVT_COMMAND_TEXT_UPDATED              10040
#define wxEVT_COMMAND_TEXT_ENTER                10041
#define wxEVT_COMMAND_TEXT_URL                  10042
#define wxEVT_COMMAND_TEXT_MAXLEN               10043
#define wxEVT_COMMAND_MENU_SELECTED             10088
#define wxEVT_COMMAND_SLIDER_UPDATED            10089
#define wxEVT_COMMAND_RADIOBOX_SELECTED         10090
#define wxEVT_COMMAND_RADIOBUTTON_SELECTED      10091
#define wxEVT_COMMAND_SCROLLBAR_UPDATED         10092
#define wxEVT_COMMAND_VLBOX_SELECTED            10093
#define wxEVT_COMMAND_COMBOBOX_SELECTED         10094
#define wxEVT_COMMAND_TOOL_RCLICKED             10095
#define wxEVT_COMMAND_TOOL_ENTER                10096
#define wxEVT_COMMAND_SPINCTRL_UPDATED          10097
#define wxEVT_TIMER                             10098
#define wxEVT_LEFT_DOWN                         10099
#define wxEVT_LEFT_UP                           10100
#define wxEVT_MIDDLE_DOWN                       10101
#define wxEVT_MIDDLE_UP                         10102
#define wxEVT_RIGHT_DOWN                        10103
#define wxEVT_RIGHT_UP                          10104
#define wxEVT_MOTION                            10105
#define wxEVT_ENTER_WINDOW                      10106
#define wxEVT_LEAVE_WINDOW                      10107
#define wxEVT_LEFT_DCLICK                       10108
#define wxEVT_MIDDLE_DCLICK                     10109
#define wxEVT_RIGHT_DCLICK                      10110
#define wxEVT_SET_FOCUS                         10111
#define wxEVT_KILL_FOCUS                        10112
#define wxEVT_CHILD_FOCUS                       10113
#define wxEVT_MOUSEWHEEL                        10114
#define wxEVT_NC_LEFT_DOWN                      10115
#define wxEVT_NC_LEFT_UP                        10116
#define wxEVT_NC_MIDDLE_DOWN                    10117
#define wxEVT_NC_MIDDLE_UP                      10118
#define wxEVT_NC_RIGHT_DOWN                     10119
#define wxEVT_NC_RIGHT_UP                       10120
#define wxEVT_NC_MOTION                         10121
#define wxEVT_NC_ENTER_WINDOW                   10122
#define wxEVT_NC_LEAVE_WINDOW                   10123
#define wxEVT_NC_LEFT_DCLICK                    10124
#define wxEVT_NC_MIDDLE_DCLICK                  10125
#define wxEVT_NC_RIGHT_DCLICK                   10126
#define wxEVT_CHAR                              10127
#define wxEVT_CHAR_HOOK                         10128
#define wxEVT_NAVIGATION_KEY                    10129
#define wxEVT_KEY_DOWN                          10130
#define wxEVT_KEY_UP                            10131
#define wxEVT_SET_CURSOR                        10132
#define wxEVT_SCROLL_TOP                        10133
#define wxEVT_SCROLL_BOTTOM                     10134
#define wxEVT_SCROLL_LINEUP                     10135
#define wxEVT_SCROLL_LINEDOWN                   10136
#define wxEVT_SCROLL_PAGEUP                     10137
#define wxEVT_SCROLL_PAGEDOWN                   10138
#define wxEVT_SCROLL_THUMBTRACK                 10139
#define wxEVT_SCROLL_THUMBRELEASE               10140
#define wxEVT_SCROLL_CHANGED                    10141
#define wxEVT_SCROLLWIN_TOP                     10142
#define wxEVT_SCROLLWIN_BOTTOM                  10143
#define wxEVT_SCROLLWIN_LINEUP                  10144
#define wxEVT_SCROLLWIN_LINEDOWN                10145
#define wxEVT_SCROLLWIN_PAGEUP                  10146
#define wxEVT_SCROLLWIN_PAGEDOWN                10147
#define wxEVT_SCROLLWIN_THUMBTRACK              10148
#define wxEVT_SCROLLWIN_THUMBRELEASE            10149
#define wxEVT_SIZE                              10150
#define wxEVT_MOVE                              10152
#define wxEVT_CLOSE_WINDOW                      10154
#define wxEVT_END_SESSION                       10155
#define wxEVT_QUERY_END_SESSION                 10156
#define wxEVT_ACTIVATE_APP                      10158
#define wxEVT_ACTIVATE                          10160
#define wxEVT_CREATE                            10161
#define wxEVT_DESTROY                           10162
#define wxEVT_SHOW                              10163
#define wxEVT_ICONIZE                           10164
#define wxEVT_MAXIMIZE                          10165
#define wxEVT_MOUSE_CAPTURE_CHANGED             10166
#define wxEVT_MOUSE_CAPTURE_LOST                10167
#define wxEVT_PAINT                             10168
#define wxEVT_ERASE_BACKGROUND                  10169
#define wxEVT_NC_PAINT                          10170
#define wxEVT_PAINT_ICON                        10171
#define wxEVT_MENU_OPEN                         10172
#define wxEVT_MENU_CLOSE                        10173
#define wxEVT_MENU_HIGHLIGHT                    10174
#define wxEVT_CONTEXT_MENU                      10175
#define wxEVT_SYS_COLOUR_CHANGED                10176
#define wxEVT_DISPLAY_CHANGED                   10177
#define wxEVT_SETTING_CHANGED                   10178
#define wxEVT_QUERY_NEW_PALETTE                 10179
#define wxEVT_PALETTE_CHANGED                   10180
#define wxEVT_JOY_BUTTON_DOWN                   10181
#define wxEVT_JOY_BUTTON_UP                     10182
#define wxEVT_JOY_MOVE                          10183
#define wxEVT_JOY_ZMOVE                         10184
#define wxEVT_DROP_FILES                        10185
#define wxEVT_DRAW_ITEM                         10186
#define wxEVT_MEASURE_ITEM                      10187
#define wxEVT_COMPARE_ITEM                      10188
#define wxEVT_INIT_DIALOG                       10189
#define wxEVT_UPDATE_UI                         10190
#define wxEVT_SIZING                            10151
#define wxEVT_MOVING                            10153
#define wxEVT_HIBERNATE                         10157
#define wxEVT_COMMAND_TEXT_COPY                 10191
#define wxEVT_COMMAND_TEXT_CUT                  10192
#define wxEVT_COMMAND_TEXT_PASTE                10193
#define wxEVT_COMMAND_LEFT_CLICK                10194
#define wxEVT_COMMAND_LEFT_DCLICK               10195
#define wxEVT_COMMAND_RIGHT_CLICK               10196
#define wxEVT_COMMAND_RIGHT_DCLICK              10197
#define wxEVT_COMMAND_SET_FOCUS                 10198
#define wxEVT_COMMAND_KILL_FOCUS                10199
#define wxEVT_COMMAND_ENTER                     10200
#define wxEVT_HELP                              10201
#define wxEVT_DETAILED_HELP                     10202
