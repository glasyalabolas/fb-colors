#include once "fbgfx.bi"
#include once "inc/fb-colors.bi"

sub _
  drawColorModel( _
    byval x as integer, _
    byval y as integer, _
    byref title as const string, _
    byval conversionFunc as function( _
      byval as Colors.float3 ) _
  as Colors.float3 )
  
  draw string _
    ( x, y ), _
    title, rgb( 0, 0, 0 )
  
  y +=> 20
  
  /'
    Shows the Hue component in the X-axis, and the Saturation (HSV/HSL)
    or Chroma (HCY) in the Y axis, at half the Value/Luminosity/Luminance.
  '/
  for _
    yy as integer => 0 to 255
    
    for _
      xx as integer => 0 to 255
      
      pset _
        ( x + xx, y + yy ), _
        conversionFunc( _
          Colors.float3( _
            xx / 255, yy / 255, 0.5 ) )
    next
  next
  
  y +=> 270
  
  /'
    Shows the Hue component in the X-axis, and the Value/Luminosity (HSV/HSL)
    Luminance (HCY) in the Y-axis, at full Saturation/Chroma.
  '/
  for _
    yy as integer => 0 to 255
    
    for _
      xx as integer => 0 to 255
      
      pset _
        ( x + xx, y + yy ), _
        conversionFunc( _
          Colors.float3( _
            xx / 255, 1.0, yy / 255 ) )
    next
  next
  
  y +=> 270
  
  /'
    Shows the Hue spectrum at full Saturation/Chroma, at half
    the Value/Luminosity/Luminance. Here, the difference between
    HCY and the other two color models is most evident.
  '/
  for _
    yy as integer => 0 to 255
    
    for _
      xx as integer => 0 to 255
      
      line _
        ( x + xx, y ) - _
        ( x + xx, y + 25 ), _
        conversionFunc( _
          Colors.float3( _
            xx / 255, 1.0, 0.5 ) )
    next
  next
end sub

/'
  Example 1: Shows the three color models.
  
  This example shows the three color models so you can see how they
  compare. Note that colors in the HCY model are more intuitively
  arranged by __perceived__ luminance.
'/
dim as integer _
  displayWidth => 1200, _
  displayHeight => 600

screenRes( _
  displayWidth, displayHeight, _
  32 )
color( _
  rgb( 0, 0, 0 ), _
  rgb( 255, 255, 255 ) )
width _
  displayWidth \ 8, _
  displayHeight \ 16

screenLock()
  cls()
  
  drawColorModel( _
    0, 0, "HSV", @Colors.HSVToRGB )
  
  drawColorModel( _
    400, 0, "HSL", @Colors.HSLToRGB )
  
  drawColorModel( _
    800, 0, "HCY", @Colors.HCYToRGB )
screenUnlock()

sleep()
