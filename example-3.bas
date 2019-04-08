#include once "fbgfx.bi"
#include once "inc/fb-colors.bi"
#include once "inc/fb-color-theme.bi"

/'
  This class defines a Color Theme in terms of a base color. The
  entire theme depends only on a single color, which is modified
  in several ways to adapt it for each UI element. Feel free to
  change the definition of each color to achieve different results!
'/
type ColorTheme extends ColorThemeBase
  public:
    declare constructor()
    declare destructor() override
  
    declare property _
      BaseColor() as Colors.HCYColor override
    declare property _
      BaseColorLight() as Colors.HCYColor override
    declare property _
      NavBarColor() as Colors.HCYColor override
    declare property _
      NavBarColorLight() as Colors.HCYColor override
    declare property _
      NavBarColorDark() as Colors.HCYColor override
    declare property _
      ToolBarColor() as Colors.HCYColor override
    declare property _
      ButtonColor() as Colors.HCYColor override
    declare property _
      ButtonColorDark() as Colors.HCYColor override
    declare property _
      ListHeaderColor() as Colors.HCYColor override
    declare property _
      ListItemColor1() as Colors.HCYColor override
    declare property _
      ListItemColor2() as Colors.HCYColor override
    declare property _
      WindowColor() as Colors.HCYColor override
    declare property _
      TextColor() as Colors.HCYColor override
    
    declare function _
      withBaseColor( _
        byref as Colors.HCYColor ) _
      as ColorTheme ptr
    
  private:
    as Colors.HCYColor _
      m_baseColor
end type

constructor _
  ColorTheme()
end constructor

destructor _
  ColorTheme()
end destructor

property _
  ColorTheme.BaseColor() _
  as Colors.HCYColor
  
  return( m_baseColor )
end property

property _
  ColorTheme.BaseColorLight() _
  as Colors.HCYColor
  
  return( Colors.HCYColor( _
    Colors.wrap( m_baseColor.x - 0.5, 0.0, 1.0 ), _
    Colors.clamp( m_baseColor.y * 1.9, 0.0, 1.0 ), _
    Colors.clamp( m_baseColor.z * 1.5, 0.0, 1.0 ) ) )
end property

property _
  ColorTheme.NavBarColor() _
  as Colors.HCYColor
  
  return( Colors.HCYColor( _
    m_baseColor.x, _
    m_baseColor.y, _
    m_baseColor.z * 0.5 ) )
end property

property _
  ColorTheme.NavBarColorLight() _
  as Colors.HCYColor
  
  return( Colors.HCYColor( _
    NavBarColor.x, _
    NavBarColor.y, _
    Colors.clamp( _
      NavBarColor.z * 1.44, 0.0, 1.0 ) ) )
end property

property _
  ColorTheme.NavBarColorDark() _
  as Colors.HCYColor
  
  return( Colors.HCYColor( _
    NavBarColor.x, _
    NavBarColor.y, _
    NavBarColor.z * 0.68 ) )
end property

property _
  ColorTheme.ToolBarColor() _
  as Colors.HCYColor
  
  return( Colors.HCYColor( _
    m_baseColor.x, _
    m_baseColor.y * 0.45, _
    Colors.clamp( _
      m_baseColor.z * 1.21, 0.0, 1.0 ) ) )
end property

property _
  ColorTheme.ButtonColor() _
  as Colors.HCYColor
  
  return( Colors.HCYColor( _
    m_baseColor.x, _
    m_baseColor.y * 0.26, _
    Colors.clamp( _
      m_baseColor.z * 1.10, 0.0, 1.0 ) ) )
end property

property _
  ColorTheme.ButtonColorDark() _
  as Colors.HCYColor
  
  return( Colors.HCYColor( _
    ButtonColor.x, _
    ButtonColor.y, _
    ButtonColor.z * 0.81 ) )
end property

property _
  ColorTheme.ListHeaderColor() _
  as Colors.HCYColor
  
  return( Colors.HCYColor( _
    m_baseColor.x, _
    m_baseColor.y * 0.45, _
    Colors.clamp( _
      m_baseColor.z * 0.50, 0.0, 1.0 ) ) )
end property

property _
  ColorTheme.ListItemColor1() _
  as Colors.HCYColor
  
  return( Colors.HCYColor( _
    ListHeaderColor.x, _
    ListHeaderColor.y * 0.9, _
    Colors.clamp( _
      m_baseColor.z * 1.10, 0.0, 1.0 ) ) )
end property

property _
  ColorTheme.ListItemColor2() _
  as Colors.HCYColor
  
  return( Colors.HCYColor( _
    ListHeaderColor.x, _
    ListHeaderColor.y * 0.9, _
    Colors.clamp( _
      m_baseColor.z * 1.05, 0.0, 1.0 ) ) )
end property

property _
  ColorTheme.WindowColor() _
  as Colors.HCYColor
  
  return( Colors.HCYColor( _
    m_baseColor.x, _
    0.2, _
    Colors.clamp( _
      m_baseColor.z * 1.9, 0.0, 1.0 ) ) )
