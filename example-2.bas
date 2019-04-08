#include once "fbgfx.bi"
#include once "inc/fb-colors.bi"

/'
  Base class for a color theme
'/
type ColorThemeBase extends Object
  public:
    declare virtual destructor()
    
    declare property _
      swatches() as integer
    declare property _
      swatch( _
        byval as integer ) as Colors.float3
      
    declare abstract function _
      generate( _
        byval as integer ) as ColorThemeBase ptr
      
  protected:
    declare constructor()
    
    as integer _
      m_swatchCount
    as Colors.HCYColor _
      m_swatches( any )
end type

constructor _
  ColorThemeBase()
end constructor

destructor _
  ColorThemeBase()
end destructor

property _
  ColorThemeBase.swatches() _
  as integer
  
  return( m_swatchCount )
end property

property _
  ColorThemeBase.swatch( _
    byval index as integer ) _
  as Colors.float3
  
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
    
    declare property _
      baseColor() as Colors.float3
      
    declare function _
      withBaseColor( _
        byref as Colors.HCYColor ) _
      as RandomTheme ptr
    declare function _
      generate( _
        byval as integer ) as RandomTheme ptr override
      
  private:
    as Colors.float3 _
      m_baseColor
end type

constructor _
  RandomTheme()
end constructor

destructor _
  RandomTheme()
end destructor

property _
  RandomTheme.baseColor() _
  as Colors.float3
  
  return( m_baseColor )
end property

function _
  RandomTheme.withBaseColor( _
    byref aBaseColor as Colors.HCYColor ) _
  as RandomTheme ptr
  
  m_baseColor => aBaseColor
  
  return( @this )
end function

/'
  This method just generates a set of random colors, using
  the HCY color model. It just varies the hue and color,
  keeping the luminance intact. One of the simplest
  methods to generate several uniformly distributed random
  colors.
'/
function _
  RandomTheme.generate( _
    byval swatchCount as integer ) _
  as RandomTheme ptr
  
  m_swatchCount => swatchCount
  
  redim _
    m_swatches( 0 to m_swatchCount - 1 )
  
  for _
    i as integer => 0 to m_swatchCount - 1
    
    m_swatches( i ) => Colors.HCYColor( _
      Colors.wrap( _
        m_baseColor.x + Colors.invPhi * i, 0.0, 1.0 ), _
      Colors.wrap( _
        m_baseColor.y + Colors.invPhi * i, 0.0, 1.0 ), _
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
        byval as Colors.float, _
        byval as Colors.float, _
        byval as Colors.float, _
        byval as Colors.float, _
        byval as Colors.float, _
        byval as Colors.float, _
        byval as Colors.float ) _
      as RandomThemeHarmonics ptr
      
    declare function _
      generate( _
        byval as integer ) _
      as RandomThemeHarmonics ptr
      
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

constructor _
  RandomThemeHarmonics()
end constructor

destructor _
  RandomThemeHarmonics()
end destructor

function _
  RandomThemeHarmonics.withParameters( _
    byval anOffsetAngle1 as Colors.float, _
    byval anOffsetAngle2 as Colors.float, _
    byval aRangeAngle0 as Colors.float, _
    byval aRangeAngle1 as Colors.float, _
    byval aRangeAngle2 as Colors.float, _
    byval aSaturation as Colors.float, _
    byval aLuminance as Colors.float ) _
  as RandomThemeHarmonics ptr
  
  m_offsetAngle1 => anOffsetAngle1
  m_offsetAngle2 => anOffsetAngle2
  m_rangeAngle0 => aRangeAngle0
  m_rangeAngle1 => aRangeAngle1
  m_rangeAngle2 => aRangeAngle2
  m_saturation => aSaturation
  m_luminance => aLuminance
  
  return( @this )
end function

