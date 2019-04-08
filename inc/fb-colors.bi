#ifndef __FB_COLORS__
#define __FB_COLORS__

/'
  A simple framework to work with different color models.
  
  You can express a color in three different color models:
  HSV, HSL and HCY (aka. Hue-Chroma-Luminance). Conversion
  functions to/from RGB are provided, such that:
  
  RGBtoHSV - Converts a color in the RGB model to the HSV model
  RGBtoHSL - Converts a color in the RGB model to the HSL model
  RGBtoHCY - Converts a color in the RGB model to the HCY model
  
  HSVtoRGB - Converts a color from the HSV model to the RGB model
  HSLtoRGB - Converts a color from the HSL model to the RGB model
  HCYtoRGB - Converts a color from the HCY model to the RGB model
  
  The mix() functions linearly interpolate between two colors in
  the RGB/RGBA model. To use them with other color models, simply
  convert them first, like this:
  
  '' Mix two HCY colors in equal amounts
  finalColor => Colors.mix( _
    Colors.HCYtoRGB( color1 ), _
    Colors.HCYtoRGB( color2 ), _
    0.5 )
'/
namespace Colors
  type as double _
    float
  
  const as float _
    epsilon => 1e-10, _
    phi => ( 1.0 + sqr( 5.0 ) ) / 2.0, _
    invPhi => 1.0 / phi
  
  /'
    This is used to modulo-divide a floating point value. Useful
    because FreeBasic's MOD operator works only with integer types.
  '/
  function _
    fmod( _
      byval n as float, _
      byval d as float ) _
    as float
    
    return( n - int( n / d ) * d )
  end function
  
  '' Select the minimum of two values
  function _
    min( _
      byval a as float, _
      byval b as float ) _
    as float
    
    return( iif( a < b, a, b ) )
  end function
  
  '' Select the maximum of two values
  function _
    max( _
      byval a as float, _
      byval b as float ) _
    as float
    
    return( iif( a > b, a, b ) )
  end function
  
  '' Clamps a value 'v' between two values, 'a' and 'b'
  function _
    clamp( _
      byval v as float, _
      byval a as float, _
      byval b as float ) _
    as float
    
    return( max( a, min( v, b ) ) )
  end function
  
  '' Wraps a value 'v' between two values, 'a' and 'b'
  function _
    wrap( _
      byval v as float, _
      byval a as float, _
      byval b as float ) _
    as float
    
    return( fmod( ( _
      fmod( ( v - a ), ( b - a ) ) + ( b - a  ) ), _
        ( b - a ) + a ) )
  end function
  
  /'
    A tuple of 3 floats. Also used to store a tuple of RGB
    colors.
  '/
  type float3
    declare constructor()
    declare constructor( _
      byval as float, _
      byval as float, _
      byval as float )
    declare constructor( _
      byref as float3 )
    declare operator _
      let( byref as float3 )
    declare destructor()
    
    declare property _
      r() as float
    declare property _
      r( byval as float )
    declare property _
      g() as float
    declare property _
      g( byval as float )
    declare property _
      b() as float
    declare property _
      b( byval as float )
    
    declare operator _
      cast() as ulong
    
    as float _
      x, y, z
  end type
  
  constructor _
    float3()
    
    this.constructor( 0.0, 0.0, 0.0 )
  end constructor
  
  constructor _
    float3( _
      byval nX as float, _
      byval nY as float, _
      byval nZ as float )
    
    x => nX
    y => nY
    z => nZ
  end constructor
  
  constructor _
    float3( _
      byref rhs as float3 )
    
    with rhs
      x => .x
      y => .y
      z => .z
    end with
  end constructor
  
  operator _
    float3.let( _
      byref rhs as float3 )
    
    with rhs
      x => .x
      y => .y
      z => .z
    end with
  end operator
  
  destructor _
    float3()
  end destructor
  
  property _
    float3.r() _
    as float
    
    return( x )
  end property
  
  property _
    float3.r( _
      byval value as float )
    
    x => value
  end property
  
  property _
    float3.g() _
    as float
    
    return( y )
  end property
  
  property _
    float3.g( _
      byval value as float )
    
    y => value
  end property
  
  property _
    float3.b() _
    as float
    
    return( z )
  end property
  
  property _
    float3.b( _
      byval value as float )
    
    z => value
  end property
  
  operator _
    float3.cast() _
    as ulong
    
    return( _
      ( cubyte( x * 255 ) shl 16 ) or _
      ( cubyte( y * 255 ) shl 8 ) or _
      ( cubyte( z * 255 ) ) )
  end operator
  
  '' Just the standard dot product
  function dot _
    overload( _
      byref v as const float3, _
      byref w as const float3 ) as float
  	
  	return( _
  	  v.x * w.x + v.y * w.y + v.z * w.z )
  end function  
  
  /'
    A tuple of 4 float values
  '/
  type float4
    declare constructor()
    declare constructor( _
      byval as float, _
      byval as float, _
      byval as float, _
      byval as float => 1.0 )
    declare constructor( _
      byref as float3, _
      byval as float )
    declare constructor( _
      byref as float4 )
    declare operator _
      let( byref as float4 )
    declare destructor()
    
    declare property _
      r() as float
    declare property _
      r( byval as float )
    declare property _
      g() as float
    declare property _
      g( byval as float )
    declare property _
      b() as float
    declare property _
      b( byval as float )
    declare property _
      a() as float
    declare property _
      a( byval as float )
    
    declare operator _
      cast() as ulong
    
    as float _
      x, y, z, w
  end type
  
  constructor _
    float4()
    
    this.constructor( 0.0, 0.0, 0.0, 1.0 )
  end constructor
  
  constructor _
    float4( _
      byval nX as float, _
      byval nY as float, _
      byval nZ as float, _
      byval nW as float => 1.0 )
    
    x => nX
    y => nY
    z => nZ
    w => nW
  end constructor
  
  constructor _
    float4( _
      byref aFloat3 as float3, _
      byval nA as float )
    
    with aFloat3
      x => .x
      y => .y
      z => .z
    end with
    
    a => nA
  end constructor
  
  constructor _
    float4( _
      byref rhs as Float4 )
    
    with rhs
      x => .x
      y => .y
      z => .z
      a => .a
    end with
  end constructor
  
  operator _
    float4.let( _
      byref rhs as float4 )
    
    with rhs
      x => .x
      y => .y
      z => .z
      w => .w
    end with
  end operator
  
  destructor _
    float4()
  end destructor

  property _
    float4.r() _
    as float
    
    return( x )
  end property
  
  property _
    float4.r( _
      byval value as float )
    
    x => value
  end property
  
  property _
    float4.g() _
    as float
    
    return( y )
  end property
  
  property _
    float4.g( _
      byval value as float )
    
    y => value
  end property
  
  property _
    float4.b() _
    as float
    
    return( z )
  end property
  
  property _
    float4.b( _
      byval value as float )
    
    z => value
  end property
  
  property _
    float4.a() _
    as float
    
    return( a )
  end property
  
  property _
    float4.a( _
      byval value as float )
    
    a => value
  end property
  
  operator _
    float4.cast() _
    as ulong
    
    return( _
      ( cubyte( r * 255 ) shl 16 ) or _
      ( cubyte( g * 255 ) shl 8 ) or _
      ( cubyte( b * 255 ) ) or _
      ( cubyte( a * 255 ) shl 24 ) )
  end operator
  
  /'
    Saturates a color such that:
      0 <= x <= 1
      0 <= y <= 1
      0 <= z <= 1
  '/
  function saturate( _
    byref aTuple as float3 ) _
    as float3
    
    return( float3( _
      clamp( aTuple.x, 0.0, 1.0 ), _
      clamp( aTuple.y, 0.0, 1.0 ), _
      clamp( aTuple.z, 0.0, 1.0 ) ) )
  end function
  
  '' Convert pure Hue to RGB
  function _
    hueToRGB( _
      byval h as float ) _
    as float3
    
    dim as float _
      r => abs( h * 6.0 - 3.0 ) - 1.0, _
      g => 2.0 - abs( h * 6.0 - 2.0 ), _
      b => 2.0 - abs( h * 6.0 - 4.0 )
    
    return( _
      saturate( float3( r, g, b ) ) )
  end function
  
  '' Convert Hue-Saturation-Value to RGB
  function _
    HSVtoRGB( _
      byval HSV as float3 ) _
    as float3
    
    dim as float3 _
      aRGB => hueToRGB( HSV.x )
    
    return( float3( _
      ( ( aRGB.x - 1.0 ) * HSV.y + 1.0 ) * HSV.z, _
      ( ( aRGB.y - 1.0 ) * HSV.y + 1.0 ) * HSV.z, _
      ( ( aRGB.z - 1.0 ) * HSV.y + 1.0 ) * HSV.z ) )
  end function
  
  '' Convert Hue-Saturation-Lightness to RGB
  function _
    HSLtoRGB( _
      byval HSL as float3 ) _
    as float3
    
    dim as float3 _
      aRGB => hueToRGB( HSL.x )
    dim as float _
      C => ( 1.0 - abs( 2.0 * HSL.z - 1.0 ) ) * HSL.y
    
    return( float3( _
      ( aRGB.x - 0.5 ) * C + HSL.z, _
      ( aRGB.y - 0.5 ) * C + HSL.z, _
      ( aRGB.z - 0.5 ) * C + HSL.z ) )
  end function

  /'
    The weights of RGB contributions to luminance.
    Should sum to unity.  
  '/
  dim as const float3 _
    HCYweights => float3( 0.299, 0.587, 0.114 )
  
  '' Convert Hue-Chroma-Luminance to RGB
  function _
    HCYtoRGB( _
      byval HCY as float3 ) _
    as float3
    
    var aRGB => hueToRGB( HCY.x )
    
    dim as float _
      Z => dot( aRGB, HCYweights )
    
    if( HCY.z < Z ) then
      HCY.y *=> HCY.z / Z
    elseif( _
      z < 1.0 ) then
      HCY.y *=> ( 1.0 - HCY.z ) / ( 1.0 - Z )
    end if
    
    return( float3( _
      ( aRGB.x - Z ) * HCY.Y + HCY.z, _
      ( aRGB.y - Z ) * HCY.Y + HCY.z, _
      ( aRGB.z - Z ) * HCY.Y + HCY.z ) )
  end function
  
  '' Convert RGB to Hue/Chroma/Value
  function _
    RGBtoHCV( _
      byref aRGB as float3 ) _
    as float3
    
    var _
      P => iif( aRGB.b < aRGB.b, _
        float4( aRGB.b, aRGB.g, -1.0, 2.0 / 3.0 ), _
        float4( aRGB.g, aRGB.b, 0.0, -1.0 / 3.0 ) ), _
      Q => iif( aRGB.r < P.x, _
        float4( P.x, P.y, P.w, aRGB.r ), _
        float4( aRGB.r, P.y, P.z, P.x ) )
      
    dim as float _
      C => Q.x - min( Q.w, Q.y ), _
      H => abs( ( Q.w - Q.y ) / ( 6.0 * C + Epsilon ) + Q.z )
    
    return( float3( H, C, Q.x ) )
  end function
  
  '' Converting RGB to Hue-Chroma-Luminance
  function _
    RGBtoHCY( _
      byref aRGB as float3 ) _
    as float3
    
    var HCV => RGBtoHCV( aRGB )
    
    dim as float _
      Y => dot( aRGB, HCYweights ), _
      Z => dot( hueToRGB( HCV.x ), HCYweights )
      
      if( Y < Z ) then
        HCV.y *=> Z / ( Epsilon + Y )
      else
        HCV.y *=> ( 1.0 - Z ) / ( Epsilon + 1.0 - Y )
      end if
      
      return( float3( HCV.x, HCV.y, Y ) )
  end function
  
  '' Converting RGB to Hue-Saturation-Value
  function _
    RGBtoHSV( _
      byref aRGB as float3 ) _
    as float3
    
    dim as float3 _
      HCV => RGBtoHCV( aRGB )
    dim as float _
      S => HCV.y / ( HCV.z + Epsilon )
    
    return( float3( HCV.x, S, HCV.z ) )
  end function
  
  '' Converting RGB to Hue-Saturation-Lightness
  function _
    RGBtoHSL( _
      byref aRGB as float3 ) _
    as float3
    
    dim as float3 _
      HCV => RGBtoHCV( aRGB )
    dim as float _
      L => HCV.z - HCV.y * 0.5, _
      S => HCV.y / ( 1.0 - abs( L * 2.0 - 1.0 ) + Epsilon )
    
    return( float3( HCV.x, S, L ) )
  end function  
  
  function _
    mix overload( _
      byref c1 as float3, _
      byref c2 as float3, _
      byval t as float ) _
    as float3
    
    return( float3( _
      c1.x + ( ( c2.x - c1.x ) * t ), _
      c1.y + ( ( c2.y - c1.y ) * t ), _
      c1.z + ( ( c2.z - c1.z ) * t ) ) )
  end function
  
  function _
    mix ( _
      byref c1 as float4, _
      byref c2 as float4, _
      byval t as float ) _
    as float4
    
    return( float4( _
      c1.x + ( ( c2.x - c1.x ) * t ), _
      c1.y + ( ( c2.y - c1.y ) * t ), _
      c1.z + ( ( c2.z - c1.z ) * t ), _
      c1.w + ( ( c2.w - c1.w ) * t ) ) )
  end function
  
  '' Just for clarity
  type as Colors.float3 _
    HSVColor, HSLColor, HCYColor
  type as Colors.float4 _
    HSVAColor, HSLAColor, HCYAColor
end namespace

#endif