end property

property _
  ColorTheme.TextColor() _
  as Colors.HCYColor
  
  return( Colors.HCYColor( _
    m_baseColor.x, _
    m_baseColor.y * 0.50, _
    m_baseColor.z ) )
end property

function _
  ColorTheme.withBaseColor( _
    byref aColor as Colors.HCYColor ) _
  as ColorTheme ptr
  
  m_baseColor => aColor
  return( @this )
end function

sub _
  drawRect( _
    byval x as integer, _
    byval y as integer, _
    byval w as integer, _
    byval h as integer, _
    byref backColor as Colors.HCYColor, _
    byref foreColor as Colors.HCYColor, _
    byref text as const string )
  
  line _
    ( x, y ) - _
    ( x + w - 1, y + h - 1 ), _
    Colors.HCYToRGB( backColor ), bf
  
  draw string _
    ( x + ( w - len( text ) * 8 ) / 2.0, y + ( h - 16 ) / 2.0 ), _
    text, _
    Colors.HCYToRGB( Colors.HCYColor( _
      foreColor.x, _
      foreColor.y, _
      iif( backColor.z > 0.5, _
        0.2, _
        0.8 ) ) )
        
end sub

sub _
  drawUI( _
    byval UIWidth as integer, _
    byval UIHeight as integer, _
    byval aColorTheme as ColorTheme ptr )
  
  '' Window
  drawRect( _
    140, 120, _
    UIWidth - 140 - 1, UIHeight - 120 - 1, _
    aColorTheme->WindowColor, _
    aColorTheme->TextColor, _
    "Window" )
  
  '' Nav bar
  drawRect( _
    0, 0, _
    UIWidth - 1, 80, _
    aColorTheme->NavBarColor, _
    aColorTheme->TextColor, _
    "NavBar" )
  '' Nav bar item
  drawRect( _
    150, 0, _
    130, 80, _
    aColorTheme->NavBarColorLight, _
    aColorTheme->TextColor, _
    "NavBarItem" )
  '' Nav bar button
  drawRect( _
    650, 25, _
    130, 30, _
    aColorTheme->NavBarColorDark, _
    aColorTheme->TextColor, _
    "NavBarButton" )
  
  '' Side menu
  drawRect( _
    0, 80, _
    140, UIHeight - 80 - 1, _
    aColorTheme->BaseColor, _
    aColorTheme->TextColor, _
    "SideBar" )
  '' Side menu item
  drawRect( _
    0, 150, _
    140, 30, _
    aColorTheme->BaseColorLight, _
    aColorTheme->TextColor, _
    "SideMenuItem" )
  
  '' Toolbar
  drawRect( _
    140, 80, _
    UIWidth - 140 - 1, 40, _
    aColorTheme->ToolBarColor, _
    aColorTheme->TextColor, _
    "Toolbar" )
  
  '' Button
  drawRect( _
    540, 170, _
    90, 30, _
    aColorTheme->ButtonColor, _
    aColorTheme->TextColor, _
    "Button" )
  '' Dark Button
  drawRect( _
    640, 170, _
    90, 30, _
    aColorTheme->ButtonColorDark, _
    aColorTheme->TextColor, _
    "DarkButton" )
  
  '' List header
  drawRect( _
    150, 210, _
    UIWidth - 140 - 20, 30, _
    aColorTheme->ListHeaderColor, _
    aColorTheme->TextColor, _
    "List header" )
  '' List item 1
  drawRect( _
    150, 240, _
    UIWidth - 140 - 20, 30, _
    aColorTheme->ListItemColor1, _
    aColorTheme->TextColor, _
    "List item 1" )
  '' List item 2
  drawRect( _
    150, 270, _
    UIWidth - 140 - 20, 30, _
    aColorTheme->ListItemColor2, _
    aColorTheme->TextColor, _
    "List item 2" )
end sub

/'
  Example 3: Generating a color theme for an UI using a single
  hue, the complimentary of that hue, and varying luminance and
  saturations for each UI element.
'/
dim as integer _
  displayWidth => 800, _
  displayHeight => 600

screenRes( _
  displayWidth, displayHeight, _
  32 )
width _
  displayWidth \ 8, _
  displayHeight \ 16
cls()

var aColorTheme => _
  new ColorTheme() _
    ->withBaseColor( _
      Colors.HCYColor( 0.57, 0.5, 0.7 ) )

windowTitle( "Example 3: UI color theme generator - <SPACE> to generate a new theme" )

drawUI( _
  displayWidth, _
  displayHeight, _
  aColorTheme )

randomize()

dim as string _
  keyPress

do
  keyPress = inkey()
  
  if( keyPress = chr( 32 ) ) then 
    aColorTheme _
      ->withBaseColor( _
        Colors.HCYColor( rnd(), 0.5, rnd() ) )
      
    cls()
    
    drawUI( _
      displayWidth, _
      displayHeight, _
      aColorTheme )
  end if
  
  sleep( 1, 1 )
loop _
  until( keyPress = chr( 255 ) + "k" )

delete( aColorTheme )