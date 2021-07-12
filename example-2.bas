#include once "fbgfx.bi"
#include once "inc/fb-colors.bi"

'' Base class for a color theme
type ColorThemeBase extends Object
  public:
    declare virtual destructor()
    
    declare property swatches() as integer
    declare property swatch( as integer ) as Colors.float3
    
    declare abstract function generate( as integer ) as ColorThemeBase ptr
    
  protected:
    declare constructor()
    
    as integer m_swatchCount
    as Colors.HCYColor m_swatches( any )
end type

constructor ColorThemeBase() : end constructor

destructor ColorThemeBase() : end destructor

property ColorThemeBase.swatches() as integer
  return( m_swatchCount )
end property

property ColorThemeBase.swatch( index as integer ) as Colors.float3
  return( m_swatches( index ) )
end property

/'
  This theme is just a random theme. It generates a series of
  random colors using the Golden Ratio.
'/
type RandomTheme extends ColorThemeBase
  public:
    declare constructor()
    declare destructor() override
    
    declare property baseColor() as Colors.float3
    
    declare function withBaseColor( as Colors.HCYColor ) as RandomTheme ptr
    declare function generate( as integer ) as RandomTheme ptr override
    
  private:
    as Colors.float3 m_baseColor
end type

constructor RandomTheme() : end constructor

destructor RandomTheme() : end destructor

property RandomTheme.baseColor() as Colors.float3
  return( m_baseColor )
end property

function RandomTheme.withBaseColor( aBaseColor as Colors.HCYColor ) as RandomTheme ptr
  m_baseColor = aBaseColor
  return( @this )
end function

/'
  This method just generates a set of random colors, using
  the HCY color model. It just varies the hue and color,
  keeping the luminance intact. One of the simplest
  methods to generate several uniformly distributed random
  colors.
'/
function RandomTheme.generate( swatchCount as integer ) as RandomTheme ptr
  m_swatchCount = swatchCount
  
  redim m_swatches( 0 to m_swatchCount - 1 )
  
  for i as integer = 0 to m_swatchCount - 1
    m_swatches( i ) = Colors.HCYColor( _
      Colors.wrap( m_baseColor.x + Colors.invPhi * i, 0.0, 1.0 ), _
      Colors.wrap( m_baseColor.y + Colors.invPhi * i, 0.0, 1.0 ), _
      m_baseColor.z )
  next
  
  return( @this )
end function

/'
  Anoher random color scheme generator. This time it uses standard harmonics
  to generate swatches.
'/
type RandomThemeHarmonics extends ColorThemeBase
  public:
    declare constructor()
    declare destructor() override
    
    declare function _
      withParameters( _
        as Colors.float, _
        as Colors.float, _
        as Colors.float, _
        as Colors.float, _
        as Colors.float, _
        as Colors.float, _
        as Colors.float ) _
      as RandomThemeHarmonics ptr
      
    declare function generate( as integer ) as RandomThemeHarmonics ptr
    
  private:
    as Colors.float _
      m_offsetAngle1, _
      m_offsetAngle2, _
      m_rangeAngle0, _
      m_rangeAngle1, _
      m_rangeAngle2, _
      m_saturation, _
      m_luminance
end type

constructor RandomThemeHarmonics() : end constructor

destructor RandomThemeHarmonics() : end destructor

function RandomThemeHarmonics.withParameters( _
    anOffsetAngle1 as Colors.float, _
    anOffsetAngle2 as Colors.float, _
    aRangeAngle0 as Colors.float, _
    aRangeAngle1 as Colors.float, _
    aRangeAngle2 as Colors.float, _
    aSaturation as Colors.float, _
    aLuminance as Colors.float ) _
  as RandomThemeHarmonics ptr
  
  m_offsetAngle1 = anOffsetAngle1
  m_offsetAngle2 = anOffsetAngle2
  m_rangeAngle0 = aRangeAngle0
  m_rangeAngle1 = aRangeAngle1
  m_rangeAngle2 = aRangeAngle2
  m_saturation = aSaturation
  m_luminance = aLuminance
  
  return( @this )
