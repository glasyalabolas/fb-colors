/'
  Base class for a color theme
'/
type ColorThemeBase extends Object
  public:
    declare virtual destructor()
    
    declare abstract property _
      BaseColor() as Colors.HCYColor
    declare abstract property _
      BaseColorLight() as Colors.HCYColor
    declare abstract property _
      NavBarColor() as Colors.HCYColor
    declare abstract property _
      NavBarColorLight() as Colors.HCYColor
    declare abstract property _
      NavBarColorDark() as Colors.HCYColor
    declare abstract property _
      ToolBarColor() as Colors.HCYColor
    declare abstract property _
      ButtonColor() as Colors.HCYColor
    declare abstract property _
      ButtonColorDark() as Colors.HCYColor
    declare abstract property _
      ListHeaderColor() as Colors.HCYColor
    declare abstract property _
      ListItemColor1() as Colors.HCYColor
    declare abstract property _
      ListItemColor2() as Colors.HCYColor
    declare abstract property _
      WindowColor() as Colors.HCYColor
    declare abstract property _
      TextColor() as Colors.HCYColor
end type

destructor _
  ColorThemeBase()
end destructor
