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
  
    declare property BaseColor() as Colors.HCYColor override
    declare property BaseColorLight() as Colors.HCYColor override
    declare property NavBarColor() as Colors.HCYColor override
    declare property NavBarColorLight() as Colors.HCYColor override
    declare property NavBarColorDark() as Colors.HCYColor override
    declare property ToolBarColor() as Colors.HCYColor override
    declare property ButtonColor() as Colors.HCYColor override
    declare property ButtonColorDark() as Colors.HCYColor override
    declare property ListHeaderColor() as Colors.HCYColor override
    declare property ListItemColor1() as Colors.HCYColor override
    declare property ListItemColor2() as Colors.HCYColor override
    declare property WindowColor() as Colors.HCYColor override
    declare property TextColor() as Colors.HCYColor override
    
    declare function withBaseColor( as Colors.HCYColor ) as ColorTheme ptr
    
  private:
    as Colors.HCYColor m_baseColor
end type

constructor ColorTheme() : end constructor

destructor ColorTheme() : end destructor

property ColorTheme.BaseColor() as Colors.HCYColor
  return( m_baseColor )
end property

property ColorTheme.BaseColorLight() as Colors.HCYColor
  return( Colors.HCYColor( _
    Colors.wrap( m_baseColor.x - 0.5, 0.0, 1.0 ), _
    Colors.clamp( m_baseColor.y * 1.9, 0.0, 1.0 ), _
    Colors.clamp( m_baseColor.z * 1.5, 0.0, 1.0 ) ) )
end property

property ColorTheme.NavBarColor() as Colors.HCYColor
  return( Colors.HCYColor( _
    m_baseColor.x, _
    m_baseColor.y, _
    m_baseColor.z * 0.5 ) )
end property

property ColorTheme.NavBarColorLight() as Colors.HCYColor
  return( Colors.HCYColor( _
    NavBarColor.x, _
    NavBarColor.y, _
    Colors.clamp( NavBarColor.z * 1.44, 0.0, 1.0 ) ) )
end property

property ColorTheme.NavBarColorDark() as Colors.HCYColor
  return( Colors.HCYColor( _
    NavBarColor.x, _
    NavBarColor.y, _
    NavBarColor.z * 0.68 ) )
end property

property ColorTheme.ToolBarColor() as Colors.HCYColor
  return( Colors.HCYColor( _
    m_baseColor.x, _
    m_baseColor.y * 0.45, _
    Colors.clamp( m_baseColor.z * 1.21, 0.0, 1.0 ) ) )
end property

property ColorTheme.ButtonColor() as Colors.HCYColor
  return( Colors.HCYColor( _
    m_baseColor.x, _
    m_baseColor.y * 0.26, _
    Colors.clamp( m_baseColor.z * 1.10, 0.0, 1.0 ) ) )
end property

property ColorTheme.ButtonColorDark() as Colors.HCYColor
  return( Colors.HCYColor( _
    ButtonColor.x, _
    ButtonColor.y, _
    ButtonColor.z * 0.81 ) )
end property

property ColorTheme.ListHeaderColor() as Colors.HCYColor
  return( Colors.HCYColor( _
    m_baseColor.x, _
    m_baseColor.y * 0.45, _
    Colors.clamp( m_baseColor.z * 0.50, 0.0, 1.0 ) ) )
end property

property ColorTheme.ListItemColor1() as Colors.HCYColor
  return( Colors.HCYColor( _
    ListHeaderColor.x, _
    ListHeaderColor.y * 0.9, _
    Colors.clamp( m_baseColor.z * 1.10, 0.0, 1.0 ) ) )
end property

property ColorTheme.ListItemColor2() as Colors.HCYColor
  return( Colors.HCYColor( _
    ListHeaderColor.x, _
    ListHeaderColor.y * 0.9, _
    Colors.clamp( m_baseColor.z * 1.05, 0.0, 1.0 ) ) )
end property

property ColorTheme.WindowColor() as Colors.HCYColor
  return( Colors.HCYColor( _
    m_baseColor.x, _
    0.2, _
    Colors.clamp( m_baseColor.z * 1.9, 0.0, 1.0 ) ) )
end property

property ColorTheme.TextColor() as Colors.HCYColor
  return( Colors.HCYColor( _
    m_baseColor.x, _
    m_baseColor.y * 0.50, _
    m_baseColor.z ) )