end function

function RandomThemeHarmonics.generate( swatchCount as integer ) as RandomThemeHarmonics ptr
  m_swatchCount = swatchCount
  
  redim m_swatches( 0 to m_swatchCount - 1 )
  
  dim as Colors.float referenceAngle = rnd() * 360.0
  
  for i as integer = 0 to m_swatchCount - 1
    dim as Colors.float _
      randomAngle = rnd() * ( m_rangeAngle0 + m_rangeAngle1 + m_rangeAngle2 )
    
    if( randomAngle > m_rangeAngle0 ) then
      if( randomAngle < m_rangeAngle0 + m_rangeAngle1 ) then
        randomAngle += m_offsetAngle1
      else
        randomAngle += m_offsetAngle2
      end if
    end if
    
    m_swatches( i ) = Colors.HCYColor( _
      Colors.wrap( ( referenceAngle + randomAngle ) / 360.0, 0.0, 1.0 ), _
      m_saturation, _
      m_luminance )
  next
  
  return( @this )
end function

/'
  A color scheme generator using three base colors
'/
type TriadMixingColorTheme extends ColorThemeBase
  public:
    declare constructor()
    declare destructor() override
    
    declare function withColors( _
        as Colors.HCYColor, _
        as Colors.HCYColor, _
        as Colors.HCYColor ) _
      as TriadMixingColorTheme ptr
    declare function withParameters( as Colors.float ) as TriadMixingColorTheme ptr
    declare function generate( as integer ) as TriadMixingColorTheme ptr override
    
  private:
    as Colors.HCYColor _
      m_color1, m_color2, m_color3
    as Colors.float m_greyControl
end type

constructor TriadMixingColorTheme() : end constructor

destructor TriadMixingColorTheme() : end destructor

function TriadMixingColorTheme.withColors( _
    color1 as Colors.HCYColor, _
    color2 as Colors.HCYColor, _
    color3 as Colors.HCYColor ) _
  as TriadMixingColorTheme ptr
  
  m_color1 = color1
  m_color2 = color2
  m_color3 = color3
  
  return( @this )
end function

function TriadMixingColorTheme.withParameters( greyControl as Colors.float ) as TriadMixingColorTheme ptr
  m_greyControl = greyControl
  
  return( @this )
end function

function TriadMixingColorTheme.generate( swatchCount as integer ) as TriadMixingColorTheme ptr
  m_swatchCount = swatchCount
  
  redim m_swatches( 0 to m_swatchCount - 1 )
  
  for i as integer = 0 to m_swatchCount - 1
    dim as integer randomIndex = rnd() * 2
    
    dim as Colors.float _
      mixRatio1 = iif( randomIndex = 0, rnd() * m_greyControl, rnd() ), _
      mixRatio2 = iif( randomIndex = 1, rnd() * m_greyControl, rnd() ), _
      mixRatio3 = iif( randomIndex = 2, rnd() * m_greyControl, rnd() ), _
      sum = mixRatio1 + mixRatio2 + mixRatio3
    
    mixRatio1 /= sum
    mixRatio2 /= sum
    mixRatio3 /= sum
    
    m_swatches( i ) = Colors.HCYColor( _
      mixRatio1 * m_color1.x + mixRatio2 * m_color2.x + mixRatio3 * m_color3.x, _
      mixRatio1 * m_color1.y + mixRatio2 * m_color2.y + mixRatio3 * m_color3.y, _
      mixRatio1 * m_color1.z + mixRatio2 * m_color2.z + mixRatio3 * m_color3.z )
  next
  
  return( @this )
end function

