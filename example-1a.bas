#include once "fbgfx.bi"
#include once "inc/fb-colors.bi"

sub drawColorModel( _
  x as integer, y as integer, title as const string, _
  conversionFunc as function( as Colors.float3 ) as Colors.float3 )
  
  draw string ( x, y ), title, rgb( 0, 0, 0 )
  
  y += 20
  
  /'
    Shows the Hue component in the X-axis, and the Saturation (HSV/HSL)
    or Chroma (HCY) in the Y axis, at half the Value/Luminosity/Luminance.
  '/
  for yy as integer = 0 to 255
    for xx as integer = 0 to 255
      pset ( x + xx, y + yy ), conversionFunc( _
        Colors.float3( xx / 255, yy / 255, 0.5 ) )
    next
  next
  
  y += 270
  
  /'
    Shows the Hue component in the X-axis, and the Value/Luminosity (HSV/HSL)
    Luminance (HCY) in the Y-axis, at full Saturation/Chroma.
  '/
  for yy as integer = 0 to 255
    for xx as integer = 0 to 255
      pset ( x + xx, y + yy ), conversionFunc( _
        Colors.float3( xx / 255, 1.0, yy / 255 ) )
    next
  next
  
  y += 270
  
  /'
    Shows the Hue spectrum at full Saturation/Chroma, at half
    the Value/Luminosity/Luminance. Here, the difference between
    HCY and the other two color models is most evident.
  '/
  for yy as integer = 0 to 255
    for xx as integer = 0 to 255
      line ( x + xx, y ) - ( x + xx, y + 25 ), conversionFunc( _
        Colors.float3( xx / 255, 1.0, 0.5 ) )
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
  displayWidth = 1200, _
  displayHeight = 600

screenRes( displayWidth, displayHeight, 32 )
color( rgb( 0, 0, 0 ), rgb( 255, 255, 255 ) )
width displayWidth \ 8, displayHeight \ 16

screenLock()
  cls()
  
  drawColorModel( 0, 0, "HSV", @Colors.HSVToRGB )
  drawColorModel( 400, 0, "HSL", @Colors.HSLToRGB )
  drawColorModel( 800, 0, "HCY", @Colors.HCYToRGB )
screenUnlock()

sleep()