function _
  RandomThemeHarmonics.generate( _
    byval swatchCount as integer ) _
  as RandomThemeHarmonics ptr
  
  m_swatchCount => swatchCount
  
  redim _
    m_swatches( 0 to m_swatchCount - 1 )
  
  dim as Colors.float _
    referenceAngle => rnd() * 360.0
  
  for _
    i as integer => 0 to m_swatchCount - 1
    
    dim as Colors.float _
      randomAngle => rnd() * ( m_rangeAngle0 + m_rangeAngle1 + m_rangeAngle2 )
    
    if( randomAngle > m_rangeAngle0 ) then
      if( randomAngle < m_rangeAngle0 + m_rangeAngle1 ) then
        randomAngle +=> m_offsetAngle1
      else
        randomAngle +=> m_offsetAngle2
      end if
    end if
    
    m_swatches( i ) => Colors.HCYColor( _
      Colors.wrap( _
        ( referenceAngle + randomAngle ) / 360.0, 0.0, 1.0 ), _
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
    
    declare function _
      withColors( _
        byref as Colors.HCYColor, _
        byref as Colors.HCYColor, _
        byref as Colors.HCYColor ) _
      as TriadMixingColorTheme ptr
    declare function _
      withParameters( _
        byval as Colors.float ) _
      as TriadMixingColorTheme ptr
    declare function _
      generate( _
        byval as integer ) _
      as TriadMixingColorTheme ptr override
    
  private:
    as Colors.HCYColor _
      m_color1, m_color2, m_color3
    as Colors.float _
      m_greyControl
end type

constructor _
  TriadMixingColorTheme()
end constructor

destructor _
  TriadMixingColorTheme()
end destructor

function _
  TriadMixingColorTheme.withColors( _
    byref color1 as Colors.HCYColor, _
    byref color2 as Colors.HCYColor, _
    byref color3 as Colors.HCYColor ) _
  as TriadMixingColorTheme ptr
  
  m_color1 => color1
  m_color2 => color2
  m_color3 => color3
  
  return( @this )
end function

function _
  TriadMixingColorTheme.withParameters( _
    byval greyControl as Colors.float ) _
  as TriadMixingColorTheme ptr
  
  m_greyControl => greyControl
  
  return( @this )
end function

function _
  TriadMixingColorTheme.generate( _
    byval swatchCount as integer ) _
  as TriadMixingColorTheme ptr
  
  m_swatchCount => swatchCount
  
  redim _
    m_swatches( 0 to m_swatchCount - 1 )
  
  for _
    i as integer => 0 to m_swatchCount - 1
    dim as integer _
      randomIndex => rnd() * 2
    
    dim as Colors.float _
      mixRatio1 => iif( randomIndex = 0, _
        rnd() * m_greyControl, rnd() ), _
      mixRatio2 => iif( randomIndex = 1, _
        rnd() * m_greyControl, rnd() ), _
      mixRatio3 => iif( randomIndex = 2, _
        rnd() * m_greyControl, rnd() ), _
      sum => mixRatio1 + mixRatio2 + mixRatio3
    
    mixRatio1 /=> sum
    mixRatio2 /=> sum
    mixRatio3 /=> sum
    
    m_swatches( i ) => Colors.HCYColor( _
      mixRatio1 * m_color1.x + mixRatio2 * m_color2.x + mixRatio3 * m_color3.x, _
      mixRatio1 * m_color1.y + mixRatio2 * m_color2.y + mixRatio3 * m_color3.y, _
      mixRatio1 * m_color1.z + mixRatio2 * m_color2.z + mixRatio3 * m_color3.z )
  next
  
  return( @this )
end function

/'
  Draws a color swatch
'/
sub _
  drawSwatch( _
    byval x as integer, _
    byval y as integer, _
    byval swatchWidth as integer, _
    byval swatchHeight as integer, _
    byref aColor as Colors.HCYColor )
  
  line _
    ( x, y ) - _
    ( x + swatchWidth - 1, y + swatchHeight - 1 ), _
    Colors.HCYtoRGB( aColor ), bf
end sub

/'
  Draws all color swatches from the specified Color Theme
'/
sub _
  drawSwatches( _
    byval x as integer, _
    byval y as integer, _
    byval swatchWidth as integer, _
    byval swatchHeight as integer, _
    byval aColorTheme as ColorThemeBase ptr )
  
  for _
    x as integer => 0 to aColorTheme->swatches - 1
    
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
  displayWidth => 800, _
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
cls()

windowTitle( "Example 2: Random color generation (<SPACE> generates new swatches)" )

randomize()

dim as string _
  keyPressed

dim as integer _
  swatchWidth => 30, _
  swatchHeight => 70, _
  numSwatches => 20
  
var aRandomTheme => _
  new RandomTheme() _
    ->withBaseColor( Colors.HCYColor( 0.2, 0.8, 0.5 ) ) _
    ->generate( numSwatches )
  
var aRandomThemeHarmonics => _
  new RandomThemeHarmonics() _
    ->withParameters( _
      120.0, _
      240.0, _
      rnd() * 360.0, _
      0.0, _
      0.0, _
      rnd(), rnd() ) _
    ->generate( numSwatches )

var aTriadMixingTheme => _
  new TriadMixingColorTheme() _
    ->withColors( _
      Colors.HCYColor( rnd(), rnd(), rnd() ), _
      Colors.HCYColor( rnd(), rnd(), rnd() ), _
      Colors.HCYColor( rnd(), rnd(), rnd() ) ) _
    ->withParameters( rnd() ) _
    ->generate( numSwatches )

do
  keyPressed = inkey()
  
  if( keyPressed = chr( 32 ) ) then
    aRandomTheme _
      ->withBaseColor( Colors.HCYColor( _
        rnd(), rnd(), rnd() ) ) _
      ->generate( numSwatches )
    
    dim as Colors.float _
      range0 => rnd() * 360.0, _
      range1 => rnd() * 5.0, _
      range2 => rnd() * 5.0
    
    aRandomThemeHarmonics _
      ->withParameters( _
        180.0 + rnd() * 10.0, _
        180.0 - rnd() * 10.0, _
        range0, _
        range1, _
        range2, _
        rnd(), 0.5 ) _
      ->generate( numSwatches )
    
    aTriadMixingTheme _
      ->withColors( _
        Colors.HCYColor( rnd(), rnd(), rnd() ), _
        Colors.HCYColor( rnd(), rnd(), rnd() ), _
        Colors.HCYColor( rnd(), rnd(), rnd() ) ) _
      ->withParameters( rnd() ) _
      ->generate( numSwatches )
  end if
  
  screenLock()
    cls()
    
    drawSwatches( _
      0, 0, _
      swatchWidth, swatchHeight, _
      aRandomTheme )
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
loop _
  until( _
    keyPressed = chr( 27 ) orElse _
    keyPressed = chr( 255 ) + "k" )

delete( aTriadMixingTheme )
delete( aRandomThemeHarmonics )
delete( aRandomTheme )