'' Draws a color swatch
sub drawSwatch( _
  x as integer, _
  y as integer, _
  swatchWidth as integer, _
  swatchHeight as integer, _
  aColor as Colors.HCYColor )
  
  line ( x, y ) - ( x + swatchWidth - 1, y + swatchHeight - 1 ), _
    Colors.HCYtoRGB( aColor ), bf
end sub

'' Draws all color swatches from the specified Color Theme
sub drawSwatches( _
  x as integer, _
  y as integer, _
  swatchWidth as integer, _
  swatchHeight as integer, _
  aColorTheme as ColorThemeBase ptr )
  
  for x as integer = 0 to aColorTheme->swatches - 1
    drawSwatch( _
      x * swatchWidth + 2, y, _
      swatchWidth, swatchHeight, _
      Colors.HCYtoRGB( aColorTheme->swatch( x ) ) )
  next
end sub

/'
  Example 2: Generating random colors
'/
dim as integer _
  displayWidth = 800, _
  displayHeight = 600

screenRes( displayWidth, displayHeight, 32 )
color( rgb( 0, 0, 0 ), rgb( 255, 255, 255 ) )
width displayWidth \ 8, displayHeight \ 16
cls()

windowTitle( "Example 2: Random color generation (<SPACE> generates new swatches)" )

randomize()

dim as string keyPressed

dim as integer _
  swatchWidth = 30, _
  swatchHeight = 70, _
  numSwatches = 20
  
var aRandomTheme = new RandomTheme() _
  ->withBaseColor( Colors.HCYColor( 0.2, 0.8, 0.5 ) ) _
  ->generate( numSwatches )
  
var aRandomThemeHarmonics = new RandomThemeHarmonics() _
  ->withParameters( _
    120.0, _
    240.0, _
    rnd() * 360.0, _
    0.0, _
    0.0, _
    rnd(), rnd() ) _
  ->generate( numSwatches )

var aTriadMixingTheme = new TriadMixingColorTheme() _
  ->withColors( _
    Colors.HCYColor( rnd(), rnd(), rnd() ), _
    Colors.HCYColor( rnd(), rnd(), rnd() ), _
    Colors.HCYColor( rnd(), rnd(), rnd() ) ) _
  ->withParameters( rnd() ) _
  ->generate( numSwatches )

do
  keyPressed = inkey()
  
  if( keyPressed = chr( 32 ) ) then
    aRandomTheme->withBaseColor( Colors.HCYColor( rnd(), rnd(), rnd() ) ) _
      ->generate( numSwatches )
    
    dim as Colors.float _
      range0 = rnd() * 360.0, _
      range1 = rnd() * 5.0, _
      range2 = rnd() * 5.0
    
    aRandomThemeHarmonics->withParameters( _
        180.0 + rnd() * 10.0, _
        180.0 - rnd() * 10.0, _
        range0, _
        range1, _
        range2, _
        rnd(), 0.5 ) _
      ->generate( numSwatches )
    
    aTriadMixingTheme->withColors( _
        Colors.HCYColor( rnd(), rnd(), rnd() ), _
        Colors.HCYColor( rnd(), rnd(), rnd() ), _
        Colors.HCYColor( rnd(), rnd(), rnd() ) ) _
      ->withParameters( rnd() ) _
      ->generate( numSwatches )
  end if
  
  screenLock()
    cls()
    
    drawSwatches( 0, 0, swatchWidth, swatchHeight, aRandomTheme )
    drawSwatches( _
      0, 1 * ( swatchHeight + 4 ), _
      swatchWidth, swatchHeight, _
      aRandomThemeHarmonics )
    drawSwatches( _
      0, 2 * ( swatchHeight + 4 ), _
      swatchWidth, swatchHeight, _
      aTriadMixingTheme )
  screenUnlock()
  
  sleep( 1, 1 )
loop until( keyPressed = chr( 27 ) orElse keyPressed = chr( 255 ) + "k" )

delete( aTriadMixingTheme )
delete( aRandomThemeHarmonics )
delete( aRandomTheme )
