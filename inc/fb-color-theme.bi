'' Base class for a color theme
type ColorThemeBase extends Object
  declare virtual destructor()
  
  declare abstract property BaseColor() as Colors.HCYColor
  declare abstract property BaseColorLight() as Colors.HCYColor
  declare abstract property NavBarColor() as Colors.HCYColor
  declare abstract property NavBarColorLight() as Colors.HCYColor
  declare abstract property NavBarColorDark() as Colors.HCYColor
  declare abstract property ToolBarColor() as Colors.HCYColor
  declare abstract property ButtonColor() as Colors.HCYColor
  declare abstract property ButtonColorDark() as Colors.HCYColor
  declare abstract property ListHeaderColor() as Colors.HCYColor
  declare abstract property ListItemColor1() as Colors.HCYColor
  declare abstract property ListItemColor2() as Colors.HCYColor
  declare abstract property WindowColor() as Colors.HCYColor
  declare abstract property TextColor() as Colors.HCYColor
end type

destructor ColorThemeBase() : end destructor
