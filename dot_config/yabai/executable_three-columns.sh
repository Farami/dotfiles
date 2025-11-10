# ~/.config/yabai/three-columns.sh  (Remember to chmod +x the file)

windows=$(yabai -m query --windows --display 1 | jq '[.[] | select(."is-visible"==true and ."is-floating"==false)] | length')

if [[ $windows == 1 ]]; then
  yabai -m config left_padding 1713
  yabai -m config right_padding 1713
  yabai -m space --balance
elif [[ $windows == 2 ]]; then
  yabai -m config left_padding 849
  yabai -m config right_padding 849
  yabai -m space --balance
elif [[ $windows == 3 ]]; then
  yabai -m config left_padding 15
  yabai -m config right_padding 15
  yabai -m space --balance
fi
