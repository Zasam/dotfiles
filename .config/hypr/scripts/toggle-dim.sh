#!/bin/bash
# Toggle the global Hyprland setting decoration:dim_inactive.
# Theme-independent copy of the aetheria theme's dimming.sh, wired into
# ~/.config/hypr/bindings.conf so it survives switching to any other theme.

if command -v jq &> /dev/null; then
    CURRENT_STATE=$(hyprctl getoption decoration:dim_inactive -j | jq '.int')
else
    CURRENT_STATE=$(hyprctl getoption decoration:dim_inactive | grep 'int:' | awk '{print $2}')
fi

if [ "$CURRENT_STATE" = "1" ]; then
    NEW_STATE="false"
else
    NEW_STATE="true"
fi

hyprctl keyword decoration:dim_inactive "$NEW_STATE"
