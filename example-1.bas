#include once "inc/fb-colors.bi"

sub _
  drawGradientWindow( _
    byref color1 as Colors.float3, _
    byref color2 as Colors.float3, _
    byval windowWidth as integer, _
    byval windowHeight as integer )
  
  for _
    i as integer => 0 to windowHeight - 1
    
    var finalColor => _
      Colors.mix( _
        color1, color2, _
        i / windowHeight )
      
    line _
      ( 0, i ) - ( windowWidth - 1, i ), _
      finalColor
  next
end sub

/'
  Example 1: Mixing colors in several color models
'/
dim as integer _
  displayWidth => 800, _
  displayHeight => 600

screenRes( _
  displayWidth, displayHeight, 32 )

'' Colors in HCY model
dim as Colors.float _
  H => 0.7, _
  C => 1.0, _
  Y => 0.2
'' Colors in HSV model
dim as Colors.float _
  S => 0.4, _
  V => 0.8

dim as Colors.float3 _
  color1 => Colors.HCYColor( H, C, Y ), _
  color2 => Colors.HCYColor( H * 0.1, C, 0.5 )

WindowTitle( "HCY (Hue-Chroma-Luminance) model" )

drawGradientWindow( _
  Colors.HCYToRGB( color1 ), _
  Colors.HCYToRGB( color2 ), _
  displayWidth, _
  displayHeight ) 

sleep()

color1 => Colors.HSVColor( H, S, V )
color2 => Colors.HSVColor( H * 0.5, S * 1.25, V * 0.9 )

WindowTitle( "HSV (Hue-Saturation-Value) model" )

drawGradientWindow( _
  Colors.HSVToRGB( color1 ), _
  Colors.HSVToRGB( color2 ), _
  displayWidth, _
  displayHeight ) 

sleep()

dim as Colors.float _
  L => 0.5

color1 => Colors.HSVColor( H, S, L )
color2 => Colors.HSVColor( _
  Colors.wrap( H - 0.5, 0.0, 1.0 ), 1.0, L * 1.5 )

WindowTitle( "HSL (Hue-Saturation-Lightness) model" )

drawGradientWindow( _
  Colors.HSLToRGB( color1 ), _
  Colors.HSLToRGB( color2 ), _
  displayWidth, _
  displayHeight ) 

sleep()