end property

function ColorTheme.withBaseColor( aColor as Colors.HCYColor ) as ColorTheme ptr
  m_baseColor = aColor
  return( @this )
end function

sub drawRect( _
  x as integer, y as integer, w as integer, h as integer, _
  backColor as Colors.HCYColor, foreColor as Colors.HCYColor, _
  text as const string )
  
  line ( x, y ) - ( x + w - 1, y + h - 1 ), Colors.HCYToRGB( backColor ), bf
  
  draw string( x + ( w - len( text ) * 8 ) / 2.0, y + ( h - 16 ) / 2.0 ), _
    text, Colors.HCYToRGB( Colors.HCYColor( _
      foreColor.x, _
      foreColor.y, _
      iif( backColor.z > 0.5, 0.2, 0.8 ) ) )
end sub

sub drawUI( UIWidth as integer, UIHeight as integer, aColorTheme as ColorTheme ptr )
  '' Window
  drawRect( 140, 120, UIWidth - 140 - 1, UIHeight - 120 - 1, _
    aColorTheme->WindowColor, aColorTheme->TextColor, _
    "Window" )
  
  '' Nav bar
  drawRect( 0, 0, UIWidth - 1, 80, _
    aColorTheme->NavBarColor, aColorTheme->TextColor, _
    "NavBar" )
  
  '' Nav bar item
  drawRect( 150, 0, 130, 80, _
    aColorTheme->NavBarColorLight, aColorTheme->TextColor, _
    "NavBarItem" )
  
  '' Nav bar button
  drawRect( 650, 25, 130, 30, _
    aColorTheme->NavBarColorDark, aColorTheme->TextColor, _
    "NavBarButton" )
  
  '' Side menu
  drawRect( 0, 80, 140, UIHeight - 80 - 1, _
    aColorTheme->BaseColor, aColorTheme->TextColor, _
    "SideBar" )
  
  '' Side menu item
  drawRect( 0, 150, 140, 30, _
    aColorTheme->BaseColorLight, aColorTheme->TextColor, _
    "SideMenuItem" )
  
  '' Toolbar
  drawRect( 140, 80, UIWidth - 140 - 1, 40, _
    aColorTheme->ToolBarColor, aColorTheme->TextColor, _
    "Toolbar" )
  
  '' Button
  drawRect( 540, 170, 90, 30, _
    aColorTheme->ButtonColor, aColorTheme->TextColor, _
    "Button" )
  
  '' Dark Button
  drawRect( 640, 170, 90, 30, _
    aColorTheme->ButtonColorDark, aColorTheme->TextColor, _
    "DarkButton" )
  
  '' List header
  drawRect( 150, 210, UIWidth - 140 - 20, 30, _
    aColorTheme->ListHeaderColor, aColorTheme->TextColor, _
    "List header" )
  
  '' List item 1
  drawRect( 150, 240, UIWidth - 140 - 20, 30, _
    aColorTheme->ListItemColor1, aColorTheme->TextColor, _
    "List item 1" )
  
  '' List item 2
  drawRect( 150, 270, UIWidth - 140 - 20, 30, _
    aColorTheme->ListItemColor2, aColorTheme->TextColor, _
    "List item 2" )
end sub

/'
  Example 3: Generating a color theme for an UI using a single
  hue, the complimentary of that hue, and varying luminance and
  saturations for each UI element.
'/
dim as integer _
  displayWidth = 800, _
  displayHeight = 600

screenRes( displayWidth, displayHeight, 32 )
width displayWidth \ 8, displayHeight \ 16
cls()

var aColorTheme = new ColorTheme() _
  ->withBaseColor( Colors.HCYColor( 0.57, 0.5, 0.7 ) )

windowTitle( "Example 3: UI color theme generator - <SPACE> to generate a new theme" )

drawUI( displayWidth, displayHeight, aColorTheme )

randomize()

dim as string keyPress

do
  keyPress = inkey()
  
  if( keyPress = chr( 32 ) ) then 
    aColorTheme->withBaseColor( Colors.HCYColor( rnd(), 0.5, rnd() ) )
    
    cls()
    
    drawUI( displayWidth, displayHeight, aColorTheme )
  end if
  
  sleep( 1, 1 )
loop until( keyPress = chr( 255 ) + "k" )

delete( aColorTheme )
